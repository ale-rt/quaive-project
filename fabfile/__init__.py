# coding=utf-8
from fabric import api


def ploneintranet_robotserver():
    """ Run the ploneintranet robot server
    """
    with api.lcd("~/Code/plone/projects/quaive"):
        with api.prefix(". bin/activate"):
            print(
                "./bin/robot -t 'Test name' src/ploneintranet/src/ploneintranet/suite/tests/acceptance/"  # noqa: E501
            )
            api.local(
                "DIAZO_ALWAYS_CACHE_RULES=1 ./bin/robot-server -dvvv -l ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT"  # noqa: E501
            )
