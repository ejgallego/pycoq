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


# ix_build_pycoq:
# nix-build nix/opam2nix.nix
# ./result/bin/opam2nix resolve --ocaml-version 4.12.0 ./pycoq.opam --dest nix/opam-selection.nix
# nix-shell nix/default.nix --run "eval $(opam env)"
# nix-shell nix/default.nix --run "dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py"
# nix-shell nix/default.nix --run "cd _build/default && python3 setup.py build && pip3 install ."
#
# ix_pyci:
# nix-shell nix/default.nix --run $(shell cat nix/pyci.sh)
#
# ix_examples:
# nix-shell nix/default.nix --run $(shell cat nix/examples.sh)
