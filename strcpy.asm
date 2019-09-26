; Copy null-terminated string
; In: HL = source pointer, DE = target pointer
; Out: HL = after source, DE = after target, ZF set, CF reset , A = 0

strcpy:	ld a,(hl)
	ld (de),a
	inc hl
	inc de
	and a
	ret z
	jr strcpy

