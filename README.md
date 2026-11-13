# AmigaLife Viewer

The first Second Life viewer for the Commodore Amiga. Totally real. Draw distance: 2 meters.

## v0.1
- Bouncing copper bars
- Rainbow scroller
- Specs nobody asked for

Left mouse button = log out.

## Run
Copy `AmigaLife` to a disk/folder in WinUAE or FS-UAE (A500, Kickstart 1.3 or newer, PAL) and run it from the Shell.

## Build
```
python3 tools/mkfont.py font.bin
python3 tools/mksine.py
vasmm68k_mot -Fhunkexe -kick1hunks -nosym -o AmigaLife AmigaLife.s
```
