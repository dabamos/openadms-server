.. _api-store-observation-data:
Store Observation Data
======================

Stores a JSON-formatted observation data object in the database. Multiple
observations can be sent as a JSON array. Maximum size of the request body is
100 KiB. The request header must contain ``Content-Type: application/json``
(``application/x-www-form-urlencoded`` will be rejected). The server returns
201 Created on success

URL
---
::

    /api/v1/observations/

Method
------
``POST``

Request Fields
--------------
``Accept: application/json``

Success Response
----------------
  * **Request:** ``POST``
  * **Request Fields:** ``Accept: application/json``
  * **Code:** 201 Created
  * **Content:** –

Error Response
--------------
Observation data was not inserted:

  * **Request:** ``POST``
  * **Request Fields:** ``Content-Type: application/json``
  * **Code:** 204 No content
  * **Content:** ``{ "code": 204, "error": "No content." }``

Wrong ``Content-Type``:

  * **Request:** ``POST``
  * **Request Fields:** ``Content-Type: application/x-www-form-urlencoded``
  * **Code:** 405 Method not allowed
  * **Response Fields:** ``Content-Type: application/json``
  * **Content:** ``{ "code": 405, "error": "Method not allowed." }``

Sample Call
-----------
cURL
^^^^
Sending an observation in JSON format from file ``data.json``:

::

    $ curl -X POST -u openadms-server:password -H "Content-Type: application/json" \
      -d @data.json http://localhost/api/v1/observations/
