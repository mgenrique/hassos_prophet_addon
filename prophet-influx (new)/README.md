This addon install de Docker container in:
[https://hub.docker.com/repository/docker/mgenrique/prophet-influx/general](https://hub.docker.com/repository/docker/mgenrique/prophet-influx/general)

if you need to pull it for other purposes you can do:
```bash
docker pull mgenrique/prophet-influx:latest
````

Container with python:3.11-slim for arm that implements an api to generate predictions with Prophet. API designed to make a Home Assistant addon obtaining data from InfluxDB.

### Repository Description

**Prophet API Add-on for Home Assistant**  
This Docker container provides a lightweight REST API based on FastAPI for time series forecasting using Meta's (formerly Facebook) Prophet model. It is specifically designed to integrate as an add-on in Home Assistant, enabling easy forecasting based on historical data.

### Features

- **REST API**: 
    - Endpoint forecast: Receives JSON-formatted data and returns predictions in JSON.
    - Endpoint query: Receives InfluxDB query and returns predictions in JSON.
    - Endpoint energy_queries: Receives InfluxDB queries and returns predictions in JSON.
- **Prophet Model**: Utilizes Prophet, a robust and accurate time series model, ideal for trend and seasonality-based data.
- **ARM Compatibility**: Optimized for ARM architectures, ideal for devices like the Raspberry Pi.

### Usage

1. **Installation**: Pull the container from Docker Hub or clone the repository and build the image.
2. **Integration with Home Assistant**: Ideal for generating real-time predictions within Home Assistant.

### Example
Test code
```python
import requests
from datetime import datetime, timedelta
import pandas as pd
import pytz

influx_pass="your_influx_pass"

# Container-API URL base
base_url = "http://localhost:5000"

# Sample data endpoint /forecast
forecast_data = {
    "data": [
        {"ds": "2023-01-01", "y": 10},
        {"ds": "2023-01-02", "y": 15},
        {"ds": "2023-01-03", "y": 20}
    ],
    "futurePeriods": 10
}



# Send POST request to the /forecast endpoint
response = requests.post(f"{base_url}/forecast", json=forecast_data)
print("\nForecast response:", response.json())

# Sample data for the /query endpoint
# Prepare influxdb query string
class_local_timezone=pytz.timezone('Europe/Madrid')

def format_date_for_influxdb( date) -> str:
    """
    Return a date and time with timezone information in the format '2024-10-01T00:00:00Z' (UTC timezone).
    """
    date = pd.to_datetime(date)
    # Check if date has a localized time
    if date.tzinfo is None:
        if class_local_timezone is None:
            date_tz = 'Europe/Madrid'        
            date = date.tz_localize(date_tz)
        else:
            date = date.tz_localize(class_local_timezone)
    # Localize the date and time to the UTC timezone
    # date = await asyncio.to_thread(date.tz_convert, 'UTC')
    date = date.tz_convert('UTC')
    # Format the date in ISO 8601 format
    date = date.strftime('%Y-%m-%dT%H:%M:%SZ')
    return date

def energy_query_string(entity_id, start: str | None = None, end: str | None = None) -> str:
    """Create the SQL query string for energy data."""
    if start is not None:
        # start = await self.format_date_for_influxdb(start)
        start = format_date_for_influxdb(start)
    if end is not None:
        # end = await self.format_date_for_influxdb(end)
        end = format_date_for_influxdb(end)
    # If start and end are not specified, return all data
    if start is None and end is None:
        query = """SELECT last("value") AS "energy_kWh" FROM "kWh" WHERE "entity_id"='{}' GROUP BY time(1h) fill(previous)""".format(entity_id)
    elif start is None:
        query = """SELECT last("value") AS "energy_kWh" FROM "kWh" WHERE (time <= '{}') AND "entity_id"='{}' GROUP BY time(1h) fill(previous)""".format(end, entity_id) 
    elif end is None:
        query = """SELECT last("value") AS "energy_kWh" FROM "kWh" WHERE (time >= '{}') AND "entity_id"='{}' GROUP BY time(1h) fill(previous)""".format(start, entity_id)   
    else:
        query = """SELECT last("value") AS "energy_kWh" FROM "kWh" WHERE (time >= '{}') AND (time <= '{}') AND "entity_id"='{}' GROUP BY time(1h) fill(previous)""".format(start, end, entity_id)
    return query 


# Sample data for endpoint /query
end=datetime.now()
start=end-timedelta(days=10)
entity_id1 = "energy_current_hour"
str_query = energy_query_string(entity_id1, start=start, end=end)
query_data = {
    "str_query": str_query,
    "influx_host": "192.168.0.100",
    "influx_port": 8086,
    "influx_user": "homeassistant",
    "influx_password": influx_pass,
    "influx_dbname": "homeassistant",
    "futurePeriods": 10
}

# Send request POST endpoint /query
response = requests.post(f"{base_url}/query", json=query_data)
if response.status_code == 200:
    try:
        print("\nQuery response:", response.json())
        cc_response = {str(k): v for k, v in response.json().items()}
        cc_response = {pd.to_datetime(k).tz_convert(class_local_timezone)\
                       .strftime('%Y-%m-%dT%H:%M:%S'): v for k, v in cc_response.items()}
        print()
        print("\nQuery response local timezone:", cc_response)        
    except requests.exceptions.JSONDecodeError:
        print("Failed to decode JSON response")
else:
    print(f"Request failed with status code {response.status_code}")


# Prepare data for the /energy_queries endpoint

end=datetime.now()
start=end-timedelta(days=10)
entity_id1 = "victron_vebus_acin1toacout_228"
str_query1 = energy_query_string(entity_id1, start=None, end=end)
entity_id2 = "victron_vebus_invertertoacout_228"
str_query2 = energy_query_string(entity_id2, start=None, end=end)
energy_query_data = {
    "str_query1": str_query1,
    "str_query2": str_query2,
    "influx_host": "192.168.0.100",
    "influx_port": 8086,
    "influx_user": "homeassistant",
    "influx_password": influx_pass,
    "influx_dbname": "homeassistant",
    "futurePeriods": 12
}

# Send Request POST endpoint /energy_queries
response = requests.post(f"{base_url}/energy_queries", json=energy_query_data)
if response.status_code == 200:
    try:
        print("\nEnergy Queries response:", response.json())
        cc_response = {str(k): v for k, v in response.json().items()}
        cc_response = {pd.to_datetime(k).tz_convert(class_local_timezone)\
                       .strftime('%Y-%m-%dT%H:%M:%S'): v for k, v in cc_response.items()}
        print("\nEnergy Queries response local timezone:", cc_response)
    except requests.exceptions.JSONDecodeError:
        print("Failed to decode JSON response")
else:
    print(f"Request failed with status code {response.status_code}")
```

