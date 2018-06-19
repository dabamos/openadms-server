#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD-2-Clause'

import falcon


class ProjectsResource(object):

    def on_get(self,
               req: falcon.Request,
               resp: falcon.Response,
               pid: str = None) -> None:
        projects = [
            {
                'name': 'Virtual Project',
                'id': '4a2e8b9d87d849e38bb6911b9f2364ea',
                'description': 'Project for testing virtual sensors.',
                'created': '2017-10-21T09:09:06.486655'
            },
            {
                'name': 'Total Station Project',
                'id': 'f27b9bcc31164390a2f8bd07aa1babd9',
                'description': 'Project for testing a total station.'
            },
            {
                'name': 'Nivel210 Project',
                'id': '19481e0791604b489a8a9c4a25e9dd80',
                'description': 'Project for testing a Leica Nivel210.'
            }
        ]

        if not pid:
            resp.media = projects
        else:
            resp.media = projects[0]
