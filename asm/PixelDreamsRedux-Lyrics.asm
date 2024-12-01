;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc lyrics

sm_ptr	= pictures.main_dl.lyrics_dl.sm_ptr

row_height = 10
row_width = 40
row_max_count = row_height*10
row_size = row_height*row_width

block_buffer = lyrics_block_buffer
block_size = row_max_count*row_width

block_ptr .word $0000
row_count .byte 0

	.proc init
	mwa #lyrics_blocks block_ptr
	rts
	.endp

	.proc start_block	;IN: <A>=lyrics_row_count
	sta row_count
 	mwa #block_buffer sm_ptr

	lda #25
	jsr wait

 	jsr copy_block
 
row_loop
	ldx #row_height
line_loop
	ldy #1
	jsr wait_vcount
	adw sm_ptr #row_width
	adw block_ptr #row_width
	dex
	bne line_loop
	ldy #111
	jsr wait_vcount

	dec row_count
	bne row_loop
	lda #240
	jsr wait
	lda #50
	jsr wait
	rts

	.proc copy_block	; Copy $1000 bytes from (block_ptr) to block_buffer
	mwa block_ptr p1
 	mwa #block_buffer p2
 	lda #lyrics_start_bank_number
 	ldx #>block_size
 	ldy #<block_size
 	jmp data_stream.get_block
 	.endp
 
 
	.proc wait_vcount	; IN: <y>=number of frames
loop

top
	lda vcount
	cmp #$69
	bne top

	lda #$00
	sta colbk
	sta colpf2
	sta prior
	mva #15 colpf1

bottom	lda vcount
	cmp #$70
	bne bottom

	sta wsync
	mva color1 colpf1
	mva color2 colpf2
       	mva gprior prior
	mva color4 colbk

	dey
	bne loop
	rts
	.endp

	.endp

	.endp

