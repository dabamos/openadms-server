#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD (2-Clause)'

import falcon


class NodesResource(object):

    def on_get(self,
               req: falcon.Request,
               resp: falcon.Response,
               pid: str = None,
               nid: str = None) -> None:
        nodes = [
            {
                'name': 'Sensor Node 1',
                'id': '21bcf8c16a664b17bbc9cd4221fd8541',
                'description': 'Sensor control unit 1.'
            },
            {
                'name': 'Sensor Node 2',
                'id': '8f0014b7b43c48c4912ed4ece9063d42',
                'description': 'Sensor control unit 2.'
            },
            {
                'name': 'Sensor Node 3',
                'id': '46502443b2c7437a84b75a31de550956',
                'description': 'Sensor control unit 3.'
            }
        ]

        resp.media = nodes
