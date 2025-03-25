.PHONY: all
all: .installed.cfg src/ploneintranet/.pre-commit-config.yaml

.venv/bin/buildout: .venv/bin/pip3 requirements.txt
	./.venv/bin/pip3 uninstall -y setuptools
	./.venv/bin/pip3 install -IUr requirements.txt

.venv/bin/pip3:
	python3 -m venv .venv

.installed.cfg: .venv/bin/buildout $(wildcard *.cfg config/*.cfg profiles/*.cfg)
	./.venv/bin/buildout
	cd components/zeo && make
	cd components/solr && make
	make fix-zopepy

.PHONY: fix-zopepy
fix-zopepy:
	# This is needed to use zopepy as the python interpreter for the workspace in vscode
	[ -e bin/zopepy ] && sed -i 's|ic:m|iIc:m|g' bin/zopepy

src/ploneintranet/.pre-commit-config.yaml: .venv/bin/buildout templates/.pre-commit-config.yaml
	./.venv/bin/buildout install code-analysis pre_commit_config pre_commit

.PHONY: upgrade
upgrade:
	./bin/upgrade plone_upgrade -S &&  ./bin/upgrade install -Sp

.PHONY: clean
clean:
	rm -rf ./.venv

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

.PHONY: update_repo
update_repo:
	cp src/ploneintranet/buildout.d/versions.cfg config/versions.cfg
	cp src/ploneintranet/requirements.txt requirements.txt

.PHONY: updatecli
updatecli:
	updatecli apply
