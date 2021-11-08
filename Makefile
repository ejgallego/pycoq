##
# PyCoq
#
# @Makefile
# @version 0.1

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install
BUILDDIR=_build/default

.PHONY: help build install test clean
build: $(BUILDDIR)/pycoq/$(PYNAME).so


help:
	@echo targets {build,install,examples,clean}

# coq-serapi.install is required so plugins are in place [runtime dep]
$(BUILDDIR)/pycoq/$(PYNAME).so:
	dune build $(SERAPI) pycoq/$(PYNAME).so

install: $(BUILDDIR)/pycoq/$(PYNAME).so
	dune build @pip-install

examples: $(BUILDDIR)/pycoq/$(PYNAME).so install
	dune build @examples/run-examples

clean:
	dune clean

# end
