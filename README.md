![OpenADMS Server](https://www.dabamos.de/github/openadms.png)

**OpenADMS Server** is a set of scripts and configuration files to run an HTTP service for time series data, obtained from IoT sensor networks based on [OpenADMS Node](https://github.com/dabamos/openadms-node/) or 3rd party applications. A REST interface API is provided for sensor data storage and retrieval. Access the API from your web browser, with command-line tools like [cURL](https://curl.haxx.se/) or [HTTPie](https://httpie.org/), or directly from within your programming language (for instance, by using [jQuery](https://jquery.com/) or [Python Requests](http://docs.python-requests.org/en/master/)).

## HTTP Service
In order to run an HTTP service for time series data, either install:

* [PostgreSQL](https://www.postgresql.org/) 9.3+ and [nginx](https://nginx.org/), or
* [Apache CouchDB](http://couchdb.apache.org/).

By using PostgreSQL as a JSONB-based document store and nginx as an HTTP front-end, additional web applications are not required to provide a REST interface, as nginx will access the database directly. In contrast, an HTTP service written in Python might require an ecosystem like:
```
+------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+
|            |   |            |   |            |   |            |   |            |   |            |   |            |
|   nginx    +-->|   uWSGI    +-->|   Python   +-->|   Falcon   +-->|    App     +-->|  Psycopg   |-->| PostgreSQL |
|            |   |            |   |            |   |            |   |            |   |            |   |            |
+------------+   +------------+   +------------+   +------------+   +------------+   +------------+   +------------+
```
However, the `ngx_postgres` module allows direct access to PostgreSQL from nginx:
```
+------------+   +------------+   +------------+
|            |   |            |   |            |
|   nginx    +-->|ngx_postgres|-->| PostgreSQL |
|            |   |            |   |            |
+------------+   +------------+   +------------+
```
The server can either return data in JSON or CSV format, depending on the HTTP accept header set by the client.

Apache CouchDB features a built-in HTTP server. But for security reasons, it is recommended to run a reverse proxy like nginx in front of the service.

## PostgreSQL
Install PostgreSQL 9.3 or higher. On FreeBSD, run:
```
# pkg databases/postgresql10-server
```
Add the service to `/etc/rc.conf`:
```
# sysrc postgresql_enable=yes
```
Create a new PostgreSQL database cluster:
```
# service postgresql initdb
```
Customise the PostgreSQL configuration file `/var/db/postgres/data10/postgresql.conf`. Add the IP address of the host to `listen_address`:
```
listen_addresses = 'localhost, <your ip>'
```
Change the client authentication in `/var/db/postgres/data10/pg_hba.conf`. Set the IP address for IPv4/IPv6 connections according to your set-up, for example:
```
# TYPE  DATABASE        USER            ADDRESS                 METHOD

# "local" is for Unix domain socket connections only
local   all             all                                     trust
# IPv4 local connections:
host    all             all             127.0.0.1/32            scram-sha-256
host    all             all             <your ip>/32            scram-sha-256
# IPv6 local connections:
host    all             all             ::1/128                 scram-sha-256
```
Start the PostgreSQL server:
```
# service postgresql start
```
Set a new password for user `postgres`. After login, create a new database user `openadms-server` and a new database `timeseries`:
```
# passwd postgres
# su - postgres
$ createuser --no-superuser --createdb --no-createrole openadms-server
$ createdb --encoding UTF8 --owner openadms-server timeseries
```
You can connect to the database with `psql`:
```
$ psql -h localhost -U openadms-server -d timeseries
timeseries=> \l
timeseries=> \d timeseries
timeseries=> \q
```
Create a new SQL table by executing `timeseries.sql` from this repository with `psql`:
```
$ psql -h localhost -U openadms-server -d timeseries -a -f timeseries.sql
```
The PostgreSQL database is now ready to store time series data. Use nginx as a front-end.

### Automated Backups
```
# pg_dump timeseries --username=openadms-server | gzip > /var/backups/`date +"%Y%m%d%H%M%S"`_timeseries.sql.gz
```

`chmod g+x pg_backup.sh`

Cron job:
```
# crontab -e
0	23	*	*	0	/usr/local/sbin/pg_backup.sh
```

`cronjob -l`

## nginx
The HTTP front-end runs on [nginx](https://nginx.org/). Either install nginx or [OpenResty](https://openresty.org/) with the following additional modules:

* [headers-more](https://github.com/openresty/headers-more-nginx-module),
* [lua](https://github.com/openresty/lua-nginx-module),
* [postgres](https://github.com/FRiCKLE/ngx_postgres),
* [set-misc](https://github.com/openresty/set-misc-nginx-module).

On FreeBSD, the full package can be installed with:
```
# pkg install www/nginx-full
```
If you use a custom nginx package or build from source, make sure that all required modules are included.

Copy the file `nginx.conf` from this repository to `/usr/local/etc/nginx/` (FreeBSD) or `/etc/nginx/` (Linux) and alter the configuration to your set-up. You have to update at least the name of the user the nginx process is running under, the connection details of your PostgreSQL database, and the actual server name:
```
user www;   # User to run nginx process under.

http {
    # PostgreSQL connection details. Change "localhost" to the IP address of
    # your database instance, if it is not running on the same host.
    #
    # dbname:   PostgreSQL database name.
    # user:     PostgreSQL user name.
    # password: PostgreSQL password.
    upstream postgresql {
        postgres_server     localhost dbname=observations user=openadms-server password=secret;
        postgres_keepalive  max=200 overflow=reject;
    }

    server {
        server_name  www.example.com;   # CHANGE TO YOUR SERVER NAME!
    }
}
```

### Access Restriction
The API uses HTTP BasicAuth for access restriction. Clients must send an authorization header with encoded user name and password. Store login credentials in `/usr/local/etc/nginx/.htpasswd`. If you use a different path, change `nginx.conf` accordingly. You can use [security/py-htpasswd](https://www.freshports.org/security/py-htpasswd/) to generate `htpasswd` files.

## Apache CouchDB
It is also possible to create an HTTP service based on Apache CouchDB. On FreeBSD, simply install the package:
```
# pkg install databases/couchdb2
```
The configuration can be altered by editing ``/usr/local/etc/couchdb2/local.ini``. Some settings are recommended:
```
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
```
It is important to enable **Cross-Origin Resource Sharing (CORS)** to allow remote access to the database from foreign hosts. Otherwise, only requests from the very same server are allowed.

You can either enable **TLS-support** in the configuration or run a reverse proxy like nginx in front of CouchDB to deal with the encryption. Be aware that only CouchDB should return CORS headers, not the reverse proxy.

### Running CouchDB
On FreeBSD, add the service to ``/etc/rc.conf`` and then start the CouchDB instance:
```
# sysrc couchdb2_enable="YES"
# service couchdb2 onestart
```
Access the Fauxton web-interface to administrate the CouchDB instance, for example at [https://couchdb.example.com/_utils/](https://couchdb.example.com/_utils/). Fauxton allows you to create new databases and define map/reduce functions for them. Make sure that all databases have at least one admin or member, otherwise they are publicly readable!

### CouchDB Views
CouchDB provides an HTTP interface to access databases. In order to query a database, a view must be stored, containing a map/reduce function written in JavaScript. Use Fauxton to add views to databases.

The following map function returns a range of observation data sets, selected by project id, sensor node id, target name, and timestamp:
```
function (doc) {
  if (doc.type == "observation" && doc.project && doc.node && doc.id && doc.timestamp && doc.target) {
     emit([doc.project, doc.node, doc.target, doc.timestamp], doc);
  }
}
```
The function is stored in design document ``by_name`` with index name ``observations`` for database ``timeseries``. Use ``curl`` to send a request to CouchDB:
```
$ curl -X GET --user <username>:<password> \
  -G 'https://couchdb.example.com/timeseries/_design/by_date/_view/observations' | jq
```
The output can be formatted with [jq](https://stedolan.github.io/jq/). Add ``startkey`` and ``endkey`` to the request to select a range of observations:
```
$ curl -X GET --user <username>:<password> \
  -G 'https://couchdb.example.com/timeseries/_design/by_date/_view/observations' \
  -d startkey='["project1","node1","p99","2016"]' \
  -d endkey='["project1","node1","p99","2018"]' | jq
```
This will limit the result to observations with given project id ``project1``, sensor node id ``node1``, target name ``p99``, and timestamp between ``2016`` and ``2018``. Month, day, and time can be added to the timestamp in ISO 8601 format (``2018-10-27T12:26:21.592259+00:00``).

## Licence
BSD-2-Clause.
