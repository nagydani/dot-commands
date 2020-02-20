; MSX1 SC2 file viewer command for esxDOS

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include	"lib/zxrom.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 2800h

execute:call options
	jr nc,usage
	ld de,f_name
	call strarg
	jr nz,usage

	ld a,"*"
	ld b,fopen_r
	ld hl,f_name
	rst 8
	defb fopen
	ret c		; file not found
	ld (fd),a

	ld hl,bitmap
	push hl
	ld bc,0007h
	rst 8
	defb fread
	pop hl
	ret c		; any read error
	ld de,sc2head
	ld b,7
chkhead:ld a,(de)
	cp (hl)
	jr nz,usage	; invalid file format
	inc de
	inc hl
	djnz chkhead

	ld c,0ffh
	in a,(c)
	ld (video),a
	in b,(c)
	or b
	inc a
	ld a,10		; Invalid I/O REQUEST
	scf
	ret z		; no Timex video modes

	ld de,(chans)
	ld hl,7800h
	sbc hl,de
	jr c,noalloc
	inc hl
	ex de,hl
	ld (ochans),hl
	ld c,e
	ld b,d
	rst 18h
	defw make_room
	inc de
	ld (chans),de	; reserve video buffer

noalloc:ld a,2
	out (0ffh),a	; change video mode to hicolor

	ld a,(fd)
	ld de,4000h

thirds:	ld bc,0800h
	ld hl,bitmap
	push de
	push hl
	rst 8
	defb fread
	pop hl
	pop de
	jr c,jcrest	; any read error
thirdl:	ld bc,08ffh
	push de
cell:	ldi
	dec de
	inc d
	djnz cell
	pop de
	inc e
	jr nz,thirdl
	ld a,d
	add a,8
	ld d,a
	or 0e7h
	inc a
fd:	equ $ + 1
	ld a,0
	jr nz,thirds

	bit 5,d
	jr nz,loaded

; load characters
	ld hl,chars0
	ld bc,0300h
	rst 8
	defb fread
	jr c,jcrest

; skip to palette
	ld hl,6000h
	ld bc,0080h
	ld a,(fd)
	rst 8
	defb fread
	jr c,jcrest

;load palette
paladd:	equ $ + 1
	ld hl,palette
	ld bc,0020h
	ld a,(fd)
	rst 8
	defb fread
jcrest:	jr c,restore

;set palette
	ld bc,0bf3bh
	ld a,40h
	out (c),a
	ld b,0ffh
	in a,(c)
	in e,(c)
	ld (palmod),a
	or e
	inc a
	jr z,jpald
ulaplus:equ $ + 1
	ld a,1
	out (c),a
	or a
jpald:	jp z,paldone

	ld e,0
	ld hl,palette
pall:	ld c,(hl)
	inc hl
	ld a,(hl)
	inc hl
	rrca
	rrca
	rrca
	ld b,a
	ld a,c
	rrca
	rrca
	and 1ch
	or b
	ld b,a
	ld a,c
	rrca
	and 03h
	or b
	ex af,af'		; A' = ULAplus color

	ld d,trantab / 100h
	ld a,(de)
	rrca
	rrca
	rrca
	bit 3,a
	jr z,dark

	add 30h		; 11 paper
	call setcol
	sub a,8		; 11 ink
	call setcol
	sub a,10h	; 10 ink
	call setcol
	sub a,8		; 01 paper
	jr bright

loaded:	rst 8
	defb fclose

; translate attributes
	ld d,trantab / 100h
	ld hl,6000h
transl:	ld e,(hl)
	ld a,(de)
	ld (hl),a
	inc hl
	ld a,h
	cp 78h
	jr c,transl

key:	xor a
	in a,(0feh)
	or 0e0h
	inc a
	jr z,key
	xor a

restore:push af

palmod:	equ $ + 1
	ld a,0
	ex af,af'
	ld a,40h
	call setcol

	ld a,(video)
	cp 2
	jr z,memok	; if video mode was hicolor, leave it
	out (0ffh),a
	rst 18h
	defw cls
	ld hl,(chans)
	ld de,(ochans)
	ld a,d
	or e
	jr z,memok	; if no memory was allocated, don't reclaim
	rst 18h
	defw reclaim1
	ld (chans),hl

memok:	pop af
	ret

dark:	call setcol	; 00 ink
	add a,8
	call setcol	; 00 paper
	add a,8
	call setcol	; 01 ink
	add a,18h
bright:	call setcol	; 10 paper

	inc e
	bit 4,e
	jp z,pall

; skip to attributes
paldone:call z,timex
	ld hl,6000h
	ld bc,0460h
	ld a,(fd)
	rst 8
	defb fread
	jr c,restore

	ld de,6000h
	ld a,(fd)
	jp thirds

setcol:	ld bc,0bf3bh
	out (c),a
	ex af,af'
	ld b,0ffh
	out (c),a
	ex af,af'
	ret

sc2head:defb 0feh, 00h, 00h, 0ffh, 37h, 00h, 00h

optab:	defb "t"
	defb timex - $
	defb "s"
	defb spectrum - $
	defb "m"
	defb msx - $
	defb "h"
	defb help - $
	defb 0

timex:	ld hl,trantab
timexl:	res 7,(hl)
	inc l
	jr nz,timexl
	xor a
	ld (ulaplus),a
	ret

spectrum:
	push de
	ld hl,approx
	ld de,mgreen
	ld bc,26
	ldir
	pop de
msx:	ld hl,bitmap
	ld (paladd),hl
	ret

help:	call usage
	ld hl,helpt
	call puts
	pop bc
	pop bc
	xor a
	ret

	include "lib/strarg.asm"
	include "lib/options.asm"
	include "lib/puts.asm"
	include "lib/indexer.asm"

usaget:	defb "Usage: sc2 [-{tsmh}] source.sc2", 0dh, 00h
helpt:	defb 0dh
	defb "Display MSX1 SC2 screenshot", 0dh, 0dh
	defb "-t Timex 20xx mode, no palette", 0dh
	defb "   overrides s and m", 0dh
	defb "-s ZX Spectrum approx. palette", 0dh
	defb "   overrides m", 0dh
	defb "-m MSX1 default palette", 0dh, 0dh
	defb "Without ULAplus, -t is default.", 0dh, 00h
video:	defb 0
ochans:	defw 0
palette:defw 0000h	; transparent, approx. black
black:	defw 0000h	; approx. bright black
mgreen:	defw 0522h	; approx. cyan
lgreen:	defw 0633h	; approx. bright green
dblue:	defw 0226h	; approx. blue
lblue:	defw 0337h	; approx. bright blue
dred:	defw 0352h	; approx. red
cyan:	defw 0637h	; approx. bright cyan
mred:	defw 0362h	; approx. magenta
lred:	defw 0473h	; approx. bright red
dyellow:defw 0662h	; approx. yellow
lyellow:defw 0665h	; approx. bright yellow
dgreen:	defw 0422h	; approx. green
magenta:defw 0355h	; approx. bright magenta
gray:	defw 0666h	; approx. white
white:	defw 0777h	; approx. bright white
approx:	defw 505h,700h,005h,007h,050h,707h,055h,070h,550h,770h,500h,077h,555h

	defs 100h * (($ + 0ffh) / 100h) - $
trantab:incbin "sc2.tab"

f_name:	include "lib/align512.asm"
bitmap:	equ $
chars0:	equ bitmap + 0800h
chars1:	equ chars0 + 0100h
chars2:	equ chars1 + 0100h

