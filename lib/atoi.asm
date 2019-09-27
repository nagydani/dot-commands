; ASCII decimal to 16-bit integer
; In: HL = pointer to ascii number
; Out: CF set on overflow, DE = number, HL = pointer to separator
; Pollutes: AF, BC
atoi:	ld de,0
atoil:	ld a,(hl)
	call digit
	ccf
	ret nc
	ex de,hl
	ld c,l
	ld b,h
	add hl,hl
	ret c
	add hl,hl
	ret c
	add hl,bc
	ret c
	add hl,hl
	ret c
	ld b,0
	ld c,a
	add hl,bc
	ret c
	ex de,hl
	inc hl
	jr atoil

	include	"lib/digit.asm"
