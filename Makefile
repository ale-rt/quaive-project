.PHONY: all
all: .installed.cfg

py38/bin/buildout: py38/bin/pip3.8 requirements.txt
	./py38/bin/pip3.8 install -IUr requirements.txt

py38/bin/pip3.8:
	python3.8 -m venv py38

.installed.cfg: py38/bin/buildout buildout.cfg
	./py38/bin/buildout

.PHONY: clean
clean:
	rm -rf ./py38
