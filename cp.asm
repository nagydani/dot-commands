; CP command for esxDOS

; Errata:
; 1. No sanitization of file names (maybe esxDOS system calls do it)

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 2400h

execute:include "lib/parse2.asm"
	include "lib/cpmv.asm"

do:	ld hl,f_name
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
copyl:	ld hl,arg_e
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

	include	"lib/strcpy.asm"
	include	"lib/basename.asm"
	include	"lib/chkdir.asm"
	include	"lib/puts.asm"
	include	"lib/buffer.asm"

usaget:	defb "Usage: cp source target", 0dh, 00h
f_name2:defw 0
fd_src:	defb 0
fd_trg:	defw 0
f_name:	include "lib/align512.asm"
