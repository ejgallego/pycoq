import pycoq  # the thing breaks if this isn't imported, even tho it's not invoked
import coq

if __name__ == "__main__":

    # parsing error
    opts = {"newtip": None, "ontop": None, "lim": 10}
    res = coq.add("Definition a := .", opts)
    print(res)
