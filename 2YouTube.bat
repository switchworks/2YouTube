@echo off
cls
if %1 == "" exit
if EXIST "C:\ffmpeg\bin\" (
	ECHO found ffmpeg at C:\ffmpeg
	SET ffmpeg=C:\ffmpeg\bin\
	goto FOUND_FFMPEG
) else if EXIST "C:\Program Files (x86)\ffmpeg\bin\" (
	ECHO found ffmpeg at C:\Program Files(x86)
	SET "ffmpeg=C:\Program Files (x86)\ffmpeg\bin\"
	goto FOUND_FFMPEG
) else if EXIST "C:\Program Files\ffmpeg\bin\" (
	ECHO found ffmpeg at C:\Program Files
	SET "ffmpeg=C:\Program Files\ffmpeg\bin\"
	goto FOUND_FFMPEG
) else (
	ECHO Please install ffmpeg.
	timeout /t 10 /nobreak
	exit
)

:FOUND_FFMPEG
if EXIST "%~n1.png" (
	ECHO found image "%~n1.png"
	SET "img=%~n1.png"
	goto FOUND_IMAGE
) else if EXIST "%~n1.jpeg" (
	ECHO found image "%~n1.jpeg"
	SET "img=%~n1.jpeg"
	goto FOUND_IMAGE
) else if EXIST "%~n1.jpeg" (
	ECHO found image "%~n1.jpeg"
	SET "img=%~n1.jpeg"
	goto FOUND_IMAGE
) else if EXIST "%~n1.bmp" (
	ECHO found image "%~n1.bmp"
	SET "img=%~n1.bmp"
	goto FOUND_IMAGE
) else (
	ECHO use default image
	SET "img=default.png"
)

:FOUND_IMAGE
echo %1
for /f "usebackq tokens=1" %%i in (`%ffmpeg%ffprobe.exe -i "%img%" -loglevel quiet -show_frames -show_entries frame^=width ^| findstr /b /c:"width"`) do set width=%%i
set width=%width:~6%
for /f "usebackq tokens=1" %%i in (`%ffmpeg%ffprobe.exe -i "%img%" -loglevel quiet -show_frames -show_entries frame^=height ^| findstr /b /c:"height"`) do set height=%%i
set height=%height:~7%
for /f "usebackq tokens=1" %%i in (`%ffmpeg%ffprobe.exe -i %1 -loglevel quiet -show_entries format^=duration ^| findstr /b /c:"duration"`) do set duration=%%i
set duration=%duration:~9%
%ffmpeg%ffmpeg.exe -loop 1 -r 1 -i "%img%" -i %1 -vcodec libx264 -acodec aac -strict experimental -ab 256k -ac 2 -ar 44100 -pix_fmt yuv420p -r 30 -s %width%x%height% -t %duration% "%~n1.mp4"
