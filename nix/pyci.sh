dune exec -- pip3 install .[dev]
dune exec -- black .
dune exec -- flake8 .
# dune exec -- pytype .
dune build test/py/unit/spec.py test/py/property/spec.py
dune exec -- python3 _build/default/test/py/unit/spec.py
