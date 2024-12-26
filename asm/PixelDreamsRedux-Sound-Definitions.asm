;	@com.wudsn.ide.lng.mainsourcefile=PixelDreamsRedux.asm

	.enum sound_quality
	full = 1
	half = 2
	.ende

	.enum sound_mode
	covox = 1
	pokey = 2
	.ende

; PCM U8 16khz
sound_block_size  = cart_size
sound_block_start = cart_start
sound_block_end = sound_block_start+sound_block_size

	.if ACTIVE_SOUND_QUALITY = sound_quality.full
sound_file_size = .filesize "../snd/PixelDreamsRedux-Sound-Data-COVOX.bin"
	.else
sound_file_size = .filesize "../snd/PixelDreamsRedux-Sound-Data-COVOX-half.bin"
	.endif

sound_file_blocks = ( sound_file_size + sound_block_size - 1)/sound_block_size
sound_start_bank_number = $10

sample_start = sound_block_start
	.echo "File size ",sound_file_size, " equals ",sound_file_blocks," blocks of ",sound_block_size, " bytes."
