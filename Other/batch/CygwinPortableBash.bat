@echo off
set PATH=%~dp0\bin\;%PATH%
%~dp0\bin\bash.exe --login -i -c 'cd c:;exec /bin/bash.exe'