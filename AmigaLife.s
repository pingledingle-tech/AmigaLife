; =============================================================
;  AmigaLife Viewer v0.1 - "The first Second Life viewer for Amiga"
;  68000, OCS/ECS/AGA, PAL. Bygg: vasmm68k_mot -Fhunkexe -kick1hunks
;  Steg 1: copper-striper, tekst og scroller. Venstre musknapp = avslutt.
; =============================================================

; exec / graphics offsets
Forbid		= -132
Permit		= -138
OpenLibrary	= -552
CloseLibrary	= -414
LoadView	= -222
WaitTOF		= -270
gb_ActiView	= 34
gb_copinit	= 38

BPW		= 42		; bytes per linje (40 synlige + 2 skjulte)
LINES		= 256
SCRY		= 224		; scroller-linje

	section code,code

start:
	move.l	4.w,a6
	jsr	Forbid(a6)
	lea	gfxname(pc),a1
	moveq	#0,d0
	jsr	OpenLibrary(a6)
	move.l	d0,gfxbase
	beq	.nogfx
	move.l	d0,a6
	move.l	gb_ActiView(a6),oldview
	sub.l	a1,a1
	jsr	LoadView(a6)
	jsr	WaitTOF(a6)
	jsr	WaitTOF(a6)

	lea	$dff000,a5
	move.w	$02(a5),olddma
	move.w	$1c(a5),oldintena
	move.w	#$7fff,$9a(a5)		; alle interrupts av
	move.w	#$7fff,$9c(a5)
	move.w	#$7fff,$96(a5)		; all DMA av

	bsr	buildcop
	bsr	drawstatic

	move.l	#copper,$80(a5)
	move.w	d0,$88(a5)		; COPJMP1
	move.w	#$8380,$96(a5)		; DMAEN|BPLEN|COPEN

.main:
	bsr	waitvb
	bsr	bars
	bsr	scroller
	bsr	scroller		; 2 piksler per frame
	addq.w	#1,frame
	btst	#6,$bfe001		; venstre musknapp
	bne.s	.main

; ---- tilbake til systemet ----
	move.w	#$7fff,$96(a5)
	move.w	olddma,d0
	or.w	#$8000,d0
	move.w	d0,$96(a5)
	move.l	gfxbase,a6
	move.l	gb_copinit(a6),$80(a5)
	move.w	d0,$88(a5)
	move.w	oldintena,d0
	or.w	#$c000,d0
	move.w	d0,$9a(a5)
	move.l	oldview,a1
	jsr	LoadView(a6)
	jsr	WaitTOF(a6)
	jsr	WaitTOF(a6)
	move.l	a6,a1
	move.l	4.w,a6
	jsr	CloseLibrary(a6)
.nogfx:
	move.l	4.w,a6
	jsr	Permit(a6)
	moveq	#0,d0
	rts

; ---- vent på vertikal blanking (linje 303) ----
waitvb:
.w1	move.l	$04(a5),d0
	and.l	#$1ff00,d0
	cmp.l	#303<<8,d0
	bne.s	.w1
.w2	move.l	$04(a5),d0
	and.l	#$1ff00,d0
	cmp.l	#303<<8,d0
	beq.s	.w2
	rts

; ---- bygg copperliste: én WAIT + COLOR00 + COLOR01 per linje ----
buildcop:
	move.l	#plane,d0
	move.w	d0,bpll
	swap	d0
	move.w	d0,bplh
	lea	copbars,a0
	move.w	#$2c,d0			; første synlige linje
	move.w	#LINES-1,d7
.l	cmp.w	#$100,d0
	bne.s	.nowrap
	move.l	#$ffdffffe,(a0)+	; passer linje 255
.nowrap	move.w	d0,d1
	lsl.w	#8,d1
	or.w	#$07,d1
	move.w	d1,(a0)+
	move.w	#$fffe,(a0)+
	move.w	#$0180,(a0)+
	clr.w	(a0)+
	move.w	#$0182,(a0)+
	move.w	#$0fff,(a0)+
	addq.w	#1,d0
	dbf	d7,.l
	move.l	#$fffffffe,(a0)+	; slutt
	; tittelfarge (gull-gradient) på linje 16-31
	lea	col1buf,a0
	move.w	#LINES-1,d7
.f	move.w	#$0fff,(a0)+
	dbf	d7,.f
	lea	col1buf+16*2,a0
	lea	goldgrad(pc),a1
	moveq	#15,d7
.g	move.w	(a1)+,(a0)+
	dbf	d7,.g
	rts

; ---- tre sprettende copper-striper + regnbue i scrolleren ----
bars:
	lea	col0buf,a0
	moveq	#0,d0
	moveq	#LINES/2-1,d7
.clr	move.l	d0,(a0)+
	dbf	d7,.clr

	lea	sine(pc),a2
	lea	bargrads(pc),a3
	moveq	#2,d6			; 3 striper
	move.w	frame,d5
	add.w	d5,d5			; fart
.bar	move.w	d5,d0
	and.w	#$ff,d0
	add.w	d0,d0
	move.w	(a2,d0.w),d0		; y-posisjon 0..240
	add.w	d0,d0
	lea	col0buf,a0
	add.w	d0,a0
	moveq	#14,d7
.cp	move.w	(a3)+,(a0)+
	dbf	d7,.cp
	add.w	#24,d5			; faseforskyvning
	dbf	d6,.bar

	; regnbuetekst i scrolleren
	lea	col1buf+SCRY*2,a0
	lea	rainbow(pc),a1
	move.w	frame,d0
	moveq	#15,d7
.rb	move.w	d0,d1
	and.w	#15,d1
	add.w	d1,d1
	move.w	(a1,d1.w),(a0)+
	addq.w	#1,d0
	dbf	d7,.rb

	; kopier inn i copperlista
	lea	copbars,a0
	lea	col0buf,a1
	lea	col1buf,a2
	moveq	#0,d6
	move.w	#LINES-1,d7
.cl	cmp.w	#$100-$2c,d6
	bne.s	.nw
	addq.l	#4,a0			; hopp over $ffdf-ventingen
.nw	move.w	(a1)+,6(a0)
	move.w	(a2)+,10(a0)
	lea	12(a0),a0
	addq.w	#1,d6
	dbf	d7,.cl
	rts

; ---- scroller: flytt 16 linjer 1 piksel til venstre ----
scroller:
	lea	plane+SCRY*BPW+BPW,a0
	moveq	#15,d7
.row	move.w	#0,ccr			; X = 0
	rept	BPW/2
	roxl.w	-(a0)
	endr
	lea	BPW*2(a0),a0
	dbf	d7,.row

	addq.w	#1,scrcnt
	cmp.w	#8,scrcnt
	bne.s	.done
	clr.w	scrcnt
	move.l	scrptr,a0
	move.b	(a0)+,d0
	bne.s	.ok
	lea	scrtext,a0
	move.b	(a0)+,d0
.ok	move.l	a0,scrptr
	moveq	#40,d1			; skjult kolonne
	move.w	#SCRY,d2
	bsr	drawchar
.done	rts

; ---- tegn ett tegn: d0=ascii, d1=kolonne (byte), d2=linje ----
drawchar:
	and.w	#$7f,d0
	sub.w	#32,d0
	bpl.s	.ok
	moveq	#0,d0
.ok	lsl.w	#4,d0
	lea	font,a1
	add.w	d0,a1
	lea	plane,a0
	mulu	#BPW,d2
	add.l	d2,a0
	add.w	d1,a0
	moveq	#15,d3
.l	move.b	(a1)+,(a0)
	lea	BPW(a0),a0
	dbf	d3,.l
	rts

; ---- tegn streng: a2=tekst (0-terminert), d4=kolonne, d5=linje ----
drawstr:
.l	moveq	#0,d0
	move.b	(a2)+,d0
	beq.s	.end
	move.w	d4,d1
	move.w	d5,d2
	bsr	drawchar
	addq.w	#1,d4
	bra.s	.l
.end	rts

; ---- statisk tekst (sentrert) ----
drawstatic:
	lea	texts(pc),a3
.l	move.w	(a3)+,d5		; linje, -1 = slutt
	bmi.s	.end
	move.l	a3,a2
	moveq	#-1,d0
.len	addq.w	#1,d0
	tst.b	(a2)+
	bne.s	.len
	moveq	#40,d4
	sub.w	d0,d4
	lsr.w	#1,d4
	move.l	a3,a2
	bsr	drawstr
	move.l	a2,d0			; neste post på jevn adresse
	addq.l	#1,d0
	and.w	#$fffe,d0
	move.l	d0,a3
	bra.s	.l
.end	rts

; ============================ data ============================
gfxname:	dc.b	"graphics.library",0
	even

texts:
	dc.w	16
	dc.b	"AMIGALIFE VIEWER V0.1",0
	even
	dc.w	56
	dc.b	"THE FIRST SECOND LIFE VIEWER",0
	even
	dc.w	72
	dc.b	"FOR THE COMMODORE AMIGA",0
	even
	dc.w	104
	dc.b	"CPU: 68000 @ 7.09 MHZ",0
	even
	dc.w	120
	dc.b	"RAM: 512 KB CHIP (MESH NOT INCLUDED)",0
	even
	dc.w	136
	dc.b	"DRAW DISTANCE: 2 METERS",0
	even
	dc.w	152
	dc.b	"FPS: YES",0
	even
	dc.w	184
	dc.b	"CLICK MOUSE TO LOG OUT",0
	even
	dc.w	-1

goldgrad:
	dc.w	$0640,$0750,$0860,$0970,$0a80,$0b90,$0ca0,$0db0
	dc.w	$0ec0,$0fd0,$0fe4,$0ff8,$0ffc,$0fe8,$0fd4,$0ec0
rainbow:
	dc.w	$0f00,$0f40,$0f80,$0fc0,$0ff0,$0bf0,$06f0,$00f4
	dc.w	$00f8,$00fc,$00cf,$008f,$004f,$040f,$080f,$0c0f
bargrads:
	dc.w	$0100,$0300,$0500,$0700,$0900,$0b00,$0d20,$0f88	; rød
	dc.w	$0d20,$0b00,$0900,$0700,$0500,$0300,$0100
	dc.w	$0010,$0030,$0050,$0070,$0090,$00b0,$02d2,$08f8	; grønn
	dc.w	$02d2,$00b0,$0090,$0070,$0050,$0030,$0010
	dc.w	$0001,$0003,$0005,$0007,$0009,$000b,$022d,$088f	; blå
	dc.w	$022d,$000b,$0009,$0007,$0005,$0003,$0001
sine:
	include	"sine.i"

	section	vars,data
gfxbase:	dc.l	0
oldview:	dc.l	0
olddma:		dc.w	0
oldintena:	dc.w	0
frame:		dc.w	0
scrcnt:		dc.w	0
scrptr:		dc.l	scrtext
col0buf:	ds.w	LINES
col1buf:	ds.w	LINES
font:		incbin	"font.bin"
scrtext:
	dc.b	"WELCOME TO SECOND LIFE ... NOW RUNNING AT 7.09 MHZ ...    "
	dc.b	"RENDERING YOUR AVATAR AT 0.0003 FPS, PLEASE STAND BY ...    "
	dc.b	"MADE ALL BY MYSELF *PROUD* ...    "
	dc.b	"YOUR FRIEND SAID UHUH ...    "
	dc.b	"TELEPORT REQUEST RECEIVED: DECLINED (OUT OF CHIP RAM) ...    "
	dc.b	"TIP: TURN DRAW DISTANCE DOWN TO 1 METER FOR BETTER PERFORMANCE ...    "
	dc.b	"GREETINGS TO EVERYONE STILL WAITING FOR THEIR MESH TO REZ ...           ",0
	even

	section	chip,data_c
copper:
	dc.w	$01fc,$0000		; FMODE (AGA-kompatibel)
	dc.w	$008e,$2c81,$0090,$2cc1	; DIWSTRT/DIWSTOP
	dc.w	$0092,$0038,$0094,$00d0	; DDFSTRT/DDFSTOP
	dc.w	$0100,$1200		; 1 bitplan, farge
	dc.w	$0102,$0000,$0104,$0000
	; nullstill sprite-data (ingen musepeker-søppel)
	dc.w	$0144,0,$0146,0
	dc.w	$014c,0,$014e,0
	dc.w	$0154,0,$0156,0
	dc.w	$015c,0,$015e,0
	dc.w	$0164,0,$0166,0
	dc.w	$016c,0,$016e,0
	dc.w	$0174,0,$0176,0
	dc.w	$017c,0,$017e,0
	dc.w	$0108,BPW-40,$010a,BPW-40	; modulo: hopp over skjulte bytes
	dc.w	$00e0
bplh:	dc.w	0
	dc.w	$00e2
bpll:	dc.w	0
copbars:
	ds.b	LINES*12+4+4

	section	chipbss,bss_c
plane:	ds.b	BPW*LINES
