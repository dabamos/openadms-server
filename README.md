![OpenADMS Server](https://www.dabamos.de/github/openadms.png)

The **OpenADMS Server** is a REST service for the storage and processing of
observation data obtained and transmitted by OpenADMS Node instances.

## Installation
Clone the repository and install the required dependencies with `pip`:
```
$ git clone https://github.com/dabamos/openadms-server.git
$ cd openadms-server
$ python3 -m pip install -U -r requirements.txt
```

Run OpenADMS Server with `gunicorn`:
```
$ gunicorn app:api --reload
```

## Licence
OpenADMS Server is licenced under BSD (2-Clause).
