Set oShell = CreateObject ("Wscript.Shell") 
Dim strArgs
strArgs = "cmd /c App\CygwinPortable\XWinServer.bat"
oShell.Run strArgs, 0, false
MsgBox "When you are done, remember to exit the X server by right-clicking its icon in the system tray.",0,"XWin"