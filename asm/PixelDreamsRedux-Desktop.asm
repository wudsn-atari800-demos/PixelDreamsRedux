;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.proc desktop

rom_chr	= $e000
emu_chr	= desktop_base
emu_sm	= desktop_base+$400
emu_height = 23
emu_width = 40
emu_sm_sound_chip = emu_sm+emu_width*13+36

tos_pm	= desktop_base+$800	;TODO: Remove $800
tos_sm	= main_sm
tos_sm_width = 40
tos_sm_lines = 200

offset_top = 0
offset_middle = 58

dli_offset_top = 14
dli_offset_middle = offset_middle+4
dli_offset_bottom = offset_middle+4+93

	jsr emu.init
;	jsr emu.animate	; Comment out to skip

	jsr tos.init
	jsr tos.animate
	rts

;----------------------------------------------------------------------

	.proc emu
	
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
	sta tos_pm+$300,x
	sta tos_pm+$400,x
	sta tos_pm+$500,x
	sta tos_pm+$600,x
	sta tos_pm+$700,x
	inx
	bne clear_pm
	rts
	.endp


	.proc animate

	mwa #dl1 sdlstl
	mva #$22 sdmctl
	mva #2 chact
	jsr emu.fade_in

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
	rts

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

	.endp		; End of animate

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
	.word audc1,audc1+$10
	.else
	.error "Undefined sound mode."
	.endif
	.endl

	.endp		; End of emu


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

	mva #>tos_pm pmbase
	mva #3 gractl
;	mva #$11 gprior	; 5th player for missles
	mva #$01 gprior	; TODO: 5th player for missles

	mva #$0f color1
	sta color3
	mva #$00 color2
	mva #$00 pcolor0
	sta pcolor1
	sta pcolor2
	sta pcolor3

	.macro m_copy
	ldx #.len :1-1
fill	mva :1,x tos_pm+$400+$100*:2+:3,x
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

	ldx #dli_offset_top
	jsr graphics8.toggle_dli_flag
	mva #$3e sdmctl
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

	.proc animate
	mva #1 pm_visible

	.use desktop_blocks

	.macro m_copy_desktop
	mwa #:1 p1
	mwa #tos_sm+tos_sm_width*:3 p2
	lda #:2
	ldx #>.len :1
	ldy #<.len :1
	jsr data_stream.get_block
	jsr cursor.draw
	.endm

	.macro m_trace
	jsr wait_50
	ldx #:1
	ldy #:2
	jsr cursor.movement.trace_to_position
	.endm

	jsr cursor.init
	jsr cursor.redraw

	m_copy_desktop desktop_01 desktop_start_bank_number offset_top
	lda #50
	jsr wait
	m_trace 192 32
	m_copy_desktop desktop_02 desktop_start_bank_number offset_top
	jsr click_and_wait_io
	m_copy_desktop desktop_01 desktop_start_bank_number offset_top

	ldx #dli_offset_middle
	jsr graphics8.toggle_dli_flag
	ldx #dli_offset_bottom
	jsr graphics8.toggle_dli_flag
	ldx #90
	lda #$c0
fill_pm	sta tos_pm+$41c+offset_middle,x
	sta tos_pm+$51c+offset_middle,x
	dex
	bpl fill_pm

	m_copy_desktop desktop_03 desktop_start_bank_number+1 offset_middle
	m_trace 52 98

	m_copy_desktop desktop_04 desktop_start_bank_number+1 offset_middle
	jsr click_and_wait_io
	m_copy_desktop desktop_05 desktop_start_bank_number+1 offset_middle
	m_trace 144 80
	m_trace 128 102
	m_copy_desktop desktop_06 desktop_start_bank_number+1 offset_middle
	jsr click_and_wait_io

	m_copy_desktop desktop_07 desktop_start_bank_number+2 offset_middle
	m_trace 52 98
	m_copy_desktop desktop_08 desktop_start_bank_number+2 offset_middle
	jsr click_and_wait_io
	m_copy_desktop desktop_09 desktop_start_bank_number+2 offset_middle
	m_trace 52 98
	m_copy_desktop desktop_10 desktop_start_bank_number+2 offset_middle
	jsr click_and_wait_io

;	Disable middle/bottom DLI and PMs
	ldx #dli_offset_middle
	jsr graphics8.toggle_dli_flag
	ldx #dli_offset_bottom
	jsr graphics8.toggle_dli_flag
	mva #0 pm_visible

	m_copy_desktop desktop_11 desktop_start_bank_number+3 offset_top
	ldx #60
	jsr wait_io
	lda #0
	sta sdmctl
	sta color4
	lda #1
	jsr wait
	ldx #dli_offset_top
	jsr graphics8.toggle_dli_flag

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

;----------------------------------------------------------------------

	.proc cursor

cursor_width = 16	; Pixels
cursor_height = 16	; Lines
cursor_speed = 2


;----------------------------------------------------------------------

	.proc init
	size = 32
	ldx #size

shift_loop
	lda graphics.and_mask-size,x
	sec
	ror
	sta graphics.and_mask,x
	lda graphics.and_mask-size+1,x
	ror
	sta graphics.and_mask+1,x

	lda graphics.or_mask-size,x
	lsr
	sta graphics.or_mask,x
	lda graphics.or_mask-size+1,x
	ror
	sta graphics.or_mask+1,x
	inx
	inx
	bne shift_loop

	lda #0
	sta colcrs
	sta colcrs+1
	sta rowcrs

	rts
	
	.endp

;----------------------------------------------------------------------

	.proc movement

	.var to_x .word
	.var to_y .byte

	.proc set_random_position
	lda random
	and #$fe
	tax
	lda random
	and #126
	tay
	jsr set_position
	rts
	.endp

	.proc set_position	 	; IN: <X>, <Y>
	stx to_x
	sty to_y
	rts
	.endp

	.proc trace_to_position	 	; IN: <X>, <Y>
	jsr set_position
loop	lda #1
	jsr wait
	jsr cursor.movement.animate
	beq return
	jsr cursor.redraw
	jmp loop
return	rts
	.endp

	.proc animate			; OUT: Z=1, if all equal
	ldy #0

	cpw colcrs to_x
	beq x_equal
	bcc x_lower
	iny
	sbw colcrs #cursor_speed
	jmp x_equal
x_lower
	iny
	adw colcrs #cursor_speed
	jmp x_equal
x_equal

	lda rowcrs
	cmp to_y
	beq y_equal
	bcc y_lower
	iny
	lda rowcrs
	sub #cursor_speed
	sta rowcrs
	jmp y_equal
y_lower
	iny
	lda rowcrs
	add #cursor_speed
	sta rowcrs
	jmp y_equal
y_equal

	tya
	rts
	.endp
	
;----------------------------------------------------------------------

	.proc read_joystick
	lda porta
	sta x1
	lsr x1
	bcs not_up
	lda rowcrs
	beq not_up
	lda rowcrs
	sub #cursor_speed
	sta rowcrs
not_up
	lsr x1
	bcs not_down
	lda rowcrs
	cmp #tos_sm_lines-cursor_width
	beq not_down
	lda rowcrs
	add #cursor_speed
	sta rowcrs
not_down

	lsr x1
	bcs not_left
	cpw colcrs #0
	beq not_left
	sbw colcrs #cursor_speed
not_left
	lsr x1
	bcs not_right
	cpw colcrs #320-cursor_width
	beq not_right
	adw colcrs #cursor_speed
not_right
	rts
	.endp

	.endp		; End of movement

;----------------------------------------------------------------------

	.proc redraw
	jsr clear
	jsr draw
	rts
	.endp

;----------------------------------------------------------------------

	.proc draw		;IN: colcrs, rowcrs
	mva colcrs+1 x1
	lda colcrs		; Compute byte offset
	lsr x1
	ror
	sta x2			; Compute HPOS offset
	lsr x1
	ror
	lsr x1
	ror

	ldx rowcrs		; Compute line offset
	clc
	adc graphics.llo,x
	sta p1
	lda #0
	adc graphics.lhi,x
	sta p1+1
	
	lda colcrs		; Compute shift offset
	and #7
	asl
	asl
	asl
	asl
	asl
	sta x1

	mwa #graphics.and_mask p2
	clc
	lda p2
	adc x1
	sta p2
	scc
	inc p2+1

	mwa #graphics.or_mask p3
	clc
	lda p3
	adc x1
	sta p3
	scc
	inc p3+1
	
	mwa p1 graphics.buffer.address
	ldx #cursor_height-1
loop	ldy #0
	lda (p1),y
	sta graphics.buffer.column1,x
	and (p2),y
	ora (p3),y
	sta (p1),y
	iny
	lda (p1),y
	sta graphics.buffer.column2,x
	and (p2),y
	ora (p3),y
	sta (p1),y
	adw p1 #tos_sm_width
	adw p2 #2
	adw p3 #2
	dex
	bpl loop
	
	clc
	lda x2
	adc #$30		; PM x-offset
	sta hposm3
	adc #2
	sta hposm2
	adc #2
	sta hposm1
	adc #2
	sta hposm0
	
	lda rowcrs
	clc
	adc #$1c		; PM y-offset
	sta graphics.buffer.ypos
	tay
	ldx #cursor_height-1
pm_loop	lda graphics.pm,x
	sta tos_pm+$300,y
	iny
	dex
	bpl pm_loop

	rts
	.endp

;----------------------------------------------------------------------

	.proc clear
	lda graphics.buffer.address+1
	beq return			;Was never drawn
	sta p1+1
	mva graphics.buffer.address p1

	ldx #cursor_height-1
loop	ldy #0
	lda graphics.buffer.column1,x
	sta (p1),y
	iny
	lda graphics.buffer.column2,x
	sta (p1),y
	adw p1 #tos_sm_width

	dex
	bpl loop

	ldy graphics.buffer.ypos
	ldx #cursor_height-1
	lda #$00
pm_loop	sta tos_pm+$300,y
	iny
	dex
	bpl pm_loop

return	rts
	.endp

;----------------------------------------------------------------------

	.local graphics

	.local and_mask
	ins "../gfx/full/desktop-cursor-01-and.pic"
	.ds 7*32
	.endl

	.local or_mask
	ins "../gfx/full/desktop-cursor-01-or.pic"
	.ds 7*32
	.endl

	.local llo
:tos_sm_lines	.byte <[tos_sm+#*tos_sm_width]
	.endl
	
	.local lhi
:tos_sm_lines	.byte >[tos_sm+#*tos_sm_width]
	.endl

	.local pm
	.byte $10,$10,$38,$b8
	.byte $f0,$f0,$f8,$f8
	.byte $f8,$f0,$f0,$e0
	.byte $e0,$c0,$c0,$80
	.endl

	.local buffer

address	.word $0000

	.local column1
	.ds cursor_height
	.endl
	.local column2
	.ds cursor_height
	.endl

ypos	.byte $00

	.endl		; End of buffer

	.endl		; End of graphics

	.endp		; End of cursor

	.endp 		; End of tos

;----------------------------------------------------------------------

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

	.endp
