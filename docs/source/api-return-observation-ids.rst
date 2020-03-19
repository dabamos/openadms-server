.. _api-return-observation-ids:

Return Observation IDs
======================

The API call returns all observation ids of a given project id, sensor node id,
sensor name, and target name. The result is either a JSON array or plain text
lines in CSV format, depending on the chosen HTTP accept header.

URL
---
::

    /api/v1/projects/<project id>/nodes/<node id>/sensors/<sensor name>/targets/<target name>/ids/

Method
------
``GET``

Request Fields
--------------
``Accept: application/json`` | ``Accept: text/csv``

Success Response
----------------
On ``GET``, the server returns either a JSON array of observation ids
(``application/json``) or lines in CSV format (``text/csv``), depending on the
chosen HTTP accept header (``Accept: application/json`` or ``Accept: text/csv``).

* **Request:** ``GET``
* **Request Fields:** ``Accept: application/json``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: application/json``
* **Content:**

::

    [ "034aa44cf9b4414b8c6ee0a9c57f4ff1", "05cbd84523af41679167de78e08d2e4c", "062d2d49c2914dbfb62c8a9155a37b85" ]

Return observation ids in CSV format:

* **Request:** ``GET``
* **Request Fields:** ``Accept: text/csv``
* **Code:** 200 OK
* **Response Fields:** ``Content-Type: text/csv``
* **Content:**

::

    034aa44cf9b4414b8c6ee0a9c57f4ff1
    05cbd84523af41679167de78e08d2e4c
    062d2d49c2914dbfb62c8a9155a37b85

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
      -G "http://localhost/api/v1/projects/0a5a2c9caa45405b9967584154ba1341/nodes/00ce160e5cbb49b9bc2ee6f243f87841/sensors/TM30/targets/P100/ids/"
