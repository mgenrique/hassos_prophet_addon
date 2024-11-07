FROM mgenrique/prophet-influx:1.0

# Copia el archivo main.py al contenedor
COPY main.py /app/main.py

# Copia el script de arranque
COPY run.sh /app/run.sh

# Da permisos de ejecución al script de arranque
RUN chmod +x /app/run.sh

# Comando de arranque
CMD ["/app/run.sh"]