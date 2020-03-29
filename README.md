![OpenADMS Server](https://www.dabamos.de/github/openadms-server.png)

**OpenADMS Server** is a set of scripts and configuration files to run an HTTP
service for time series data, obtained from IoT sensor networks based on
[OpenADMS Node](https://github.com/dabamos/openadms-node/) or 3rd party
applications. A REST interface API is provided for storage and retrieval of
sensor data, log messages, and heartbeats. Access the API from your web browser,
with command-line tools like [cURL](https://curl.haxx.se/) or
[HTTPie](https://httpie.org/), or directly from within your programming language
(for instance, by using [jQuery](https://jquery.com/) or
[Python Requests](http://docs.python-requests.org/en/master/)).

The OpenADMS Server is based on [PostgreSQL](https://www.postgresql.org/) and
[nginx](https://nginx.org/)/[OpenResty](https://openresty.org/). The
following nginx modules are required:

* [form-input](https://github.com/calio/form-input-nginx-module)
* [headers-more](https://github.com/openresty/headers-more-nginx-module)
* [http-realip](http://nginx.org/en/docs/http/ngx_http_realip_module.html)
* [lua](https://github.com/openresty/lua-nginx-module)
* [postgres](https://github.com/FRiCKLE/ngx_postgres)
* [set-misc](https://github.com/openresty/set-misc-nginx-module)

## Quick Start
The complete documentation is hosted on the
[project website](https://www.dabamos.de/manual/openadms-server/).

### PostgreSQL
Install [PostgreSQL 11](https://www.postgresql.org/) or higher. On FreeBSD, run:

```
# pkg databases/postgresql11-server
```

Add the service to `/etc/rc.conf`:

```
# sysrc postgresql_enable="YES"
```

Create a new PostgreSQL database cluster:

```
# service postgresql initdb
```

Customise the PostgreSQL configuration file
`/var/db/postgres/data11/postgresql.conf`. Set the password encryption to
`scram-sha-256`:

```
password_encryption = scram-sha-256
```

Optionally, add another host IP address to `listen_address`. Change the client
authentication in `/var/db/postgres/data11/pg_hba.conf`. Set the IP address for
IPv4/IPv6 connections according to your set-up, for example:

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

Set a new password for user `postgres`. After login, add a new database user
(e.g., `openadms`) and a new database (e.g., `timeseries`):

```
# passwd postgres
# su - postgres
$ createuser --no-superuser --createdb --no-createrole --pwprompt <username>
Enter password for new role:
Enter it again:
$ createdb --encoding UTF8 --owner <username> <database>
```

You may want to create additional roles which have restricted privileges. Create
the SQL schema by executing the file `psql/timeseries.sql` from the repository
with `psql`:

```
$ psql -h localhost -U <username> -d timeseries -a -f psql/timeseries.sql
```

The PostgreSQL database is now ready to store time series data. Configure nginx
as a front-end.

### nginx
Install [nginx](https://nginx.org/) with all required 3rd party modules. On
Linux, you probably prefer [OpenResty](https://openresty.org/). On FreeBSD, the
full package can be installed with:

```
# pkg install www/nginx-full www/lua-resty-core
```

Copy the file `nginx/nginx.conf` and directory `nginx/openadms-server` from the
GitHub repository to `/usr/local/etc/nginx/` (FreeBSD) or `/etc/nginx/` (Linux)
and alter the configuration to your set-up. You have to set at least the name
of the user the nginx process is running under, the connection details of your
PostgreSQL database, and the actual server name:

```
user www;   # User to run nginx process under (or "nobody").

http {
    # PostgreSQL connection details. Change "localhost" to the IP address of
    # your database instance, if it is not running on the same host, and enter
    # user name and passwort.
    #
    # dbname:   PostgreSQL database name.
    # user:     PostgreSQL user name.
    # password: PostgreSQL password.
    upstream postgresql {
        postgres_server     localhost dbname=<database> user=<username> password=<password>;
        postgres_keepalive  max=200 overflow=reject;
    }

    server {
        server_name  www.example.com;   # CHANGE TO YOUR SERVER NAME!
    }
}
```

It is strongly adviced to add an X.509 certificate and change the port to 443.
Please see the
[nginx manual](http://nginx.org/en/docs/http/configuring_https_servers.html)
on how to configure HTTPS servers.

The API uses HTTP Basic Auth for access restriction. Clients must send an
authorisation header with encoded user name and password. Store login
credentials in `.htpasswd` along your `nginx.conf`. If you use a different path,
change `nginx.conf` accordingly. You can use `security/py-htpasswd` to generate
the `.htpasswd` file, or simply run OpenSSL:

```
$ printf "<username>:$(openssl passwd -crypt <password>)\n" >> .htpasswd
```

## API
| Method | Endpoint                                                                                                               | Description                 |
|--------|------------------------------------------------------------------------------------------------------------------------|-----------------------------|
| GET    | `/api/v1/`                                                                                                             | Returns system info.        |
| POST   | `/api/v1/heartbeats/`                                                                                                  | Stores heartbeat.           |
| POST   | `/api/v1/logs/`                                                                                                        | Stores log message.         |
| GET    | `/api/v1/logs/<id>/`                                                                                                   | Returns single log message. |
| POST   | `/api/v1/observations/`                                                                                                | Stores observation.         |
| GET    | `/api/v1/observations/<id>/`                                                                                           | Returns observation.        |
| GET    | `/api/v1/projects/`                                                                                                    | Returns project ids.        |
| GET    | `/api/v1/projects/<pid>/nodes/`                                                                                        | Returns sensor node ids.    |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/heartbeat/`                                                                        | Returns last heartbeat.     |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/logs/?start=<timestamp>&end=<timestamp>`                                           | Returns log messages.       |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/sensors/`                                                                          | Returns sensor names.       |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/`                                                         | Returns target names.       |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/<target>/ids/`                                            | Returns observation ids.    |
| GET    | `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/<target>/observations/?start=<timestamp>&end=<timestamp>` | Returns observations.       |

## Build the Documentation
You can then generate the documentation with
[Sphinx](http://www.sphinx-doc.org/). Install Sphinx with:

```
$ python3 -m venv virtual-environment
$ source virtual-environment/bin/activate
$ pip3 install sphinx sphinx_rtd_theme
$ deactivate
```

Make the documentation with:

```
$ source virtual-environment/bin/activate
$ cd docs/
$ gmake clean
$ gmake html
$ deactivate
```

If you are using PyPy3, run:

```
$ gmake html "SPHINXBUILD=pypy3 -msphinx"
```

You will find the compiled documentation in `./build/html/`.

## Licence
BSD-2-Clause.
