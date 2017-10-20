#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD (2-Clause)'

import json
from typing import *


class User(object):

    def __init__(self, id: int, username: str, password: str):
        self.id = id
        self.username = username
        self.password = password

    def __str__(self):
        return "User(id='{}')".format(self.id)

    def clone(self) -> 'User':
        return User(self.id, self.username, self.password)

    def to_dict(self) -> Dict:
        return {
            'id': self.id,
            'username': self.username
        }

    def serialize(self) -> str:
        return json.dumps(self.to_dict())