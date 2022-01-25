.PHONY: all
all: .installed.cfg

py38/bin/buildout: py38/bin/pip3.8 requirements.txt
	./py38/bin/pip3.8 install -IUr requirements.txt

py38/bin/pip3.8:
	python3.8 -m venv py38

.installed.cfg: py38/bin/buildout $(wildcard *.cfg config/*.cfg profiles/*.cfg)
	./py38/bin/buildout

.PHONY: upgrade
upgrade:
	./bin/upgrade plone_upgrade -S &&  ./bin/upgrade install -Sp

.PHONY: clean
clean:
	rm -rf ./py38

.PHONY: graceful
graceful: .installed.cfg
	./bin/supervisord 2> /dev/null || ( \
	    ./bin/supervisorctl reread && \
		./bin/supervisorctl update && \
		for process in `./bin/supervisorctl status|awk '{print $1}'`; do \
			./bin/supervisorctl restart "$$process" && \
			sleep 30; \
		done \
	)
