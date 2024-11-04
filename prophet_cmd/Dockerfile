# Extiende la imagen base de Docker Hub
FROM mgenrique/prophet-api:latest

# Copia el archivo dev_app.py a /app
COPY dev_app.py /app/dev_app.py

# Copia el archivo run.sh a /app y da permisos de ejecución
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh

# Ejecuta run.sh como comando principal
CMD ["/app/run.sh"]
