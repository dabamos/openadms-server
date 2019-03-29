.. _api-return-sensors:

Return Sensors
==============

The API call returns all sensors of a given sensor node.

URL
---
::

    /api/v1/projects/<project id>/nodes/<node id>/sensors/

Method
------
``GET``

Request Fields
--------------
The server either returns sensor names in JSON or CSV format. Select output
format by setting the accept header.

``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
Requesting sensor names in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [ "totalstation", "pt100", "weatherStation" ]

Requesting sensor names in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::
    totalstation
    pt100
    weatherStation

Error Response
--------------
No sensors in database:

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
      -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/00ce160e5cbb49b9bc2ee6f243f87841/sensors/"
