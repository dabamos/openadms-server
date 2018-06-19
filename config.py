#!/usr/bin/env python3.6

import core.util

# OpenADMS Server Configuration

class Config:

    # HTTP Basic Auth (RFC 2617):
    USERNAME = 'default'        # Name of user who can access the API.
    PASSWORD = hash('secret')   # Hashed password of user.

    # Serving CSV files:
    SERVE_CSV = True            # Turns file serving on/off.
    CSV_DIR   = './data'        # Local path to CSV files.
    CSV_EXT   = 'csv'           # Extension of CSV files (e.g., 'csv', 'txt', ...).

