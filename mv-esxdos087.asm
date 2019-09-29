; MV command from esxDOS v0.8.7

; Errata:
; 1. Only the first argument is moved to the last, no check against more than 2 args
; 2. Arguments buffer overflow
; 3. No sanitization of file names (maybe esxDOS system calls do it)

	include "lib/sysvars.asm"
	include "lib/hooks.asm"
	include	"lib/empty-usage.asm"
	include "lib/cpmv-esxdos087.asm"

arg_e:	equ 2200h

do:	ld a,"*"
	ld hl,f_name
	ld de,(f_name2)
	rst 8
	defb frename
	ret

	include "lib/strcpy.asm"
	include "lib/parse2-esxdos087.asm"
	include "lib/basename.asm"
	include "lib/chkdir.asm"
	include "lib/puts.asm"

usaget:	defb "Usage: mv source target", 0dh, 00h

f_name2:defw 0
	defb 0
f_name:	defs arg_e - $
