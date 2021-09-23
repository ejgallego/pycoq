import pycoq, coq

# parsing error
opts = {"newtip": None, "ontop": None, "lim": 10 }
res = coq.add("Definition a := .", opts)
print(res)
