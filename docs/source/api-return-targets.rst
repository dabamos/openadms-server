.. _api-return-targets:

Return Targets
==============

The API call returns all targets of a given sensor.

URL
---
::

    /api/v1/projects/<project id>/nodes/<node id>/sensors/<sensor name>/targets/

Method
------
``GET``

Request Fields
--------------
The server either returns targets in JSON or CSV format. Select output format by
setting the accept header.

``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
The server returns either a JSON array of targets (``application/json``) or
lines in CSV format (``text/csv``), depending on the chosen HTTP accept header.

Requesting targets in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [ "P100", "P101", "P102" ]

Requesting targets in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    P100
    P101
    P102

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
      -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/00ce160e5cbb49b9bc2ee6f243f87841/sensors/totalstation/targets/"
