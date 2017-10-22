#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD (2-Clause)'

import uuid
from wsgiref import simple_server

from falcon_auth import FalconAuthMiddleware, BasicAuthBackend

from route.auth import *
from route.nodes import *
from route.projects import *
from route.root import *


# A dummy loader function to fetch user information.
def user_loader(username, password):
    return {
        'id': uuid.uuid4().hex,
        'username': username
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

if __name__ == '__main__':
    # For testing, run:
    # $ gunicorn app:api --reload
    httpd = simple_server.make_server('127.0.0.1', 8000, api)
    httpd.serve_forever()
