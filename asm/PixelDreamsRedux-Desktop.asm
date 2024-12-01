;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc desktop

rom_chr	= $e000
emu_chr	= desktop_base
emu_sm	= desktop_base+$400
emu_pm	= desktop_base+$800
emu_height = 23
emu_width = 40
emu_sm_sound_chip = emu_sm+emu_width*13+36

	jsr init
;	jmp quick

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
	
	.proc tos
	
	.var pm_visible = 0 .byte

	.proc init
	jsr graphics8.clear
	mwa #graphics8.dl sdlstl

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
	eor #$80
	sta graphics8.dl,x
	rts
	.endp

	.proc vbi
	jsr set_pm_position
	mwa #dli.top vdslst
	mva #$c0 nmien
	jmp sysvbv
	.endp

	.proc dli
	
	.proc top
	pha
	sta wsync
	mva #$b0 colpf2
	mwa #middle vdslst
	pla
	rti
	.endp

	.proc middle
	pha
	sta wsync
	mva pcolor0 colpf2
	mva #$b0 colpm0
	sta colpm1
	lda #$30
	sta hposp0
	lda #$c8
	sta hposp1
	mwa #bottom vdslst
	pla
	rti
	.endp

	.proc bottom
	pha
	sta wsync
	mva #$b0 colpf2
	mva pcolor0 colpm0
	mva pcolor1 colpm1
	jsr set_pm_position
	pla
	rti
	.endp
	.endp

	.proc set_pm_position
	lda pm_visible
	beq not_visible
	clc
	lda #$32
	sta hposp0
	adc #$28
	sta hposp1
	adc #$28
	sta hposp2
	adc #$28
	sta hposp3
	rts
not_visible
	sta hposp0
	sta hposp1
	sta hposp2
	sta hposp3

	rts
	.endp

	.proc test
	mva #1 pm_visible

	.use desktop_blocks

	.macro m_copy_desktop
	mwa #:1 p1
	mwa #sm+40*:3 p2
	lda #:2
	ldx #>.len :1
	ldy #<.len :1
	jsr data_stream.get_block

	.endm

	top = 0
	middle = 58

	m_copy_desktop desktop_01 desktop_start_bank_number top
	jsr wait_50
	m_copy_desktop desktop_02 desktop_start_bank_number top
	jsr click_and_wait_io
	m_copy_desktop desktop_01 desktop_start_bank_number top

	ldx #middle+4
	jsr toggle_dli_flag
	ldx #middle+4+93
	jsr toggle_dli_flag
	ldx #90
	lda #$c0
fill_pm	sta emu_pm+$41c+middle,x
	sta emu_pm+$51c+middle,x
	dex
	bpl fill_pm


	m_copy_desktop desktop_03 desktop_start_bank_number+1 middle
	jsr wait_50
	m_copy_desktop desktop_04 desktop_start_bank_number+1 middle
	jsr click_and_wait_io
	m_copy_desktop desktop_05 desktop_start_bank_number+1 middle
	jsr wait_50
	m_copy_desktop desktop_06 desktop_start_bank_number+1 middle
	jsr click_and_wait_io
	

	m_copy_desktop desktop_07 desktop_start_bank_number+2 middle
	jsr wait_50
	m_copy_desktop desktop_08 desktop_start_bank_number+2 middle
	jsr click_and_wait_io
	m_copy_desktop desktop_09 desktop_start_bank_number+2 middle
	jsr wait_50
	m_copy_desktop desktop_10 desktop_start_bank_number+2 middle
	jsr click_and_wait_io

;	Disable middle/bottom DLI and PMs
	ldx #middle+4
	jsr toggle_dli_flag
	ldx #middle+4+93
	jsr toggle_dli_flag
	mva #0 pm_visible

	m_copy_desktop desktop_11 desktop_start_bank_number+3 top
	ldx #60
	jsr wait_io
	lda #0
	sta sdmctl
	sta color4
	lda #1
	jsr wait

	rts
	
	.proc wait_50
	lda #50
	jsr wait
	rts
	.endp

	.proc click_and_wait_io
	jsr click
	ldx #25
	jmp wait_io
	.endp

	.proc wait_io	; IN: <X>=number of 10-frame blocks
loop	lda #0
	sta consol
	lda random
	and #3
	ora #1
	jsr wait
	dex
	bne loop
	rts
	.endp

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
	.var sound_chip_index .byte 

	.if ACTIVE_SOUND_MODE=sound_mode.covox
	mva #1 sound_chip_index
	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
	mva #0 sound_chip_index
	.else
	.error "Undefined sound mode."
	.endif

	
	jsr print_sound_chip_address

	mva #250 x1
loop	lda x1
	beq return
	lda consol
	lsr
	bcc return	;START
	lsr
	bcs no_select

	jsr next_sound_chip_address

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
	
	.proc print_sound_chip_address	; IN: sound_chip_index, OUT: sound_chip_base
	mwa #emu_sm_sound_chip p1
	ldy #0

	lda sound_chip_index
	asl
	tax
	lda sound_chip_addresses,x
	sta sound_chip_base
	and #$f0		; For pokey, the lower 4 bits include the channel, but that is not displayed
	pha
	lda sound_chip_addresses+1,x
	sta sound_chip_base+1
	jsr print_byte
	pla
	jsr print_byte
	rts
	.endp
	
	.proc invert_sound_chip_address
	ldx #3
loop	lda emu_sm_sound_chip,x
	eor #$80
	sta emu_sm_sound_chip,x
	dex
	bpl loop
	rts
	.endp

	.proc next_sound_chip_address
	lda sound_chip_index
	clc
	adc #1
	cmp #[.len sound_chip_addresses]/2
	sne
	lda #0
	sta sound_chip_index
	jsr print_sound_chip_address
	jsr invert_sound_chip_address
	jsr click
	lda #3
	jsr wait
	jsr invert_sound_chip_address
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

	.if ACTIVE_SOUND_MODE=sound_mode.covox
	.sb "Sound Chip:         COVOX 8-bit at $D280"
	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
	.sb "Sound Chip:         POKEY 4-bit at $D200"
	.else
	.error "Undefined sound mode."
	.endif

	.sb "Boot Time:          2024/12/07 00:00:00 "
	.sb "----------------------------------------"
	.sb "                                        "
	.sb "Hold <START> to skip AUTO/ACC           "
	.if ACTIVE_SOUND_MODE=sound_mode.covox
	.sb "Hold <SELECT> to select COVOX address   "
	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
	.sb "Hold <SELECT> to select POKEY address   "
	.else
	.error "Undefined sound mode."
	.endif
	.sb "Press key 'D' to boot from D1:          "
	.sb "Press key <Esc> to run an early console "
	.sb "                                        "	
	.sb +$80 "   Hold <Shift> to pause this screen    "
	.endl
	
	.local chr_special
:8	.byte $55
:8	.byte $ff
	.endl

	.local sound_chip_addresses
	.if ACTIVE_SOUND_MODE=sound_mode.covox
	.word $d100,$d280,$d600,$d700	; $d500 would collide with cartridge
	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
	.word $d202,$d212
	.else
	.error "Undefined sound mode."
	.endif
	.endl

	.endp
