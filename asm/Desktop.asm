
	icl "Kernel-Equates.asm"

p1	= $80
p2	= $82
x1	= $90


rom_chr	= $e000
emu_chr	= $3000
emu_sm	= $3400
emu_height = 23
emu_width = 40
emu_sm_covox = emu_sm+emu_width*13+36

	org $2000

	.proc desktop

	jsr init
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

	mwa #dl3 sdlstl
	mva #$22 sdmctl
	jmp *

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
	rts
	.endp

	.proc fade_in
	mwa #dl1 sdlstl
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

	.local dl1	
	.byte $70,$70,$30
	.byte $42,a(sm1)
	.byte $41,a(dl1)
	.endl

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
	.sb "Hold <Start> to skip AUTO/ACC           "
	.sb "Hold <Select> to select COVOX address   "
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

	.local dl3
	width = 40

	.byte $70,$70,$30
	.byte $4f,a(sm3)
:101	.byte $0f
	.byte $4f,a(sm3+102*width)
:97	.byte $0f
	.byte $41,a(dl3)
	.endl
	.endp



	.proc wait
	clc
	adc rtclok+2
loop	cmp rtclok+2
	bne loop
	rts
	.endp

	org $8010
	.local sm3
	ins "../gfx/screenshots/desktop-01.pic"
	.endl
