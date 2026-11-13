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

## Known bugs & feature requests

### Bugs
| # | Issue | Status |
|---|-------|--------|
| 1 | **Disk not found.** Axelle inserted the AmigaLife floppy, but it ended up in the wrong slot (VCR?). | Cannot reproduce, works on my Amiga |
| 2 | **Avatar stuck at 1% rezzing.** | Works as intended |
| 3 | **Teleport always declined.** Reason: out of Chip RAM. | Fix: buy more RAM |

### Feature requests
| # | Request | Status |
|---|---------|--------|
| 4 | **Mesh support.** Requires 4 MB Chip RAM and roughly 3 weeks per mesh. | Planned (2031) |
| 5 | **Put AO in hood**, because someone managed it in SL. | Investigating |
| 6 | **Increase draw distance to 3 meters.** | Won't fix, too ambitious |
| 7 | **More shiny latex.** Requested by Tricky. Avatars must shine more, even though the Amiga only has 32 colors. | Copper team assigned |
| 8 | **Drone NX-001 requests shiny.**<br>`] NX-001: ᶶᶽᶱ, ʱ ᶳᵝᶟᵋ ʸᶪᶲᵡᶪʶᶸ?! ʸᶪᶶ, gimp, you ᶿᶾᶴᶣ ᵠʶᵋᵅ ᶮᵠᶯᶭᶯˠ drone ᵞᵝᶣ'ʶ ᶪᵠᶣ no to ᶲᶶᶛᶴᶱᶞᶺᶾᵅ shiny~ ᶞᶝᶲᶣ ᶹᶫ to me, ᶱᶹᵋᶫʱᶭ, ᶧᶲʷʸ ᶩᶪ ᶱᶸ?`<br>*Translation: unit wants shiny too. Request queued.* | Queued |

## Run
Copy `AmigaLife` to a disk or folder in WinUAE or FS-UAE (A500, Kickstart 1.3 or newer, PAL) and run it from the Shell.

## Build
```
python3 tools/mkfont.py font.bin
python3 tools/mksine.py
vasmm68k_mot -Fhunkexe -kick1hunks -nosym -o AmigaLife AmigaLife.s
```

*AmigaLife is a joke project and is not affiliated with Linden Lab, Second Life or Aurora Viewer.*
