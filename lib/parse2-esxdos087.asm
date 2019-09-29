; parse source and target from esxDOS v0.8.7

parsefn:ld de,f_name
parsel:	ld a,(hl)
	and a
	jr z,parsee
	cp ":"
	jr z,parsee
	cp 00dh
	jr z,parsee
	cp " "
	jr z,parse2
	ldi
	jr parsel

parsee:	xor a
	ld (de),a
	ret

parse2:	xor a
	ld (de),a
	inc hl
	inc de
	ld (f_name2),de
	jr parsel
