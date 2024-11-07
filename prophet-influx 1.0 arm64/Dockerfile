# Usa la imagen base de Docker Hub
FROM mgenrique/prophet-influx:1.0_arm64

# Añade las variables de entorno que se configurarán a través de los valores del archivo de opciones del add-on
ENV INFLUXDB_HOST=${INFLUXDB_HOST}
ENV INFLUXDB_PORT=${INFLUXDB_PORT}
ENV INFLUXDB_USER=${INFLUXDB_USER}
ENV INFLUXDB_PASSWORD=${INFLUXDB_PASSWORD}
ENV INFLUXDB_DBNAME=${INFLUXDB_DBNAME}
ENV PORT=${PORT}

# Expone el puerto configurado para la API
EXPOSE 5000

COPY . .

# Establece el comando por defecto para ejecutar tu aplicación
CMD ["python", "app/main.py"]
