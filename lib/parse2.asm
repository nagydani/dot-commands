; parse source and target

parsefn:ld de,f_name
parsel:	ld a,(hl)
	or a
	jr z,parsee
	cp ":"
	jr z,parsee
	cp 00dh
	jr z,parsee
	cp " "
	jr z,parse2
	ldi
	ld a,d
	cp arg_e / 100h
	jr c,parsel		; guard against buffer overflow
	jr usage

parse2:	xor a
	ld (de),a
	ld a,(f_name2 + 1)
	or a
	jr nz,usage		; guard against more than two arguments
	inc hl
	inc de
	ld (f_name2),de
	jr parsel

parsee:	xor a
	ld (de),a
