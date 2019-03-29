nginx
=====

The HTTP front-end runs on `nginx`_. Either install nginx or `OpenResty`_ with
the following additional modules:

* `headers-more`_,
* `lua`_,
* `postgres`_,
* `set-misc`_.

On FreeBSD, the full package can be installed with:

.. code-block:: console

   # pkg install www/nginx-full

If you use a custom nginx package or build from source, make sure that all
required modules are included.

Copy the file ``nginx.conf`` from the GitHub repository to
``/usr/local/etc/nginx/`` (FreeBSD) or ``/etc/nginx/`` (Linux) and alter the
configuration to your set-up.  You have to update at least the name of the user
the nginx process is running under, the connection details of your PostgreSQL
database, and the actual server name:

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
           postgres_server     localhost dbname=observations user=openadms-server password=secret;
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
change ``nginx.conf`` accordingly. You can use `security/py-htpasswd`_ to
generate ``htpasswd`` files.

.. _nginx: https://nginx.org/
.. _OpenResty: https://openresty.org/
.. _headers-more: https://github.com/openresty/headers-more-nginx-module
.. _lua: https://github.com/openresty/lua-nginx-module
.. _postgres: https://github.com/FRiCKLE/ngx_postgres
.. _set-misc: https://github.com/openresty/set-misc-nginx-module
.. _security/py-htpasswd: https://www.freshports.org/security/py-htpasswd/
