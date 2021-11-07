##
# PyCoq
#
# @Makefile
# @version 0.1

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install
BUILDDIR=_build/default

.PHONY: help build install test examples clean
build: $(BUILDDIR)/pycoq/$(PYNAME).so

help:
	@echo targets {build,python,test,clean}

help:
	@echo targets {build,python,test,clean}

# coq-serapi.install is required so plugins are in place [runtime dep]
$(BUILDDIR)/pycoq/$(PYNAME).so:
	dune build $(SERAPI) pycoq/$(PYNAME).so

install:
	dune build @pip-install

examples: $(BUILDDIR)/pycoq/$(PYNAME).so install
	dune build @examples/run-examples

test: $(BUILDDIR)/pycoq/$(PYNAME).so install
	dune build @test/runtest

all: test examples

clean:
	dune clean
