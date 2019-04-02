# coding=utf-8
from json import dumps

import sys


CONF = {
    "files.associations": {"*.zcml": "xml"},
    "files.exclude": {
        "**/__pycache__": True,
        "**/.vscode": True,
        "**/*.h*": True,
        "**/*.py[co]": True,
        "**/*.so": True,
        "**/bin": True,
        "**/develop-eggs": True,
        "**/include": True,
        "**/lib": True,
        "**/local": True,
        "**/parts": True,
        "**/var": True,
    },
    "python.pythonPath": sys.executable,
    "python.linting.flake8Path": "/home/ale/Code/plone/projects/quaive/bin/flake8",
    "python.autoComplete.extraPaths": sorted(filter(None, set(sys.path))),
    "python.jediEnabled": False,
    "python.linting.pylintEnabled": False,
    "python.linting.flake8Enabled": True,
    "python.linting.enabled": True,
}

print(dumps(CONF, indent=2))
