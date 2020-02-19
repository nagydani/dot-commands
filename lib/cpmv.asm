; Common part of cp and mv commands for esxDOS

	ld hl,(f_name2)
	ld a,l
	or h
	jr z,usage		; missing target

	ld hl,f_name
	ld a,(hl)
	and a
	jr z,usage		; missing source

	ld hl,(f_name2)		; if target is
	call chkdir		; not a directory
	jr nz,do		; then jump forward
	push hl			; otherwise save terminator
	ld hl,f_name		; take the source
	call basename		; file base name
	pop de			; restore terminator in DE
	call strcpy		; append to target path
