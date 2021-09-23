.PHONY: python help

PYNAME=pycoq
SERAPI=coq-serapi/coq-serapi.install

# coq-serapi.install is required so plugins are in place [runtime dep]
python:
	dune build $(SERAPI) pycoq/$(PYNAME).so pycoq/__init__.py setup.py
	( cd _build/default && python3 setup.py build && pip3 install . )

test:
	dune build examples/test.py examples/test2.py examples/error.py
	dune exec -- python3 _build/default/examples/test.py
	dune exec -- python3 _build/default/examples/test2.py
	dune exec -- python3 _build/default/examples/error.py

help:
	@echo Nothing to display
