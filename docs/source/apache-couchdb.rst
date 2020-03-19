Apache CouchDB
==============

.. warning:: This section is outdated. It is recommended to use PostgreSQL and
             nginx instead to provide a REST API for timeseries data.

It is also possible to create an HTTP service based on Apache CouchDB.  On
FreeBSD, simply install the package:

.. code-block:: console

   # pkg install databases/couchdb2

The configuration can be altered by editing
``/usr/local/etc/couchdb2/local.ini``. Some settings are recommended:

::

   [chttpd]
   port = 5984
   bind_address = 0.0.0.0

   [httpd]
   WWW-Authenticate = Basic realm="Restricted"
   enable_cors = true

   [couch_httpd_auth]
   require_valid_user = true

   [cluster]
   n = 1

   [cors]
   origins = *
   credentials = true
   methods = GET, PUT, POST, HEAD, DELETE
   headers = Accept, Authorization, Content-Type, Origin, Referer, X-CSRF-Token

   [admins]
   admin = <secret passphrase>

It is important to enable **Cross-Origin Resource Sharing (CORS)** to allow
remote access to the database from foreign hosts. Otherwise, only requests from
the very same server are allowed.

You can either enable **TLS-support** in the configuration or run a reverse
proxy like nginx in front of CouchDB to deal with the encryption. Be aware that
only CouchDB should return CORS headers, not the reverse proxy.

Running CouchDB
---------------

On FreeBSD, add the service to ``/etc/rc.conf`` and then start the CouchDB
instance:

.. code-block:: console

   # sysrc couchdb2_enable="YES"
   # service couchdb2 onestart

Access the Fauxton web-interface to administrate the CouchDB instance, for
example at `https://couchdb.example.com/_utils/`_. Fauxton allows you to create
new databases and define map/reduce functions for them.  Make sure that all
databases have at least one admin or member, otherwise they are publicly
readable!

CouchDB Views
-------------

CouchDB provides an HTTP interface to access databases. In order to query a
database, a view must be stored, containing a map/reduce function written in
JavaScript. Use Fauxton to add views to databases.

The following map function returns a range of observation data sets, selected by
project id, sensor node id, target name, and timestamp:

.. code-block:: javascript

   function (doc) {
     if (doc.type == "observation" && doc.project && doc.node && doc.id && doc.timestamp && doc.target) {
        emit([doc.project, doc.node, doc.target, doc.timestamp], doc);
     }
   }

The function is stored in design document ``by_name`` with index name
``observations`` for database ``timeseries``. Use ``curl`` to send a request to
CouchDB:

.. code-block:: console

   $ curl -X GET --user <username>:<password> \
     -G 'https://couchdb.example.com/timeseries/_design/by_date/_view/observations' | jq

The output can be formatted with `jq`_. Add ``startkey`` and ``endkey`` to the
request to select a range of observations:

.. code-block:: console

   $ curl -X GET --user <username>:<password> \
     -G 'https://couchdb.example.com/timeseries/_design/by_date/_view/observations' \
     -d startkey='["project1","node1","p99","2016"]' \
     -d endkey='["project1","node1","p99","2018"]' | jq

This will limit the result to observations with given project id ``project1``,
sensor node id ``node1``, target name ``p99``, and timestamp between \`

.. _`https://couchdb.example.com/_utils/`: https://couchdb.example.com/_utils/
.. _jq: https://stedolan.github.io/jq/
