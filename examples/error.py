import pycoq
import coq

if __name__=="__main__":

    # parsing error
    opts = {"newtip": None, "ontop": None, "lim": 10 }
    res = coq.add("Definition a := .", opts)
    print(res)
