; CP command from esxDOS v0.8.7

	include	"sysvars.asm"
	include	"hooks.asm"
	include	"empty-usage.asm"

execute:call parsefn
	ld hl,(f_name2)
	ld a,l
	or h
	jr z,usage		; missing target

	ld hl,f_name
	ld a,(hl)
	and a
	jr z,usage		; missing source

	ld hl,(f_name2)		; if target is
	call chkdir		; not a directory
	jr nz,docopy		; then jump forward
	push hl			; otherwise save terminator
	ld hl,f_name		; take the source
	call basename		; file base name
	pop de			; restore terminator in DE
	call strcpy		; append to target path

docopy:	ld hl,f_name
	ld a,"*"
	ld b,fopen_r
	rst 8
	defb fopen
	ret c
	ld (fd_src),a
	ld hl,(f_name2)
	ld a,"*"
	ld b,fopen_w
	rst 8
	defb fopen
	jr c,exit
	ld (fd_trg),a
	call buf32k

bufptr:	equ $ + 1
copyl:	ld hl,02200h
buflen: equ $ + 1
	ld bc,01000h
	ld a,(fd_src)
	push hl
	push bc
	rst 8
	defb fread
	pop de
	pop hl
	jr c,exit
	ld a,(fd_trg)
	push de
	rst 8
	defb fwrite
	pop de
	jr c,exit
	ld a,b
	cp d
	jr nz,finish
	jr copyl

finish:	or a
exit:	push af
	ld a,(fd_src)
	and a
	call nz,f_close
	ld a,(fd_trg)
	and a
	call nz,f_close
	pop af
	ret

f_close:rst 8
	defb fclose
	ret

	include	"strcpy.asm"

parsefn:ld de,f_name
parsel:	ld a,(hl)
	and a
	jr z,parsee
	cp ":"
	jr z,parsee
	cp 00dh
	jr z,parsee
	cp " "
	jr z,parse2
	ldi
	jr parsel

parsee:	xor a
	ld (de),a
	ret

parse2:	xor a
	ld (de),a
	inc hl
	inc de
	ld (f_name2),de
	jr parsel

	include	"basename.asm"
	include	"chkdir.asm"
	include	"puts.asm"
	include	"buffer.asm"

usaget:	defb "Usage: cp source target", 0dh, 00h
f_name2:defw 0
fd_src:	defb 0
fd_trg:	defw 0
f_name:	defs $2200 - $
