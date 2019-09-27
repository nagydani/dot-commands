; ASCII decimal to 8-bit integer
; In: HL = pointer to ascii number
; Out: CF set on overflow, E = number, HL = pointer to separator
; Pollutes: AF, D
atoi:	ld e,0
atoil:	ld a,(hl)
	call digit
	ccf
	ret nc
	ld d,a
	ld a,e
	add a,a
	ret c
	add a,a
	ret c
	add a,e
	ret c
	add a,a
	ret c
	add a,d
	ret c
	ld e,a
	inc hl
	jr atoil

	include "lib/digit.asm"
