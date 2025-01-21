import os
import zipfile
import json
import pymysql
from dotenv import load_dotenv

# Загрузка переменных окружения из .env файла
load_dotenv()

# Конфигурация базы данных
DB_CONFIG = {
    'host': os.getenv('MYSQL_HOST'),
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'database': os.getenv('MYSQL_DATABASE')
}

# Путь для загрузки файлов
LOAD_PATH = os.getenv('LOAD_PATH', './data')

# Задача для получения списка файлов из базы данных
def fetch_file_list():
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            query = """
                SELECT fl.id, fl.file_url, ff.format AS file_format
                FROM file_links fl
                LEFT JOIN file_format ff ON ff.id = fl.id_file_format
                LEFT JOIN file_load_log fll ON fll.id_file = fl.id AND fll.load_status = 'load_sa_ok'
                WHERE fl.id_file_format IN (7, 8)
                  AND fll.id_file IS NULL
                LIMIT 50
                ;
            """
            cursor.execute(query)
            records = cursor.fetchall()
            return [(record[0], os.path.basename(record[1]), json.loads(record[2])) for record in records]
    finally:
        connection.close()

def log_file_load(file_id, status):
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            query = """
                INSERT INTO file_load_log (id_file, load_status, dt)
                VALUES (%s, %s, NOW())
            """
            cursor.execute(query, (file_id, status))
        connection.commit()
        print(f"Log entry added for file ID {file_id} with status {status}")
    except Exception as e:
        print(f"Error logging file ID {file_id}: {e}")
    finally:
        connection.close()


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

def save_parsed_data(data):
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            query = """
                INSERT INTO sa_standart (ID_NUMBER, NAME, COUNTRY, SEX, TITLE, WTITLE, OTITLE, FOA, RAITING, GAMES, KFACTOR, BIRTHDAY, FLAG, id_file)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
            """
            cursor.executemany(query, data)
        connection.commit()
        print(f"Inserted {len(data)} rows into the database.")
    finally:
        connection.close()

# Функция для обработки одного файла
def process_file(id_file, archive_name, file_format, archive, load_path, batch_size=1000000):
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
                                log_file_load(id_file, status='load_sa_ok')
                                break

                            parsed_data.extend(parse_file_by_structure(lines, file_format, id_file))
                            save_parsed_data(parsed_data)
                            parsed_data = []

                    except (UnicodeDecodeError, ValueError) as e:
                        print(f"Error processing file {file_name}: {e}")
    else:
        print(f"Archive {archive_name} not found in {load_path}")



def main():
    print("Fetching file list from database...")
    file_list = fetch_file_list()

    if not file_list:
        print("No files to process.")
        return

    os.makedirs(LOAD_PATH, exist_ok=True)
    
    for id_file, archive_name, file_format in file_list:
        with zipfile.ZipFile(os.path.join(LOAD_PATH, archive_name), 'r') as archive:
            process_file(id_file, archive_name, file_format, archive, LOAD_PATH)
    

if __name__ == "__main__":
    main()