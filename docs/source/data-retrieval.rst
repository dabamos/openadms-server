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

The `URL manipulation tools`_ of `GNU Octave`_ can directly download resources
from OpenADMS Server into the current workspace. Using the `jsonlab`_ library
outputs:

.. code-block:: matlab

    >> addpath('./jsonlab');
    >> host = "api.example.com";
    >> user = "<user>";
    >> password = "<password>";
    >> api = strcat("https://", user, ":", password, "@", host, "/api/v1/");
    >> x = loadjson(urlread(api))
    >> x =

      scalar structure containing the fields:

        database = timeseries
        timestamp = 2020-03-25T17:17:19.212534+01:00
        uptime = 1 day 15:50:47
        version = PostgreSQL 11.7 on amd64-portbld-freebsd12.1, compiled by FreeBSD clang version 8.0.1 (tags/RELEASE_801/final 366581) (based on LLVM 8.0.1), 64-bit

`MATLAB`_ offers similiar routines to read from RESTful web services.

JavaScript
----------

Furthermore, web applications written in JavaScript can access the OpenADMS
Server API as well. The following example uses `jQuery`_ and `Papa Parse`_ to
retrieve observations in CSV format and list them in a table. Copy the source
code to ``index.html`` and open the file in a web browser. jQuery and Papa
Parse are are fetched from CDN.

.. code-block:: html

    <!DOCTYPE html>
    <html>
        <head>
            <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
            <meta http-equiv="X-UA-Compatible" content="IE=edge,chrome=1">
            <meta name="viewport" content="width=device-width, initial-scale=1.0, maximum-scale=1.0">

            <script type="application/javascript" src="https://code.jquery.com/jquery-3.4.1.min.js"></script>
            <script type="application/javascript" src="https://cdnjs.cloudflare.com/ajax/libs/PapaParse/5.1.0/papaparse.min.js"></script>

            <title>OpenADMS Server API Test</title>

            <style type="text/css">
                body    { background-color: Beige; padding: 4em; }
                tbody   { background-color: White; }
                thead   { background-color: LightGray; }
                td, th  { padding: .5em; }
                td      { text-align: right; }
                th      { text-transform: uppercase; }
            </style>
        </head>
        <body>
            <h1>OpenADMS Server API Test</h1>
            <p>Basic example that fetches observations from an OpenADMS Server
            instance and lists the data inside a table, using jQuery and
            Papa Parse.</p>
            <form>
                <p>
                    <label for="csv-host">Host:</label><br>
                    <input id="csv-host" placeholder="https://api.example.com" size="40" type="text"><br>

                    <label for="csv-user">User Name:</label><br>
                    <input id="csv-user" size="40" type="text"><br>

                    <label for="csv-password">Password:</label><br>
                    <input id="csv-password" size="40" type="password">
                </p>
                <p>
                    <label for="csv-pid">Project ID:</label><br>
                    <input id="csv-pid" size="40" type="text"><br>

                    <label for="csv-nid">Sensor Node ID:</label><br>
                    <input id="csv-nid" size="40" type="text">
                </p>
                <p>
                    <label for="csv-sensor">Sensor Name:</label><br>
                    <input id="csv-sensor" size="40" type="text"><br>

                    <label for="csv-target">Target Name:</label><br>
                    <input id="csv-target" size="40" type="text">
                </p>
                <p>
                    <input id="csv-fetch" type="button" value="Fetch">
                    <input type="reset" value="Clear">
                </p>
            </form>
            <p id="csv-status">Fill out the form and click “Fetch” to retrieve
            observations.</p>
            <hr>
            <h2>Fetched Observations</h2>
            <table border="1" id="csv-table">
                <thead>
                </thead>
                <tbody>
                </tbody>
            </table>

            <script type="application/javascript">
                $(function() {
                    $('#csv-fetch').click(function() {
                        let $table = $('#csv-table');
                        let $status = $('#csv-status');

                        let host = $('#csv-host').val();
                        let user = $('#csv-user').val();
                        let password = $('#csv-password').val();
                        let pid = $('#csv-pid').val();
                        let nid = $('#csv-nid').val();
                        let sensor = $('#csv-sensor').val();
                        let target = $('#csv-target').val();

                        if (!host || !user || !password || !pid || !nid || !sensor || !target) {
                            $status.html('Please fill out all input fields.');
                            return;
                        }

                        let is_first = true;
                        let url = host.concat('/api/v1/projects/', pid, '/nodes/', nid, '/sensors/', sensor,
                                              '/targets/', target, '/observations/');

                        $table.children('thead').empty();
                        $table.children('tbody').empty();

                        Papa.parse(url, {
                            delimiter: ',',
                            download: true,
                            downloadRequestHeaders: {
                                'Authorization': 'Basic ' + btoa(user + ':' + password),
                                'Accept': 'text/csv'
                            },
                            step: function(row) {
                                $status.html('Adding row …');

                                /* Output table head. */
                                if (is_first) {
                                    is_first = false;
                                    let head = '<tr>';
                                    head += `<th>Timestamp</th>
                                             <th>Observation ID</th>
                                             <th>Sensor Name</th>
                                             <th>Target Name</th>`;

                                    for (let i = 6; i < row.data.length; i += 4) {
                                        let value = row.data[i];
                                        head += `<th>${value}</th>`;
                                    }

                                    head += '</tr>';
                                    $table.children('thead').append(head);
                                }

                                /* Output table body. */
                                let timestamp = row.data[0];
                                let oid = row.data[3];
                                let body = '<tr>'

                                body += `<td>${timestamp}</td>
                                         <td><code>${oid}</code></td>
                                         <td>${sensor}</td>
                                         <td>${target}</td>`;

                                for (let i = 6; i < row.data.length; i += 4) {
                                    let value = row.data[i + 3];
                                    let unit = row.data[i + 2];
                                    body += `<td>${value} ${unit}</td>`;
                                }

                                body += '</tr>';
                                $table.children('tbody').append(body);

                            },
                            complete: function(results) {
                                $status.html('Finished.');
                            },
                            error: function(err, file, element, reason) {
                                $status.html(err);
                            }
                        });
                    });
                });
            </script>
        </body>
    </html>


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
