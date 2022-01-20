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

doopen:	ld b,09h
	ld a,"*"
	ld hl,f_name
	rst 8
	defb fopen
	ret c
	ld (fd),a

	ld hl,(prog)
next_ln:ld a,(hl)
	cp $40
	jr nc, doclose

	ld d,a
	inc hl
	ld e,(hl)
	inc hl
	push hl
	ex de,hl
	ld e," "
	ld bc,-1000
	call out_dig
	ld bc,-100
	call out_dig
	ld bc,-10
	call out_dig
	ld a, l
	call out_cd
	pop hl

	inc hl
	inc hl

next_c:	ld a, (hl)
	inc hl
	cp $0D
	jr z,next_l
	cp $0E
	jr nz,n_skip
	inc hl
	inc hl
	inc hl
	inc hl
	inc hl
	jr next_c

next_l:	ld a,$0A
	call out_char
	jr next_ln

n_skip:	call out_char
	jr next_c

doclose:ld a,(fd)
	rst 8
	defb fclose
	ret

out_dig:xor a
out_dl:	add hl,bc
	inc a
	jr c,out_dl
	sbc hl,bc
	dec a
	jr nz,out_cd
	ld a, e
	jr write_a
out_cd:	ld e,"0"
	add a,e
write_a:ld bc,1
	push de
	push hl
	ld hl,buf
	ld (hl),a
	ld a,(fd)
	rst 8
	defb fwrite
	pop hl
	pop de
	ret

token:	cp tk_rnd
	jr c,t_sp
	cp tk_line
	jr c,t_nosp
t_sp:	bit 0,(iy+flags-err_nr)
	jr nz,t_nosp
	push af
	ld a, " "
	call write_a
	pop af
t_nosp:	push af
	sub a,tk_spectrum
	ld l,a
	ld h,0
	add hl,hl
	ld de,tokens128
	add hl,de
	ld a,(hl)
	inc hl
	ld h,(hl)
	ld l,a
	ld c,(hl)
	ld b,0
	inc hl
	ld a,(fd)
	rst 8
	defb fwrite
	dec hl
	ld c,(hl)
	pop af
	pop hl
	cp tk_rnd
	jr c,t_sp2
	cp tk_fn
	ret c
t_sp2:	ld a,c
	cp "A"
	ret c
	ld a," "

out_char:
	push hl
	ld hl,flags
	res 0,(hl)
	cp " "
	jr nz, nospc
	set 0,(hl)
nospc:	ld hl,flags2
	cp "\""
	jr nz, noquot
noquot:	bit 2,(hl)
	jr nz,quoted
	bit 4,(iy+flags-err_nr)
	ld c,tk_rnd
	jr z,t48
	ld c,tk_spectrum
t48:	cp c
	jr nc,token
quoted:	call write_a
	pop hl
	ret

	include "lib/tokens.asm"
	include "lib/strarg.asm"
	include	"lib/puts.asm"

usaget:	defb "Usage: save filename", 0dh, 00h
fd:	equ $
buf:	equ fd + 1
f_name:	equ buf + 1
	include "lib/align512.asm"
