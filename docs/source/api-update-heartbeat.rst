.. _api-update-heartbeat:
Update Heartbeat
================

Creates a new or updates an exicisting heartbeat of a sensor node in the
database. The request header must contain ``Content-Type:
application/x-www-form-urlencoded``. The project id and the node id must be
submitted as form data (``pid`` and ``nid``). The server returns 201 Created on
success. The server stores project id, node id, IP address of the client, and
timestamp with timezone in the database.

URL
---
::

    /api/v1/heartbeat/

Method
------
``PUT``

Request Fields
--------------
``Content-Type: application/x-www-form-urlencoded``

Success Response
----------------
  * **Request:** ``PUT``
  * **Request Fields:** ``Content-Type: application/x-www-form-urlencoded``
  * **Code:** 201 Created
  * **Content:** –

Error Response
--------------
Heartbeat not successful:

  * **Request:** ``PUT``
  * **Request Fields:** ``Content-Type: application/x-www-form-urlencoded``
  * **Code:** 410 Gone
  * **Content:** –

Wrong request type:

  * **Request:** ``POST``
  * **Request Fields:** ``Content-Type: application/x-www-form-urlencoded``
  * **Code:** 405 Method not allowed
  * **Response Fields:** ``Content-Type: application/json``
  * **Content:** ``{ code: 405, error: "Method not allowed." }``

Sample Call
-----------
cURL
^^^^
Sending a heartbeat:

::

    $ curl -X PUT -u openadms-server:password -H "Content-Type: application/x-www-form-urlencoded" \
      -d "pid=<project id>&nid=<node id>" http://localhost/api/v1/heartbeat/
