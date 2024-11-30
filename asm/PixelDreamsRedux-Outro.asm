;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc outro
	.use outro_blocks

;----------------------------------------------------------------------

	.proc init

	mwa #outro_01 p1
	lda #outro_start_bank_number
	jsr graphics8.get_block

	mwa #outro_02 p1
	mwa #outro_02_buffer p2
	ldx #>[.len outro_02]
	ldy #<[.len outro_02]
	jsr data_stream.get_next_block

	mwa #outro_02_mask p1
	mwa #outro_02_mask_buffer p2
	lda #outro_start_bank_number+1
	ldx #>[.len outro_02_mask]
	ldy #<[.len outro_02_mask]
	jsr data_stream.get_block

	mwa #graphics8.dl sdlstl
	mva #$00 gprior
	rts
	.endp				; End of init

;----------------------------------------------------------------------

	.proc transition
	
	lda #$55
	ldx #$ff
	jsr phase

	lda #$55
	ldx #$aa
	jsr phase

	lda #$00
	ldx #$aa
	jsr phase

	lda #$00
	ldx #$00
	jsr phase
	rts
	
	.proc phase			; IN: <A>=pattern1, <X>=pattern2
	width = 40
	yoffset = 30
	height = 124
	offset = width*yoffset

	sta x1
	stx x2

	mwa #sm+offset p1
	mwa #outro_02_buffer+offset p2
	mwa #outro_02_mask_buffer+offset p3
	ldx #height
line_loop
	ldy #width-1
column_loop
	lda (p3),y
	and x1
	and (p1),y
	ora (p2),y
	sta (p1),y
	dey
	bpl column_loop
	lda x1
	pha
	mva x2 x1
	pla
	sta x2
	adw p1 #width
	adw p2 #width
	adw p3 #width
	txa
	and #1
	seq
	jsr wait
	dex
	bne line_loop
	rts
	.endp				; End of phase

	.endp				; End of transition

	.endp				; End of outro
