@echo off

SET ILMERGE=0
SET NSISLAUNCHER=1

CALL "%VS140COMNTOOLS%vsvars32.bat"

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
copy help.html Release\help.html

REM ---------------------------------------------------------------------
echo Create NSIS Launcher
REM ---------------------------------------------------------------------
if %ILMERGE%==1 (
del "%CD%\Other\source\CygwinPortable.exe"
..\NSISPortable\App\NSIS\makensis.exe Other\source\CygwinPortable.nsi
copy Other\source\CygwinPortable.exe Release\CygwinPortable.exe
)
REM ---------------------------------------------------------------------
echo Create NSIS Launcher
REM ---------------------------------------------------------------------
del "%CD%\Other\source\CygwinPortable.exe"
..\NSISPortable\App\NSIS\makensis.exe Other\source\CygwinPortable.nsi

REM ---------------------------------------------------------------------
echo Ready
REM ---------------------------------------------------------------------
pause