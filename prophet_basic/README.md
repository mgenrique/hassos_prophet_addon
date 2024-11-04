This addon install de Docker container in:
https://hub.docker.com/repository/docker/mgenrique/prophet-api/general

if you need to pull it for other purposes you can do:
```bash
docker pull mgenrique/prophet-api:latest
````

Container with python:3.11-slim for arm that implements an api to generate predictions with Prophet. 
Here’s a possible description for your Docker Hub repository:

---

### Repository Description

**Prophet API Add-on for Home Assistant**  
This Docker container provides a lightweight REST API based on Flask for time series forecasting using Meta's (formerly Facebook) Prophet model. It is specifically designed to integrate as an add-on in Home Assistant, enabling easy forecasting based on historical data.

### Features

- **REST API**: Receives JSON-formatted data and returns predictions in JSON.
- **Prophet Model**: Utilizes Prophet, a robust and accurate time series model, ideal for trend and seasonality-based data.
- **ISO Date Format**: Returns dates in ISO format to ensure compatibility.
- **ARM Compatibility**: Optimized for ARM architectures, ideal for devices like the Raspberry Pi.

### Usage

1. **Installation**: Pull the container from Docker Hub or clone the repository and build the image.
2. **Requests**: Send data in JSON format to receive forecasts.
3. **Integration with Home Assistant**: Ideal for generating real-time predictions within Home Assistant.

---

### Example

Send a POST request to the API with date and value data in the following format:

```json
{
  "data": [
    {"ds": "2024-01-01", "y": 10},
    {"ds": "2024-01-02", "y": 15},
    {"ds": "2024-01-03", "y": 13}
  ]
}
```

The API will return a forecast of future values.

### Notes

This container is ideal for home automation and applications that require local time series forecasting, especially on ARM architectures.

Example request:
```python
import requests
import json

# API URL
url = "http://<container IP>:5000/forecast"

# sample data (dates and values)
data = {
    "data": [
        {"ds": "2024-01-01", "y": 10},
        {"ds": "2024-01-02", "y": 15},
        {"ds": "2024-01-03", "y": 13},
        {"ds": "2024-01-04", "y": 18}
    ]
}

# Hacer la solicitud POST
response = requests.post(url, json=data)

# Verificar la respuesta
if response.status_code == 200:
    forecast = response.json()
    print("Forecast:")
    print(json.dumps(forecast, indent=2))
else:
    print("Error:", response.status_code)
    print(response.text)
```

You get a response with forecast for 30 periods
