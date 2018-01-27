#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD-2-Clause'

import falcon


class AuthResource(object):
    """
    AuthResource is used to generate a JWT for a valid user.
    """

    auth = {
        'auth_disabled': True
    }

    def on_get(self, req: falcon.Request, resp: falcon.Response) -> None:
        resp.body = 'Success'


class AuthMeResource(object):
    """
    AuthMeResource returns information of the authenticated user.
    """

    def on_get(self, req: falcon.Request, resp: falcon.Response) -> None:
        user = req.context.get('user')
        resp.media = user


class AuthVerifyResource(object):
    """
    AuthVerifyResource returns whether or not the user is authenticated.
    """

    def on_get(self, req: falcon.Request, resp: falcon.Response) -> None:
        user = req.context.get('user')
        is_valid = True if user else False
        resp.media = {'valid': is_valid}
