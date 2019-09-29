; very simple text file editor for esxDOS

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include "lib/zxrom.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 2800h

execute:ld de,f_name
	call strarg
	jr nz,usage

	ld a,"*"
	ld b,fopen_r
	ld hl,f_name
	rst 8
	defb fopen
	ret c
	ld (fd),a

	rst 18h
	defw set_work
	ld hl,flagx
	res 6,(hl)
	set 7,(hl)
	set 5,(hl)
	ld bc,0001h
	rst 18h
	defw 0030h
	ld (hl),0dh
	ld (k_cur),hl

	ld hl,(d_num)
	ld a,h
	or l
	jr z,line0
	push hl
	call seekln
	ld bc,1000h
	ld hl,arg_e
	ld a,(fd)
	rst 8
	defb fread
	ld (buffer),bc
	pop de

redraw:	set 4,(iy+tv_flag-err_nr)
	ld a,16h
	rst 10h
	xor a
	rst 10h
	rst 10h
	ld hl,(c_num)
	and a
	sbc hl,de
	ld de,arg_e
	call lines
	jr nc,moveup
	ld a,14h
	rst 10h
	ld a,1
	rst 10h
	ld hl,1
	ld (c_ptr),de
	ld (c_len),bc
	call lines
	jr nc,donescr
line0:	ld hl,(s_posn+1)
	ld h,0
	call lines

donescr:res 4,(iy+tv_flag-err_nr)
	rst 18h
	defw cls_lower
	ld bc,(c_num)
	rst 18h
	defw stack_bc
	rst 18h
	defw print_fp
	ld a,":"
	rst 10h

keyloop:rst 18h
	defw wait_key
	cp 18h
	jr nc,insert
	cp 07h
	jr c,insert
	jr z,edit
	cp 0ah
	jr z,down
	cp 0bh
	jr z,up
	cp 0dh
	ret z
	rst 18h
	defw ed_keys
	jr keyloop

insert:	rst 18h
	defw add_char
	jr keyloop

edit:	rst 18h
	defw clear_sp
	ld a,0ffh
	rst 18h
	defw chan_open
c_ptr:	equ $ + 1
	ld de,arg_e
c_len:	equ $ + 1
	ld bc,0000h
	call println
	jr redraw2

up:	ld hl,(k_cur)
	ld de,(worksp)
	and a
	sbc hl,de
	jr z,moveup
	ld (k_cur),de
	jr keyloop

moveup:	ld hl,(c_num)
	dec hl
	ld a,h
	or l
	jr z,keyloop
	jr vert

down:	ld hl,(k_cur)
	ld a,0dh
	cp (hl)
	jr z,movedown
	ld bc,0
	cpir
	dec hl
	ld (k_cur),hl
	jr keyloop

movedown:
	ld hl,(c_num)
	inc hl
vert:	ld (c_num),hl
redraw2:ld a,2
	rst 18h
	defw chan_open
	ld de,(d_num)
buffer: equ $ + 1
	ld bc,0000h
	jp redraw

; seek line
; In: line number
; Out: ZF set if found
; Pollutes: everything
seekln:	ld bc,0001h
seekd:	dec hl
	ld a,h
	or l
	ret z
seekl:	push hl
	ld hl,seekc
fd:	equ $ + 1
	ld a,0
	rst 8
	defb fread
	pop hl
	dec c
	ret nz
seekc:	equ $ + 1
	ld a,0
	cp 0dh		; cr
	jr z,seekd
	cp 0ah		; lf
	jr nz,seekl
	jr seekd

; print lines
; In: HL = number of lines to print, DE = pointer, BC = bytes till EOF
; Out: CF clear on EOF
; Pollutes: everything
lines:	ld a,h
	or l
	jr nz,linel
	scf
	ret

linel:	call println
	ret nc
	cp 0dh
	jr z,linecr
linelf:	ld a,91h
	jr line_e
linecr: ld a,90h
line_e:	push hl
	ld hl,(udg)
	push hl
	exx
	ld hl,crudg
	ld de,membot + 5
	ld (udg),de
	ld bc,10h
	ldir
	exx
	rst 10h
	pop hl
	ld (udg),hl
	pop hl
	ld a,0dh
	push bc
	ld b,(iy+s_posn-err_nr)
	call blank
	pop bc
	dec hl
	jr lines

blank:	ld a,80h
	jr pad
padl:	rst 10h
pad:	djnz padl
inv0:	ld a,14h
	rst 10h
	xor a
	rst 10h
	ret

	include "lib/strarg.asm"
	include "lib/println.asm"
	include	"lib/puts.asm"

usaget:	defb "Usage: te filename", 0dh, 00h

crudg:	defb 00000000b
	defb 00000010b
	defb 00010010b
	defb 00100010b
	defb 01111110b
	defb 00100000b
	defb 00010000b
	defb 00000000b

lfudg:	defb 00000000b
	defb 01001110b
	defb 01001000b
	defb 01001110b
	defb 01001000b
	defb 01001000b
	defb 01111000b
	defb 00000000b

d_num:	defw 0001h
c_num:	defw 0001h
	defb 00h		; separator
f_name:	include "lib/align512.asm"

