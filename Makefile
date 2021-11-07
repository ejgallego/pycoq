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

#  coq-serapi.install is required so plugins are in place [runtime dep]
# (BUILDDIR)/pycoq/$(PYNAME).so:
# dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py requirements.txt README.md
# # cd _build/default && dune exc -- python3 setup.py build && dune exec -- pip3 install .
# # eval $(shell opam env)
#
# xamples: $(BUILDDIR)/pycoq/$(PYNAME).so
# dune build examples/add_commutative.py examples/definitions_ast.py examples/syntax_error.py
# dune exec -- python3 _build/default/examples/add_commutative.py
# dune exec -- python3 _build/default/examples/definitions_ast.py
# dune exec -- python3 _build/default/examples/syntax_error.py
#
# yci: $(BUILDDIR)/pycoq/$(PYNAME).so
# dune exec -- pip3 install .[dev]
# dune exec -- black .
# dune exec -- flake8 .
# # pytype .  # haven't gotten `dune` to work with this yet.
# # `dune` doesn't work with `pytest` yet.
# # dune exec -- python3 test/py/property/spec.py  # module state blocks property tests.
# dune build test/py/unit/spec.py test/py/property/spec.py
# dune exec -- python3 _build/default/test/py/unit/spec.py
#
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
#
# ll: clean $(BUILDDIR)/pycoq/$(PYNAME).so pyci examples
#
# ix: nix_build_pycoq nix_examples nix_pyci
#
# elp:
# @echo "If you have nix installed, try 'make nix_examples'. Else, try 'make examples'."
#
# lean:
# dune clean
# rm -rf pycoq.egg-info
# rm -rf .pytype
#
