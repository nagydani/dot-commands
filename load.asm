; save BASIC program as ASCII file

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include "lib/zxrom.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 3400h

execute:ld a,(hl)
	ld de,f_name
	call strarg
	jr nz,usage

	ld de,(prog)
	ld hl,(vars)
	rst 18h
	defw reclaim1

	include "lib/addlines.asm"
	include "lib/tokens.asm"
	include "lib/strarg.asm"
	include	"lib/puts.asm"

usaget:	defb "Usage: load filename", 0dh, 00h
fd:	equ $
buf:	equ fd + 1
found:	equ buf + 1
foundl:	equ found + 1
f_name:	equ foundl + 1
	include "lib/align512.asm"
