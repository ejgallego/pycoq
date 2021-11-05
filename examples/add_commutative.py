import pycoq  # the thing breaks if this isn't imported, even tho it's not invoked
import coq

if __name__ == "__main__":
    # Some common definitions we'll use
    ppopts = {
        "pp_format": ("PpSer", None),
        "pp_depth": 1000,
        "pp_elide": "...",
        "pp_margin": 90,
    }

    # Add a full document chunk [mainly parsing]
    opts = {"newtip": None, "ontop": 1, "lim": 20}
    res = coq.add(
        "Lemma addnC n m : n + m = m + n. Proof. now induction n; simpl; auto; rewrite IHn. Qed.",
        opts,
    )

    # Check the proof.
    res = coq.exec(5)

    # We can show the goals at the tactic point
    opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
    cmd = ("Goals", None)
    res = coq.query(opts, cmd)
    print(res)

    # We can also output the ast for example, of the main tactic in our
    # document
    opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
    cmd = ("Ast", None)
    res_ast = coq.query(opts, cmd)
    print(res)

    # Such AST can be actually pretty-printed
    obj = res[0][1][0][0]
    opts = {"pp": {"pp_format": ("PpStr", None)}}
    res = coq.print(obj, opts)
    print(res)
