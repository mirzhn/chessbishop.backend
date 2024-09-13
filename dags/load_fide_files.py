import os
import requests
from airflow import DAG
from airflow.operators.python_operator import PythonOperator
from airflow.providers.mysql.hooks.mysql import MySqlHook
from airflow.hooks.base_hook import BaseHook
from datetime import datetime, timedelta

default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2023, 1, 1),
}

dag = DAG(
    dag_id='load_fide_files',
    default_args=default_args,
    schedule_interval=None,
)

# Функция для получения списка файлов из MySQL
def fetch_file_list(**kwargs):
    mysql_hook = MySqlHook(mysql_conn_id='chessbi')
    
    # Выполнение SQL-запроса и получение всех записей
    records = mysql_hook.get_records(sql="SELECT file_url FROM file_links;")
    
    # Извлечение списка файлов из записей
    file_list = [row[0] for row in records]
    
    # Сохранение списка файлов в XCom
    kwargs['ti'].xcom_push(key='file_list', value=file_list)

def load_files(**kwargs):
    # Извлечение списка файлов из XCom
    file_list = kwargs['ti'].xcom_pull(task_ids='fetch_files', key='file_list')
    
    # Загрузка списка файлов
    conn = BaseHook.get_connection('load_path')
    load_path = conn.extra_dejson.get('path')

    for file_url in file_list:
        print(f"File to process: {file_url}")
        load_file(file_url, load_path)

def load_file(file_url, load_path):
    try:
        # Получение имени файла из URL
        file_name = os.path.basename(file_url)
        file_path = os.path.join(load_path, file_name)
        
        # Загрузка файла
        response = requests.get(file_url)
        response.raise_for_status()  # Выдает исключение, если статус ответа не 200
        
        # Сохранение файла в целевую директорию
        with open(file_path, 'wb') as f:
            f.write(response.content)
        
        print(f"File saved: {file_path}")
    except Exception as e:
        print(f"Error downloading {file_url}: {e}")

# Задача для получения списка файлов
fetch_files_task = PythonOperator(
    task_id='fetch_files',
    python_callable=fetch_file_list,
    provide_context=True,
    dag=dag,
)

# Задача для загрузки списка файлов
load_files_task = PythonOperator(
    task_id='print_files',
    python_callable=load_files,
    provide_context=True,
    dag=dag,
)

fetch_files_task >> load_files_task
