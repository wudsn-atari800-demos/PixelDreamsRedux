;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc intro
	.use intro_blocks

	.var picture_number .byte

;----------------------------------------------------------------------

	.proc init

	mwa #graphics8.dl sdlstl
	mva #$00 gprior
	sta color1
	sta color2
	sta color4

	mva #0 picture_number
	rts
	.endp				; End of init

;----------------------------------------------------------------------

	.proc next
	ldx picture_number
	mva data.lo,x p1
	mva data.hi,x p1+1
	lda data.bank_numbers,x
	jsr graphics8.get_block

	jsr graphics8.fade_in
	jsr fade_out

	inc picture_number
	rts

	.local data
	.local lo
	.byte <intro_01,<intro_02,<intro_03,<intro_04
	.endl
	
	.local hi
	.byte >intro_01,>intro_02,>intro_03,>intro_04
	.endl
	
	.local bank_numbers
	.byte intro_start_bank_number,intro_start_bank_number,intro_start_bank_number+1,intro_start_bank_number+1
	.endl
	.endl

	.endp				; End of next

	.endp				; End of intro
