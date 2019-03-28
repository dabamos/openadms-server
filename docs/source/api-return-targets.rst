.. _api-return-targets:
Return Targets
==============

The API call returns timeseries data for given project id, sensor node id,
target name, and time range. Timestamps must be formatted as ISO 8601
(``YYYY-MM-DDThh:mm:ss.ffffff±hh:mm``). The result is either a JSON array with
observation data objects or plain text lines in CSV format, depending on the
chosen HTTP accept header.

URL
---
::

    /api/v1/projects/<project id>/nodes/<node id>/targets/

Method
------
``GET``

Request Fields
--------------
The server either returns observation data in JSON or CSV format. Select output
format by setting the accept header.

``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
The server returns either a JSON array of observation data objects
(``application/json``) or lines in CSV format (``text/csv``), depending on the
chosen HTTP accept header. The CSV contains timestamp, project id, node id,
observation id, sensor name, target name, and all sensor response sets.

Requesting observation data in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**
::

    [
      {
        "id": "00ce160e5cbb49b9bc2ee6f243f87841",
        "nid": "2d1be5b0bd8d42eda483d44232d8ce5d",
        "pid": "0a5a2c9caa45405b9967584154ba1341",
        "name": "getSensorData",
        "sensorName": "incl",
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

Requesting observation data in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**
::

    2018-11-05T11:51:43.256699+00:00,0a5a2c9caa45405b9967584154ba1341,2d1be5b0bd8d42eda483d44232d8ce5d,00ce160e5cbb49b9bc2ee6f243f87841,incl,P100,x,mm,8.0141

Error Response
--------------
No targets in database:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 410 Gone
* **Response Fields:** ``Content-Type: application/json``
* **Content:** ``{ error: "No rows." }``

Sample Call
-----------
cURL
^^^^
::

    $ curl -X GET -u openadms-server:password -H "Accept: application/json" \
      -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/00ce160e5cbb49b9bc2ee6f243f87841/targets/P100/?start=2018-11-05T11:50:00.000000+00:00&end=2019-11-05T11:54:00.000000+00:00"
