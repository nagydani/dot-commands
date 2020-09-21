; very simple text file editor for esxDOS

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include "lib/zxrom.asm"
	include	"lib/empty-usage.asm"

arg_e:	equ 2800h

execute:ld de,f_name
	call strarg
	jr nz,usage

	rst 18h
	defw cls

teloop:	rst 18h
	defw set_work
	ld hl,flagx
	res 6,(hl)
	set 7,(hl)		; INPUT LINE
	set 5,(hl)		; INPUT
	ld bc,0001h
	rst 18h
	defw 0030h
	ld (hl),0dh
	ld (k_cur),hl
	ld hl,0
	ld (e_num),hl
	ld hl,0ffech
	add hl,sp
	ld (list_sp),hl

	ld a,"*"
	ld b,fopen_r
	ld hl,f_name
	rst 8
	defb fopen
	ld bc,0000h
	ld de,0001h
	jr c,redraw
	ld (fd),a
	ld hl,newfile
	ld (hl),e		; file not new

	ld hl,(d_num)
	ld a,h
	or l
	jr z,line0
telp1:	push hl
	call seekln
	ld bc,1000h
	ld hl,arg_e
	ld a,(fd)
	rst 8
	defb fread
	ld (buffer),bc
	pop de

redraw:	ld a,0feh
	push bc
	push de
	rst 18h
	defw chan_open
	pop de
	pop bc
	set 4,(iy+tv_flag-err_nr)
	ld (iy+breg-err_nr),0
	ld a,16h
	rst 10h
	xor a
	rst 10h
	rst 10h
	ld hl,(c_num)
	and a
	sbc hl,de
	jr nc,curvis
	add hl,de	; restore c_num
	ld (d_num),hl
	push hl
	call seek0
	pop hl
	jr telp1

curvis:	ld de,arg_e
	call lines
	jr nc,moveup
	bit 4,(iy+tv_flag-err_nr)
	jr nz,inscr
	; TODO: SLOW
scrdown:call seek0
	ld hl,(d_num)
	inc hl
	ld (d_num),hl
	jr telp1

inscr:	ld a,14h
	rst 10h
	ld a,1
	rst 10h
	ld hl,1
	ld (c_ptr),de
	ld (c_len),bc
	call lines
	jr nc,donescr
	bit 4, (iy+tv_flag-err_nr)
	jr z,scrdown
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
	cp " "
	jr z,space
	cp 18h
	jr nc,insert
	cp 07h
	jr c,insert
	jr z,edit
	cp 0ah
	jr z,down
	cp 0bh
	jr z,up
	cp 0ch
	jr z,delete
	cp 0dh
	jp z,enter
edkeys:	rst 18h
	defw ed_keys
	jr keyloop

moveup:	ld hl,(c_num)
	dec hl
	ld a,h
	or l
	jr z,keyloop
	jr vert

edit:	rst 18h
	defw clear_sp
edit2:	ld a,0ffh
	rst 18h
	defw chan_open
c_ptr:	equ $ + 1
	ld de,arg_e
c_len:	equ $ + 1
	ld bc,0000h
	call println
	ld (terminator),a
	ld hl,(c_num)
	ld (e_num),hl
	jr redraw2

up:	ld hl,(k_cur)
	ld de,(worksp)
	and a
	sbc hl,de
	jr z,moveup
	ld (k_cur),de
	jr keyloop

space:	rst 18h
	defw caps_shift
	ret nc
	call symbol_shift
	ld a," "
	jr z,insert
	jr edit2

insert:	rst 18h
	defw add_char
keyloop2:
	jr keyloop

down:	ld hl,(k_cur)
	ld a,0dh
	cp (hl)
	jr z,movedown
	ld bc,0
	cpir
	dec hl
	ld (k_cur),hl
	jr keyloop2

movedown:
	ld hl,(c_num)
	inc hl
vert:	ld (c_num),hl
redraw2:ld de,(d_num)
buffer: equ $ + 1
	ld bc,0000h
	jp redraw

delete:	bit 1,(iy+mode-err_nr)
	jr z,edkeys
	rst 18h
	defw caps_shift
	ld hl,(k_cur)
	jr nc,backdel
	ld e,l
	ld d,h
	ld bc,0
	ld a,0dh
	cpir
	dec hl
	jr fwdel

backdel:ld de,(worksp)
fwdel:	rst 18h
	defw reclaim1
	ld (k_cur),hl
	jp keyloop

enter:	ld hl,terminator
	rst 18h
	defw caps_shift
	jr c,enter3
	ld (hl),0
	jr enter2		; join

enter3:	call symbol_shift
	jr z,enter4
	ld a,(hl)
	or a
	jr nz,enterx
	ld a,0ah
enterx:	xor 7
	ld (hl),a		; switch

enter4:	bit 1,(iy+mode-err_nr)
	jr z,enter2
	ld a,0dh
	rst 18h
	defw add_char		; split

enter2:	ld hl,tmpname
	ld a,"*"
	ld b,fopen_w
	rst 8
	defb fopen
	ret c
	ld (ofd),a

	call seek0
	ld hl,(c_num)
	call copyln
enter0:	ld hl,(worksp)
	ld bc,1
enterl:	ld a,(hl)
	cp 0dh
	jr z,enter1
	ld a,(ofd)
	push hl
	rst 8
	defb fwrite
	pop hl
enterl1:inc hl
	jr nc,enterl
	ret

seek0:	ld a,(fd)
	ld bc,0
	ld e,c
	ld d,c
	ld l,c
	rst 8
	defw fseek
	ret

terminator: equ $ + 1
enter1:	ld a,0dh
	or a
	jr z,entersk
	push hl
	ld hl,terminator
	ld a,(ofd)
	rst 8
	defb fwrite
	pop hl
	ret c
entersk:bit 1,(iy+mode-err_nr)
	res 1,(iy+mode-err_nr)
	jr nz,enterl1

newfile:equ $ + 1
	ld a,0
	or a
	jr z,enterc
	ld hl,(c_num)
	ld bc,(e_num)
	sbc hl,bc
	jr nz,fcopyl
	inc l
	inc l
	call seekln
fcopyl:	ld hl,arg_e
	ld bc,1000h
	ld a,(fd)
	push hl
	push bc
	rst 8
	defb fread
	pop de
	pop hl
	ld a,(ofd)
	push de
	rst 8
	defb fwrite
	pop de
	ret c
	ld a,b
	cp d
	jr z,fcopyl

enterc:	ld a,(fd)
	rst 8
	defb fclose
enterce:ld a,(ofd)
	rst 8
	defb fclose
	ld a,"*"
	ld hl,f_name
	push hl
	rst 8
	defb funlink
	ld a,"*"
	ld hl,tmpname
	pop de
	rst 8
	defb frename
	ret c
	ld hl,(c_num)
	inc hl
	ld (c_num),hl
	jp teloop

; seek line
; In: HL = line number
; Out: ZF set if found
; Pollutes: everything
; TODO: SLOW
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
	inc c
seekc:	equ $ + 1
	ld a,0
	cp 0dh		; cr
	jr z,seekd
	cp 0ah		; lf
	jr nz,seekl
	jr seekd

; copy lines
; In: HL = line number
; TODO: SLOW
copyln:	ld bc,0001h
copyd:	dec hl
	ld a,h
	or l
	ret z
copyl:	push hl
	ld hl,copyc
	ld a,(fd)
	rst 8
	defb fread
	dec c
	jr nz,copyr
	inc c
	dec hl
ofd:	equ $ + 1
	ld a,0
	rst 8
	defb fwrite
	pop hl
	ret c
copyc:	equ $ + 1
	ld a,0
	cp 0dh		; cr
	jr z,copyd
	cp 0ah		; lf
	jr nz,copyl
	jr copyd
copyr:	pop hl
	ret

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
	ld de,membot + 9
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

symbol_shift:
	ld a,7fh
	in a,(0feh)
	or 0fdh
	inc a
	ret

	include "lib/strarg.asm"
	include "lib/println.asm"
	include	"lib/puts.asm"

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
e_num:	defw 0000h
usaget:	defb "Usage: te filename", 0dh, 00h
tmpname:defb "/tmp/te.tmp", 00h
f_name:	include "lib/align512.asm"
