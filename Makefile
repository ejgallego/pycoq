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
install: $(BUILDDIR)/pip.installed
install-dev: $(BUILDDIR)/pip.dev.installed

help:
	@echo targets {build,install,install-dev,examples,test,lint,typecheck,clean}

help:
	@echo targets {build,python,test,clean}

# coq-serapi.install is required so plugins are in place [runtime dep]
$(BUILDDIR)/pycoq/$(PYNAME).so:
	dune build $(SERAPI) pycoq/$(PYNAME).so

$(BUILDDIR)/pip.installed:
	dune build @pip-install

$(BUILDDIR)/pip.dev.installed:
	dune build @pip-install-dev

examples: $(BUILDDIR)/pycoq/$(PYNAME).so $(BUILDDIR)/pip.installed
	dune build @examples/run-examples

test: $(BUILDDIR)/pycoq/$(PYNAME).so $(BUILDDIR)/pip.installed $(BUILDDIR)/pip.dev.installed
	dune build --verbose @test/runtest

lint: $(BUILDDIR)/pip.dev.installed
	dune build --verbose @lint

typecheck: $(BUILDDIR)/pip.dev.installed
	dune build --verbose @typecheck

all: lint typecheck test examples

clean:
	dune clean
	rm -rf .pytype
