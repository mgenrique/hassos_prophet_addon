# Prophet InfluxDB Addon

This addon allows running a forecasting script using Prophet and data from InfluxDB.

## Configuration

You can configure the following options from the Home Assistant UI:

- `INFLUXDB_HOST`: InfluxDB host, InfluxAddon host_name or external IP, examples: a0d7b954-influxdb or 192.168.0.100
- `INFLUXDB_PORT`: InfluxDB port
- `INFLUXDB_USER`: InfluxDB user
- `INFLUXDB_PASSWORD`: InfluxDB password
- `INFLUXDB_DBNAME`: InfluxDB database name

This addon use the Docker image in:
https://hub.docker.com/repository/docker/mgenrique/prophet-influx/general

The addon build a Docker container with python:3.11-slim that implements an api to generate predictions with Prophet. 

### Repository Description

**Prophet API Add-on for Home Assistant**  
This Docker container provides a lightweight REST API based on Flask for time series forecasting using Meta's (formerly Facebook) Prophet model. It is specifically designed to integrate as an add-on in Home Assistant, enabling easy forecasting based on historical data.

### Features

- **REST API**: Receives JSON-formatted data and returns predictions in JSON.
- **Prophet Model**: Utilizes Prophet, a robust and accurate time series model, ideal for trend and seasonality-based data.
- **ISO Date Format**: Returns dates in ISO format to ensure compatibility.

### Usage

1. **Requests**: Send data in JSON format to receive forecasts.
2. **Requests**: Send InfluxQL queries to receive forecasts.
3. **Integration with Home Assistant**: Ideal for generating real-time predictions within Home Assistant.
4. Use it inside your Python code in you own custom component


### Example endpoint `forecast`

Send a POST request to the API `forecast` endpoint with date and value data in the following format:
```bash
curl -X POST "http://localhost:5000/forecast" -H "Content-Type: application/json" -d 'json_string'
```
```python
import requests
import json

# API URL
url = "http://localhost:5000/forecast"

# Sample data (dates and values)
data = {
    "data": [
        {"ds": "2024-01-01", "y": 10},
        {"ds": "2024-01-02", "y": 15},
        {"ds": "2024-01-03", "y": 13},
        {"ds": "2024-01-04", "y": 18}
    ],
    "numPeriods": 30
}

# Make the POST request
response = requests.post(url, json=data)

# Check the response
if response.status_code == 200:
    forecast = response.json()
    print("Forecast:")
    print(json.dumps(forecast, indent=2))
else:
    print("Error:", response.status_code)
    print(response.text)
```
The API will return a forecast of future values.
If `numPeriods` is not specified, it returns the forecast for 30 periods.

### Example endpoint `query`

Send a POST request to the API `query` endpoint with a InfluxDB InfluxQL query a connection parameters:
```bash
curl -X POST "http://localhost:5000/query" -H "Content-Type: application/json" -d 'json_string'
```

```python
import requests
import json

# API URL
url = "http://localhost:5000/query"

# Query request data
data = {
    "str_query": "SELECT * FROM your_measurement WHERE time > now() - 1d",
    "user": "your_user",
    "password": "your_password",
    "dbname": "your_dbname",
    "numPeriods": 30
}

# Make the POST request
response = requests.post(url, json=data)

# Check the response
if response.status_code == 200:
    forecast = response.json()
    print("Forecast:")
    print(json.dumps(forecast, indent=2))
else:
    print("Error:", response.status_code)
    print(response.text)
```
The API will return a forecast of future values training Prophet with the InfluxDB query results
If `numPeriods` is not specified, it returns the forecast for 30 periods.

### Notes

This container is ideal for home automation and applications that require local time series forecasting, especially on ARM architectures.

