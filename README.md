![OpenADMS Server](https://www.dabamos.de/github/openadms.png)

**OpenADMS Server** is a set of scripts and configuration files to run an HTTP
service for time series data, obtained from IoT sensor networks based on
[OpenADMS Node](https://github.com/dabamos/openadms-node/) or 3rd party
applications. A REST interface API is provided for sensor data storage and
retrieval. Access the API from your web browser, with command-line tools like
[cURL](https://curl.haxx.se/) or [HTTPie](https://httpie.org/), or directly from
within your programming language (for instance, by using
[jQuery](https://jquery.com/) or [Python
Requests](http://docs.python-requests.org/en/master/)).

## Documentation
The documentation is hosted on the
[project website](https://www.dabamos.de/manual/openadms-server/).

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
