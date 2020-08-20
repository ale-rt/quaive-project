.PHONY: all

all: .installed.cfg

bin/buildout: bin/pip3.8 requirements.txt
	./bin/pip3.8 install -IUr requirements.txt

bin/pip3.8:
	python3.8 -m venv .

.installed.cfg: bin/buildout buildout.cfg
	./bin/buildout
