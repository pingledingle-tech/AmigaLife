# Lager font.bin: ASCII 32-127, 8x16 piksler, 16 byte per tegn (Unifont)
import sys
from PIL import Image, ImageDraw, ImageFont
f = ImageFont.truetype("/usr/share/fonts/opentype/unifont/unifont.otf", 16)
out = bytearray()
for c in range(32, 128):
    im = Image.new("1", (8, 16), 0)
    ImageDraw.Draw(im).text((0, 0), chr(c), font=f, fill=1)
    for y in range(16):
        b = 0
        for x in range(8):
            b = (b << 1) | (1 if im.getpixel((x, y)) else 0)
        out.append(b)
open(sys.argv[1], "wb").write(out)
