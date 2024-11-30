;
;	Test which bank is the start bank of the cartridge.
;
;	@com.wudsn.ide.lng.outputfileextension=.rom

	icl "Kernel-Equates.asm"
	icl "PixelDreamsRedux-Globals.asm"

	m_start_first_bank
	.proc main
loop	lda $d40b
	sta $d01a
	jmp loop
	.endp

	org cartcs
	.byte a($0000),$00,$00,a(main)

	.rept 127
	m_align_next_bank $00
	.byte #
	.endr
	
	m_align_next_bank $00 


