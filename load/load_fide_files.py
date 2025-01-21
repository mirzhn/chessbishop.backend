import os
import requests
import pymysql
from datetime import datetime
from dotenv import load_dotenv

# Загрузка переменных окружения из корневой директории проекта
load_dotenv(dotenv_path=os.path.join(os.path.dirname(os.path.abspath(__file__)), '../.env'))

# Конфигурация базы данных
DB_CONFIG = {
    'host': os.getenv('MYSQL_HOST'),
    'user': os.getenv('MYSQL_USER'),
    'password': os.getenv('MYSQL_PASSWORD'),
    'database': os.getenv('MYSQL_DATABASE')
}

# Путь для загрузки файлов
LOAD_PATH = os.getenv('LOAD_PATH')

# Функция для получения списка файлов из базы данных
def fetch_file_list():
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            query = """
                SELECT file_url
                FROM file_links fl
                LEFT JOIN file_load_log fll ON fll.id_file = fl.id AND fll.load_status = 'load_ok'
                WHERE fll.id_file IS NULL
            """
            cursor.execute(query)
            records = cursor.fetchall()
            return [record[0] for record in records]
    finally:
        connection.close()

# Функция для загрузки файла
def load_file(file_url):
    file_name = os.path.basename(file_url)
    file_path = os.path.join(LOAD_PATH, file_name)

    try:
        response = requests.get(file_url)
        response.raise_for_status()

        with open(file_path, 'wb') as f:
            f.write(response.content)

        log_file_load(file_url, status='load_ok')
        print(f"File saved: {file_path}")
    except Exception as e:
        print(f"Error downloading {file_url}: {e}")
        log_file_load(file_url, status='error')

# Функция для логирования статуса загрузки файла
def log_file_load(file_url, status):
    connection = pymysql.connect(**DB_CONFIG)
    try:
        with connection.cursor() as cursor:
            file_id_query = "SELECT id FROM file_links WHERE file_url = %s"
            cursor.execute(file_id_query, (file_url,))
            file_id = cursor.fetchone()[0]

            insert_query = """
                INSERT INTO file_load_log (id_file, load_status, dt)
                VALUES (%s, %s, NOW())
            """
            cursor.execute(insert_query, (file_id, status))
        connection.commit()
        print(f"Log entry added for file {file_url} with status {status}")
    except Exception as e:
        print(f"Error logging file {file_url}: {e}")
    finally:
        connection.close()

# Главная функция для выполнения всего процесса
def main():
    print("Fetching file list from database...")
    file_list = fetch_file_list()

    if not file_list:
        print("No files to process.")
        return

    print(f"Found {len(file_list)} files to process.")
    os.makedirs(LOAD_PATH, exist_ok=True)

    for file_url in file_list:
        print(f"Processing file: {file_url}")
        load_file(file_url)

if __name__ == "__main__":
    main()
