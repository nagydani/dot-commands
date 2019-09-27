; Next argument
; In: HL = pointer to space, A = " "
; Out: CF clear, ZF set if last argument, HL = pointer to next
nxarg:	inc hl
	cp (hl)
	jr z,nxarg
	ld a,(hl)
	cp ":"
	ret z
	cp 0dh
	ret z
	or a
	ret
