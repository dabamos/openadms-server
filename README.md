![OpenADMS Server](https://www.dabamos.de/github/openadms.png)

The **OpenADMS Server** is a REST service for the storage and processing of
observation data obtained and transmitted by
[OpenADMS Node](https://github.com/dabamos/openadms-node/) instances.

The API is based on [Falcon](https://github.com/falconry/falcon/).

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

## Testing
The API can be tested with [HTTPie](https://httpie.org/):
```
$ python3 -m pip install httpie
$ rehash
$ http :8000/auth/me -a user:password
```

## Licence
OpenADMS Server is licenced under BSD-2-Clause.
