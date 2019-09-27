; Read decimal argument
; In: HL = pointer to argument
; Out: CF set on error, ZF set if last arg, DE = numeric argument
decarg:	call digit
	ret c
	call atoi
	ret c
	ld a,(hl)
	cp " "
	jr z,nxarg
	cp ":"
	ret z
	cp 0dh
	ret z
	or a
	ret z
	scf
	ret

nxarg:	inc hl
	cp (hl)
	jr z,nxarg
	or a
	ret
