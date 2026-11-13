# AmigaLife Viewer

**The first Second Life viewer for the Commodore Amiga.** Draw distance: 2 meters. Experience: unforgettable.

## Why?

The world is running out of chips. Every new AI, every new graphics card, every new gadget needs more silicon. Meanwhile millions of perfectly good computers sit in attics, waiting.

We believe the greenest computer is the one that already exists.

The Amiga 500 was built in 1987. It still works. It has never asked for a driver update. It boots in seconds and draws only a few watts. If we can run a virtual world on it, then nothing ever needs to be thrown away again.

AmigaLife is our small contribution to a better planet: **reuse the machine, save the chip.**

## The experience

Modern viewers like Aurora Viewer are doing amazing work making Second Life faster and smoother on today's hardware. We have huge respect for that, and you should absolutely use them.

AmigaLife takes the other road. Instead of more frames per second, we offer more *seconds per frame*. Every rezzed pixel is earned. Every teleport is a journey. You will not just visit Second Life, you will *wait* for it, and the waiting is the experience.

Imaginary users report:
- "I have never been this calm in Second Life."
- "My avatar is still rezzing. I have made peace with it."
- "Draw distance 2 meters. I finally see what is right in front of me."

## v0.1
- Bouncing copper bars
- Rainbow scroller
- Specs nobody asked for

Left mouse button = log out.

## Run
Copy `AmigaLife` to a disk or folder in WinUAE or FS-UAE (A500, Kickstart 1.3 or newer, PAL) and run it from the Shell.

## Build
```
python3 tools/mkfont.py font.bin
python3 tools/mksine.py
vasmm68k_mot -Fhunkexe -kick1hunks -nosym -o AmigaLife AmigaLife.s
```

*AmigaLife is a joke project and is not affiliated with Linden Lab, Second Life or Aurora Viewer.*
