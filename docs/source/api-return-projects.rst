.. _api-return-projects:

Return Projects
===============

The API call returns all project ids.

URL
---
::

    /api/v1/projects/

Method
------
``GET``

Request Fields
--------------
The server either returns project ids in JSON or CSV format. Select output
format by setting the accept header.

``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
Requesting project ids in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [ "d9d3cc1b44c046edbc3ec53573f6a81d", "60b8ab8b2aa74404a3d8914a4c505515", "28b8752974f54e6cb635f42b4b2a3e91" ]

Requesting project ids in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    d9d3cc1b44c046edbc3ec53573f6a81d
    60b8ab8b2aa74404a3d8914a4c505515
    28b8752974f54e6cb635f42b4b2a3e91

Error Response
--------------
No project ids in database:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:** ``[]``

Sample Call
-----------
cURL
^^^^
::

    $ curl -X GET -u user:password -H "Accept: application/json" -G "http://localhost/api/v1/projects/"
