;
;	>>> Kernel Equates JAC! <<<
;
;	(c) 2024 by JAC! for Silly Venture 2k24 WE
;
;	.def alignment_mode should be used by default in parent program 

	.enum opcode
adc_imm	= $69
asl	= $0a
bit_abs	= $2c
bne	= $d0
brk	= $00
cmp_zp	= $c5
cmp_imm	= $c9
cmp_abs	= $cd
dec_zp	= $c6
eor_zp	= $45
inc_zp	= $e6
inc_abs	= $ee
jsr	= $20
lax_izy	= $b3	;LAX (zp),y
lax_zp	= $a7	;LAX zp
lda_abs	= $ad
lda_imm = $a9
lda_zp	= $a5
lda_zpy	= $b1
ldx_imm = $a2
ldy_imm = $a0
nop	= $ea
rts     = $60
sta_abs	= $8d
sta_zpy	= $91
stx_abs	= $8e
sty_abs	= $8c
	.ende

	.enum cio_command
	open = 3
	get_character = 7
	close = 12
	run_executable = 40
	change_directory = 41	
	.ende

; Zero page
casini = $02
warmst = $08
boot   = $09
dosvec = $0a
dosini = $0c
pokmsk = $10
rtclok = $12
soundr = $41
critic = $42
atract = $4d
lmargn = $52
rowcrs = $54
savmsc = $58
ramtop = $6a
keydef = $79	;121 (XL) KEY DEFINATION POINTER, 2 BYTES

; Page 2
vdslst	= $200
vvblki	= $222
vvblkd	= $224

sdmctl	= $22f
sdlstl	= $230
sdlsth	= $231
coldst	= $244
gprior	= $26f
stick0	= $278
strig0	= $284


pcolor0	= $2c0
pcolor1	= $2c1
pcolor2	= $2c2
pcolor3	= $2c3
color0	= $2c4
color1	= $2c5
color2	= $2c6
color3	= $2c7
color4	= $2c8
runad	= $2e0
ramsiz	= $2e4
crsinh	= $2f0
chact	= $2f3	;Shadow of chactl ($d401)
chbas	= $2f4
ch	= $2fc

iocb   = $340	;832
ichid  = $340	;832
icdno  = $341	;833
iccom  = $342	;834
icsta  = $343	;835
icbal  = $344	;836
icbah  = $345	;837
icptl  = $346	;838
icpth  = $347	;839
icbll  = $348	;840
icblh  = $349	;841
icax1  = $34a	;842
icax2  = $34b	;843
icax3  = $34c	;844
icax4  = $34d	;845
icax5  = $34e	;846
icax6  = $34f	;847
basicf = $3f8
gintlk = $3fa

; Cartridge
cartcs	= $bffa ;Start address
cart	= $bffc	;$00 for cartridges
cartfg	= $bffd	;Bit 7: diagnostic cart, jump to (CARTAD) with initilization; Bit 2: call (CARTAD) then (CARTCS), otherwise only (CARTAD) is called, Bit 1: Boot peripherals
cartad	= $bffa ;Init address

; GTIA
gtia	= $d000
hposp0	= $d000
hposp1	= $d001
hposp2	= $d002
hposp3	= $d003

m0pf	= $d000	;Read collisions of M0 with playfield
m1pf	= $d001	;Read collisions of M1 with playfield
m2pf	= $d002	;Read collisions of M2 with playfield
m3pf	= $d003	;Read collisions of M3 with playfield

hposm0	= $d004
hposm1	= $d005
hposm2	= $d006
hposm3	= $d007
sizep0	= $d008
sizep1	= $d009
sizep2	= $d00a
sizep3	= $d00b
sizem	= $d00c
grafp0	= $d00d
grafp1	= $d00e
grafp2	= $d00f
grafp3	= $d010
trig0	= $d010
trig1	= $d011
trig3	= $d013
grafm	= $d011
colpm0	= $d012
colpm1	= $d013
colpm2	= $d014
pal     = $d014 ;PAL=$01, NTSC=$0f
colpm3	= $d015
colpf0	= $d016
colpf1	= $d017
colpf2	= $d018
colpf3	= $d019
colbk	= $d01a
prior	= $d01b
gractl	= $d01d
hitclr	= $d01e
consol	= $d01f

; POKEY
pokey	= $d200
audf1	= $d200
audc1	= $d201
audf2	= $d202
audc2	= $d203
audf3	= $d204
audc3	= $d205
audf4	= $d206
audc4	= $d207
audctl	= $d208
kbcode	= $d209
stimer	= $d209
random	= $d20a
irqen	= $d20e
skctl	= $d20f
skstat	= $d20f

;PIA
porta	= $d300
portb	= $d301


; ANTIC
antic	= $d400
dmactl	= $d400
chactl	= $d401
dlistl 	= $d402
dlisth 	= $d403
hscrol	= $d404
vscrol	= $d405
pmbase	= $d407
chbase	= $d409
wsync 	= $d40a
vcount	= $d40b
nmien	= $d40e
nmist	= $d40f
nmires	= $d40f

; ROM
ciov	= $e456
setvbv	= $e45c	;<A>=6 (immediate) ot 7 (deferred), <X>=high, <Y>=low
setvbv.immediate = 6
setvbv.deferred = 7
sysvbv	= $e45f	;End of immediate VBI
xitvbv	= $e462	;End of deferred VBI
warmsv	= $e474	;Warmstart
coldsv	= $e477

; VBXE - from MadPascal's "cpu6502.asm"
fx_video_control   = $40
fx_vc              = fx_video_control

; MEMAC-A / MEMAC-B registers
fx_memac_b_control = $5d
fx_memb            = fx_memac_b_control
fx_memac_control   = $5e
fx_memc            = fx_memac_control
fx_memac_bank_sel  = $5f
fx_mems            = fx_memac_bank_sel
fx_core_reset      = $d080


;===============================================================
;	Stop emulation and open monitor
	.macro jam
	.byte $02
	.endm

	
;===============================================================
;	Indicate end of program
	.macro xx
loop	lda vcount
	sta colbk
	jmp loop
	.endm

;===============================================================
	.macro m_info	;Works with ranges like ".PROC", ".LOCAL"
	.print ":1: " , :1, " - ", :1 + .len :1 -1, " (", .len :1,")"
	.endm

	.macro m_align_page	;Fills with 0 and prints how much space is "lost"
	m_align $100
	.endm

	.macro m_align		;Fills with 0 and prints how much space is "lost"
	here = *
	size = [[[here+:1]/:1]*:1]-*
	.print "Alignment added at ",here,": ", size, " bytes."
	.rept size
	.byte 0
	.endr
	.endm
	
	.macro m_assert_same_page ;For timing critical loop or ranges enclosed by ".PROC" or ".LOCAL"
	.if :1 / $100 <> (:1 + .len :1 - 1) / $100
		.if .def alignment_mode
			.error ":1 crosses page boundary between ", :1, " - ", :1 + .len :1 - 1
		.else
			.print ":1 crosses page boundary between ", :1, " - ", :1 + .len :1 - 1
		.endif
	.else
		.print ":1 within page boundary between ", :1, " - ", :1 + .len :1 - 1
	.endif
	.endm

	.macro m_assert_same_1k	;For display lists
	.if :1 / $400 <> (:1 + .len :1 - 1) / $400
		.if .def alignment_mode
			.error ":1 crosses 1k boundary between ", :1, " - ", :1 + .len :1 - 1
		.else
			.print ":1 crosses 1k boundary between ", :1, " - ", :1 + .len :1 - 1
		.endif
	.else
		.print ":1 within 1k boundary between ", :1, " - ", :1 + .len :1 - 1
	.endif
	.endm

	.macro m_assert_same_4k	;For screen memory
	.if :1 / $1000 <> (:1 + .len :1 - 1) / $1000
		.if .def alignment_mode
			.error ":1 crosses 4k boundary between ", :1, " - ", :1 + .len :1 - 1
		.else
			.print ":1 crosses 4k boundary between ", :1, " - ", :1 + .len :1 - 1
		.endif
	.else
		.print ":1 within 4k boundary between ", :1, " - ", :1 + .len :1 - 1
	.endif
	.endm

	.macro m_assert_align	; Uses .def alignment_mode to control if misaligment is error or warning
	.if :1 / :2 <> (:1 + :2 - 1) / :2
		.if .def alignment_mode
			.error ":1 crosses ",:2," boundary between ", :1, " - ", :1 + :2 - 1
		.else
			.print ":1 crosses ",:2," boundary between ", :1, " - ", :1 + :2 - 1
		.endif
	.else
		.print ":1 within ",:2," boundary between ", :1, " - ", :1 + :2 - 1
	.endif
	.endm

	.macro m_assert_end_of_code ;For assuring the code does not overlap some data	
end_of_code
	.if end_of_code > :1
	.error "END_OF_CODE (",end_of_code,") > :1 (",:1,"), ", end_of_code-:1, " bytes too far" 
	.else
	.print "END_OF_CODE (",end_of_code,") <= :1 (",:1,"), ", :1-end_of_code, " bytes free" 
	.endif
	.endm
	
	.macro m_color
	lda trig0
	bne no_col
	mva #:1 colbk
no_col
	.endm

;;
;; ATARI 800 SYSTEM EQUATE LISTING
;;
;; Tranferred to ATASM format by JAC! on 2010-11-11 based on
;; http://evilbill.org/old/orig/Atari/8-Bit/Refman/appendixB.html.
;; Formatted using tabs for a tab width of 8 characters.
;; Last update on 2010-11-11.
;;
;; This listing is based on the original release of Operating System,
;; version A. The vectors shown here were not changed in version B.
;; New equates for XL and XE models are included and noted. 
;; Changes from version B to XL/XE are also noted.
;;
;; Most of the equate names given below are the official Atari names.
;; They are in common use but are not mandatory.
;
;;
;;
;;	DEVICE NAMES
;;
;;
;;SCREDT = "E"	;SCREEN EDITOR
;;KBD    = "K"	;KEYBOARD
;;DISPLY = "S"	;DISPLAY
;;PRINTR = "P"	;PRINTER
;;CASSET = "C"	;CASSETTE
;;DISK   = "D"	;DISK DRIVE
;
;;
;;
;;	STATUS CODES
;;
;;
;SUCCES = $01	;  1
;BRKABT = $80	;128 BREAK KEY ABORT
;PRVOPN = $82	;130 IOCB ALREADY OPEN
;NONDEV = $82	;130 NONEXISTANT DEVICE
;WRONLY = $83	;131 OPENED FOR WRITE ONLY
;NVALID = $84	;132 INVALID COMMAND
;NOTOPN = $85	;133 DEVICE OR FILE NOT OPEN
;BADIOC = $86	;134 INVALID IOCB NUMBER
;RDONLY = $87	;135 OPENED FOR READ ONLY
;EOFERR = $88	;136 END OF FILE
;TRNRCD = $89	;137 TRUNCATED RECORD
;TIMOUT = $8A	;138 PERIPHERAL TIME OUT
;DNACK  = $8B	;139 DEVICE DOES NOT ACKNOWLEDGE
;FRMERR = $8C	;140 SERIAL BUS FRAMING ERROR
;CRSROR = $8D	;141 CURSOR OUT OF RANGE
;OVRRUN = $8E	;142 SERIAL BUS DATA OVERRUN
;CHKERR = $8F	;143 SERIAL BUS CHECKSUM ERROR
;DERROR = $90	;144 PERIPHERAL DEVICE ERROR
;BADMOD = $91	;145 NON EXISTANT SCREEN MODE
;FNCNOT = $92	;146 FUNCTION NOT IMPLEMENTED
;SCRMEM = $93	;147 NOT ENOUGH MEMORY FOR SCREEN MODE
;
;;
;;
;;
;;	COMMAND CODES FOR CIO
;;
;;
;OPEN   = $03	;  3
;OPREAD = $04	;  4 OPEN FOR INPUT
;GETREC = $05	;  5 GET RECORD
;OPDIR  = $06	;  6 OPEN TO DISK DIRECTORY
;GETCHR = $07	;  7 GET BYTE
;OWRITE = $08	;  8 OPEN FOR OUTPUT
;PUTREC = $09	;  9 WRITE RECORD
;APPEND = $09	;  9 OPEN TO APPEND TO END OF DISK FILE
;MXDMOD = $10	; 16 OPEN TO SPLIT SCREEN (MIXED MODE)
;PUTCHR = $0B	; 11 PUT-BYTE
;CLOSE  = $0C	; 12
;OUPDAT = $0C	; 12 OPEN FOR INPUT AND OUTPUT AT THE SAME TIME
;STATUS = $0D	; 13
;SPECIL = $0E	; 14 BEGINNING OF SPECIAL COMMANDS
;DRAWLN = $11	; 17 SCREEN DRAW
;FILLIN = $12	; 18 SCREEN FILL
;RENAME = $20	; 32
;INSCLR = $20	; 32 OPEN TO SCREEN BUT DON'T ERASE
;DELETE = $21	; 33
;DFRMAT = $21	; 33 FORMAT DISK (RESIDENT DISK HANDLER (RDH))
;LOCK   = $23	; 35
;UNLOCK = $24	; 36
;POINT  = $25	; 37
;NOTE   = $26	; 38
;PTSECT = $50	; 80 RDH PUT SECTOR
;GTSECT = $52	; 82 RDH GET SECTOR
;DSTAT  = $53	; 83 RDH GET STATUS
;PSECTV = $57	; 87 RDH PUT SECTOR AND VERIFY
;NOIRG  = $80	;128 NO GAP CASSETTE MODE
;CR     = $9B	;155 CARRIAGE RETURN (EOL)
;;
;IOCBSZ = $10	; 16 IOCB SIZE
;MAXIOC = $80	;128 MAX IOCB BLOCK SIZE
;IOCBF  = $FF	;255 IOCB FREE
;;
;LEDGE  = $02	;  2 DEFAULT LEFT MARGIN
;REDGE  = $27	; 39 DEFAULT RIGHT MARGIN
;;
;;	OS VARIABLES
;;
;;	PAGE 0
;;
;LINZBS = $00	;  0 (800) FOR ORIGINAL DEBUGGER
;;	 $00	;  0 (XL) RESERVED
;NGFLAG = $01	;  1 (XL) FOR POWER-UP SELF TEST
;CASINI = $02	;  2
;RAMLO  = $04	;  4 POINTER FOR SELF TEST
;TRAMSZ = $06	;  6 TEMPORARY RAM SIZE
;TSTDAT = $07	;  7 TEST DATA
;WARMST = $08	;  8
;BOOT?  = $09	;  9 SUCCESSFUL BOOT FLAG
;DOSVEC = $0A	; 10 PROGRAM RUN VECTOR
;DOSINI = $0C	; 12 PROGRAM INITIALIZATION
;APPMHI = $0E	; 14 DISPLAY LOW LIMIT
;POKMSK = $10	; 16 IRQ ENABLE FLAGS
;BRKKEY = $11	; 17 FLAG
;RTCLOK = $12	; 18 3 BYTES, MSB FIRST
;BUFADR = $15	; 21 INDIRECT BUFFER ADDRESS
;ICCOMT = $17	; 23 COMMAND FOR VECTOR
;DSKFMS = $18	; 24 DISK FILE MANAGER POINTER
;DSKUTL = $1A	; 26 DISK UTILITY POINTER (DUP.SYS)
;PTIMOT = $1C	; 28 (800) PRINTER TIME OUT REGISTER
;ABUFPT = $1C	; 28 (XL) RESERVED
;PBPNT  = $1D	; 29 (800) PRINTER BUFFER POINTER
;;	 $1D	; 29 (XL) RESERVED
;PBUFSZ = $1E	; 30 (800) PRINTER BUFFER SIZE
;;	 $1E	; 30 (XL) RESERVED
;PTEMP  = $1F	; 31 (800) TEMPORARY REGISTER
;;	 $1F	; 31 (XL) RESERVED
;ZIOCB  = $20	; 32 ZERO PAGE IOCB
;ICHIDZ = $20	; 32 HANDLER INDEX NUMBER (ID)
;ICDNOZ = $21	; 33 DEVICE NUMBER
;ICCOMZ = $22	; 34 COMMAND
;ICSTAZ = $23	; 35 STATUS
;ICBALZ = $24	; 36 BUFFER POINTER LOW BYTE
;ICBAHZ = $25	; 37 BUFFER POINTER HIGH BYTE
;ICPTLZ = $26	; 38 PUT ROUTINE POINTER LOW
;ICPTHZ = $27	; 39 PUT ROUTINE POINTER HIGH
;ICBLLZ = $28	; 40 BUFFER LENGTH LOW
;ICBLHZ = $29	; 41
;ICAX1Z = $2A	; 42 AUXILIARY INFORMATION BYTE 1
;ICAX2Z = $2B	; 43
;ICSPRZ = $2C	; 44 TWO SPARE BYTES (CIO USE)
;ICIDNO = $2E	; 46 IOCB NUMBER X 16
;CIOCHR = $2F	; 47 CHARACTER BYTE FOR CURRENT OPERATION
;;
;STATUS = $30	; 48 STATUS STORAGE
;CHKSUM = $31	; 49 SUM WITH CARRY ADDED BACK
;BUFRLO = $32	; 50 DATA BUFFER LOW BYTE
;BUFRHI = $33	; 51
;BFENLO = $34	; 52 ADDRESS OF LAST BUFFER BYTE +1 (LOW)
;BFENHI = $35	; 53
;CRETRY = $36	; 54 (800) NUMBER OF COMMAND FRAME RETRIES
;LTEMP  = $36	; 54 (XL) LOADER TEMPORARY STORAGE, 2 BYTES
;DRETRY = $37	; 55 (800) DEVICE RETRIES
;BUFRFL = $38	; 56 BUFFER FULL FLAG
;RECVDN = $39	; 57 RECEIVE DONE FLAG
;XMTDON = $3A	; 58 TRANSMISSION DONE FLAG
;CHKSNT = $3B	; 59 CHECKSUM-SENT FLAG
;NOCKSM = $3C	; 60 CHECKSUM-DOES-NOT-FOLLOW-DATA FLAG
;BPTR   = $3D	; 61
;FTYPE  = $3E	; 62
;FEOF   = $3F	; 63
;FREQ   = $40	; 64
;;
;SOUNDR = $41	; 65 0=QUIET I/O
;CRITIC = $42	; 66 CRITICAL FUNCTION FLAG, NO DEFFERED VBI
;FMSZPG = $43	; 67 DOS ZERO PAGE, 7 BYTES
;CKEY   = $4A	; 74 (800) START KEY FLAG
;ZCHAIN = $4A	; 74 (XL) HANDLER LOADER TEMP, 2 BYTES
;CASSBT = $4B	; 75 (800) CASSETTE BOOT FLAG
;DSTAT  = $4C	; 76 DISPLAY STATUS
;;
;ATRACT = $4D	; 77
;DRKMSK = $4E	; 78 ATTRACT MASK
;COLRSH = $4F	; 79 ATTRACT COLOR SHIFTER (EORed WITH GRAPHICS)
;;
;TMPCHR = $50	; 80
;HOLD1  = $51	; 81
;LMARGN = $52	; 82 SCREEN LEFT MARGIN REGISTER
;RMARGN = $53	; 83 SCREEN RIGHT MARGIN
;ROWCRS = $54	; 84 CURSOR ROW
;COLCRS = $55	; 85 CURSOR COLUMN, 2 BYTES
;DINDEX = $57	; 87 DISPLAY MODE
;SAVMSC = $58	; 88 SCREEN ADDRESS
;OLDROW = $5A	; 90 CURSOR BEFORE DRAW OR FILL
;OLDCOL = $5B	; 91
;OLDCHR = $5D	; 93 DATA UNDER CURSOR
;OLDADR = $5E	; 94 CURSOR ADDRESS
;NEWROW = $60	; 96 (800) DRAWTO DESTINATION
;FKDEF  = $60	; 96 (XL) FUNCTION KEY DEFINATION POINTER
;NEWCOL = $61	; 97 (800) DRAWTO DESTINATION, 2 BYTES
;PALNTS = $62	; 98 (XL) EUROPE/NORTH AMERICA TV FLAG
;LOGCOL = $63	; 99 LOGICAL LINE COLUMN POINTER
;MLTTMP = $66	;102
;OPNTMP = $66	;102 TEMPORARY STORAGE FOR CHANNEL OPEN
;SAVADR = $68	;104
;RAMTOP = $6A	;106 START OF ROM (END OF RAM + 1), HIGH BYTE ONLY
;
;BUFCNT = $6B	;107 BUFFER COUNT
;BUFSTR = $6C	;108 POINTER USED BY EDITOR
;BITMSK = $6E	;110 POINTER USED BY EDITOR
;SHFAMT = $6F	;111
;ROWAC  = $70	;112
;COLAC  = $72	;114
;ENDPT  = $74	;116
;DELTAR = $76	;118
;DELTAC = $77	;119
;ROWINC = $79	;121 (800)
;COLINC = $7A	;122 (800)
;SWPFLG = $7B	;123 NON 0 IF TEXT AND REGULAR RAM IS SWAPPED
;HOLDCH = $7C	;124 CH MOVED HERE BEFORE CTRL AND SHIFT
;INSDAT = $7D	;125
;COUNTR = $7E	;126
;;
;ZROFRE = $80	;128 FREE ZERO PAGE, 84 BYTES
;FPZRO  = $D4	;212 FLOATING POINT RAM, 43 BYTES
;FR0    = $D4	;212 FP REGISTER 0
;FRE    = $DA	;218
;FR1    = $E0	;224 FP REGISTER 1
;FR2    = $E6	;230 FP REGISTER 2
;FRX    = $EC	;236 SPARE
;EEXP   = $ED	;237 VALUE OF E
;NSIGN  = $ED	;237 SIGN OF FP NUMBER
;ESIGN  = $EF	;239 SIGN OF FP EXPONENT
;FCHFLG = $F0	;240 FIRST CHARACTER FLAG
;DIGRT  = $F1	;241 NUMBER OF DIGITS RIGHT OF DECIMAL POINT
;CIX    = $F2	;242 INPUT INDEX
;INBUFF = $F3	;243 POINTER TO ASCII FP NUMBER
;ZTEMP1 = $F5	;245
;ZTEMP4 = $F7	;247
;ZTEMP3 = $F9	;249
;DEGFLG = $FB	;251
;RADFLG = $FB	;251 0=RADIANS, 6=DEGREES
;FLPTR  = $FC	;252 POINTER TO BCD FP NUMBER
;FPTR2  = $FE	;254
;;
;;
;;	PAGE 1
;;
;;	65O2 STACK
;;
;;
;;
;;
;;	PAGE 2
;;
;;
;INTABS = $0200	;512 INTERRUPT RAM
;VDSLST = $0200	;512 NMI VECTOR
;VPRCED = $0202	;514 PROCEED LINE IRQ VECTOR
;VINTER = $0204	;516 INTERRUPT LINE IRQ VECTOR
;VBREAK = $0206	;518
;VKEYBD = $0208	;520
;VSERIN = $020A	;522 SERIAL INPUT READY IRQ
;VSEROR = $020C	;524 SERIAL OUTPUT READY IRQ
;VSEROC = $020E	;526 SERIAL OUTPUT COMPLETE IRQ
;VTIMR1 = $0210	;528 TIMER 1 IRQ
;VTIMR2 = $0212	;530 TIMER 2 IRQ
;VTIMR4 = $0214	;532 TIMER 4 IRQ
;VIMIRQ = $0216	;534 IRQ VECTOR
;CDTMV1 = $0218	;536 DOWN TIMER 1
;CDTMV2 = $021A	;538 DOWN TIMER 2
;CDTMV3 = $021C	;540 DOWN TIMER 3
;CDTMV4 = $021E	;542 DOWN TIMER 4
;CDTMV5 = $0220	;544 DOWN TIMER 5
;VVBLKI = $0222	;546
;VVBLKD = $0224	;548
;CDTMA1 = $0226	;550 DOWN TIMER 1 JSR ADDRESS
;CDTMA2 = $0228	;552 DOWN TIMER 2 JSR ADDRESS
;CDTMF3 = $022A	;554 DOWN TIMER 3 FLAG
;SRTIMR = $022B	;555 REPEAT TIMER
;CDTMF4 = $022C	;556 DOWN TIMER 4 FLAG
;INTEMP = $022D	;557 IAN'S TEMP
;CDTMF5 = $022E	;558 DOWN TIMER FLAG 5
;SDMCTL = $022F	;559 DMACTL SHADOW
;SDLSTL = $0230	;560 DISPLAY LIST POINTER
;SSKCTL = $0232	;562 SKCTL SHADOW
;;	 $0233	;563 (800) UNLISTED
;LCOUNT = $0233	;563 (XL) LOADER TEMP
;LPENH  = $0234	;564 LIGHT PEN HORIZONTAL
;LPENV  = $0235	;565 LIGHT PEN VERTICAL
;;	 $0236	;566 2 SPARE BYTES
;;	 $0238	;568 (800) SPARE, 2 BYTES
;RELADR = $0238	;568 (XL) LOADER
;CDEVIC = $023A	;570 DEVICE COMMAND FRAME BUFFER
;CAUX1  = $023C	;572 DEVICE COMMAND AUX 1
;CAUX2  = $023D	;573 DEVICE COMMAND AUX 2
;TEMP   = $023E	;574 TEMPORARY STORAGE
;ERRFLG = $023F	;575 DEVICE ERROR FLAG (EXCEPT TIMEOUT)
;DFLAGS = $0240	;576 FLAGS FROM DISK SECTOR 1
;DBSECT = $0241	;577 NUMBER OF BOOT DISK SECTORS
;BOOTAD = $0242	;578 BOOT LOAD ADDRESS POINTER
;COLDST = $0244	;580 COLD START FLAG, 1 = COLD START IN PROGRESS
;;	 $0245	;581 (800) SPARE
;RECLEN = $0245	;581 (XL) LOADER
;DSKTIM = $0246	;582 (800) DISK TIME OUT REGISTER
;;	;	;$0246	;582 (XL) RESERVED, 39 BYTES
;LINBUF = $0247	;583 (800) CHARACTER LINE BUFFER, 40 BYTES
;CHSALT = $026B	;619 (XL) CHARACTER SET POINTER
;VSFLAG = $026C	;620 (XL) FINE SCROLL TEMPORARY
;KEYDIS = $026D	;621 (XL) KEYBOARD DISABLE
;FINE   = $026E	;622 (XL) FINE SCROLL FLAG
;GPRIOR = $026F	;623 P/M PRIORITY AND GTIA MODES
;GTIA   = $026F	;623
;PADDL0 = $0270	;624 (XL) 3 MORE PADDLES, (800) 6 MORE PADDLES
;STICK0 = $0278	;632 (XL) 1 MORE STICK, (800) 3 MORE STICKS
;PTRIG0 = $027C	;636 (XL) 3 MORE PADDLE TRIGGERS, (800) 6 MORE
;STRIG0 = $0284	;644 (XL) 1 MORE STICK TRIGGER, (800) 3 MORE
;CSTAT  = $0288	;648 (800)
;WMODE  = $0289	;649
;BLIM   = $028A	;650
;;	;	;$028B	;651 5 SPARE BYTES
;NEWADR = $028E	;654 (XL)  LOADER RAM
;TXTROW = $0290	;656
;TXTCOL = $0291	;657
;TINDEX = $0293	;659 TEXT INDEX
;TXTMSC = $0294	;660
;TXTOLD = $0296	;662 OLD ROW AND OLD COL FOR TEXT, 2 BYTES
;;	;	;$0298	;664 4 SPARE BYTES
;TMPX1  = $029C	;668 (800)
;CRETRY = $029C	;668 (XL)  NUMBER OF COMMAND FRAME RETRIES
;SUBTMP = $029E	;670
;HOLD2  = $029F	;671
;DMASK  = $02A0	;672
;TMPLBT = $02A1	;673
;ESCFLG = $02A2	;674
;TABMAP = $02A3	;675 15 BYTE BIT MAP FOR TAB SETTINGS
;LOGMAP = $02B2	;690 4 BYTE LOGICAL LINE START BIT MAP
;INVFLG = $02B6	;694
;FILFLG = $02B7	;695 FILL DIRING DRAW FLAG
;TMPROW = $02B8	;696
;TMPCOL = $02B9	;697
;SCRFLG = $02BB	;699 SCROLL FLAG
;HOLD4  = $02BC	;700
;HOLD5  = $02BD	;701 (800)
;DRETRY = $02BD	;701 (XL)  NUMBER OF DEVICE RETRIES
;SHFLOC = $02BE	;702
;BOTSCR = $02BF	;703 24 NORM, 4 SPLIT
;PCOLR0 = $02C0	;704 3 MORE PLAYER COLOR REGISTERS
;COLOR0 = $02C4	;708 4 MORE GRAPHICS COLOR REGISTERS
;;	 $02C9	;713 (800) 23 SPARE BYTES
;RUNADR = $02C9	;713 (XL) LOADER VECTOR
;HIUSED = $02CB	;715 (XL) LOADER VECTOR
;ZHIUSE = $02CD	;717 (XL) LOADER VECTOR
;GBYTEA = $02CF	;719 (XL) LOADER VECTOR
;LOADAD = $02D1	;721 (XL) LOADER VECTOR
;ZLOADA = $02D3	;723 (XL) LOADER VECTOR
;DSCTLN = $02D5	;725 (XL) DISK SECTOR SIZ
;ACMISR = $02D7	;727 (XL) RESERVED
;KRPDER = $02D9	;729 (XL) KEY AUTO REPEAT DELAY
;KEYREP = $02DA	;730 (XL) KEY AUTO REPEAT RATE
;NOCLIK = $02DB	;731 (XL) KEY CLICK DISABLE
;HELPFG = $02DC	;732 (XL) HELP KEY FLAG
;DMASAV = $02DD	;733 (XL) SDMCTL (DMA) SAVE
;PBPNT  = $02DE	;734 (XL) PRINTER BUFFER POINTER
;PBUFSZ = $02DF	;735 (XL) PRINTER BUFFER SIZE
;GLBABS = $02E0	;736 GLOBAL VARIABLES, 4 SPARE BYTES
;RAMSIZ = $02E4	;740 PERMANENT START OF ROM POINTER
;MEMTOP = $02E5	;741 END OF FREE RAM
;MEMLO  = $02E7	;743
;;	 $02E9	;745 (800) SPARE
;HNDLOD = $02E9	;745 (XL) HANDLER LOADER FLAG
;DVSTAT = $02EA	;746 DEVICE STATUS BUFFER, 4 BYTES
;CBAUDL = $02EE	;750 CASSETTE BAUD RATE, 2 BYTES
;CRSINH = $02F0	;752 1 = INHIBIT CURSOR
;KEYDEL = $02F1	;753 KEY DELAY AND RATE
;CH1    = $02F2	;754
;CHACT  = $02F3	;755
;CHBAS  = $02F4	;756 CHARACTER SET POINTER
;NEWROW = $02F5	;757 (XL) DRAW DESTINATION
;NEWCOL = $02F6	;758 (XL) DRAW DESTINATION
;ROWINC = $02F8	;760 (XL)
;COLINC = $02F9	;761 (XL)
;CHAR   = $02FA	;762
;ATACHR = $02FB	;763 ATASCII CHARACTER FOR CIO
;CH     = $02FC	;764
;FILDAT = $02FC	;764 COLOR FOR SCREEN FILL
;DSPFLG = $02FE	;766 DISPLAY CONTROL CHARACTERS FLAG
;SSFLAG = $02FF	;767 DISPLAY START/STOP FLAFG
;;
;;
;;	PAGE 3
;;
;;
;;	RESIDENT DISK HANDLER/SIO INTERFACE
;;
;DCB    = $0300	;768 DEVICE CONTROL BLOCK
;DDEVIC = $0300	;768
;DUNIT  = $0301	;769
;DCOMND = $0302	;770
;DSTATS = $0303	;771
;DBUFLO = $0304	;772
;DBUFHI = $0305	;773
;DTIMLO = $0306	;774
;DBYTLO = $0308	;776
;DBYTHI = $0309	;777
;DAUX1  = $030A	;778
;DAUX2  = $030B	;779
;TIMER1 = $030C	;780 INITIAL TIMER VALUE
;ADDCOR = $030E	;782 (800) ADDITION CORRECTION
;JMPERS = $030E	;782 (XL) OPTION JUMPERS
;CASFLG = $030F	;783 CASSETTE MODE WHEN SET
;TIMER2 = $0310	;784 FINAL VALUE, TIMERS 1 & 2 DETERMINE BAUD RATE
;TEMP1  = $0312	;786
;TEMP2  = $0313	;787 (XL)
;;TEMP2 = $0314	;788 (800)
;PTIMOT = $0314	;788 (XL) PRINTER TIME OUT
;TEMP3  = $0315	;789
;SAVIO  = $0316	;790 SAVE SERIAL IN DATA PORT
;TIMFLG = $0317	;791 TIME OUT FLAG FOR BAUD RATE CORRECTION
;STACKP = $0318	;792 SIO STACK POINTER SAVE
;TSTAT  = $0319	;793 TEMPORARY STATUS HOLDER
;HATABS = $031A	;794 HANDLER ADDRESS TABLE, 38 BYTES
;MAXDEV = $0321	;801 MAXIMUM HANDLER ADDRESS INDEX
;PUPBT1 = $033D	;829 (XL) POWER-UP/RESET
;PUPBT2 = $033E	;830 (XL) POWER-UP/RESET
;PUPBT3 = $033F	;831 (XL) POWER-UP/RESET
;;
;;IOCB's
;;
;IOCB   = $0340	;832
;ICHID  = $0340	;832
;ICDNO  = $0341	;833
;ICCOM  = $0342	;834
;ICSTA  = $0343	;835
;ICBAL  = $0344	;836
;ICBAH  = $0345	;837
;ICPTL  = $0346	;838
;ICPTH  = $0347	;839
;ICBLL  = $0348	;840
;ICBLH  = $0349	;841
;ICAX1  = $034A	;842
;ICAX2  = $034B	;843
;ICAX3  = $034C	;844
;ICAX4  = $034D	;845
;ICAX5  = $034E	;846
;ICAX6  = $034F	;847
;;		 OTHER IOCB's, 112 BYTES
;
;PRNBUF = $03C0	;960 PRINTER BUFFER, 40 BYTES
;;	 $03E8	;1000 (800) 21 SPARE BYTES
;SUPERF = $03E8	;1000 (XL) SCREEN EDITOR
;CKEY   = $03E9	;1001 (XL) START KEY FLAG
;CASSBT = $03EA	;1002 (XL) CASSETTE BOOT FLAG
;CARTCK = $03EB	;1003 (XL) CARTRIDGE CHECKSUM
;ACMVAR = $03ED	;1005 (XL) RESERVED, 6 BYTES
;MINTLK = $03F9	;1017 (XL) RESERVED
;GINTLK = $03FA	;1018 (XL) CARTRIDGE INTERLOCK
;CHLINK = $03FB	;1019 (XL) HANDLER CHAIN, 2 BYTES
;CASBUF = $03FD	;1021 CASSETTE BUFFER, 131 BYTES TO $047F
;;
;;
;;	PAGE 4
;;
;;
;USAREA = $0480	;1152 128 SPARE BYTES
;;
;;	SEE APPENDIX C FOR PAGES 4 AND 5 USAGE
;;
;;
;;
;;
;;	PAGE 5
;;
;PAGE5  = $0500	;1280 127 FREE BYTES
;;	 $057E	;1406 129 FREE BYTES IF FLOATING POINT ROUTINES
;NOT USED
;;
;;FLOATING POINT NON-ZERO PAGE RAM, NEEDED ONLY IF FP IS USED
;;
;LBPR1  = $057E	;1406 LBUFF PREFIX 1
;LBPR2  = $05FE	;1534 LBUFF PREFIX 2
;LBUFF  = $0580	;1408 LINE BUFFER
;PLYARG = $05E0	;1504 POLYNOMIAL ARGUMENTS
;FPSCR  = $05E6	;1510 PLYARG+FPREC
;FPSCR1 = $05EC	;1516 FPSCR+FPREC
;FSCR   = $05E6	;1510 =FPSCR
;FSCR1  = $05EC	;1516 =FPSCR1
;LBFEND = $05FF	;1535 END OF LBUFF
;;
;;
;;	PAGE 6
;;
;;
;PAGE6  = $0600	;1536 256 FREE BYTES
;;
;;
;;	PAGE 7
;;
;;
;BOOTRG = $0700	;1792 PROGRAM AREA
;;
;;
;;	UPPER ADDRESSES
;;
;;
;RITCAR = $8000	;32768 RAM IF NO CARTRIDGE
;LFTCAR = $A000	;40960 RAM IF NO CARTRIDGE
;;C0PAGE= $C000	;49152 (800) EMPTY, 4K BYTES
;C0PAGE = $C000	;49152 (XL) 2K FREE RAM IF NO CARTRIDGE
;;	 $C800	;51200 (XL) START OF OS ROM
;CHORG2 = $CC00	;52224 (XL) INTERNATIONAL CHARACTER SET
;;
;;
;;	HARDWARE REGISTERS
;;
;;
;;	SEE REGISTER LIST FOR MORE INFORMATION
;;
;;
;HPOSP0 = $D000	;53248
;M0PF   = $D000	;53248
;SIZEP0 = $D008	;53256
;M0PL   = $D008	;53256
;SIZEM  = $D00C	;53260
;GRAFP0 = $D00D	;53261
;GRAFM  = $D011	;53265
;COLPM0 = $D012	;53266
;COLPF0 = $D016	;53270
;PRIOR  = $D01B	;53275
;GTIAR  = $D01B	;53275
;VDELAY = $D01C	;53276
;GRACTL = $D01D	;53277
;HITCLR = $D01E	;53278
;CONSOL = $D01F	;53279
;AUDF1  = $D200	;53760
;AUDC1  = $D201	;53761
;AUDCTL = $D208	;53768
;RANDOM = $D20A	;53770
;IRQEN  = $D20E	;53774
;SKCTL  = $D20F	;53775
;PORTA  = $D300	;54016
;PORTB  = $D301	;54017
;PACTL  = $D302	;54018
;PBCTL  = $D303	;54019
;DMACLT = $D400	;54272
;DLISTL = $D402	;54274
;HSCROL = $D404	;54276
;VSCROL = $D405	;54277
;CHBASE = $D409	;54281
;WSYNC  = $D40A	;54282
;VCOUNT = $D40B	;54283
;NMIEN  = $D40E	;54286
;
;;
;;
;;	FLOATING POINT MATH ROUTINES
;;
;;
;
;AFP    = $D800	;55296
;FASC   = $D8E6	;55526
;IFP    = $D9AA	;55722
;FPI    = $D9D2	;55762
;ZFR0   = $DA44	;55876
;ZF1    = $DA46	;55878
;FSUB   = $DA60	;55904
;FADD   = $DA66	;55910
;FMUL   = $DADB	;56027
;FDIV   = $DB28	;56104
;PLYEVL = $DD40	;56640
;FLD0R  = $DD89	;56713
;FLD0P  = $DD8D	;56717
;FLD1R  = $DD98	;56728
;FLD1P  = $DD9C	;56732
;FSTOR  = $DDA7	;56743
;FSTOP  = $DDAB	;56747
;FMOVE  = $DDB6	;56758
;EXP    = $DDC0	;56768
;EXP10  = $DDCC	;56780
;LOG    = $DECD	;57037
;LOG10  = $DED1	;57041
;
;;
;;
;;	OPERATING SYSTEM
;;
;;
;;	MODULE ORIGIN TABLE
;;
;CHORG  = $E000	;57344 CHARACTER SET, 1K
;VECTBL = $E400	;58368 VECTOR TABLE
;VCTABL = $E480	;58496 RAM VECTOR INITIAL VALUE TABLE
;CIOORG = $E4A6	;58534 CIO HANDLER
;INTORG = $E6D5	;59093 INTERRUPT HANDLER
;SIOORG = $E944	;59716 SIO DRIVER
;DSKORT = $EDEA	;60906 DISK HANDLER
;PRNORG = $EE78	;61048 PRINTER HANDLER
;CASORG = $EE78	;61048 CASSETTE HANDLER
;MONORG = $F0E3	;61667 MONITOR/POWER UP MODULE
;KBDORG = $F3E4	;62436 KEYBOARD/DISPLAY HANDLER
;;
;;
;;  VECTOR TABLE, CONTAINS ADDRESSES OF CIO ROUTINES IN THE
;;  FOLLOWING ORDER. THE ADDRESSES IN THE TABLE ARE TRUE ADDRESSES-1
;;
;;  ADDRESS + 0  OPEN
;;	   + 2  CLOSE
;;	   + 4  GET
;;	   + 6  PUT
;;	   + 8  STATUS
;;	   + A  SPECIAL
;;	   + C  JMP TO INITIALIZATION
;;	   + F  NOT USED
;;
;;
;EDITRV = $E400	;58368 EDITOR
;SCRENV = $E410	;58384 SCREEN
;KEYBDV = $E420	;58400 KEYBOARD
;PRINTV = $E430	;58416 PRINTER
;CASETV = $E440	;58432 CASSETTE
;;
;;	ROM VECTORS
;;
;DSKINV = $E453	;58451
;CIOV   = $E456	;58454
;SIOV   = $E459	;58457
;SYSVBV = $E45F	;58463
;VBIVAL = $E460	;58464 ADR AT VVBLKI
;XITVBV = $E462	;58466 EXIT VBI
;VBIXVL = $E463	;58467 ADR AT VVBLKD
;BLKBDV = $E471	;58481 MEMO PAD MODE
;WARMSV = $E474	;58484
;COLDSV = $E477	;58487

