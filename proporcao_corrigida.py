width = 161
height = 90
fa = 3
fb = 4

prop_type = prop(width, height, fa, fb)
#print(prop_type)

def prop(w, h, a, b):
    if w * a == h * b:
        return 2
    elif w * a * a == h * b * b:
        return 1
    else:
        return 0
