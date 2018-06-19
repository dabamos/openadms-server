![OpenADMS Server](https://www.dabamos.de/github/openadms.png)

**OpenADMS Server** is a REST service for the storage and and retrieval of time
series obtained and transmitted by
[OpenADMS Node](https://github.com/dabamos/openadms-node/) instances.

The API is based on [Falcon](https://github.com/falconry/falcon/).

## Installation
Clone the OpenADMS Server repository with Git:
```
$ git clone https://github.com/dabamos/openadms-server.git
$ cd openadms-server/
```
Install a PostgreSQL 10 client. On FreeBSD:
```
# pkg install databases/postgresql10-client
```
All further dependencies can be installed with `pip`:
```
$ python3 -m pip install -U -r requirements.txt
```
(On FreeBSD, you may have to install `psycopg2` from Ports.)

## Configuration
The configuration can be changed by editing the file `config.py`.

## Testing
For testing only, run OpenADMS Server with `gunicorn`:
```
$ gunicorn app:api --reload
```

The API can be tested with [HTTPie](https://httpie.org/):
```
$ python3 -m pip install httpie
$ http :8000/v1/auth/me -a user:password
```

## Run in Production
On the assumption that OpenADMS Server will be installed on a productive
system running FreeBSD 11 and CPython 3.6, clone the repository to
`/var/www/`.

Nginx and uWSGI are going to be used to server the application:
```
# pkg install www/nginx www/uwgsi
```

Save the provided uWSGI configuration `uwgsi.ini` to
`/usr/local/etc/uwgsi/`. Then, create a virtual environment in
`/usr/local/etc/virtualenv/` (or any other directory, but don’t forget to modify
the uWSGI configuration accordingly):
```
# python3 -m venv /usr/local/etc/virtualenv/
# source /usr/local/etc/virtualenv/bin/activate
# python3 -m pip install -U -r /var/www/requirements.txt
```

Configure Nginx and add the uWSGI socket:
```
upstream python {
    server unix:///tmp/uwsgi.sock;
}

server {
    listen       8080;
    server_name  www.example.com; # IP address or FQDN of the server.

    location /api/ {
        uwsgi_pass python;
        include    /usr/local/etc/nginx/uwsgi_params;
    }
}
```

Add Nginx and uWSGI to the system configuration:
```
# sysrc nginx_enable="YES"
# sysrc uwsgi_enable="YES"
# sysrc uwsgi_configfile="/usr/local/etc/uwsgi/uwsgi.ini"
```

Start the daemons with:
```
# service uwgsi start
# service nginx start
```

The API is served on `http://localhost:8080/api/`.

## Licence
OpenADMS Server is licenced under BSD-2-Clause.
