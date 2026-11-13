# sine.i: 256 y-posisjoner 0..240 for copper-stripene
import math
v=[round(120+120*math.sin(i*2*math.pi/256)) for i in range(256)]
with open("sine.i","w") as f:
    for i in range(0,256,16):
        f.write("\tdc.w\t"+",".join(map(str,v[i:i+16]))+"\n")
