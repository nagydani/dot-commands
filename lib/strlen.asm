; Length of string
; In: HL = pointer to string
; Out: HL = length of string, BC = 65535 - HL, A = 0, CF set, ZF set if zero length
strln:	xor a
	ld b,a
	ld c,a
	cpir
	ld h,a
	ld l,a
	scf
	sbc hl,bc
	ret
