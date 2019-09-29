; Find file name at the end of null-terminated path string
; In: HL = pointer to path
; Out: HL = pointer to file name, A = 0 if no path, "/" otherwise
basename:
	ld bc,00080h
bname:	xor a
	cpir
	dec hl
bnamel:	dec hl
	ld a,(hl)
	and a
	jr z,bnamee
	cp "/"
	jr nz,bnamel
bnamee:	inc hl
	ret
