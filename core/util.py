#!/usr/bin/env python3.6

import hashlib


def hash(s: str) -> str:
    return hashlib.sha3_256(s.encode()).hexdigest()

