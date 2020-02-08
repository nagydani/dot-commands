; Print null-terminated string with maximum length
; In: HL = pointer to string, BC = maximum length
; Out: HL = end of string, A = 0 if reached 0, 1 otherwise, ZF set if A=0, CF=0

puts:	ld bc,0000h
lputs:	ld a,(hl)
	and a
	ret z
	rst 10h
	inc hl
	dec bc
	ld a,b
	or c
	jr nz,lputs
	inc a
	ret
