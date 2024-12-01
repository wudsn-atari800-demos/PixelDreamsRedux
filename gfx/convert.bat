@echo off
cd %~dp0
set MAGICK="C:\Program Files\ImageMagick-7.1.0-Q16-HDRI\magick.exe"

call :convert_bw_image desktop-01
call :convert_bw_image desktop-02

call :convert_desktop_section desktop-03
call :convert_desktop_section desktop-04
call :convert_desktop_section desktop-05
call :convert_desktop_section desktop-06
call :convert_desktop_section desktop-07
call :convert_desktop_section desktop-08
call :convert_desktop_section desktop-09
call :convert_desktop_section desktop-10

call :convert_bw_image desktop-11

call :convert_bw_image intro-01
call :convert_bw_image intro-02
call :convert_bw_image intro-03
call :convert_bw_image intro-04

call :convert_bw_image lyrics

call :convert_color_image main-01
call :convert_color_image main-02
call :convert_color_image main-03
call :convert_color_image main-04

call :convert_bw_image outro-01
call :convert_bw_image outro-02
call :copy_mask_image  outro-02-mask
goto :eof


:convert_bw_image
set IMAGE=%1
echo Converting black/white %IMAGE%
set COMMON=-threshold 30%
%MAGICK% full/%IMAGE%.png %COMMON% -colors 2 gr8/%IMAGE%.png
goto :eof

:convert_desktop_section
echo Converting desktop section %IMAGE%
set IMAGE=%1
set COMMON=-threshold 50% -monochrome
%MAGICK% full/%IMAGE%.png -crop "320x91+0+56" -colors 2 gr8/%IMAGE%.png
goto :eof

:copy_mask_image
set IMAGE=%1
echo Copying %IMAGE%
set COMMON=
%MAGICK% full/%IMAGE%.png %COMMON% gr8/%IMAGE%.png
goto :eof

:convert_color_image
set IMAGE=%1
echo Converting color %IMAGE%
set COMMON=-seed 100 -crop 320x180+0+0 -dither FloydSteinberg -quantize sRGB
%MAGICK% full/%IMAGE%.png %COMMON% -resize 160x180! -colors 4 gr15/%IMAGE%.png
%MAGICK% full/%IMAGE%.png %COMMON% -resize 80x180!  -colors 8 gr10/%IMAGE%.png
goto :eof
