.. _api-send-heartbeat:
Send Heartbeat
==============

Creates a new or updates an exicisting heartbeat of a sensor node in the
database. The request header must contain ``Content-Type:
application/x-www-form-urlencoded``. The project id, the node id, and the
heartbeat frequency in seconds must be submitted as form data (``pid``, ``nid``,
and ``freq``). The server returns 201 Created on success. The server stores
project id, node id, frequency, IP address of the client, and timestamp with
timezone in the database.

URL
---
::

    /api/v1/heartbeats/

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
  * **Code:** 201 Created
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
      -d "pid=<project id>&nid=<node id>&freq=300" http://localhost/api/v1/heartbeats/

Python
^^^^^^
Sending a heartbeat with `Requests`_:

::

    response = requests.post('http://localhost/api/v1/heartbeats/',
                             auth=('<user>', '<password>'),
                             data={'pid': project_id, 'nid': node_id, 'freq': frequency},
                             timeout=30)

.. _Requests: https://requests.readthedocs.io/en/master/
