@echo off

rem Run this file in cmd.exe or tcc.exe to change
rem Title of console window.

rem Note!
rem "Inject ConEmuHk" and "ANSI X3.64" options
rem must be turned ON in ConEmu Settings!

echo ]2;"%~1"\
prompt $e]2;"%~1"$e\$p$g
