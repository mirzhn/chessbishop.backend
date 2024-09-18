import os
import zipfile
import json
import re
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.mysql.hooks.mysql import MySqlHook
from airflow.hooks.base_hook import BaseHook
from datetime import datetime

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
}

# Изменённый DAG
dag = DAG(
    dag_id='upload_old_type',
    default_args=default_args,
    schedule_interval=None,
)

# Задача для получения списка файлов из базы данных
def fetch_file_list(**kwargs):
    mysql_hook = MySqlHook(mysql_conn_id='chessbi')
    
    # Выполнение изменённого запроса для получения конкретного URL файла и его формата
    records = mysql_hook.get_records(sql="""
        SELECT fl.id, fl.file_url, format AS file_format 
        FROM file_links fl
           LEFT JOIN file_format ff on ff.id = fl.id_file_format                             
        WHERE fl.file_url = 'http://ratings.fide.com/download/jan01frl.zip'
    """)
    
    # Создание списка кортежей (id_file, file_name, file_format)
    file_list = [(record[0], os.path.basename(record[1]), json.loads(record[2])) for record in records]
    
    # Сохранение списка файлов и их id в XCom
    kwargs['ti'].xcom_push(key='file_list', value=file_list)

# Функция для декодирования файла с учётом кодировки
def decode_file_content(file, encoding):
    try:
        # Пробуем декодировать содержимое файла и обрабатывать переносы строк Windows
        content = [line.decode(encoding).replace('\r\n', '\n').strip() for line in file.readlines()]
        if len(content) > 0:  # Проверка, что контент не пустой
            print(f"Successfully decoded file with encoding {encoding}")
        return content
    except UnicodeDecodeError:
        raise UnicodeDecodeError(f"Failed to decode file with encoding {encoding}")

# Функция для парсинга файла по структуре
def extract_field(line, position, next_position=None):
    if position is None:
        return None  # Если позиция None, возвращаем None
    if next_position is not None:
        return line[position:next_position].strip() or None  # Убираем пробелы, если поле пустое, возвращаем None
    else:
        return line[position:].strip() or None  # Если это последнее поле, берем до конца

def get_next_position(columns, current_index):
    for i in range(current_index + 1, len(columns)):
        if columns[i]['position'] is not None:
            return columns[i]['position']
    return None  # Если нет больше полей с указанной позицией

# Функция для парсинга файла по структуре
def parse_file_by_structure(lines, file_format, id_file):
    parsed_data = []

    # Проходим по каждой строке данных
    for line in lines:
        row = []
        
        # Проходим по каждому полю в формате файла
        for i, column in enumerate(file_format['columns']):
            position = column['position']  # Начальная позиция поля
            next_position = get_next_position(file_format['columns'], i)  # Получаем следующую позицию
            field_value = extract_field(line, position, next_position)  # Извлекаем значение поля
            row.append(field_value)

        # Добавляем id файла в конец строки
        row.append(id_file)
        parsed_data.append(tuple(row))

    return parsed_data

# Функция для обработки одного файла
def process_file(id_file, archive_name, file_format, archive, mysql_hook, load_path, batch_size=1000):
    archive_path = os.path.join(load_path, archive_name)

    if os.path.exists(archive_path):
        for file_name in archive.namelist():
            if file_name.lower().endswith('.txt'):
                with archive.open(file_name) as file:
                    try:
                        encoding = file_format.get('encoding', 'utf-8')
                        skip_lines = file_format.get('skip_lines', 0)

                        for _ in range(skip_lines):
                            next(file)

                        parsed_data = []
                        while True:
                            lines = [file.readline().decode(encoding) for _ in range(batch_size)]
                            lines = [line for line in lines if line]

                            if not lines:
                                break

                            parsed_data.extend(parse_file_by_structure(lines, file_format, id_file))

                            # Если накопили достаточное количество данных
                            if len(parsed_data) >= batch_size:
                                insert_query = """
                                    INSERT INTO sa_old_type_2 (ID_NUMBER, NAME, TITLE, COUNTRY, RAITING, GAMES, BIRTHDAY, FLAG, id_file)
                                    VALUES {}
                                """.format(', '.join(['(%s, %s, %s, %s, %s, %s, %s, %s, %s)'] * len(parsed_data)))

                                # Передаем все параметры
                                parameters = [item for sublist in parsed_data for item in sublist]
                                mysql_hook.run(insert_query, parameters=parameters)
                                print(f"Inserting batch of {len(parsed_data)} rows")
                                parsed_data = []

                        # Вставка оставшихся данных, если есть
                        if parsed_data:
                            insert_query = """
                                INSERT INTO sa_old_type_2 (ID_NUMBER, NAME, TITLE, COUNTRY, RAITING, GAMES, BIRTHDAY, FLAG,id_file)
                                VALUES {}
                            """.format(', '.join(['(%s, %s, %s, %s, %s, %s, %s, %s, %s)'] * len(parsed_data)))
                            
                            parameters = [item for sublist in parsed_data for item in sublist]
                            mysql_hook.run(insert_query, parameters=parameters)
                            print(f"Inserting final batch of {len(parsed_data)} rows")

                    except (UnicodeDecodeError, ValueError) as e:
                        print(f"Error processing file {file_name}: {e}")
    else:
        print(f"Archive {archive_name} not found in {load_path}")

# Функция для обработки всех файлов
def process_files(**kwargs):
    # Получение списка файлов из XCom
    ti = kwargs['ti']
    file_list = ti.xcom_pull(key='file_list', task_ids='fetch_file_list')
    
    # Получение пути к папке с архивами из подключения
    conn = BaseHook.get_connection('load_path')
    load_path = conn.extra_dejson.get('path')

    # Подключение к MySQL
    mysql_hook = MySqlHook(mysql_conn_id='chessbi')

    # Проход по каждому архиву из списка
    for id_file, archive_name, file_format in file_list:
        with zipfile.ZipFile(os.path.join(load_path, archive_name), 'r') as archive:
            process_file(id_file, archive_name, file_format, archive, mysql_hook, load_path)

# Задача для получения списка файлов
fetch_file_list_task = PythonOperator(
    task_id='fetch_file_list',
    python_callable=fetch_file_list,
    provide_context=True,
    dag=dag,
)

# Задача для обработки файлов
process_files_task = PythonOperator(
    task_id='process_files',
    python_callable=process_files,
    provide_context=True,
    dag=dag,
)

# Настройка зависимостей между задачами
fetch_file_list_task >> process_files_task
