Introduction
============
In order to run an HTTP service for time series data, either install:

* `PostgreSQL <https://www.postgresql.org/>`_ 11 (or higher), and
* `nginx <https://nginx.org/>`_ or `OpenResty <https://openresty.org/>`_.

By using PostgreSQL as a JSONB-based document store and nginx as an HTTP
front-end, additional web applications are not required to provide REST
interfaces, as nginx will access the database directly. In contrast, an HTTP
service written in Python might require an ecosystem like:

::

    +------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+
    |            |   |            |   |            |   |            |   |            |   |            |   |            |
    |   nginx    +-->|   uWSGI    +-->|   Python   +-->|   Falcon   +-->|    App     +-->|  Psycopg   |-->| PostgreSQL |
    |            |   |            |   |            |   |            |   |            |   |            |   |            |
    +------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+

Whereas the nginx module ``ngx_postgres`` provides direct access to PostgreSQL:

::

    +------------+   +------------+   +------------+
    |            |   |            |   |            |
    |   nginx    +-->|ngx_postgres|-->| PostgreSQL |
    |            |   |            |   |            |
    +------------+   +------------+   +------------+

The server can either return data in JSON or CSV format, depending on the HTTP
accept header set by the client.

Instead of PostgreSQL and nginx, `Apache CouchDB <https://couchdb.apache.org/>`_
can be used that features a built-in HTTP server. For security reasons, it is
recommended to still run a reverse proxy like nginx in front of the service.
