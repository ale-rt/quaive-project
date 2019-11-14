# coding=utf-8
from fabric import api


def robottest(name):
    """ Run the robot test matching "name"
    """
    api.local(
        "ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 ./bin/robot --variable BROWSER:chrome -t '{}' src/ploneintranet/src/ploneintranet/suite/tests/acceptance/".format(  # noqa: E501
            name
        )
    )


def robottestff(name):
    """ Run the robot test matching "name"
    """
    api.local(
        "ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 ./bin/robot -t '{}' src/ploneintranet/src/ploneintranet/suite/tests/acceptance/".format(  # noqa: E501
            name
        )
    )


def robotserver():
    """ Run the ploneintranet robot server
    """
    with api.prefix(". bin/activate"):
        api.local(
            "ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 DIAZO_ALWAYS_CACHE_RULES=1 ./bin/robot-server -dvvv -l ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT"  # noqa: E501
        )
