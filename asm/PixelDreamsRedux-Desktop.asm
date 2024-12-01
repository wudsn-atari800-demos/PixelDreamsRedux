;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc desktop

rom_chr	= $e000
emu_chr	= desktop_base
emu_sm	= desktop_base+$400
emu_pm	= desktop_base+$800
emu_height = 23
emu_width = 40
emu_sm_covox = emu_sm+emu_width*13+36

	jsr init
	jmp quick

	mwa #dl1 sdlstl
	mva #$22 sdmctl
	mva #2 chact
	jsr fade_in

	lda #25
	jsr wait
	mva #0 color1
	lda #50
	jsr wait
	mva #14 color1
	
	mwa #dl2 sdlstl
	mva #$36 color0
	mva #$0a color3
	lda #50
	jsr wait
	mva #0 color1

	jsr print_emu_sm
	jsr handle_input

	mva #0 sdmctl
	lda #25
	jsr wait

quick
	jsr tos.init
	jsr tos.test
	.byte 2
	
	.proc tos
	
	.proc init
	jsr graphics8.clear
	mwa #graphics8.dl sdlstl
	
	mwa #desktop_blocks.desktop_01 p1
	lda #desktop_start_bank_number
	jsr graphics8.get_block

	lda #$03
	sta sizep0
	sta sizep1
	sta sizep2
	sta sizep3

	mva #>emu_pm pmbase
	mva #3 gractl
	mva #1 gprior

	mva #$0f color1
	mva #$00 color2
	mva #$00 pcolor0
	sta pcolor1
	sta pcolor2
	sta pcolor3

	.macro m_copy
	ldx #.len :1-1
fill	mva :1,x emu_pm+$400+$100*:2+:3,x
	dex
	bpl fill
	.endm

	m_copy disk_pm $0 43
	m_copy disk_pm $1 43
	m_copy harddisk_pm $2 43

	m_copy trash_pm $0 180
	m_copy printer_pm $3 182

	clc
	lda #$32
	sta hposp0
	adc #$28
	sta hposp1
	adc #$28
	sta hposp2
	adc #$28
	sta hposp3

	lda #6
	ldx #>vbi
	ldy #<vbi
	jsr setvbv

	ldx #14
	jsr toggle_dli_flag
	mva #$3e sdmctl
	rts
	.endp

	.proc toggle_dli_flag	; IN: <X>=offset in dl
	lda graphics8.dl,x
	ora #$80
	sta graphics8.dl,x
	rts
	.endp

	.proc vbi
	mwa #dli vdslst
	mva #$c0 nmien
	jmp sysvbv
	.endp

	.proc dli
	pha
	sta wsync
	mva #$b0 colpf2
	pla
	rti
	.endp

	.proc test

	mwa #desktop_blocks.desktop_01 p1
	lda #desktop_start_bank_number
	jsr graphics8.get_block

	mwa #desktop_blocks.desktop_02 p1
	lda #desktop_start_bank_number
	jsr graphics8.get_block

	jmp test
	
	lda #0
	sta sdmctl
	sta color1
	sta color2
	sta color4
	lda #25
	jsr wait
	rts
	.endp

	.local disk_pm
:27	.byte $3c
:9	.byte $ff
	.endl

	.local harddisk_pm
:6	.byte $00
:21	.byte $3c
:9	.byte $ff
	.endl

	.local trash_pm
:2	.byte $18
:29	.byte $3c
:9	.byte $ff
	.endl

	.local printer_pm
:29	.byte $3c
:9	.byte $ff
	.endl
	
	.endp 		; End of TOS

	.proc init
	ldx #0
copy_chr
:4	mva rom_chr+#*$100,x emu_chr+#*$100,x
	inx
	bne copy_chr
	mva #>emu_chr chbas

	ldx #15
copy_chr_special
	mva chr_special,x emu_chr+$200,x
	dex
	bpl copy_chr_special
	
	lda #$00
	tax
clear_pm
;	lda random
	sta emu_pm+$300,x
	sta emu_pm+$400,x
	sta emu_pm+$500,x
	sta emu_pm+$600,x
	sta emu_pm+$700,x
	inx
	bne clear_pm
	rts
	.endp

	.proc fade_in
	ldx #0
fade_in
	stx color1
	stx color2
	stx color4
	lda #5
	jsr wait
	inx
	cpx #15
	bne fade_in
	rts
	.endp

	.proc print_emu_sm
	mwa #sm2 p1
	mwa #emu_sm p2
	ldx #0
yloop	ldy #emu_width-1
xloop	lda (p1),y
	cpx #5
	bcs no_mapping

	cmp #"*"
	sne
	lda #$40
	cmp #"#"
	sne
	lda #$c1

no_mapping
	sta (p2),y
	dey
	bpl xloop
	adw p1 #emu_width
	adw p2 #emu_width
	lda #1
	jsr wait
	inx
	cpx #emu_height
	bne yloop
	rts
	.endp
	
	.proc handle_input
	.var covox_index=1 .byte 

	jsr print_covox_address

	mva #250 x1
loop	lda x1
	beq return
	lda consol
	lsr
	bcc return	;START
	lsr
	bcs no_select

	jsr next_covox_address

	mva #200 x1
still_select
	lda consol
	and #2
	beq still_select

no_select

shift_down
	lda skctl
	and #8
	beq shift_down
	lda #1
	jsr wait
	
	dec x1
	jmp loop
return
	rts
	
	.proc print_covox_address
	mwa #emu_sm_covox p1
	ldy #0

	lda covox_index
	asl
	tax
	lda covox_addresses,x
	pha
	lda covox_addresses+1,x
	jsr print_byte
	pla
	jsr print_byte
	rts
	.endp
	
	.proc invert_covox_address
	ldx #3
loop	lda emu_sm_covox,x
	eor #$80
	sta emu_sm_covox,x
	dex
	bpl loop
	rts
	.endp

	.proc next_covox_address
	lda covox_index
	clc
	adc #1
	cmp #[.len covox_addresses]/2
	sne
	lda #0
	sta covox_index
	jsr print_covox_address
	jsr invert_covox_address
	jsr click
	lda #3
	jsr wait
	jsr invert_covox_address
	rts
	.endp
	
	.endp		; End of handle_input

	.proc click
	ldy #$0c
	lda #$08
le4cf	ldx #$04
	pha                                                                                                                     
le4d2	lda vcount
le4d5	cmp vcount
	beq le4d5
	dex
	bne le4d2
	pla
	eor #$08
	sta consol
	bne le4cf
	dey
	bne le4cf
	rts
	.endp
	
	.proc print_byte
	pha
	lsr
	lsr
	lsr
	lsr
	tax
	lda hex_digits,x
	sta (p1),y
	iny
	pla
	and #15
	tax
	lda hex_digits,x
	sta (p1),y
	iny
	rts

	.local hex_digits
	.byte "0123456789ABCDEF"
	.endl

	.endp

	m_align $400	;$TODO

	.local dl1	
	.byte $70,$70,$30
	.byte $42,a(sm1)
	.byte $41,a(dl1)
	.endl

	m_assert_same_1k dl1

	.local sm1
	.sb "EmuTOS Version 1.3 Redux                "
	.endl

	.local dl2	
	.byte $70,$70,$30
	.byte $70
	.byte $44,a(emu_sm),$04,$04,$04,$04
:18	.byte $02
	
	.byte $41,a(dl2)
	.endl

	m_assert_same_1k dl2

	.local sm2
	.sb "   *********** ##########  ###   ####   "	
	.sb "   *                  #   #   # #       "
	.sb "   ****   * *  *   *  #   #   #  ###    "
	.sb "   *     * * * *   *  #   #   #     #   "
	.sb "   ***** * * *  ***   #    ###  ####    "
	.sb "                                        "
	.sb "----------------------------------------"
	.sb "                                        "
	.sb "EmuTOS Version:     1.3 Redux           "
	.sb "CPU type:           MOS 6502C           "
	.sb "Machine:            Atari XL/XE         "         
	.sb "Base-RAM:           64 kB               "
	.sb "AtariDOS Drives:    D1                  "
	.sb "Sound Chip:         COVOX 8 bit at $D280"
	.sb "Boot Time:          2024/12/07 00:00:00 "
	.sb "----------------------------------------"
	.sb "                                        "
	.sb "Hold <START> to skip AUTO/ACC           "
	.sb "Hold <SELECT> to select COVOX address   "
	.sb "Press key 'D' to boot from D1:          "
	.sb "Press key <Esc> to run an early console "
	.sb "                                        "	
	.sb +$80 "   Hold <Shift> to pause this screen    "
	.endl
	
	.local chr_special
:8	.byte $55
:8	.byte $ff
	.endl

	.local covox_addresses
	.word $d100,$d280,$d500,$d600,$d700
	.endl

	.endp
