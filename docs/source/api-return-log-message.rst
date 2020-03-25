.. _api-return-log-message:

Return Log Message
==================

Returns the log message of the given id, containing log id, project id, node id,
timestamp, OpenADMS Node module name, log level, and log message. The log id is
a numeric value. The log message is either returned in JSON or CSV format.

URL
---
::

    /api/v1/logs/<id>/

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
      "id": 8,
      "pid": "4a2e8b9d87d849e38bb6911b9f2364ea",
      "nid": "21bcf8c16a664b17bbc9cd4221fd8541",
      "dt": "2020-03-21T04:18:05+01:00",
      "module": "errorGenerator",
      "level": "warning",
      "message": "AUTO GENERATED WARNING #1"
    }

In CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    8,4a2e8b9d87d849e38bb6911b9f2364ea,21bcf8c16a664b17bbc9cd4221fd8541,2020-03-21 04:18:05+01,errorGenerator,warning,AUTO GENERATED WARNING #1

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
Requesting a log message in JSON format:

::

    $ curl -X GET -u user:password -H "Accept: application/json" \
      http://localhost/api/v1/logs/142/

Requesting a log message in CSV format:

::

    $ curl -X GET -u user:password -H "Accept: text/csv" \
      http://localhost/api/v1/logs/142/

