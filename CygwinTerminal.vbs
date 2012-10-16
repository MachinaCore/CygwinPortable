Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c App\CygwinPortable\CygwinTerminal.bat"
oShell.Run strArgs, 0, false