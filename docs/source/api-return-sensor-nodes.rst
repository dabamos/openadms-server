.. _api-return-sensor-nodes:

Return Sensor Nodes
===================

The API call returns all sensor nodes of a given project.

URL
---
::

    /api/v1/projects/<project id>/nodes/

Method
------
``GET``

Request Fields
--------------
The server either returns sensor node ids in JSON or CSV format. Select output
format by setting the accept header.

``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
Requesting sensor node ids in JSON format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [ "92177f1e6c49459abc6e85d03df87138", "f07e9064c0024781bb3b885977109742", "5f105f5bd1d743de9a1c2be5178cabec" ]

Requesting sensor node ids in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    92177f1e6c49459abc6e85d03df87138
    f07e9064c0024781bb3b885977109742
    5f105f5bd1d743de9a1c2be5178cabec

Error Response
--------------
No sensor node ids in database:

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 410 Gone
* **Response Fields:** ``Content-Type: application/json``
* **Content:** ``{ "code": 410, "error": "No rows." }``

Sample Call
-----------
cURL
^^^^
::

    $ curl -X GET -u openadms-server:password -H "Accept: application/json" \
      -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/"
