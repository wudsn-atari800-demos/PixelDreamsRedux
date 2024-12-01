;	@com.wudsn.ide.lng.outputfileextension=.rom
	icl "Kernel-Equates.asm"
	icl "PixelDreamsRedux-Globals.asm"
	icl "PixelDreamsRedux-Sound-Definitions.asm"

	.def alignment_mode

; Features
.ifndef ACTIVE_SOUND_MODE
ACTIVE_SOUND_MODE = sound_mode.covox
.endif

; Zeropage
p1	= $80	;Word
p2	= $82	;Word
p3	= $84	;Word
x1	= $86	;Byte
x2	= $87	;Byte
covox_base = $88 ;Word, set by desktop, used by sound

main_bank = $90

irq_zp	= $b0	;$38 bytes

; Main screen is 180/5/10/5
sm_width = 40
sm	= main_sm		; 102*40 byte per 4k block, 194 lines total
sm2	= sm+102*sm_width

;----------------------------------------------------------------------

	m_start_first_bank
	
	.byte "Pixel Dream Redux - Bohemian Grove and AJC! - Preview 2024-11-30",13,10,0

	.proc bootloader
	sei
	ldx #$ff
	txs

	mwa #main_rom p1	; Copy main to RAM.
	mwa #main p2
	ldx #>[.len main+$ff]
	ldy #0
loop	lda (p1),y
	sta (p2),y
	iny
	bne loop
	inc p1+1
	inc p2+1
	dex
	bne loop


	.proc init_keymap

	ldy #0
loop	lda (keydef),y
	sta keymap,y
	iny
	cpy #192
	bne loop
	.endp

	jmp main
	.endp

main_rom
	.proc main,$2000
	.var .byte loop_mode = 0
 
 	cli
	jsr desktop

loop	jsr init
	jsr play

	lda #200
	jsr wait
	lda loop_mode
	bne loop
no_start
	lda consol
	and #1
	bne no_start
	mva #1 loop_mode
	jmp loop

;----------------------------------------------------------------------

	icl "PixelDreamsRedux-Common.asm"
	icl "PixelDreamsRedux-Desktop.asm"
	icl "PixelDreamsRedux-Intro.asm"
	icl "PixelDreamsRedux-Pictures.asm"
	icl "PixelDreamsRedux-Lyrics.asm"
	icl "PixelDreamsRedux-Outro.asm"
	icl "PixelDreamsRedux-Sound.asm"

;----------------------------------------------------------------------

	.proc init
	sei
	lda #0
	sta nmien
	sta irqen
	
	mva #$fe portb
	mwa #interrupts.nmi $fffa
	mwa #sound.irq $fffe
	
	jsr sync
	jsr init_pokey
	rts

	.proc init_pokey
	ldx #8
	lda #0
loop	sta pokey,x
	sta pokey+$10,x
	dex
	bne loop
	mva #3 skctl
	rts
	.endp

	.endp

;----------------------------------------------------------------------

	.proc interrupts
	
;	.proc jam
;	.byte 2
;	.endp

	.proc enable
	lda #0
	sta rtclok+2
	sta rtclok+1

	mva #$40 nmien		; Enable VBI

	jsr sound.init		; Enable IRQ sound replyy
	rts
	.endp

	.proc nmi
	pha
	bit nmist		; Test bit 7 and 6
	bpl vbi

;	.proc dli
;	sta nmires		; Reset status flags
;dliv = *+1
;	jmp jam			; DLI vector, return with PLA:RTI
;	.endp

	.proc vbi
	sta nmires		; Reset status flags
	mva #$22 dmactl
	mwa sdlstl dlistl
;	mwa vdslst dli.dliv
;	mva #$c0 nmien		; Enable VBI & DLI
        mva pcolor0 colpm0
        mva pcolor1 colpm1
        mva pcolor2 colpm2
        mva pcolor3 colpm3
	mva color0 colpf0
	mva color1 colpf1
	mva color2 colpf2
        mva color3 colpf3
	mva color4 colbk
	mva gprior prior
	inc rtclok+2
	sne
	inc rtclok+1
	pla
	rti
	.endp

	.endp			;End of nmi
	
	.endp			;End of interrupts

;----------------------------------------------------------------------

	.proc play

	jsr interrupts.enable
	
	jsr intro.init
	jsr intro.next
	jsr intro.next
	jsr intro.next
	jsr intro.next

	jsr pictures.init
	jsr lyrics.init

;	.byte 2			; Must be at RTCLOK=$1D8

loop	lda #9
	jsr show_picture_and_lyrics

	lda #5
	jsr show_picture_and_lyrics

	lda #5
	jsr show_picture_and_lyrics

	lda #5
	jsr show_picture_and_lyrics

	jsr outro.init
	jsr graphics8.fade_in
	lda #210
	jsr wait
	lda #200
	jsr wait
	jsr outro.transition
	lda #50
	jsr wait
	jsr fade_out
	rts
	
	.proc show_picture_and_lyrics	;IN: <A>=lytics_row_count
	pha
;reset
	jsr pictures.next
;	dec pictures.picture_number
;
;test
;	lda skstat
;	sta x1
;	and #4
;	bne test
;
;	lda kbcode
;	and #63
;	tay
;	lda keymap,y
;	cmp #27
;	beq reset
;	sec
;	sbc #'1'
;	tax
;	bmi test
;
;
;	lda x1
;	and #8
;	beq do_dec
;
;	inc pcolor0,x
;	jmp done
;do_dec	dec pcolor0,x
;done	lda #3
;	jsr wait
;	jmp test
;
	pla
	jsr lyrics.start_block
	jsr fade_out
	rts
	.endp

	.endp				; End of play

	.endp				; End of main

	m_info main
	org cartcs			; End of main bank 
	.byte a($0000),$00,$00,a(bootloader)

;----------------------------------------------------------------------

	.local padding
	m_align_next_bank $00
	.byte $00
	m_align_next_bank $00
	.byte $00
	m_align_next_bank $00
	.byte $00
	m_align_next_bank $00
	.byte $00
	.endl


;----------------------------------------------------------------------
	m_align_next_bank $00

	.local desktop_blocks

	.local desktop_01
	ins "../gfx/gr8/desktop-01.pic"
	m_align $2000
	.endl

	.local desktop_02
	ins "../gfx/gr8/desktop-02.pic"
	m_align $2000
	.endl
	
	m_align_next_bank $00
	.local desktop_03
	ins "../gfx/gr8/desktop-03.pic"
	.endl
	m_align $1000
	.local desktop_04
	ins "../gfx/gr8/desktop-04.pic"
	.endl
	m_align $1000
	.local desktop_05
	ins "../gfx/gr8/desktop-05.pic"
	.endl
	m_align $1000
	.local desktop_06
	ins "../gfx/gr8/desktop-06.pic"
	.endl
	m_align $1000
	
	m_align_next_bank $00
	.local desktop_07
	ins "../gfx/gr8/desktop-07.pic"
	.endl
	m_align $1000
	.local desktop_08
	ins "../gfx/gr8/desktop-08.pic"
	.endl
	m_align $1000
	.local desktop_09
	ins "../gfx/gr8/desktop-09.pic"
	.endl
	m_align $1000
	.local desktop_10
	ins "../gfx/gr8/desktop-10.pic"
	.end
	m_align $1000
	
	m_align_next_bank $00
	.local desktop_11
	ins "../gfx/gr8/desktop-11.pic"
	.endl
	m_align $2000
	.endl

;----------------------------------------------------------------------

	m_align_next_bank $00

	.local intro_blocks

	.local intro_01
	ins "../gfx/gr8/intro-01.pic"
	.endl
	m_align $2000
	m_info intro_01

	.local intro_02
	ins "../gfx/gr8/intro-02.pic"
	.endl
	m_align $2000
	m_info intro_02

	m_align_next_bank $00

	.local intro_03
	ins "../gfx/gr8/intro-03.pic"
	.endl
	m_align $2000
	m_info intro_03

	.local intro_04
	ins "../gfx/gr8/intro-04.pic"
	.endl
	m_align $2000
	m_info intro_04

	.endl

;----------------------------------------------------------------------

	m_align_next_bank $00

	.local pictures_blocks

	.local main_01
	ins "../gfx/gr10/main-01.pic"
	.endl
	m_align $2000
	m_info main_01

	.local main_02
	ins "../gfx/gr10/main-02.pic"
	.endl
	m_align $2000
	m_info main_02

	m_align_next_bank $00

	.local main_03
	ins "../gfx/gr10/main-03.pic"
	.endl
	m_align $2000
	m_info main_03

	.local main_04
	ins "../gfx/gr10/main-04.pic"
	.endl
	m_align $2000
	m_info main_04

	.endl

;----------------------------------------------------------------------

	m_align_next_bank $00

	.local lyrics_blocks
	ins "../gfx/gr8/lyrics.pic"	;$2710 bytes
	.endl
	m_info lyrics_blocks

;----------------------------------------------------------------------

	m_align_next_bank $00


	.local outro_blocks

	.local outro_01
	ins "../gfx/gr8/outro-01.pic"	;$1f40 bytes
	.endl
	m_align $2000

	.local outro_02
	ins "../gfx/gr8/outro-02.pic"	;$1f40 bytes
	.endl
	m_align $2000

	m_align_next_bank $00

	.local outro_02_mask
	ins "../gfx/gr8/outro-02-mask.pic" ;$1f40 bytes
	.endl
	m_align $2000

	.endl
	m_info outro_blocks

;----------------------------------------------------------------------

	m_align_next_bank $00

	.if ACTIVE_SOUND_MODE=sound_mode.covox
	ins "../snd/PixelDreamsRedux-Sound-Data-COVOX.bin"
	.elseif ACTIVE_SOUND_MODE=sound_mode.pokey
	ins "../snd/PixelDreamsRedux-Sound-Data-POKEY.bin"
	.else
	.error "Undefined sound mode."
	.endif
