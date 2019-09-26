; Check whether null-termianted path string ends with /
; In: HL = pointer to path string
; Out: HL = pointer to terminator, ZF set if it does, A = "/", BC = $80 - length
chkdir:	ld bc,00080h
	xor a
	cpir
	dec hl
	dec hl
	ld a,(hl)
	cp "/"
	inc hl
	ret
