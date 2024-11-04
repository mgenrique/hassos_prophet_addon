#!/bin/bash
echo "Starting Prophet API Add-on..."

# Verificación de existencia de dev_app.py
if [ -f /app/dev_app.py ]; then
    echo "dev_app.py found. Starting the application..."
    python /app/dev_app.py
else
    echo "Error: dev_app.py not found. Exiting..."
    exit 1
fi

echo "Prophet API Add-on has stopped."
