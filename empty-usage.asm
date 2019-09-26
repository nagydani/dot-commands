	org	02000h

start:	ld a,h
	or l
	jr nz,execute

usage:	ld hl,usaget
	call puts
	or a
	ret
