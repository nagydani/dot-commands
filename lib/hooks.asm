; RST 8 errors and hook codes

bad_fd_err:	equ 0dh


fopen:		equ 9ah
fopen_r:	equ 01h
fopen_we:	equ 06h
fopen_w:	equ 0ch

fclose:		equ 9bh

fread:		equ 9dh

fwrite:		equ 9eh

fseek:		equ 9fh

funlink:	equ 0adh

frename:	equ 0b0h
