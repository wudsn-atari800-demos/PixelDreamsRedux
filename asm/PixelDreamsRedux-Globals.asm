;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

keymap = $600

covox	= $d280

lyrics_block_buffer = $5000	; 10*10*40 = 4000 bytes
main_sm = $6010	
main_sm_size = 200*40		; 200*40 = 8000 ($1f40) bytes
outro_02_buffer = $3000		; $2000 bytes
outro_02_mask_buffer  = $d800	; $2000 bytes

;+---------------------------------------------------------------------------+
;| Type 64: MegaCart 2 MB cartridge                                          |
;+---------------------------------------------------------------------------+
;
; A bank-switched cartridge that occupies 16 KB of address space between
; $8000 and $BFFF. It is controlled by a byte written to $D500-$D5FF. Bits 0-6
; select one of 128 available banks, bit 7 disables the cartridge.

cart_size = $4000
cart_start = $8000
cart_end = cart_start+cart_size
cart_bank = $d500	;+bank number to activate bank

?cart_bank_number = 0

	.macro m_start_first_bank

	opt h-
	
.def ?cart_bank_number = 0
	opt f-
	org cart_start
	opt f+
	.echo "Starting bank ", ?cart_bank_number," at ",*,"."

	.endm	

	.macro m_pad_current_bank
	.if *<cart_end
		.if *=cart_start
			.echo "Bank ", ?cart_bank_number ," is empty. "
		.else
			.echo "Padding ",(cart_end-*)," bytes at the end of bank ", ?cart_bank_number ," with ", :1, ". "
		.endif
		.rept cart_end-*
		.byte :1
		.endr
		.echo "Bank ",?cart_bank_number," ends at ",*-1,"."
	.else
		.echo "Bank ",?cart_bank_number," ends at ",*-1,". No padding required."
	.endif
	opt f-
	org cart_start
	opt f+
	.endm

	.macro m_align_next_bank
	
	m_pad_current_bank :1

	opt f-
	org cart_start
	opt f+

.def ?cart_bank_number++

	.echo "Starting bank ", ?cart_bank_number," at ",*
	.endm
