; Read decimal argument
; In: HL = pointer to argument
; Out: CF set on error, ZF set if last arg, DE = numeric argument
numarg:	ld a,(hl)
	call digit
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
