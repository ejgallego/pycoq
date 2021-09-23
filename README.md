## PyCoq: Access Coq from Python!

[![Build Status][action-badge]][action-link]
[![Zulip][zulip-badge]][zulip-link]

[action-badge]: https://github.com/ejgallego/pycoq/actions/workflows/ci.yml/badge.svg?branch=v8.13
[action-link]: https://github.com/ejgallego/pycoq/actions/workflows/ci.yml?query=branch%3Av8.13

[zulip-badge]: https://img.shields.io/badge/Zulip-chat-informational.svg
[zulip-link]: https://coq.zulipchat.com/#narrow/stream/301571-PyCoq

![Temporary logo][tmp-logo]

[tmp-logo]: http://1.bp.blogspot.com/-gG_8XR3MKJU/TtVO_VjsP6I/AAAAAAAAAUc/T-zU36EYp7s/s400/tattoo-rae-rooster-snake.jpg

PyCoq is a set of bindings and libraries allowing to interact with the
[Coq interactive proof assistant](https://github.com/coq/coq) from
inside Python 3.

This way, typical operations such as parsing Coq documents, and
checking them, can be performed programatically using Python.

This project is **extremely experimental**, and we don't provide a
release yet. Use at your own risk.

Help is more than welcome; don't hesitate to open issues, suggest
improvements, or help with documentation

We have a [contributing guide](CONTRIBUTING.md) and a [Code of Conduct](CODE_OF_CONDUCT.md)

### Build Instructions

To build PyCoq, you need Python 3 and an OCaml environment able to
build SerAPI; usually, this can be achieved using the OPAM package
manager and doing:
```
$ opam install --deps-only coq-serapi
$ opam install ppx_python pythonlib
```
for the 0.13 version that targets Coq v8.13; note that OCaml >= 4.11.0
is recommended, and >= 4.08.0 required by the dependencies.

For the moment, PyCoq requires a special version of `ppx_python`,
which can be obtained also using OPAM:
```
$ opam pin add -y ppx_python https://github.com/ejgallego/ppx_python.git#fixup

```

Once the right dependencies have been installed, you can do:
```
$ make && dune exec -- python3 _build/default/test.py
```

Our continuous integration should contain up-to-date build instructions.

### Documentation

As of today, the only documentation we have is the small example below.

### Use example:

```python
```

### TODO and Roadmap

As a nascent project, the roadmap is still in flux; issues should
track the more concrete items, but indeed a lot more work is needed in
order for PyCoq to be useful.

For a start, we need handle errors correctly and to adhere to Python
conventions. A large amount of feedback is required from Python
experts as I am not familiar with Python myself at all.

### Acknowledgments

- `ppx_python` and `pythonlib` developers were very helpful and resolved our issues quickly, thanks!
- Current setup was bootstrapped from https://github.com/jonathan-laurent/pyml_example , thanks a lot!

### Developer team

- [Emilio Jesus Gallego Arias](https://www.irif.fr/~gallego), Inria, Université de Paris, IRIF, Paris
- [Thierry Martinez](https://github.com/thierry-martinez), Inria Paris
