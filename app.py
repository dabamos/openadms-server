#!/usr/bin/env python3.6

# OpenADMS Server is a REST service for the storage and and retrieval of time
# series obtained and transmitted by OpenADMS Node instances. The API is based
# on Falcon.
#
# For testing, run:
# $ gunicorn app:api --reload

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2018 Hochschule Neubrandenburg'
__license__ = 'BSD-2-Clause'

# Intrinsic modules:
import uuid
from wsgiref import simple_server

# Third-party modules:
import falcon
from falcon_auth import (FalconAuthMiddleware, BasicAuthBackend)

# Internal modules:
import core.util
from config import Config
from route.auth import (AuthResource, AuthMeResource, AuthVerifyResource)
from route.data import FileResource
from route.nodes import NodesResource
from route.projects import ProjectsResource
from route.root import RootResource


# Loader function to fetch user information.
def user_loader(username, password):
    if (username == Config.USERNAME) and (hash(password) == Config.PASSWORD):
        return {
            'id': uuid.uuid4().hex,     # TODO
            'username': Config.USERNAME
        }


# The HTTP Basic Authentication backend.
basic_auth = BasicAuthBackend(user_loader=user_loader)

# Middleware that uses `basic_auth` for authentication.
auth_middleware = FalconAuthMiddleware(basic_auth)

# The REST API.
api = falcon.API(middleware=[auth_middleware])
api.add_route('/', RootResource())
api.add_route('/v1/auth', AuthResource())
api.add_route('/v1/auth/me', AuthMeResource())
api.add_route('/v1/auth/verify', AuthVerifyResource())
api.add_route('/v1/projects', ProjectsResource())
api.add_route('/v1/projects/{pid}', ProjectsResource())
api.add_route('/v1/projects/{pid}/nodes', NodesResource())
api.add_route('/v1/projects/{pid}/nodes/{nid}', NodesResource())

if Config.SERVE_CSV:
    api.add_route('/v1/local/files', FileResource(Config.CSV_DIR, Config.CSV_EXT))
    api.add_route('/v1/local/files/{file_name}', FileResource(Config.CSV_DIR, Config.CSV_EXT))

if __name__ == '__main__':
    httpd = simple_server.make_server('127.0.0.1', 8000, api)
    httpd.serve_forever()
