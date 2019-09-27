; RST 8 errors and hook codes

bad_fd_err:	equ 0dh


fopen:		equ 9ah
fopen_r:	equ 01h
fopen_w:	equ 0ch

fclose:		equ 9bh

fread:		equ 9dh

fwrite:		equ 9eh
