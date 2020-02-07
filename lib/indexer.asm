indexer_1:
	inc	hl

; Finds a byte associated with another byte (see L16DC in ROM1)
; In: C = code to look for, HL = base address of the table
; Out: HL = address of the associated byte (if found), CF set if code found
; Pollutes: AF
indexer:ld	a,(hl)
	or	a
	ret	z
	cp	c
	inc	hl
	jr	nz,indexer_1
	scf
	ret

