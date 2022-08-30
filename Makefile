.PHONY: all
all: .installed.cfg src/ploneintranet/.pre-commit-config.yaml

py3/bin/buildout: py3/bin/pip3 requirements.txt
	./py3/bin/pip3 uninstall -y setuptools
	./py3/bin/pip3 install -IUr requirements.txt

py3/bin/pip3:
	python3 -m venv py3

.installed.cfg: py3/bin/buildout $(wildcard *.cfg config/*.cfg profiles/*.cfg)
	./py3/bin/buildout
	cd components/zeo && make
	cd components/solr && make

src/ploneintranet/.pre-commit-config.yaml: py3/bin/buildout templates/.pre-commit-config.yaml
	./py3/bin/buildout install pre_commit

.PHONY: upgrade
upgrade:
	./bin/upgrade plone_upgrade -S &&  ./bin/upgrade install -Sp

.PHONY: clean
clean:
	rm -rf ./py3

.PHONY: read_registry
read_registry: .installed.cfg
	./bin/instance run scripts/read_registry.py etc/registry/*.xml

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
