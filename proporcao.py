w = 1920
h = 1080

result = 0

def prop(width, height):
    if width * 9 == height * 16:
        proportion = 1
    elif width * 3 == height * 4:
        proportion = 2
    else:
        proportion = 0

    return proportion

result = prop(1920, 1080)