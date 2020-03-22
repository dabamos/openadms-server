![OpenADMS Server](https://www.dabamos.de/github/openadms-server.png)

**OpenADMS Server** is a set of scripts and configuration files to run an HTTP
service for time series data, obtained from IoT sensor networks based on
[OpenADMS Node](https://github.com/dabamos/openadms-node/) or 3rd party
applications. A REST interface API is provided for sensor data storage and
retrieval. Access the API from your web browser, with command-line tools like
[cURL](https://curl.haxx.se/) or [HTTPie](https://httpie.org/), or directly from
within your programming language (for instance, by using
[jQuery](https://jquery.com/) or [Python
Requests](http://docs.python-requests.org/en/master/)).

The OpenADMS Server API is based on
[nginx](https://nginx.org/en/)/[OpenResty](https://openresty.org/en/) and
[PostgreSQL](https://www.postgresql.org/). The following nginx modules are
required:

* [form-input](https://github.com/calio/form-input-nginx-module)
* [headers-more](https://github.com/openresty/headers-more-nginx-module)
* [http-realip](http://nginx.org/en/docs/http/ngx_http_realip_module.html)
* [lua](https://github.com/openresty/lua-nginx-module)
* [postgres](https://github.com/FRiCKLE/ngx_postgres)
* [set-misc](https://github.com/openresty/set-misc-nginx-module)

## Documentation
The documentation is hosted on the
[project website](https://www.dabamos.de/manual/openadms-server/).

## API
| Endpoint                                                                                                               | Method | Description                 |
|------------------------------------------------------------------------------------------------------------------------|--------|-----------------------------|
| `/api/v1/`                                                                                                             | `GET`  | Returns system info.        |
| `/api/v1/heartbeats/`                                                                                                  | `POST` | Stores heartbeat.           |
| `/api/v1/logs/`                                                                                                        | `POST` | Stores log message.         |
| `/api/v1/logs/<id>/`                                                                                                   | `GET`  | Returns single log message. |
| `/api/v1/observations/`                                                                                                | `POST` | Stores observation.         |
| `/api/v1/observations/<id>/`                                                                                           | `GET`  | Returns observation.        |
| `/api/v1/projects/`                                                                                                    | `GET`  | Returns project ids.        |
| `/api/v1/projects/<pid>/nodes/`                                                                                        | `GET`  | Returns sensor node ids.    |
| `/api/v1/projects/<pid>/nodes/<nid>/heartbeat/`                                                                        | `GET`  | Returns last heartbeat.     |
| `/api/v1/projects/<pid>/nodes/<nid>/logs/?start=<timestamp>&end=<timestamp>`                                           | `GET`  | Returns log messages.       |
| `/api/v1/projects/<pid>/nodes/<nid>/sensors/`                                                                          | `GET`  | Returns sensor names.       |
| `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/`                                                         | `GET`  | Returns target names.       |
| `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/<target>/ids/`                                            | `GET`  | Returns observation ids.    |
| `/api/v1/projects/<pid>/nodes/<nid>/sensors/<sensor>/targets/<target>/observations/?start=<timestamp>&end=<timestamp>` | `GET`  | Returns observations.       |

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
