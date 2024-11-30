@echo off
cd "%~dp0"
call ..\Make-Settings.bat
IF ERRORLEVEL 1 goto :dir_error

cd %BASE_DIR%

echo Starting site build.
if not exist %SITE_DIR% goto :site_error

REM Target directory
set TARGET_DIR=%SITE_DIR%\productions\atari800\%RELEASE_LOWERCASE%
if not exist %TARGET_DIR% mkdir %TARGET_DIR%

REM Target file name prefix
set TARGET_NAME=%TARGET_DIR%\%RELEASE_LOWERCASE%

REM Make target.zip
set TARGET=%TARGET_NAME%.zip
call :cleanup asm
call Makefile.bat
if errorlevel 1 goto :make_error
call :cleanup asm
if exist export\atr\*.*           del /Q export\atr\*.*
if exist original\screenshots\*.* del /Q original\screenshots\*.*
if exist original\video\*.*       del /Q original\video\*.*
if exist export\snd\*.bin         del /Q export\snd\*.bin

echo * >site\%RELEASE%\.gitignore
copy %RELEASE%*.car site\%RELEASE%\
copy %RELEASE%.nfo site\%RELEASE%\%RELEASE%.nfo
copy %RELEASE%.png site\%RELEASE%\%RELEASE%.png
copy %RELEASE%.nfo %TARGET_NAME%.nfo
if exist %RELEASE%.gif copy %RELEASE%.gif %TARGET_NAME%.gif
if exist %RELEASE%.jpg copy %RELEASE%.jpg %TARGET_NAME%.jpg
echo [url=https://www.wudsn.com/productions/atari800/%RELEASE_LOWERCASE%/%RELEASE_LOWERCASE%.zip]download[/url]       >%TARGET_DIR%\pouet.txt
echo [url=https://www.wudsn.com/productions/atari800/%RELEASE_LOWERCASE%/%RELEASE_LOWERCASE%-source.zip]source[/url] >>%TARGET_DIR%\pouet.txt
echo [url=https://www.wudsn.com/productions/atari800/%RELEASE_LOWERCASE%/%RELEASE_LOWERCASE%-video.zip]video[/url]   >>%TARGET_DIR%\pouet.txt
echo [url=https://www.wudsn.com/productions/atari800/%RELEASE_LOWERCASE%/%RELEASE_LOWERCASE%.nfo]nfo[/url]           >>%TARGET_DIR%\pouet.txt
echo [url=https://www.wudsn.com/productions/atari800/%RELEASE_LOWERCASE%/%RELEASE_LOWERCASE%.jpg]screen shot[/url]   >>%TARGET_DIR%\pouet.txt


if not exist site\%RELEASE% mkdir site\%RELEASE%
cd site\%RELEASE%
if exist %TARGET% del %TARGET%
%WINRAR% a -r -afzip -x.gitignore %TARGET% *.*
cd ..\..
REM start %TARGET%

REM Make target-source.zip
set TARGET=%TARGET_NAME%-source.zip

cd..
if exist %TARGET% del %TARGET%
%WINRAR% a -afzip -x*.car -x*.zip %TARGET% %RELEASE%\*.* %RELEASE%\asm %RELEASE%\build %RELEASE%\export %RELEASE%\gfx %RELEASE%\images %RELEASE%\java %RELEASE%\launch %RELEASE%\original %RELEASE%\snd %RELEASE%\site\Makefile-Site.bat
REM start %TARGET%
cd %RELEASE%\site
start %TARGET_DIR%

call %SITE_DIR%\productions\www\site\export\upload.bat productions/atari800/%RELEASE_LOWERCASE%
IF ERRORLEVEL 1 goto :site_error
goto :eof


:cleanup
if exist %1\*.xex   del %1\*.xex
if exist %1\*.rom   del %1\*.rom
if exist %1\*.lst   del %1\*.lst
if exist %1\*.lab   del %1\*.lab
if exist %1\*.atdbg del %1\*.atdbg
goto :eof

:site_error
echo ERROR: Invalid site directory or site error.
exit /b

:dir_error
echo ERROR: Invalid working directory.
exit /b

:make_error
echo ERROR: Makefile errors occurred. Check error message above.
exit /b