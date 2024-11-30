;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc selector
	cld
	cli
	mva #$e0 chbas
	mwa #dl sdlstl
	mva #$22 sdmctl
	mva #$76 color0
	mva #$34 color1
	mva #$58 color2
	mva #$ff color3
;	lda #150
;	jsr wait
	rts
	
	.local dl

	.byte $70,$70,$70
:7	.byte $70
	.byte $46,a(sm),$70,$06,$70,$06
	.byte $41,a(dl)
	.endl
	
	.local sm
;	.byte "01234567890123456789"
	.byte "PRESS OPTION: covox "
	.byte "PRESS SELECT: $d280 "
	.byte "PRESS START TO BEGIN"

	.endl

	.endp
