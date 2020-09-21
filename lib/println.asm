linepr:	set 2,(iy+30h)	; inside quotes
	rst 10h
; Print a line without terminating CR or LF
; In: DE = line pointer, BC = maximum length
; Out: CF set if terminated, A = terminator, BC = remaining length, DE = points AFTER terminator
println:ld a,b
	or c
	ret z
	dec bc
	ld a,(de)
	inc de
	cp 0dh		; cr
	jr z,prlncr
	cp 0ah		; lf
	jr nz,linepr
prlncr:	scf
	ret
