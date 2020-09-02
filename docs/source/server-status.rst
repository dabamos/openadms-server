.. _server-status:

Server Status
=============

Returns the current server status, including database name, date and time,
uptime, and PostgreSQL version string.

URL
---
::

    /api/v1/

Method
------
``GET``

Request Fields
--------------
``Content-Type: application/json``

Success Response
----------------
Requesting targets in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    {
      "database": "openadms",
      "timestamp": "2020-04-11T13:44:15.01106+02:00",
      "uptime": "18 days 11:17:43",
      "version": "PostgreSQL 11.7 on amd64-portbld-freebsd12.1, compiled by FreeBSD clang version 8.0.1 (tags/RELEASE_801/final 366581) (based on LLVM 8.0.1), 64-bit"
    }


Sample Call
-----------
cURL
^^^^
Retrieving the server status:

::

    $ curl -X GET -u user:password -H "Content-Type: application/json" \
      -G http://localhost/api/v1/

