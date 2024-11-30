;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc pictures
	.use pictures_blocks

	.var picture_number .byte

;----------------------------------------------------------------------

	.proc init
	
	mwa #main_dl sdlstl
	mva #$80 gprior
	mva #0 picture_number

	jsr off
	rts

;----------------------------------------------------------------------

	.proc off
	lda #0
	sta pcolor0
	sta pcolor1
	sta pcolor2
	sta pcolor3
	sta color0
	sta color1
	sta color2
	sta color3
	sta color4
	rts
	.endp
	
	.endp

;----------------------------------------------------------------------
	
	.proc next
	ldx picture_number
	mva data.lo,x p1
	mva data.hi,x p1+1
	mwa #main_sm p2
	lda data.bank_numbers,x
	ldx #>[.len main_01]
	ldy #<[.len main_01]
	jsr data_stream.get_block
	
	lda picture_number

        asl
        asl
        asl
        tax
        mva data.palette+0,x pcolor1
        mva data.palette+1,x pcolor2
        mva data.palette+2,x pcolor3
        mva data.palette+3,x color0
        mva data.palette+4,x color1
        mva data.palette+5,x color2
        mva data.palette+6,x color3
        mva data.palette+7,x color4
        
	inc picture_number
	lda picture_number
	cmp #.len data.hi
	bne not_last
	mva #0 picture_number 
not_last
	rts
	

	.local data

	.local lo
	.byte <main_01,<main_02,<main_03,<main_04
	.endl
	
	.local hi
	.byte >main_01,>main_02,>main_03,>main_04
	.endl
	
	.local bank_numbers
	.byte pictures_start_bank_number,pictures_start_bank_number,pictures_start_bank_number+1,pictures_start_bank_number+1
	.endl
	
	.local palette
	
        .byte $62,$44,$74,$36,$38,$2a,$ec,$86
        .byte $50,$52,$44,$46,$55,$48,$68,$64
        .byte $44,$48,$46,$90,$52,$66,$58,$5a
        .byte $46,$44,$04,$02,$86,$48,$7e,$8a
	
	.endl				; End of palette

	.endl 				; End of data

	.endp				; End of next

;----------------------------------------------------------------------

	.align $400
	.local main_dl
	
	dc = $0f

	.byte $70,$70,$30

	.byte $40+dc,a(sm)		; 180 lines
:101	.byte dc
	.byte $40+dc,a(sm2)
:76	.byte dc
	.byte dc

	.byte $00,$00,$00,$00,$00	; 5 lines

	.local lyrics_dl		; 10 lines
	.byte $4f
sm_ptr	.word lyrics.block_buffer
	.rept lyrics.row_height-1
	.byte $0f
	.endr
	.endl				; End of lyrics_dl

	.byte $41,a(main_dl)
	.endl				; End of main_dl

	m_assert_same_1k main_dl
	.endp 				; End of pictures