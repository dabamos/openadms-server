#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD (2-Clause)'

import time
from datetime import datetime

import falcon

from core.version import *


class RootResource(object):

    auth = {
        'auth_disabled': True
    }

    def __init__(self):
        self._app_start_time = time.time()

    def get_uptime(self) -> float:
        return time.time() - self._app_start_time

    def on_get(self, req: falcon.Request, resp: falcon.Response) -> None:
        root = {
            'api': APP_API,
            'name': APP_NAME,
            'serverTime': datetime.utcnow().isoformat(),
            'uptime': self.get_uptime(),
            'version': APP_VERSION
        }

        resp.media = root
