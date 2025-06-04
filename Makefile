.PHONY: all
all: .installed.cfg src/ploneintranet/.pre-commit-config.yaml  ## install everything

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


##
## Maintanance tasks:

.PHONY: upgrade
upgrade:  ## Run the Plone upgrade steps with ftw.upgrade
	./bin/upgrade plone_upgrade -S &&  ./bin/upgrade install -Sp

.PHONY: clean
clean:  ## Clean up the buildout virtual environment
	rm -rf ./.venv

.PHONY: read_registry
read_registry: .installed.cfg ## Read the registry XML files to update the site settings
	./bin/instance run scripts/read_registry.py etc/registry/*.xml

.PHONY: graceful
restart: .installed.cfg  ## Restart the supervisor managed processes
	@./bin/supervisord 2> /dev/null || ( \
	    ./bin/supervisorctl reread && \
		./bin/supervisorctl update && \
		./bin/supervisorctl restart all \
	)

.PHONY: graceful
graceful: .installed.cfg  ## Gracefully restart the supervisor managed processes
	@./bin/supervisord 2> /dev/null || ( \
	    ./bin/supervisorctl reread && \
		./bin/supervisorctl update && \
		for process in `./bin/supervisorctl status|awk '{print $1}'`; do \
			./bin/supervisorctl restart "$$process" && \
			sleep 30; \
		done \
	)

##
## Update helpers:

.PHONY: update_repo
update_repo:  ## Update the repository to the latest version coming from ploneintranet
	cp src/ploneintranet/buildout.d/versions.cfg config/versions.cfg
	cp src/ploneintranet/requirements.txt requirements.txt

.PHONY: updatecli
updatecli:  ## Run updatecli to update the repository
	updatecli apply

##
## Obtaining help:

.PHONY: help
help:  ## Show this help message
	@gawk -vG=$$(tput setaf 2) -vR=$$(tput sgr0) ' \
	  match($$0, "^(([^#:]*[^ :]) *:)?([^#]*)##([^#].+|)$$",a) { \
	    if (a[2] != "") { printf "    make %s%-18s%s %s\n", G, a[2], R, a[4]; next }\
	    if (a[3] == "") { print a[4]; next }\
	    printf "\n%-36s %s\n","",a[4]\
	  }' $(MAKEFILE_LIST)
