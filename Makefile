.PHONY: all
all: .installed.cfg

py27/bin/buildout: py27/bin/pip2.7 requirements.txt
	./py27/bin/pip2.7 install -IUr requirements.txt

py27/bin/pip2.7:
	python2.7 -m venv py27

.installed.cfg: py27/bin/buildout buildout.cfg
	./py27/bin/buildout

.PHONY: upgrade
upgrade:
	./bin/upgrade plone_upgrade -S &&  ./bin/upgrade install -Sp

.PHONY: clean
clean:
	rm -rf ./py27

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
