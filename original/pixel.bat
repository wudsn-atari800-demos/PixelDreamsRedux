@echo off
cd %~dp0
set ORIGINAL_DIR=%CD%

set HATARI=C:\jac\system\AtariFalcon\Tools\EMU\hatari\hatari.exe
set EXECUTABLE=pixel
set AVI_FILE=%ORIGINAL_DIR%\video\%EXECUTABLE%.avi
set SCREEENSHOTS_DIR=%ORIGINAL_DIR%\screenshots

REM Remove comment to record and AVI video.
REM set OPTIONS=--avirecord --avi-vcodec bmp --avi-fps 50 --avi-file %AVI_FILE% 

%HATARI% --configfile pixel.config %OPTIONS% --screenshot-dir %SCREEENSHOTS_DIR% %ORIGINAL_DIR%\%EXECUTABLE%.prg
if errorlevel 1 goto :hatari_error
goto :eof

:hatari_error:
echo "HATARI error. See error messages above."
pause
goto :eof
