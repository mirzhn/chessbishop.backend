# Exit on any error
set -e

# Load environment variables
export $(grep -v '^#' .env | xargs)

echo "Setting up Airflow connection for load path..."
docker exec -it airflow-webserver airflow connections add 'load_path' \
    --conn-type 'fs' \
    --conn-host 'localhost' \
    --conn-extra "{\"path\": \"${LOAD_LOCAL_PATH}\"}"