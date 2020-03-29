#!/usr/bin/env python3

import requests

if __name__ == '__main__':
    host = 'api.example.com'        # OpenADMS Server instance.
    user = '<user>'                 # User name.
    password = '<password>'         # User password.

    pid = '<pid>'                   # Project id.
    nid = '<nid>'                   # Sensor node id.
    sensor = '<sensor>'             # Sensor name.
    target = '<target>'             # Target name.

    start = '2020-01-01T00:00:00'   # Start of time period.
    end = '2020-12-31T23:59:59'     # End of time period.

    api = ''.join(['https://', host, '/api/v1/projects/', pid, '/nodes/', nid,
                   '/sensors/', sensor, '/targets/', target, '/observations/'])

    payload = { 'start': start, 'end': end }
    r = requests.get(api, auth=(user, password), params=payload, timeout=30)
    print(r.json())
