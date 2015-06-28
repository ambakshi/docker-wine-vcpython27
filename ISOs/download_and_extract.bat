::@echo off
::
:: Downloads VS2013 Pro, Winows7.1 SDK and uses Chromium's
:: toolchain2013.py to extract and repack it into vs2013.7z
:: This is then used to populate the docker container
::
setlocal EnableExtensions 
cd /d "%~dp0"

set PATH=%CD%\..\7z;%PATH%;C:\Python27;C:\Python27\Scripts
set TEMP=%~d0\dtmp
set TMP=%TEMP%
set OUTPUT=%TMP%\o

if not exist %TEMP% mkdir %TEMP%

:: Visual Studio 2013 Prof.
if not exist VS2013_RTM_PRO_ENU.ISO (
    call :pswget http://download.microsoft.com/download/A/F/1/AF128362-A6A8-4DB3-A39A-C348086472CC/VS2013_RTM_PRO_ENU.iso VS2013_RTM_PRO_ENU.IS_
    if ERRORLEVEL 1 goto FAIL
    if exist VS2013_RTM_PRO_ENU.ISO del /f /q VS2013_RTM_PRO_ENU.ISO
    rename VS2013_RTM_PRO_ENU.IS_ VS2013_RTM_PRO_ENU.ISO
)

:: Windows 8 SDK
if not exist Standalone (
    del /f /q sdk_setup.exe
    call :pswget http://download.microsoft.com/download/F/1/3/F1300C9C-A120-4341-90DF-8A52509B23AC/standalonesdk/sdksetup.exe sdk_setup.exe
    if ERRORLEVEL 1 goto FAIL
    if exist _Standalone rmdir /s /q _Standalone
    mkdir _Standalone
    start "foo" /wait sdksetup.exe /quiet /features OptionId.WindowsDesktopDebuggers OptionId.WindowsDesktopSoftwareDevelopmentKit /layout _Standalone
    if ERRORLEVEL 1 goto FAIL
    mkdir Standlone
    rename _Standalone Standalone
)

:: Windows 7.1 SDK
if not exist GRMWDK_EN_7600_1.ISO (
    call :pswget http://download.microsoft.com/download/4/A/2/4A25C7D5-EFBE-4182-B6A9-AE6850409A78/GRMWDK_EN_7600_1.ISO GRMWDK_EN_7600_1.IS_
    if ERRORLEVEL 1 goto FAIL
    if exist GRMWDK_EN_7600_1.ISO del /f /q GRMWDK_EN_7600_1.ISO
    rename GRMWDK_EN_7600_1.IS_ GRMWDK_EN_7600_1.ISO
)

if not exist %OUTPUT% mkdir %OUTDIR%

python.exe toolchain2013.py --noclean --local=%~dp0 --targetdir=%OUTPUT%\vs2013
if ERRORLEVEL 1 goto FAIL


cd /d %OUTPUT%
7z.exe a -r vs2013.7z data.json vs2013
if ERRORLEVEL 1 goto FAIL
popd
popd
set OUTZIP=%1
if "x%1x"=="xx" set OUTZIP=%CD%\..
copy /y %OUTPUT%\vs2013.7z %OUTZIP%

exit 0

:pswget
echo Downloading %1 to %2 ...
powershell -NoProfile -ExecutionPolicy unrestricted -Command "(New-Object System.Net.WebClient).DownloadFile('%1','%2')"
exit /b %errorlevel%

:FAIL
echo ERROR
exit 2
