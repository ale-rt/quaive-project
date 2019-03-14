# coding=utf-8
from json import dumps

import sys


CONF = {
    "files.associations": {"*.zcml": "xml"},
    "files.exclude": {
        "**/.vscode/": True,
        "**/*.so": True,
        "**/*.py[co]": True,
        "**/*.h*": True,
        "**/__pycache__": True,
    },
    "python.pythonPath": sys.executable,
    "python.linting.flake8Path": "/home/ale/Code/plone/projects/quaive/bin/flake8",
    "python.autoComplete.extraPaths": sys.path,
    "python.jediEnabled": False,
    "python.linting.pylintEnabled": False,
    "python.linting.flake8Enabled": True,
    "python.linting.enabled": True,
}

print(dumps(CONF, indent=2))
