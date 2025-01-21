import os
import pymysql
from dotenv import load_dotenv

def replace_env_variables(sql_script, env_vars):
    """
    Заменяет переменные в SQL на значения из окружения
    """
    for key, value in env_vars.items():
        sql_script = sql_script.replace(f"${{{key}}}", value)
    return sql_script

def run_migrations(migrations_folder, mysql_config):
    # Получаем список файлов миграции
    migration_files = sorted(f for f in os.listdir(migrations_folder) if f.endswith('.sql'))
    
    # Загружаем переменные окружения в словарь
    env_vars = {key: value for key, value in os.environ.items()}

    # Подключаемся к базе данных
    connection = pymysql.connect(**mysql_config)
    cursor = connection.cursor()

    try:
        for migration_file in migration_files:
            migration_path = os.path.join(migrations_folder, migration_file)
            print(f"Executing migration: {migration_file}")

            with open(migration_path, 'r', encoding='utf-8') as file:
                sql_script = file.read()

            # Заменяем переменные в SQL файле
            sql_script = replace_env_variables(sql_script, env_vars)

            # Выполняем SQL скрипт
            for statement in sql_script.split(';'):
                statement = statement.strip()
                if statement:  # Пропустить пустые строки
                    cursor.execute(statement)
            connection.commit()
            print(f"Migration {migration_file} executed successfully.")
    except Exception as e:
        connection.rollback()
        print(f"Error executing migration {migration_file}: {e}")
    finally:
        cursor.close()
        connection.close()

if __name__ == "__main__":
    # Загрузка переменных из .env
    load_dotenv()

    # Настройка MySQL из переменных окружения
    mysql_config = {
        'host': os.getenv('MYSQL_HOST'),
        'user': os.getenv('MYSQL_USER'),
        'password': os.getenv('MYSQL_PASSWORD'),
        'database': 'sys',
        'port': int(os.getenv('MYSQL_PORT', 3306)),  # Порт по умолчанию 3306
        'charset': 'utf8mb4',
        'autocommit': True,
    }

    # Путь к папке миграций
    migrations_folder = os.path.join(os.getcwd(), 'db', 'migrations')

    # Запуск миграций
    run_migrations(migrations_folder, mysql_config)
