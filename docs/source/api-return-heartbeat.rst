.. _api-return-heartbeat:
Return Heartbeat
================

Returns the last heartbeat of a sensor node, containing project id, node id, IP
address, and timestamp.

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
      "ip": "10.0.0.9",
      "dt": "2019-04-04T20:15:09.847721+02:00"
    }

In CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:** ``e1a36b67e32f4f0ea1f40e6f1898b28e,de5cc10f4a9a4bda9b390ccd8c5a3aa4,10.0.0.9,2019-04-04T20:15:09.847721+02:00``

Error Response
--------------
Wrong or missing credentials:

* **Request:** ``GET``
* **Request Fields:** ``Content-Type: application/json``
* **Code:** 401
* **Content:** ``{ code: 401, error: "Unauthorized." }``

Sample Call
-----------
cURL
^^^^
Requesting the last heartbeat of a given project id and node id:

::

    $ curl -X GET -u openadms-server:password -H "Accept: application/json" \
      http://localhost/api/v1/projects/pid/nodes/nid/heartbeat/
