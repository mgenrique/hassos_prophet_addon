#!/bin/bash
# run.sh - Start script for the Prophet API Add-on

# Copia dev_app.py al directorio raíz
cp /app/dev_app.py /dev_app.py

# Muestra un mensaje para confirmar la ejecución
echo "Starting Prophet API with dev_app.py..."

# Ejecuta dev_app.py
python /dev_app.py
