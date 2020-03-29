Data Retrieval
==============

Using the REST API of OpenADMS Server, timeseries and other data can be accessed
by many 3rd party applications and programming languages.

cURL
----

`cURL`_ can be used to retrieve stored data, like observations, log messages,
and heartbeats, from an OpenADMS Server instance. You may want to format the
JSON output with `jq`_.

Return a single observation with ID ``00ce160e5cbb49b9bc2ee6f243f87841`` in JSON
format:

::

    $ curl -X GET -u <user>:<password> \
      -H "Accept: application/json" \
      -G "https://api.example.com/api/v1/observations/00ce160e5cbb49b9bc2ee6f243f87841/"

Return the same observation in CSV format instead:

::

    $ curl -X GET -u <user>:<password> \
      -H "Accept: text/csv" \
      -G "https://api.example.com/api/v1/observations/00ce160e5cbb49b9bc2ee6f243f87841/"

Return all log messages of a given time period in JSON format and pipe the
output to ``jq``:

::

    $ curl -X GET -u <user>:<password> \
      -H "Accept: application/json"
      -G https://api.example.com/api/v1/projects/<pid>/nodes/<nid>/logs/?start=2020-01-01T00:00:00&end=2020-06-01T00:00:00 | jq

HTTPie
------

`HTTPie`_ is a more convenient command-line tool for JSON output of API results.
For example, to return all observations of a given time period, run:

::

    $ http -a <user>:<password> \
      https://api.example.com/api/v1/projects/<pid>/nodes/<nid>/logs/ \
      start==2020-03-23T00:00:00 end==2020-05-01T00:00:00

Python 3
--------

The `Requests`_ library for Python 3 allows access to arbitrary web resources.
The example below reads all observation data and prints them to console.

::

    import requests

    if __name__ == '__main__':
        host = 'api.example.com'        # OpenADMS Server instance.
        user = '<user>'                 # User name.
        password = '<password>'         # User password.

        pid = '<pid>'                   # Project id.
        nid = '<nid>'                   # Sensor node id.
        sensor = '<sensor>'             # Sensor name.
        target = '<target>'             # Target name.

        start = '2020-01-01T00:00:00'   # Start of time period.
        end = '2020-12-31T23:59:59'     # End of time period.

        api = ''.join(['https://', host, '/api/v1/projects/', pid, '/nodes/', nid,
                       '/sensors/', sensor, '/targets/', target, '/observations/'])

        payload = { 'start': start, 'end': end }
        r = requests.get(api, auth=(user, password), params=payload, timeout=30)
        print(r.json())

GNU Octave
----------

The `URL manipulation tools`_ of `GNU Octave`_ can directly download resources
from OpenADMS Server into the current workspace. The example uses the `jsonlab`_
library:

.. code-block:: matlab

    >> addpath('./jsonlab');
    >> host = "api.example.com";
    >> user = "<user>";
    >> password = "<password>";
    >> api = strcat("https://", user, ":", password, "@", host, "/api/v1/");
    >> x = loadjson(urlread(api));
    >> x =

      scalar structure containing the fields:

        database = timeseries
        timestamp = 2020-03-25T17:17:19.212534+01:00
        uptime = 1 day 15:50:47
        version = PostgreSQL 11.7 on amd64-portbld-freebsd12.1, compiled by FreeBSD clang version 8.0.1 (tags/RELEASE_801/final 366581) (based on LLVM 8.0.1), 64-bit

`MATLAB`_ offers similiar routines to read from RESTful web services. See
directory ``examples/clients/octave/`` for a more complete example.

JavaScript
----------

Also, web applications written in JavaScript can access the OpenADMS Server API
as well. The example in ``examples/clients/js`` uses `jQuery`_ and `Papa Parse`_
to retrieve observations in CSV format and list them in a table.  Simply open
``index.html`` in a web browser. jQuery and Papa Parse are are fetched from CDN.

.. _cURL: https://curl.haxx.se/
.. _jq: https://stedolan.github.io/jq/
.. _HTTPie: https://httpie.org/
.. _Requests: https://requests.readthedocs.io/en/master/
.. _URL manipulation tools: https://octave.org/doc/v4.0.1/URL-Manipulation.html
.. _GNU Octave: https://octave.org/
.. _jsonlab: https://github.com/fangq/jsonlab
.. _MATLAB: https://www.mathworks.com/help/matlab/ref/webread.html
.. _jQuery: https://jquery.com/
.. _Papa Parse: https://www.papaparse.com/
