.PHONY: all checkout-ploneintranet

all: .installed.cfg

bin/buildout: bin/pip src/ploneintranet/requirements.txt
	./bin/pip install -IUr src/ploneintranet/requirements.txt

bin/pip:
	virtualenv -p python2.7 --no-site-packages .

checkout-ploneintranet:
	test -x src/ploneintranet || git clone git@github.com:quaive/ploneintranet.git src/ploneintranet
	cd src/ploneintranet && git checkout master && git pull origin master && touch -mt `git log -1 --date=format:%Y%m%d%H%M.%S --pretty=format:%ad .` .

src/ploneintranet: checkout-ploneintranet

src/ploneintranet/requirements.txt: src/ploneintranet

.installed.cfg: bin/buildout buildout.cfg src/ploneintranet
	./bin/buildout
