; open esxDOS file stream

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include "lib/zxrom.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 3400h

execute:ld a,(hl)
	cp "#"
	jr nz,nohash
	inc hl
nohash:	call numarg
	jr c,usage
	jr z,usage
	ld a,e
	ld (s_num),a
	ld de,f_name
	call strarg
	jr z,usage
	ld (m_add),de
	call strarg
	jr nz,usage
m_add:	equ $ + 1
	ld hl,0000h
	ld a,(hl)
	and 0dfh
	cp "R"
	jr z,do_r
	cp "W"
	jr nz,usage
do_w:	ld a,fopen_w
	jr do_fop
do_r:	ld a,fopen_r
do_fop:	ld (open_m),a

	ld hl,serv
	ld de,chinfo
	push hl
	push de
	ld b,serv_l
openl:	ld a,(de)
	cp (hl)
	jr nz,setserv
	inc hl
	inc de
	djnz openl
	pop de
	pop hl
	jr doopen

setserv:ld hl,(chans)
	bit 7,h
	jr nz,rep_o	; ZX85 coroutines cannot do this
	ld bc,serv_l
	push bc
	dec hl		; move CHANS as well
	rst 18h
	defw make_room
	pop bc
	pop de
	pop hl
	push bc
	ldir
	pop bc
	dec hl
	ld de,(chans)
	dec de
	lddr

open_m:	equ $ + 1
doopen:	ld b,0
	ld a,"*"
	ld hl,f_name
	rst 8
	defb fopen
	ret c
	ld (fd),a

s_num:	equ $ + 1
zxopen:	ld a,0
	rst 18h
	defw str_data0
	ld a,b
	or c
	jr z,open1
	ex de,hl
	ld hl,(chans)
	add hl,bc
	inc hl
	inc hl
	inc hl
	ld a,(hl)
	ex de,hl
	cp "K"
	jr z,open1
	cp "S"
	jr z,open1
	cp "P"
	jr z,open1
rep_o:	rst 18h
	defw report_o_2
open1:	push hl
	ld hl,(prog)
	dec hl
	ld bc,fch_e-fch
	push bc
	rst 18h
	defw make_room
	ld hl,fch_e - 1
	pop bc
	lddr
	ld hl,(chans)
	ex de,hl
	and a
	sbc hl,de
	inc hl
	inc hl
	ex de,hl
	pop hl
	ld (hl),e
	inc hl
	ld (hl),d
	and a
	ret

	include	"lib/numarg.asm"
	include "lib/strarg.asm"
	include	"lib/atob.asm"
	include	"lib/puts.asm"

serv:	equ $
	org chinfo
	ld ix,(curchl)
	ld a,(ix+5)
	ld bc,1
	ret
fin:	call chinfo
	ld ix,membot
	rst 8
	defb fread
	dec c
	ld a,(membot)
	scf
	ret z
	or c
	ret
fout:	ld (membot),a
	call chinfo
	ld ix,membot
	rst 8
	defb fwrite
	ret nc
	rst 8
	defb 12h

serv_l:	equ $ - chinfo
	org serv + serv_l

usaget:	defb "Usage: open [#]stream file_name {r|w}", 0dh, 00h
fch:	defw fout
	defw fin
	defb "F"
fd:	defb 0
	defs 3
	defw fch_e - fch
fch_e:	equ $
f_name:	include "lib/align512.asm"
