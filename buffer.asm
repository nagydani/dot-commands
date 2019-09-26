; Allocate a buffer of at most 32 kilobytes
buf32k:	ld hl,08000h

; Allocate a buffer of at least 4 kilobytes
; In: HL = maximum buffer size (must be power of 2, not less than 1000h)
; Out: CF set if available, HL = pointer to buffer, DE = buffer size
; Pollutes: AF
buf:	call chkmem
	jr c,bufok
	srl h
	ld a,h
	cp 010h
	ret z
	jr buf

bufok:	ld (buflen),hl
	ex de,hl
	ld (bufptr),hl
	ret

; Check available memory between (STKEND) and SP
; In: HL = required memory
; Out: C set if available, DE = (STKEND)
chkmem:	push hl
	ld de,(stkend)
	add hl,de
	inc h
	sbc hl,sp
	pop hl
	ret
