w = 1920
h = 1080

def prop(width, height):
    if width * 9 == height * 16:
        return 1
    elif width * 3 == height * 4:
        return 2
    else:
        return 0
