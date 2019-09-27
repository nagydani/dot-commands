; Read string argument
; In: HL = pointer to argument, DE = pointer to string buffer
; Out: ZF set if last arg, DE = pointer to next string buffer
strarg:	ld a,(hl)
	or a
	jr z,strarge
	sub 0dh
	jr z,strarge
	sub " "-0dh
	jr z,strargs
	sub ":"-" "
	jr z,strarge
	ldi
	ld a,arg_e / 100h
	cp d
	jr nc,strarg	; guard against buffer overflow
	ret

strarge:ld (de),a
	inc de
	ret

strargs:ld (de),a
	inc de
	ld a,(hl)
	include "lib/nextarg.asm"
