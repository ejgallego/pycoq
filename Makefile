.PHONY: build_pycoq help

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install

# coq-serapi.install is required so plugins are in place [runtime dep]
build_pycoq:
	dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py
	cp requirements.txt _build/default/requirements.txt && cp README.md _build/default/README.md
	cd _build/default && python3 setup.py build && pip3 install .

examples: build_pycoq
	dune build examples/add_commutative.py examples/definitions_ast.py examples/syntax_error.py
	dune exec -- python3 _build/default/examples/add_commutative.py
	dune exec -- python3 _build/default/examples/definitions_ast.py
	dune exec -- python3 _build/default/examples/syntax_error.py

pyci: build_pycoq
	pip install .[dev]
	black .
	flake8 .
	pytype .
	pytest testpy

nix_build_pycoq:
	nix-build nix/opam2nix.nix
	./result/bin/opam2nix resolve --ocaml-version 4.12.0 ./pycoq.opam --dest nix/opam-selection.nix
	nix-shell nix/default.nix --run "eval $(opam env)"
	nix-shell nix/default.nix --run "dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py"
	nix-shell nix/default.nix --run "cd _build/default && python3 setup.py build && pip3 install ."

nix_examples: nix_build_pycoq
	nix-shell nix/default.nix --run "dune build examples/add_commutative.py examples/definitions_ast.py examples/syntax_error.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/add_commutative.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/definitions_ast.py"
	nix-shell nix/default.nix --run "dune exec -- python3 _build/default/examples/syntax_error.py"

allpy: build_pycoq pyci examples

help:
	@echo "If you have nix installed, try 'make nix_examples'. Else, try 'make examples'."

clean:
	rm -rf _build
	rm -r .pytype
