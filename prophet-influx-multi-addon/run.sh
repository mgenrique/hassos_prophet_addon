#!/bin/bash

# Mensaje de inicio
echo "Iniciando el addon Prophet InfluxDB..."

# Lee las configuraciones del archivo /data/options.json y las exporta como variables de entorno

export INFLUXDB_HOST=$(jq -r '.influxdb_host' /data/options.json)
export INFLUXDB_PORT=$(jq -r '.influxdb_port' /data/options.json)
export INFLUXDB_USER=$(jq -r '.influxdb_user' /data/options.json)
export INFLUXDB_PASSWORD=$(jq -r '.influxdb_password' /data/options.json)
export INFLUXDB_DBNAME=$(jq -r '.influxdb_dbname' /data/options.json)
export PORT=$(jq -r '.port' /data/options.json)

# Ejecuta la aplicación principal
exec python /app/main.py

# Mensaje de finalización
echo "El addon Prophet InfluxDB ha terminado."
