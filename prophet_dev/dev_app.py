from flask import Flask, request, jsonify
from prophet import Prophet
import pandas as pd
import logging

# Configura el logger
logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

# Mensajes de log
logger.info("Starting Prophet API from dev_app.py...")

app = Flask(__name__)

@app.route('/forecast', methods=['POST'])
def forecast():
    data = request.json.get("data")

    # Verifica que data no esté vacío
    if not data:
        return jsonify({"error": "No data provided"}), 400

    # Crea el DataFrame con los datos recibidos
    df = pd.DataFrame(data)

    # Valida que el DataFrame tenga exactamente dos columnas
    if df.shape[1] != 2:
        return jsonify({"error": "Expected two columns 'ds' and 'y'"}), 400

    # Asigna nombres a las columnas
    df.columns = ['ds', 'y']

    # Configura y entrena el modelo Prophet
    model = Prophet()
    model.fit(df)
    future = model.make_future_dataframe(periods=30)
    forecast = model.predict(future)

    # Convertir las fechas a formato ISO y crear el diccionario de salida
    forecast['ds'] = forecast['ds'].dt.strftime('%Y-%m-%dT%H:%M:%S')
    response = forecast[['ds', 'yhat']].to_dict(orient='records')

    return jsonify(response)

if __name__ == '__main__':
    app.run(host='0.0.0.0', port=5000)
