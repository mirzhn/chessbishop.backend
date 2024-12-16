#!/bin/bash

# Exit on any error
set -e

# Load environment variables
export $(grep -v '^#' .env | xargs)

echo "Starting MySQL and Airflow containers..."
docker-compose up -d mysql airflow-init

echo "Waiting for MySQL to initialize..."
sleep 20

echo "Running MySQL initialization scripts..."
envsubst < ./db/init.sql | docker exec -i mysql sh -c "exec mysql -uroot -p${MYSQL_ROOT_PASSWORD}"

echo "Copying DAGs to Airflow DAGs folder..."
mkdir -p ${AIRFLOW_DAGS_FOLDER}
cp -R ./dags/* ${AIRFLOW_DAGS_FOLDER}/

echo "Starting Airflow components..."
docker-compose up -d airflow-webserver airflow-scheduler

echo "Setting up Airflow connection for chessbi..."
docker exec -it airflow-webserver airflow connections add 'chessbi' \
    --conn-type 'mysql' \
    --conn-host 'mysql' \
    --conn-port ${MYSQL_PORT} \
    --conn-schema ${MYSQL_CHESSBI_DATABASE} \
    --conn-login ${MYSQL_CHESSBI_USER} \
    --conn-password ${MYSQL_CHESSBI_PASSWORD}

echo "Project setup completed successfully!"
