# coding=utf-8
from invoke import task

@task
def robottest(c, name):
    """ Run the robot test matching "name"
    """
    print(
        "ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 ./bin/robot --variable BROWSER:chrome -t '{}' src/ploneintranet/src/ploneintranet/suite/tests/acceptance/".format(  # noqa: E501
            name
        )
    )

@task
def robottestff(c, name):
    """ Run the robot test matching "name"
    """
    print(
        "ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 ./bin/robot -t '{}' src/ploneintranet/src/ploneintranet/suite/tests/acceptance/".format(  # noqa: E501
            name
        )
    )

@task
def robotserver(c):
    """ Run the ploneintranet robot server
    """
    with c.prefix(". .venv/bin/activate"):
        c.run(
            "SOLR_BUILDOUT_DIR=$PWD/components/solr ZSERVER_HOST=127.0.0.2 ZSERVER_PORT=55001 DIAZO_ALWAYS_CACHE_RULES=1 ./bin/robot-server -nvvv -l ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT ploneintranet.suite.testing.PLONEINTRANET_SUITE_ROBOT"  # noqa: E501
        )
