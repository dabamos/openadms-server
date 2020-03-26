Introduction
============
OpenADMS Server stores observations, log messages, and heartbeats from OpenADMS
Node instances or 3rd party applications. In order to run an instance, install

* `PostgreSQL <https://www.postgresql.org/>`_ 11 (or higher), and
* `nginx <https://nginx.org/>`_ or `OpenResty <https://openresty.org/>`_.

PostgreSQL is used as a JSONB-based document store, and nginx as an HTTP
front-end. Additional software is not required to provide the REST interfaces,
as nginx will access the PostgreSQL database directly. A traditional web
application written in Python 3 might require an infrastructure similar to
the following one to make calls to a database backend:

::

    +------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+
    |            |   |            |   |            |   |            |   |            |   |            |   |            |
    |   nginx    +-->|   uWSGI    +-->|   Python   +-->|   Falcon   +-->|    App     +-->|  Psycopg   |-->| PostgreSQL |
    |            |   |            |   |            |   |            |   |            |   |            |   |            |
    +------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+

In contrast, the nginx module ``ngx_postgres`` provides direct access to
PostgreSQL:

::

    +------------+   +------------+   +------------+
    |            |   |            |   |            |
    |   nginx    +-->|ngx_postgres|-->| PostgreSQL |
    |            |   |            |   |            |
    +------------+   +------------+   +------------+

The server can either return data in JSON or CSV format, depending on the HTTP
accept header sent by the client.

Instead of PostgreSQL and nginx, the
`Apache CouchDB <https://couchdb.apache.org/>`_ NoSQL database can be
used to store observations. Read/write access is provided by a built-in HTTP
server. For security reasons, it is still recommended to run a reverse proxy
with TLS like nginx in front of the service.
