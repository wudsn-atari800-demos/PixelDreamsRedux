;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc sync
loop	lda vcount
	beq loop
	rts
	.endp

	.proc wait		; IN: <A>=number of frames
	clc
	adc rtclok+2
	sta value 
loop
;	lda vcount
;	sta colbk
	lda rtclok+2
value = *+1
	cmp #$ff
	bne loop
	rts
	.endp

	.proc fade_out		; IN: Fade out colors registers
	ldy #16	
fade_loop
	ldx #8
color_loop
	lda pcolor0,x
	and #$0f
	bne not_black
	sta pcolor0,x
	beq next_color
not_black
	dec pcolor0,x
next_color
	dex
	bpl color_loop
	lda #3
	jsr wait
	dey
	bne fade_loop
	rts
	.endp

	.proc graphics8
	
	.proc clear
	mwa #sm p1
	ldx #>main_sm_size
	lda #0
	tay
loop	sta (p1),y
	iny
	bne loop
	inc p1+1
	dex
	bne loop
loop2	cpy #<main_sm_size
	sta (p1),y
	iny
	bne loop2
	rts
	.endp

	.proc get_block		; IN: <A>=start_bank_number, p1=start_address
	mwx #sm p2
	ldx #>main_sm_size
	ldy #<main_sm_size
	jsr data_stream.get_block
	rts
	.endp

	.proc fade_in
	ldx #0
loop	stx color1
	lda #3
	jsr wait
	inx
	cpx #16
	bne loop
	rts
	.endp

	.proc toggle_dli_flag	; IN: <X>=offset in dl
	lda graphics8.dl,x
	eor #$80
	sta graphics8.dl,x
	rts
	.endp


	.local dl
dc = $0f
	.byte $70,$70,$30
	.byte $40+dc,a(sm)
:101	.byte dc
	.byte $40+dc,a(sm2)
:97	.byte dc
	.byte $41,a(dl)
	.endl				; End of dl
	m_assert_same_1k dl

	.endp				; End of graphics8

;----------------------------------------------------------------------

	.proc data_stream
	
	.proc get_block		; IN: <A>=bank, <X>=>size, <Y>=<size, <p1>=from, <p2>=to
	sei
	sta main_bank
	sta cart_bank
	cli
	.endp			; Fall-trough
	
	.proc get_next_block	; IN: <X>=>size, <Y>=<size, <p1>=from, <p2>=to
	sty bytes

	cpx #0
	beq no_page

	ldy #0
page_loop
	mva (p1),y (p2),y
	iny
	mva (p1),y (p2),y
	iny
	bne page_loop
	inc p1+1
	inc p2+1

	lda p2+1
	cmp #>cart_end
	bne same_bank
	inc main_bank
	lda main_bank
	sta cart_bank
same_bank
	dex
	bne page_loop

no_page
bytes = *+1
	ldy #$00
	beq no_bytes
	dey
byte_loop
	mva (p1),y (p2),y
	dey
	cpy #$ff
	bne byte_loop

no_bytes
	rts
	.endp

	.endp
	