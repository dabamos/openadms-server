Introduction
============
In order to run an HTTP service for time series data, either install:

* `PostgreSQL <https://www.postgresql.org/>`_ 9.3+ and
  `nginx <https://nginx.org/>`_, or
* `Apache CouchDB <http://couchdb.apache.org/>`_.

By using PostgreSQL as a JSONB-based document store and nginx as an HTTP
front-end, additional web applications are not required to provide a REST
interface, as nginx will access the database directly. In contrast, an HTTP
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

Apache CouchDB features a built-in HTTP server. But for security reasons, it is recommended to run a reverse proxy like nginx in front of the service.
