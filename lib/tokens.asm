tokens:	defw t_rnd,t_inkeys,t_pi
	defw t_fn,t_point,t_screens,t_attr,t_at,t_tab,t_vals,t_code
	defw t_val,t_len,t_sin,t_cos,t_tan,t_asn,t_acs,t_atn
	defw t_ln,t_exp,t_int,t_sqr,t_sgn,t_abs,t_peek,t_in
	defw t_usr,t_strs,t_chrs,t_not,t_bin,t_or,t_and,t_le
	defw t_ge,t_ne,t_line,t_then,t_to,t_step,t_deffn,t_cat
	defw t_format,t_move,t_erase,t_open,t_close,t_merge,t_verify,t_beep
	defw t_circle,t_ink,t_paper,t_flash,t_bright,t_inverse,t_over,t_out
	defw t_lprint,t_llist,t_stop,t_read,t_data,t_restore,t_new,t_border
	defw t_continue,t_dim,t_rem,t_for,t_goto,t_gosub,t_input,t_load
	defw t_list,t_let,t_pause,t_next,t_poke,t_print,t_plot,t_run
	defw t_save,t_randomize,t_if,t_cls,t_draw,t_clear,t_return,t_copy

t_rnd:	defb 3,"RND"
t_inkeys:defb 6,"INKEY$"
t_pi:	defb 2,"PI"
t_fn:	defb 2,"FN"
t_point:defb 5,"POINT"
t_screens:defb 7,"SCREEN$"
t_attr:	defb 4,"ATTR"
t_at:	defb 2,"AT"
t_tab:	defb 3,"TAB"
t_vals:	defb 4,"VAL$"
t_code:	defb 4,"CODE"
t_val:	defb 3,"VAL"
t_len:	defb 3,"LEN"
t_sin:	defb 3,"SIN"
t_cos:	defb 3,"COS"
t_tan:	defb 3,"TAN"
t_asn:	defb 3,"ASN"
t_acs:	defb 3,"ACS"
t_atn:	defb 3,"ATN"
t_ln:	defb 2,"LN"
t_exp:	defb 3,"EXP"
t_int:	defb 3,"INT"
t_sqr:	defb 3,"SQR"
t_sgn:	defb 3,"SGN"
t_abs:	defb 3,"ABS"
t_peek:	defb 4,"PEEK"
t_in:	defb 2,"IN"
t_usr:	defb 3,"USR"
t_strs:	defb 4,"STR$"
t_chrs:	defb 4,"CHR$"
t_not:	defb 3,"NOT"
t_bin:	defb 3,"BIN"
t_or:	defb 2,"OR"
t_and:	defb 3,"AND"
t_le:	defb 2,"<="
t_ge:	defb 2,">="
t_ne:	defb 2,"<>"
t_line:	defb 4,"LINE"
t_then:	defb 4,"THEN"
t_to:	defb 2,"TO"
t_step:	defb 4,"STEP"
t_deffn:defb 6,"DEF FN"
t_cat:	defb 3,"CAT"
t_format:defb 6,"FORMAT"
t_move:	defb 4,"MOVE"
t_erase:defb 5,"ERASE"
t_open:	defb 5,"OPEN #"
t_close:defb 6,"CLOSE #"
t_merge:defb 5,"MERGE"
t_verify:defb 6,"VERIFY"
t_beep:	defb 4,"BEEP"
t_circle:defb 6,"CIRCLE"
t_ink:	defb 3,"INK"
t_paper:defb 5,"PAPER"
t_flash:defb 5,"FLASH"
t_bright:defb 6,"BRIGHT"
t_inverse:defb 7,"INVERSE"
t_over:	defb 4,"OVER"
t_out:	defb 3,"OUT"
t_lprint:defb 6,"LPRINT"
t_llist:defb 5,"LLIST"
t_stop:	defb 4,"STOP"
t_read:	defb 4,"READ"
t_data:	defb 4,"DATA"
t_restore:defb 7,"RESTORE"
t_new:	defb 3,"NEW"
t_border:defb 6,"BORDER"
t_continue:defb 8,"CONTINUE"
t_dim:	defb 3,"DIM"
t_rem:	defb 3,"REM"
t_for:	defb 3,"FOR"
t_goto:	defb 5,"GO TO"
t_gosub:defb 6,"GO SUB"
t_input:defb 5,"INPUT"
t_load:	defb 4,"LOAD"
t_list:	defb 4,"LIST"
t_let:	defb 3,"LET"
t_pause:defb 5,"PAUSE"
t_next:	defb 4,"NEXT"
t_poke:	defb 4,"POKE"
t_print:defb 5,"PRINT"
t_plot:	defb 4,"PLOT"
t_run:	defb 3,"RUN"
t_save:	defb 4,"SAVE"
t_randomize:defb 9,"RANDOMIZE"
t_if:	defb 2,"IF"
t_cls:	defb 3,"CLS"
t_draw:	defb 4,"DRAW"
t_clear:defb 5,"CLEAR"
t_return:defb 6,"RETURN"
t_copy:	defb 4,"COPY"

tk_rnd:	equ $a5
tk_inkeys:equ $a6
tk_pi:	equ $a7
tk_fn:	equ $a8
tk_point:equ $a9
tk_screens:equ $aa
tk_attr:equ $ab
tk_at:	equ $ac
tk_tab:	equ $ad
tk_vals:equ $ae
tk_code:equ $af
tk_val:	equ $b0
tk_len:	equ $b1
tk_sin:	equ $b2
tk_cos:	equ $b3
tk_tan:	equ $b4
tk_asn:	equ $b5
tk_acs:	equ $b6
tk_atn:	equ $b7
tk_ln:	equ $b8
tk_exp:	equ $b9
tk_int:	equ $ba
tk_sqr:	equ $bb
tk_sgn:	equ $bc
tk_abs:	equ $bd
tk_peek:equ $be
tk_in:	equ $bf
tk_usr:	equ $c0
tk_strs:equ $c1
tk_chrs:equ $c2
tk_not:	equ $c3
tk_bin:	equ $c4
tk_or:	equ $c5
tk_and:	equ $c6
tk_le:	equ $c7
tk_ge:	equ $c8
tk_ne:	equ $c9
tk_line:equ $ca
tk_then:equ $cb
tk_to:	equ $cc
tk_step:equ $cd
tk_deffn:equ $ce
tk_cat:	equ $cf
tk_format:equ $d0
tk_move:equ $d1
tk_erase:equ $d2
tk_open:equ $d3
tk_close:equ $d4
tk_merge:equ $d5
tk_verify:equ $d6
tk_beep:equ $d7
tk_circle:equ $d8
tk_ink:	equ $d9
tk_paper:equ $da
tk_flash:equ $db
tk_bright:equ $dc
tk_inverse:equ $dd
tk_over:equ $de
tk_out:	equ $df
tk_lprint:equ $e0
tk_llist:equ $e1
tk_stop:equ $e2
tk_read:equ $e3
tk_data:equ $e4
tk_restore:equ $e5
tk_new:	equ $e6
tk_border:equ $e7
tk_continue:equ $e8
tk_dim:	equ $e9
tk_rem:	equ $ea
tk_for:	equ $eb
tk_goto:equ $ec
tk_gosub:equ $ed
tk_input:equ $ee
tk_load:equ $ef
tk_list:equ $f0
tk_let:	equ $f1
tk_pause:equ $f2
tk_next:equ $f3
tk_poke:equ $f4
tk_print:equ $f5
tk_plot:equ $f6
tk_run:	equ $f7
tk_save:equ $f8
tk_randomize:equ $f9
tk_if:	equ $fa
tk_cls:	equ $fb
tk_draw:equ $fc
tk_clear:equ $fd
tk_return:equ $fe
tk_copy:equ $ff
