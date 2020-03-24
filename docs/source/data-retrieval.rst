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

Returns the same observation in CSV format instead:

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

`HTTPie`_ provides a more convenient command-line access to the REST API. For
example, to return all observations of a given time period, run:

::

    $ http -a <user>:<password> \
      https://api.example.com/api/v1/projects/<pid>/nodes/<nid>/logs/ \
      start==2020-03-23T00:00:00 end==2020-05-01T00:00:00

Python 3
--------

The `Requests`_ library for Python 3 allow access to arbitrary web resources,
like reading observation data:

::

    import requests

    if __name__ == '__main__':
        host = 'api.example.com'        # OpenADMS Server instance
        user = '<user>'                 # user name
        password = '<password>'         # password

        pid = '<pid>'                   # project id
        nid = '<nid>'                   # sensor node id
        sensor = '<sensor>'             # sensor name
        target = '<target>'             # target name

        start = '2020-01-01T00:00:00'   # start of time period
        end = '2020-12-31T23:59:59'     # end of time period

        api = ''.join(['https://', host, '/api/v1/projects/', pid, '/nodes/', nid,
                       '/sensors/', sensor, '/targets/', target, '/observations/'])

        payload = { 'start': start, 'end': end }
        r = requests.get(api, auth=(user, password), params=payload, timeout=30)
        print(r.json())

GNU Octave
----------

The `URL manipulation tools`_ of `GNU Octave`_ let us directly download
resources from OpenADMS Server into the current workspace. For instance:

::

    >> host = "api.example.com";
    >> user = "<user>";
    >> password = "<password>";
    >> api = strcat("https://", user, ":", password, "@", host, "/api/v1/");
    >> x = load_json(urlread(api));

`MATLAB`_ offers similiar routines to read from RESTful web services.

.. _cURL: https://curl.haxx.se/
.. _jq: https://stedolan.github.io/jq/
.. _HTTPie: https://httpie.org/
.. _Requests: https://requests.readthedocs.io/en/master/
.. _URL manipulation tools: https://octave.org/doc/v4.0.1/URL-Manipulation.html
.. _GNU Octave: https://octave.org/
.. _MATLAB: https://www.mathworks.com/help/matlab/ref/webread.html
