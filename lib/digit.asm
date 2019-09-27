; Converts ASCII digit to number
; In: A = decimal digit
; Out: CF set on error, A = digit
digit:	sub "0"
	ret c
	cp 0ah
	ccf
	ret
