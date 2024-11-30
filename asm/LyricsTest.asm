;
;	Pixel Dreams Redux - Lyrics Test
;

	icl "Kernel-Equates.asm"
	
p1	= $80
p2	= $82

	org $2000

; Main screen is 180/5/10/5

	.proc main
	mwa #dl 560
	mva #0 710
	mva #14 709

	lda #100
	jsr delay

loop	jsr lyrics.init
	ldx #10
	jsr lyrics.start_block
	ldx #6
	jsr lyrics.start_block
	ldx #6
	jsr lyrics.start_block
	ldx #6
	jsr lyrics.start_block
	jmp loop

	.proc lyrics


row_height = 10
row_width = 40
row_max_count = row_height*10
row_size = row_height*row_width

block_buffer = $8000

block_ptr .word $0000
row_count .byte 0

	.proc init
	mwa #blocks block_ptr
	rts
	.endp

	.proc start_block	;IN: <X>=row_count
	stx row_count
	mwa #block_buffer dl.lyrics_dl.sm_ptr

	mwa block_ptr p1	; Copy $1000 bytes from (block_ptr) to block_buffer
 	mwa #block_buffer p2
 	ldx #$10
 	ldy #0
copy_loop
 	mva (p1),y (p2),y
 	iny
 	bne copy_loop
 	inc p1+1
 	inc p2+1
 	dex
 	bne copy_loop
row_loop
	ldx #row_height
line_loop
	lda #1
	jsr delay
	adw dl.lyrics_dl.sm_ptr #row_width
	adw block_ptr #row_width
	dex
	bne line_loop
	lda #100
	jsr delay
	dec row_count
	bne row_loop
	lda #50
	jsr delay
	rts
	.endp

	.endp

	.proc delay
	clc
	adc rtclok+2
loop	cmp rtclok+2
	bne loop
	rts
	.endp


	.local dl
	.byte $70,$70,$30

:180	.byte $00

	.local lyrics_dl
	.byte $4f
sm_ptr	.word lyrics.block_buffer
	.rept lyrics.row_height-1
	.byte $0f
	.endr
	.endl
	.byte $41,a(dl)
	.endl
	
	.local blocks
	ins "../gfx/gr8/lyrics.pic"	;$2710 bytes
	.endl

	.endp

	m_info main

	run main

