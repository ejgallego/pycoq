import pycoq, coq

print("step1")
opts = {"newtip": 2, "ontop": 1, "lim": 10 }
res = coq.add("Definition a := 3.", opts)
print(res)

print("step2")
opts = {"newtip": 3, "ontop": 2, "lim": 10 }
res = coq.add("Definition b := 2.", opts)
print(res)

print("step3")
res = coq.exec(3)
print(res)

print("step4")
ppopts = { "pp_format": ("PpSer",None), "pp_depth": 1000, "pp_elide": "...", "pp_margin": 90}
opts = {"limit": 100, "preds": [], "sid": 3, "pp": ppopts, "route": 0}
cmd = ('Ast',None)
res = coq.query(opts, cmd)
print(res)

print("step5")
obj = res[0][1][0][0]
opts = { "pp": { "pp_format": ("PpStr",None) } }
res = coq.print(obj, opts)
print(res)
