; Print null-terminated string
; In: HL = pointer to string
; Out: HL = end of string, A = 0, ZF=1, CF=0

puts:	ld a,(hl)
	and a
	ret z
	rst 10h
	inc hl
	jr puts

