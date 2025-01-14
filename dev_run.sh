#!/bin/bash
# Функция для остановки процесса по имени
stop_process() {
    PROCESS_NAME=$1
    # Находим PID процесса по имени
    PIDS=$(ps aux | grep "$PROCESS_NAME" | grep -v grep | awk '{print $2}')
    
    if [ -z "$PIDS" ]; then
        echo "Процесс $PROCESS_NAME не найден."
    else
        echo "Останавливаю процесс $PROCESS_NAME..."
        # Останавливаем каждый найденный PID
        for PID in $PIDS; do
            kill -9 $PID
            echo "Процесс $PROCESS_NAME с PID $PID остановлен."
        done
    fi
}

# Останавливаем webserver
stop_process "airflow webserver"

# Останавливаем scheduler
stop_process "airflow scheduler"

echo "Все процессы Airflow остановлены."

airflow webserver --port 8081 -D
airflow scheduler -D