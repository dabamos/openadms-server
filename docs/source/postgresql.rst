.. _postgresql:
PostgreSQL
==========

Install PostgreSQL 9.3 or higher. On FreeBSD, run:

.. code-block:: console

    # pkg databases/postgresql11-server

Add the service to ``/etc/rc.conf``:

.. code-block:: console

    # sysrc postgresql_enable="YES"

Create a new PostgreSQL database cluster:

.. code-block:: console

    # service postgresql initdb

Configuration
-------------
Customise the PostgreSQL configuration file
``/var/db/postgres/data11/postgresql.conf``. Add the IP address of the host to
``listen_address``:

.. code-block:: console

    listen_addresses = 'localhost, <your ip>'

Also, set the password encryption to ``scram-sha-256``:

.. code-block:: console

    password_encryption = scram-sha-256

Change the client authentication in ``/var/db/postgres/data11/pg_hba.conf``. Set
the IP address for IPv4/IPv6 connections according to your set-up, for example:

::

    # TYPE  DATABASE        USER            ADDRESS                 METHOD
    
    # "local" is for Unix domain socket connections only
    local   all             all                                     trust
    # IPv4 local connections:
    host    all             all             127.0.0.1/32            scram-sha-256
    host    all             all             <your ip>/32            scram-sha-256
    # IPv6 local connections:
    host    all             all             ::1/128                 scram-sha-256

Start the PostgreSQL server:

.. code-block:: console

    # service postgresql start

Set a new password for user ``postgres``. After login, create a new database
user (e.g., ``openadms-server``) and a new database (e.g., ``timeseries``):

.. code-block:: console

    # passwd postgres
    # su - postgres
    $ createuser --no-superuser --createdb --no-createrole --pwprompt openadms-server
    Enter password for new role:
    Enter it again:
    $ createdb --encoding UTF8 --owner openadms-server timeseries

You may want to create additional users who have read/write privileges to
selected databases only. Open a connection to the database ``timeseries`` with
``psql``:

.. code-block:: console

    $ psql -h localhost -U openadms-server -d timeseries
    timeseries=> \l
    timeseries=> \q

Create the SQL tables by executing ``timeseries.sql`` from the OpenADMS Server
repository with ``psql``:

.. code-block:: console

    $ psql -h localhost -U openadms-server -d timeseries -a -f timeseries.sql

The tables ``observations`` and ``heartbeats`` are now in database
``timeseries``.

.. code-block:: console

    $ psql -h localhost -U openadms-server -d timeseries
    timeseries=> \l
    timeseries=> \dt+ openadms.*
                                  List of relations
      Schema  |     Name     | Type  |      Owner      |    Size    | Description 
    ----------+--------------+-------+-----------------+------------+-------------
     openadms | heartbeats   | table | openadms-server | 0 bytes    | 
     openadms | observations | table | openadms-server | 8192 bytes | 
    (2 rows)
    timeseries=> \q

The PostgreSQL database is now ready to store time series data. Use nginx as a
front-end.

Automated Backups
-----------------
Use ``pg_dump`` to create database dumps:

.. code-block:: console

    # pg_dump timeseries --username=openadms-server | gzip > /var/backups/`date +"%Y%m%d%H%M%S"`_timeseries.sql.gz

Automate backups with cron. Create a shell script ``pg_backup.sh`` with the
above command and make it executable with
``chmod g+x /usr/local/sbin/pg_backup.sh``. Add a new cron job that runs the
backup script every week on Sunday at 23:00:

.. code-block:: console

    # crontab -e
    0	23	*	*	0	sh /usr/local/sbin/pg_backup.sh

You can list active cron jobs with ``cronjob -l``.
