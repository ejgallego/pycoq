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
$ opam install pythonlib
```
for the 0.13 version that targets Coq v8.13; note that OCaml >= 4.11.0
is recommended, and >= 4.08.0 required by the dependencies.

For the moment, PyCoq requires a special version of `ppx_python`, while the situation stabilizes
in the OPAM repository we have vendored it in the SerAPI branch we use.

Once the right dependencies have been installed, you can do:
```
$ git clone git@github.com:ejgallego/pycoq.git
$ git submodule update 
$ make examples
```

If you want an interactive environment, use:
```
$ make && dune exec -- python3
>>> import os
>>> os.chdir('_build/default')
>>> import pycoq, coq
```

Our continuous integration should contain up-to-date build
instructions.

### Documentation

As of today, the only documentation we have is the small example below.

Note however, that if you are familiar with the [SerAPI protocol](https://github.com/ejgallego/coq-serapi), you will quickly
get used to the current API as it basically mirrors the one there [and it is derived automatically, so SerAPI's documentation could
be considered as canonical for pyCoq for now]

### Use example:

```python
import pycoq, coq

# Some common definitions we'll use
ppopts = { "pp_format": ("PpSer",None), "pp_depth": 1000, "pp_elide": "...", "pp_margin": 90}

# Add a full document chunk [mainly parsing]
opts = {"newtip": None, "ontop": 1, "lim": 20 }
res = coq.add("Lemma addnC n m : n + m = m + n. Proof. now induction n; simpl; auto; rewrite IHn. Qed.", opts)

# Check the proof.
res = coq.exec(5)

# We can show the goals at the tactic point
opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
cmd = ('Goals', None)
res = coq.query(opts, cmd)
print(res)

# We can also output the ast for example, of the main tactic in our
# document
opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
cmd = ('Ast', None)
res_ast = coq.query(opts, cmd)
print(res)

# Such AST can be actually pretty-printed
obj = res[0][1][0][0]
opts = { "pp": { "pp_format": ("PpStr",None) } }
res = coq.print(obj, opts)
print(res)
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
