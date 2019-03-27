# Return Observation Data
The API call returns timeseries data for given project id, sensor node id, sensor name, target name, and time range. Timestamps must be formatted as ISO 8601 (``YYYY-MM-DDThh:mm:ss.ffffff±hh:mm``). The result is either a JSON array with observation data objects or plain text lines in CSV format, depending on the chosen HTTP accept header.

## URL
```
/api/v1/projects/<project id>/nodes/<node id>/sensors/<sensor name>/targets/<target name>/?start=YYYY-MM-DDThh:mm:ss.ffffff±hh:mm&end=YYYY-MM-DDThh:mm:ss.ffffff±hh:mm
/api/v1/projects/<project id>/nodes/<node id>/sensors/<sensor name>/targets/<target name>/?start=YYYY-MM-DD&end=YYYY-MM-DD
```
## Method
`GET`

## Request Fields
`Accept: application/json` | `Accept: text/csv`

## URL Params
The start and end timestamp can be provided as URL parameters (defaults are `1900` and `2300`).

### Optional
`start=[string]`
Example: `start=2018-11-05T11:50:00.000000+00:00`

`end=[string]`
Example: `end=2019-11-05T11:54:00.000000+00:00`

## Success Response
On 'GET', the server returns either a JSON array of observation data objects (`application/json`) or lines in CSV format (`text/csv`), depending on the chosen HTTP accept header ('Accept: application/json' or 'Accept: text/csv').

  * **Code:** 200
  * **Response Fields:** `Content-Type: application/json`
  * **Content:**
```
 [
  {
    "id": "00ce160e5cbb49b9bc2ee6f243f87841",
    "nid": "2d1be5b0bd8d42eda483d44232d8ce5d",
    "pid": "0a5a2c9caa45405b9967584154ba1341",
    "name": "getSensorData",
    "type": "observation",
    "target": "P100",
    "timestamp": "2018-11-05T11:51:43.256699+00:00",
    "responseSets": {
      "x": {
        "type": "float",
        "unit": "mm",
        "value": "8.0141"
      }
    }
  }
]
```

  * **Request:** `GET`
  * **Code:** 200
  * **Response Fields:** `Content-Type: text/csv`
  * **Content:**
```
2018-11-05T11:51:43.256699+00:00,pid,0a5a2c9caa45405b9967584154ba1341,nid,2d1be5b0bd8d42eda483d44232d8ce5d,id,00ce160e5cbb49b9bc2ee6f243f87841,target,P100,x,8.0141,mm
```

## Error Response
  * **Request:** `GET`
  * **Code:** 410 Gone
  * **Response Fields:** `Content-Type: application/json`
  * **Content:** `{ error: "No rows." }`

## Sample Call
### cURL
```
$ curl -X GET -u openadms-server:password -H "Accept: application/json" -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/00ce160e5cbb49b9bc2ee6f243f87841/sensors/TM30/targets/P100/?start=2018-11-05T11:50:00.000000+00:00&end=2019-11-05T11:54:00.000000+00:00"
```
