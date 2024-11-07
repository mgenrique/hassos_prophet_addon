#!/bin/bash

# Mensaje de inicio
echo "Iniciando el addon Prophet InfluxDB..."

# Exporta las variables de entorno desde la configuración del addon
export INFLUXDB_HOST=${INFLUXDB_HOST}
export INFLUXDB_PORT=${INFLUXDB_PORT}
export INFLUXDB_USER=${INFLUXDB_USER}
export INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD}
export INFLUXDB_DBNAME=${INFLUXDB_DBNAME}
export PORT=${PORT}

# Ejecuta el script principal
python /app/main.py

# Ejecuta el script principal
python /app/main.py

# Mensaje de finalización
echo "El addon Prophet InfluxDB ha terminado."
