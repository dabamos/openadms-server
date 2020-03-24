.. _api-send-log-message:

Send Log Messages
=================

Stores a single log message in the database. The request header must contain
``Content-Type: application/x-www-form-urlencoded``. The message must be
submitted as form data:

* project id (``pid``),
* sensor node id (``nid``),
* ISO 8601 timestamp (``dt``),
* OpenADMS Node module name (``module``),
* log level (``level``),
* message (``message``).

The server returns 20O OK on success.

URL
---
::

    /api/v1/logs/

Method
------
``POST``

Request Fields
--------------
``Content-Type: application/x-www-form-urlencoded``

Success Response
----------------
  * **Request:** ``POST``
  * **Request Fields:** ``Content-Type: application/x-www-form-urlencoded``
  * **Code:** 200 OK
  * **Content:** –

Error Response
--------------
Wrong ``Content-Type``:

  * **Request:** ``POST``
  * **Request Fields:** ``Content-Type: application/json``
  * **Code:** 405 Method not allowed
  * **Response Fields:** ``Content-Type: application/json``
  * **Content:** ``{ "code": 405, "message": "Method not allowed." }``

Sample Call
-----------
cURL
^^^^
Sending a heartbeat:

::

    $ curl -X POST -u user:password -H "Content-Type: application/x-www-form-urlencoded" \
      -d "pid=<project id>&nid=<node id>&dt=2020-01-04T13:01:00&module=myModule&level=warning&message=test" \
      http://localhost/api/v1/logs/
