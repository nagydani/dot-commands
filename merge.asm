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

doopen:	ld b,fopen_r
	ld a,"*"
	ld hl,f_name
	rst 8
	defb fopen
	ret c
	ld (fd),a

nextln:	rst 18h
	defw set_min
	ld a,0ffh
	rst 18h
	defw chan_open

copyln:	call fgetc
	ret c
	jr nz,doclose
	cp 0ah
	jr z,readyln
	cp 0dh
	jr z,readyln
	rst 18h
	defw 0010h
	jr copyln

readyln:ld hl,(e_line)
	ld e,l
	ld d,h
tloop:	ld a,(de)
	cp "\""
	jr nz,tnq
tquot:	ld (hl),a
	inc de
	inc hl
	ld a,(de)
	cp "\""
	jr nz,tquot
tnq:	call tokenize
	ld a,(foundl)
	or a
	ld a,(de)
	jr z,ntoken
	ld a,(foundl)
	dec a
	add e
	ld e,a
	jr nc, tnc
	inc d
tnc:	ld a,(found)
ntoken:	ld (hl), a
	inc hl
	inc de
	cp 0dh
	jr nz,tloop
	ld (hl),80h
	inc hl
	ld (worksp),hl

scan_ln:rst 18h
	defw line_scan
	ld a,(err_nr)
	sub 0ffh
	ret c

	ld hl,(e_line)
	ld (ch_add),hl
	rst 18h
	defw e_line_no
	ld a,b
	or c
	call nz,addline
	jr nextln

doclose:ld a,(fd)
	rst 8
	defb fclose
	ret c
	rst 18h
	defw 0058h

fgetc:	ld a,(fd)
	ld hl,buf
	ld bc,1
	rst 8
	defb fread
	ret c
	dec bc
	ld a, b
	or c
	ret nz
	ld a,(buf)
	ret

tokenize:
	xor a
	ld (foundl),a
	push hl
	ld c,tk_spectrum
	ld hl,t_spectrum
tsrc:	xor a
	ex af,af'
	push de
	ld a,(de)
	cp " "
	jr nz,tnskp
	ex af,af'
	inc a
	ex af,af'
	inc de
tnskp:	ld b,(hl)
	push hl
tchk:	inc hl
	ld a,(de)
	inc de
	ex af,af'
	inc a
	ex af,af'
	rst 18h
	defw alpha
	jr nc,tsym
	and 5fh
tsym:	cp (hl)
	jr nz,tneq
	djnz tchk
	ex af,af'
	ld b,a
	ld a,(de)
	cp " "
	jr nz,tntrl
	inc b
tntrl:	ld a,(foundl)
	cp b
	jr nc,tshort
	ld (found),bc
tshort:	pop hl
tcont:	inc hl
	inc c
	pop de
	jr nz,tsrc
	pop hl
	ret

tneq:	ld (buf),a
	ld a,(hl)
	cp " "
	ld a,(buf)
	jr nz,tnosp
	inc hl
	dec b
	jr tsym

tnosp:	pop hl
	ld a,(hl)
	add l
	ld l,a
	jr nc,tcont
	inc h
	jr tcont

addline:ld (e_ppc),bc
	ld hl,(ch_add)
	ex de,hl
	ld hl,(worksp)
	scf
	sbc hl,de
	push hl
	ld h,b
	ld l,c
	rst 18h
	defw line_addr
	jr nz,addln1
	rst 18h
	defw next_one
	rst 18h
	defw reclaim2
addln1:	pop bc
	ld a,c
	dec a
	or b
	ret z
	push bc
	inc bc
	inc bc
	inc bc
	inc bc
	dec hl
	ld de,(prog)
	push de
	rst 18h
	defw make_room
	pop hl
	ld (prog),hl
	pop bc
	push bc
	inc de
	ld hl,(worksp)
	dec hl
	dec hl
	lddr
	ld hl,(e_ppc)
	ex de,hl
	pop bc
	ld (hl),b
	dec hl
	ld (hl),c
	dec hl
	ld (hl),e
	dec hl
	ld (hl),d
	ret

	include "lib/tokens.asm"
	include "lib/strarg.asm"
	include	"lib/puts.asm"

usaget:	defb "Usage: merge filename", 0dh, 00h
fd:	equ $
buf:	equ fd + 1
found:	equ buf + 1
foundl:	equ found + 1
f_name:	equ foundl + 1
	include "lib/align512.asm"
