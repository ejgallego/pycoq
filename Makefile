.PHONY: python build test clean help
.PHONY: build help

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install

help:
	@echo targets {build,python,test,clean}

# coq-serapi.install is required so plugins are in place [runtime dep]
build:
	dune build $(SERAPI) pycoq/$(PYNAME).so

python:
	dune build @python

test:
	dune build @examples/runtest

clean:
	@echo Nothing to display
	dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py
	( cd _build/default && python3 setup.py build && pip3 install . )

nixbuild:
	nix-build nix/opam2nix.nix
	./result/bin/opam2nix resolve --ocaml-version 4.12.0 ./pycoq.opam --dest nix/opam-selection.nix
	nix-shell nix/default.nix --run "dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py"
	cd _build/default && nix-shell nix/default.nix --run "python3 setup.py build" && nix-shell nix/default.nix --run "pip3 install ."

nixtest: nixbuild
	nix-shell nix/default.nix --run "dune build examples/test.py examples/test2.py examples/error.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/test.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/test2.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/error.py"

test: build
	dune build examples/test.py examples/test2.py examples/error.py
	dune exec -- python3 _build/default/examples/test.py
	dune exec -- python3 _build/default/examples/test2.py
	dune exec -- python3 _build/default/examples/error.py

help:
	@echo "If you have nix installed, try 'make nixtest'. Else, try 'make test'."
