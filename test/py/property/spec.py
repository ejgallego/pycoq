import pycoq
import coq
from hypothesis import given
from hypothesis.strategies import integers


@given(x=integers(min_value=1, max_value=10), y=integers(min_value=11, max_value=100))
def test_lia(x: int, y: int):

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
        f"""
        Require Import Lia. Theorem x_lt_y : {x} < {y}. Proof. lia. Qed.
    """,
        opts,
    )

    res = coq.exec(5)
    resdict = dict(res)
    assert "Completed" in resdict.keys()
    assert resdict["Completed"] is None

    opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
    cmd = ('Goals', None)
    res = coq.query(opts, cmd)
    resdict = dict(res)
    assert "Completed" in resdict.keys()
    assert resdict["Completed"] is None


if __name__=="__main__":
    test_lia()
