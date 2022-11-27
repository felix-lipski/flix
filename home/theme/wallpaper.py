from PIL import Image
import sys
import json

in_path = sys.argv[1]
out_path = sys.argv[2]
palette = json.loads(sys.argv[3])

def hex2rgb(hex_str):
    return [int(x, 16) for x in [hex_str[1:3],hex_str[3:5],hex_str[5:7]]]

palette_ints = []

def append_palette(color_name):
    global palette_ints
    palette_ints = palette_ints + hex2rgb(palette[color_name])

append_palette("black")
append_palette("white")

with Image.open(in_path) as original:
    raw_pal = original.getpalette()
    im = original.copy()
    print(raw_pal)
    im.putpalette(palette_ints)
    im.save(out_path)
