.. _nginx:

nginx
=====

The HTTP front-end runs on `nginx <https://nginx.org/>`_. Either install nginx
or `OpenResty <https://openresty.org/>`_ with the following additional modules:

* `form-input`_,
* `headers-more`_,
* `http-realip`_,
* `lua`_,
* `postgres`_,
* `set-misc`_.

Installation on FreeBSD
-----------------------
On FreeBSD, the full package can be installed with:

.. code-block:: console

   # pkg install www/nginx-full www/lua-resty-core

If you use a custom nginx package or build from source, make sure that all
required modules are included. Build the port with:

.. code-block:: console

    # cd /usr/local/ports/www/nginx/
    # make config

Select at least the following modules:

* ``HTTP_REALIP``
* ``FORMINPUT``
* ``HEADERS_MORE``
* ``LUA``
* ``POSTGRES``
* ``SET_MISC``

Then, build the port:

.. code-block:: console

    # make
    # make install

Installation on Linux
---------------------
On Linux, you probably prefer OpenResty. Binary packages are available for most
distributions, but do not inluce the requires PostgreSQL module. Therefore,
OpenResty has to be build from source.

At first, install all dependencies. On Debian:

.. code-block:: console

    $ sudo apt-get install libpcre3-dev libssl-dev perl make build-essential curl postgresql-contrib

On CentOS/RHEL, run instead:

.. code-block:: console

    $ sudo dnf install pcre-devel openssl-devel gcc curl postgres-devel

Then, download, unpack, and compile
`OpenResty <https://openresty.org/en/download.html>`_:

.. code-block:: console

    $ wget https://openresty.org/download/openresty-VERSION.tar.gz
    $ tar xfvz openresty-VERSION.tar.gz
    $ cd openresty-VERSION/
    $ ./configure --prefix=/usr/local/openresty \
                  --with-luajit \
                  --with-pcre-jit \
                  --with-ipv6 \
                  --with-http_iconv_module \
                  --with-http_realip_module \
                  --with-http_postgres_module \
                  --j2
    $ sudo make -j2
    $ sudo make install

OpenResty is installed to ``/usr/local/openresty/``, but you can choose any
other path (for instance, ``/opt/openresty/``).

Configuration
-------------
Copy the file ``nginx.conf`` and directory ``openadms-server`` from the GitHub
repository to ``/usr/local/etc/nginx/`` (FreeBSD) or ``/etc/nginx/`` (Linux) and
alter the configuration to your set-up. You have to update at least the name of
the user the nginx process is running under, the connection details of your
PostgreSQL database, and the actual server name:

::

   user www;   # User to run nginx process under.

   http {
       # PostgreSQL connection details. Change "localhost" to the IP address of
       # your database instance, if it is not running on the same host.
       #
       # dbname:   PostgreSQL database name.
       # user:     PostgreSQL user name.
       # password: PostgreSQL password.
       upstream postgresql {
           postgres_server     localhost dbname=timeseries user=<username> password=<password>;
           postgres_keepalive  max=200 overflow=reject;
       }

       server {
           server_name  www.example.com;   # CHANGE TO YOUR SERVER NAME!
       }
   }

Access Restriction
------------------

The API uses HTTP BasicAuth for access restriction. Clients must send an
authorisation header with encoded user name and password. Store login
credentials in ``/usr/local/etc/nginx/.htpasswd``. If you use a different path,
change ``openadms-server/api.conf`` accordingly. You can use
`security/py-htpasswd`_ to generate a ``.htpasswd``, or simply run OpenSSL:

::

    $ printf "<username>:$(openssl passwd -crypt <password>)\n" >> .htpasswd

.. _form-input: https://github.com/calio/form-input-nginx-module
.. _headers-more: https://github.com/openresty/headers-more-nginx-module
.. _http-realip: http://nginx.org/en/docs/http/ngx_http_realip_module.html
.. _lua: https://github.com/openresty/lua-nginx-module
.. _postgres: https://github.com/FRiCKLE/ngx_postgres
.. _set-misc: https://github.com/openresty/set-misc-nginx-module
.. _security/py-htpasswd: https://www.freshports.org/security/py-htpasswd/
