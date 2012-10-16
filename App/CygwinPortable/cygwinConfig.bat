@echo off

rem This script is meant to be run by a vbs script in the
rem CygwinPortable root directory. If this is not the case,
rem uncomment the cd command below.
rem Change to the root of the CygwinPortable directory
rem cd ..\..

rem Find the USB stick's drive letter and the path for the Cygwin directory
rem CYGROOT will be something like E:\PortableApps\CygwinPortable\
rem USBDRV will be something like E:
SET CYGROOT=%cd%\
SET USBDRV=%~d0

start %CYGROOT%cygwinConfig.exe -R %CYGROOT% -l %CYGROOT%packages -n
rem cd App/CygwinPortable