@echo off

SET ILMERGE=0
SET NSISLAUNCHER=1
SET SEVENZIP=1
SET PORTABLEAPPSINSTALLER=1
SET CONEMU=1
SET CYGWIN=1

CALL "%VS140COMNTOOLS%vsvars32.bat"

REM ---------------------------------------------------------------------
echo Get Version
REM ---------------------------------------------------------------------
set APPINFOINI=App\AppInfo\appinfo.ini
set APPINFOSECTION=Version
set APPINFOKEY=DisplayVersion

for /f "delims=:" %%a in ('findstr /binc:"[%APPINFOSECTION%]" "%APPINFOINI%"') do (
  for /f "tokens=1* delims==" %%b in ('more +%%a^<"%APPINFOINI%"') do (
    set "APPINFOKEY=%%b"
    set "APPINFOVERSION=%%c"
    setlocal enabledelayedexpansion
    if "!APPINFOKEY:~,1!"=="[" (endlocal&goto notFound)
    if /i "!APPINFOKEY!"=="%APPINFOKEY%" (endlocal&goto found)
    endlocal
  )
) 

:notFound
set APPINFOVERSION=0.0.0.0

:found
echo %APPINFOVERSION%

REM ---------------------------------------------------------------------
echo Compiling
REM ---------------------------------------------------------------------
devenv %CD%\CygwinPortable.sln /Clean
devenv %CD%\CygwinPortable.sln /Rebuild "Release|Any CPU"

REM ---------------------------------------------------------------------
echo IlMerge Files
REM ---------------------------------------------------------------------
if %ILMERGE%==1 (
del "%CD%\App\CygwinPortableMerge.exe"
"C:\Program Files (x86)\Microsoft\ILMerge\ILMerge.exe"^
 /ndebug^
 /copyattrs^
 /targetplatform:4.0,"C:\Windows\Microsoft.NET\Framework64\v4.0.30319"^
 /out:"%CD%\App\CygwinPortableMerge.exe"^
 "%CD%\App\CygwinPortable.exe"^
 "%CD%\App\SharpConfig.dll"
del "%CD%\App\SharpConfig.dll"
del "%CD%\App\CygwinPortable.exe"
ren "%CD%\App\CygwinPortableMerge.exe" CygwinPortable.exe
)


REM ---------------------------------------------------------------------
echo Prepare Release
REM ---------------------------------------------------------------------
rmdir /s /q Release
mkdir Release
robocopy App\ *.exe Release\App\
robocopy App\ *.config Release\App\
robocopy App\ *.pdb Release\App\
robocopy App\ *.dll Release\App\
robocopy App\AppInfo Release\App\AppInfo /s /e
robocopy App\DefaultData Release\App\DefaultData /s /e
robocopy Other Release\Other /s /e
if %CONEMU%==1 (
robocopy App\RuntimeClean\ConEmu Release\App\Runtime\ConEmu /s /e
)
if %CYGWIN%==1 (
robocopy App\RuntimeClean\Cygwin_x64 Release\App\Runtime\Cygwin /s /e
)

copy help.html Release\help.html

REM ---------------------------------------------------------------------
echo Create NSIS Launcher
REM ---------------------------------------------------------------------
if %NSISLAUNCHER%==1 (
del "%CD%\Other\source\CygwinPortable.exe"
..\NSISPortable\App\NSIS\makensis.exe Other\source\CygwinPortable.nsi
copy Other\source\CygwinPortable.exe "%CD%\Release\CygwinPortable.exe"
)

REM ---------------------------------------------------------------------
echo 7zip Archive
REM ---------------------------------------------------------------------
if %SEVENZIP%==1 (
del "%CD%\CygwinPortable_%APPINFOVERSION%_x64.7z"
..\7-ZipPortable\App\7-Zip\7z.exe a -r -t7z -mx=9 CygwinPortable_%APPINFOVERSION%_x64.7z .\Release\*
)

REM ---------------------------------------------------------------------
echo Create PortableApps Installer
REM ---------------------------------------------------------------------

del "%CD%\CygwinPortable_%APPINFOVERSION%_x64.paf.exe"

if %PORTABLEAPPSINSTALLER%==1 (
..\CybeSystems.comAppInstaller\PortableApps.comInstaller.exe "%CD%\Release"
)

ren "%CD%\CygwinPortable_%APPINFOVERSION%.paf.exe" CygwinPortable_%APPINFOVERSION%_x64.paf.exe

REM ---------------------------------------------------------------------
echo Ready
REM ---------------------------------------------------------------------
pause