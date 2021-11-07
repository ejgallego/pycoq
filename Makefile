.PHONY: help build install test clean

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install

help:
	@echo targets {build,python,test,clean}

# coq-serapi.install is required so plugins are in place [runtime dep]
build:
	dune build $(SERAPI) pycoq/$(PYNAME).so

install:
	dune build @pip-install

test:
	dune build @examples/runtest

clean:
	@echo Nothing to display
