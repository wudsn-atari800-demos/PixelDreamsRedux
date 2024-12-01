;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc sound

;----------------------------------------------------------------------

	.proc init
	sei
	ldx #[.len irq]-1
copy_irq
	mva irq_ram,x irq,x
	dex
	bpl copy_irq
	mwa sound_chip_base irq.sound_chip_base
	mva #sound_start_bank_number irq.bank_number
	mwa #sound_block_start irq.sound_ptr
	
	mva #$40 audctl		; Enable 1.77 MhZ mode for channel 1
	mva #107 audf1
	sta stimer		; Start timers
	mva #$01 irqen		; Enable 1st POKEY timer
	cli
	rts
	.endp

;----------------------------------------------------------------------

irq_ram
	.proc irq,irq_zp
	pha
bank_number = *+1
	mva #$ff cart_bank
sound_ptr = *+1
	lda $ffff
sound_chip_base = *+1
	sta $ffff
;	.if ACTIVE_SOUND_MODE=sound_mode.covox
;	sta covox
;	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
;	sta audc1
;	.else
;	.error "Undefined sound mode."
;	.endif

	inc sound_ptr
	beq next_page
return
	mva main_bank cart_bank
	mva #$00 irqen
	mva #$01 irqen

	pla
	rti

next_page
	inc sound_ptr+1
	lda sound_ptr+1
	cmp #>sound_block_end
	bne return
	mva #>sound_block_start sound_ptr+1
	inc bank_number
	bpl return
	mva #$00 irqen		; End of song
	pla
	rti

	.endp			; End of irq

	m_info irq

	.endp


