; Read options
; In: HL = pointer to current argument
; Out: CF set if more arguments, HL = pointer to next argument to process, ZF set if options done
options:ld a,(hl)
	cp "-"
	scf
	ret nz
nextop:	ld de,optab
	inc hl
	ld c,(hl)
	ex de,hl
	call indexer
	jr nc,endopt
	ld c,(hl)
	ld b,0
	add hl,bc
	call jphl
	ex de,hl
	jr nextop

endopt:	ex de,hl
	inc hl
	ld a,c
	cp " "
	scf
	ret z
	cp ":"
	ret z
	cp 00dh
	ret z
	push af
	ld hl,illopt
	call puts
	pop af
	rst 10h
	ld a,0dh
	rst 10h
	pop bc
	ld a,22		; No such COMMAND
	scf
	ret

jphl:	jp (hl)

illopt:	defm "Illegal option: "
	defb 0
