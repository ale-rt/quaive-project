.PHONY: all

all: .installed.cfg

bin/buildout: bin/pip2.7 src/ploneintranet/requirements.txt
	./bin/pip2.7 install -IUr src/ploneintranet/requirements.txt

bin/pip2.7:
	virtualenv -p python2.7 --no-site-packages .

src/ploneintranet:
	test -x src/ploneintranet || git clone git@github.com:quaive/ploneintranet.git src/ploneintranet
	cd src/ploneintranet && git checkout plone5.2 && git pull origin plone52 && touch -mt `git log -1 --date=format:%Y%m%d%H%M.%S --pretty=format:%ad .` .

src/ploneintranet/requirements.txt: src/ploneintranet

.installed.cfg: bin/buildout buildout.cfg src/ploneintranet
	./bin/buildout
