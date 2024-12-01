
	icl "Kernel-Equates.asm"

p1	= $80
p2	= $82

rom_chr	= $e000
chr	= $3000
sm2a	= $3400

	org $2000

	ldx #0
copy_chr
:4	mva rom_chr+#*$100,x chr+#*$100,x
	inx
	bne copy_chr
	mva #>chr chbas

	ldx #15
copy_chr_special
	mva chr_special,x chr+$200,x
	dex
	bpl copy_chr_special
	
	mwa #dl1 sdlstl
	ldx #0
fade_in
	stx color1
	stx color2
	stx color4
	lda #3
	jsr wait
	inx
	cpx #15
	bne fade_in

	lda #25
	jsr wait
	mva #0 color1
	lda #50
	jsr wait
	mva #14 color1
	
	mwa #dl2 sdlstl
	mva #$36 color0
	mva #$0a color3
	lda #75
	jsr wait
	mva #0 color1

height = 22
width = 40

	mwa #sm2 p1
	mwa #sm2a p2
	ldx #0
yloop	ldy #width-1
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
	adw p1 #width
	adw p2 #width
	lda #1
	jsr wait
	inx
	cpx #height
	bne yloop
	
	lda #250
	jsr wait	
shift_down
	lda skctl
	and #8
	beq shift_down

	mva #0 sdmctl
	lda #25
	jsr wait

	mwa #dl3 sdlstl
	mva #$22 sdmctl
	jmp *
	
	.proc wait
	clc
	adc rtclok+2
loop	cmp rtclok+2
	bne loop
	rts
	.end


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
	.byte $70,$70
	.byte $44,a(sm2a),$04,$04,$04,$04
:17	.byte $02
	
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
	.sb "Boot Time:          2024/12/07 00:00:00 "
	.sb "----------------------------------------"
	.sb "                                        "
	.sb "Hold <Control> to skip AUTO/ACC         "
	.sb "Hold <Alternate> to skip HDD boot       "
	.sb "Press key 'D' to boot from D1:          "
	.sb "Press key <Esc> to run an early console "
	.sb "                                        "	
	.sb +$80 "   Hold <Shift> to pause this screen    "
	.endl
	
	.local chr_special
:8	.byte $55
:8	.byte $ff
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

	org $8010
	.local sm3
	ins "../gfx/screenshots/desktop-01.pic"
	.endl
