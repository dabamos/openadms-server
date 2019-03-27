#!/usr/bin/env python3.6

__author__ = 'Philipp Engel'
__copyright__ = 'Copyright (c) 2017 Hochschule Neubrandenburg'
__license__ = 'BSD-2-Clause'

from pathlib import Path
import falcon


class FilesResource(object):

    auth = {
        'auth_disabled': True
    }

    def __init__(self, path: str, file_ext: str):
        self.path = Path(path)
        self.file_ext = file_ext

    def on_get(self,
               req: falcon.Request,
               resp: falcon.Response,
               file_name: str = None) -> None:
        paths = list(self.path.glob('*.{}'.format(self.file_ext)))
        files = [ str(f.parts[-1]) for f in paths ]

        # Return list of files (JSON).
        if not file_name:
            resp.media = files
            return

        # Return contents of single file.
        if not file_name in files:
             raise falcon.HTTPNotFound(
                title="File not found",
                description="The requested file has not been found."
            )

        file_path = Path(self.path, file_name)
        resp.content_type = falcon.MEDIA_TEXT

        with open(file_path) as f:
            resp.body = str(f.read())

