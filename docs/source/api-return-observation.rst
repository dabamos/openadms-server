.. _api-return-observation:

Return Observation
==================

The API call returns a single observation by given id. The result is either a
JSON array with observation data objects or plain text lines in CSV format,
depending on the chosen HTTP accept header. A line in CSV format contains
timestamp, project id, node id, sensor, target, and all reponse sets with name,
unit, and value.

URL
---
::

    /api/v1/observations/<observation id>/

Method
------
``GET``

Request Fields
--------------
``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
On ``GET``, the server returns either a JSON array of observation data objects
(``application/json``) or lines in CSV format (``text/csv``), depending on the
chosen HTTP accept header (``Accept: application/json`` or ``Accept: text/csv``).

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [
      {
        "type": "observation"
        "id": "00ce160e5cbb49b9bc2ee6f243f87841",
        "nid": "2d1be5b0bd8d42eda483d44232d8ce5d",
        "pid": "0a5a2c9caa45405b9967584154ba1341",
        "sensorName": "incl",
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

Return observation data in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    2018-11-05T11:51:43.256699+00:00,0a5a2c9caa45405b9967584154ba1341,2d1be5b0bd8d42eda483d44232d8ce5d,00ce160e5cbb49b9bc2ee6f243f87841,P100,x,mm,8.0141

Error Response
--------------
No observations:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 410 Gone
* **Response Fields:** ``Content-Type: application/json``
* **Content:** ``{ "code": 410, "message": "No rows." }``

Sample Call
-----------
cURL
^^^^
::

    $ curl -X GET -u user:password -H "Accept: application/json" \
      -G "http://localhost/api/v1/observations/00ce160e5cbb49b9bc2ee6f243f87841/"
