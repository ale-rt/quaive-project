# coding=utf-8
from json import dumps

import os
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
    "python.analysis.disabled": ["unresolved-import"],
    "python.pythonPath": sys.executable,
    "python.linting.flake8Path": "{}/bin/flake8".format(os.getcwd()),
    "python.linting.flake8Args": ["--ignore=E203,W503,Q000,C812"],
    "python.autoComplete.extraPaths": sorted(filter(None, set(sys.path))),
    "python.jediEnabled": False,
    "python.linting.pylintEnabled": False,
    "python.linting.flake8Enabled": True,
    "python.linting.enabled": True,
    "search.exclude": ["**/.vscode"],
}

print(dumps(CONF, indent=2))
