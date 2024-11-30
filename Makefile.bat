@rem Run via launch configuration from within WUDSN IDE to see the full logs.
@echo off
call Make-Settings.bat
echo Building release %RELEASE% (%RELEASE_LOWERCASE%)

set THECART_CAR_FILE=%RELEASE%-TheCart.car

cd %BASE_DIR%

java -cp java\bin com.wudsn.productions.atari800.demos.pixeldreamsredux.SoundConverter snd\PixelDreamsRedux-NR-PCM-U8-15625kHz.raw snd\PixelDreamsRedux-Sound-Data-COVOX.bin snd\PixelDreamsRedux-Sound-Data-POKEY.bin
if ERRORLEVEL 1 goto :sound_converter_error

set OUTPUT_TYPE=COVOX
set SOUND_MODE=1
call :make_output

set OUTPUT_TYPE=POKEY
set SOUND_MODE=2
call :make_output

call :make_thecart

start %THECART_CAR_FILE%
goto :eof


:make_output
rem Make main file
call :make %RELEASE%.rom
set CAR_TYPE=64
set CAR_FILE=%RELEASE%-MegaCart-2-MB-%OUTPUT_TYPE%.car
if exist %CAR_FILE% del %CAR_FILE% 
java -jar build\AtariROMMaker.jar -load:asm\%OUTPUT_FILE% -convertToCar:%CAR_TYPE% -save:%CAR_FILE%
if not exist %CAR_FILE% goto :rom_maker_error

set TCD_CAR_FILE=export\%RELEASE%.tcd\%CAR_FILE%
copy /B/Y %CAR_FILE% %TCD_CAR_FILE%
java -jar .\build\TheCartStudio.jar -open:export\%RELEASE%.tcw -addEntries:%TCD_CAR_FILE% -save -exportToCarImage:%THECART_CAR_FILE% -exportToAtrImage:export\atr\%RELEASE%.atr
if ERRORLEVEL 1 goto :studio_error
goto :eof

:make_thecart
java -jar .\build\TheCartStudio.jar -open:export\%RELEASE%.tcw -exportToCarImage:%THECART_CAR_FILE% -exportToAtrImage:export\atr\%RELEASE%.atr
if ERRORLEVEL 1 goto :studio_error
goto :eof

:make
cd asm
set OUTPUT_FILE=%1
echo Assembling %OUTPUT_FILE%.
if exist %OUTPUT_FILE% del %OUTPUT_FILE% 
%MADS% -d:ACTIVE_SOUND_MODE=%SOUND_MODE% -s %RELEASE%.asm -o:%OUTPUT_FILE%
if ERRORLEVEL 1 goto :mads_error
cd ..
goto :eof

:sound_converter_error
echo ERROR: SoundConverter errors occurred. Check error messages above.
exit

:mads_error
echo ERROR: MADS compilation errors occurred. Check error messages above.
exit

:rom_maker_error
echo ERROR: AtariROMMaker errors occurred. Check error messages above.
exit

:studio_error
echo ERROR: The!Cart Studio errors occurred. Check error messages above.
exit

