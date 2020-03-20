.. _api-return-heartbeat:
Return Heartbeat
================

Returns the last heartbeat of a sensor node, containing project id, node id,
heartbeat frequency in seconds, IP address, and timestamp of last heartbeat.

URL
---
::

    /api/v1/projects/<pid>/nodes/<nid>/heartbeat/

Method
------
``GET``

Request Fields
--------------
``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
In JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    {
      "pid": "e1a36b67e32f4f0ea1f40e6f1898b28e",
      "nid": "de5cc10f4a9a4bda9b390ccd8c5a3aa4",
      "freq": 300,
      "ip": "10.0.0.9",
      "dt": "2019-04-04T20:15:09.847721+02:00"
    }

In CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:** ``e1a36b67e32f4f0ea1f40e6f1898b28e,de5cc10f4a9a4bda9b390ccd8c5a3aa4,300,10.0.0.9,2019-04-04T20:15:09.847721+02:00``

Error Response
--------------
Wrong or missing credentials:

* **Request:** ``GET``
* **Request Fields:** ``Content-Type: application/json``
* **Code:** 401
* **Content:** ``{ "code": 401, "message": "Unauthorized." }``

Sample Call
-----------
cURL
^^^^
Requesting the last heartbeat of a given project id and node id in JSON format:

::

    $ curl -X GET -u user:password -H "Accept: application/json" \
      http://localhost/api/v1/projects/e1a36b67e32f4f0ea1f40e6f1898b28e/nodes/de5cc10f4a9a4bda9b390ccd8c5a3aa4/heartbeat/

Requesting the last heartbeat of a given project id and node id in CSV format:

::

    $ curl -X GET -u user:password -H "Accept: text/csv" \
      http://localhost/api/v1/projects/e1a36b67e32f4f0ea1f40e6f1898b28e/nodes/de5cc10f4a9a4bda9b390ccd8c5a3aa4/heartbeat/

