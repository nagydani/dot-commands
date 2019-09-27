; close esxDOS file stream

	include	"lib/sysvars.asm"
	include	"lib/hooks.asm"
	include "lib/zxrom.asm"
	include	"lib/empty-usage.asm"

execute:ld a,(hl)
	cp "#"
	jr nz,nohash
	inc hl
nohash:	call numarg
	jr c,usage
	jr nz,usage
	ld a,e
	push af
	rst 18h
	defw str_data0
	pop af
	push hl
	rst 18h
	defw chan_open
	ld ix,(curchl)
	ld a,(ix+4)
	cp "F"
	ld a,bad_fd_err
	scf
	ret nz
doclose:ld a,(ix+5)
	rst 8
	defb fclose
; seems to always return with CF set
;	pop hl
;	ret c
;	push hl
	ld c,(ix+09h)
	ld b,(ix+0ah)
	push ix
	pop de
	ld hl,(chans)
	and a
	sbc hl,de
	ex de,hl
	ld hl,strms
	ld a,19
closel:	ex af,af'
	push hl
	ld a,(hl)
	inc l
	ld h,(hl)
	ld l,a
	add hl,de
	jr nc,closelo
	and a
	sbc hl,bc
	ex (sp),hl
	dec sp
	pop af
	ld (hl),a
	inc l
	dec sp
	pop af
	ld (hl),a
	dec hl
	defb 3eh	; ld a, skip one byte
closelo:pop hl
	inc l
	inc l
	ex af,af'
	dec a
	jr nz,closel
	push ix
	pop hl
	rst 18h
	defw reclaim2
	pop hl
	rst 18h
	defw close0
	and a
	ret

	include	"lib/numarg.asm"
	include "lib/nextarg.asm"
	include	"lib/atob.asm"
	include	"lib/puts.asm"

usaget:	defb "Usage: close [#]stream", 0dh, 00h
f_name:	include "lib/align512.asm"
