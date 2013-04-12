#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=App\AppInfo\appicon1.ico
#AutoIt3Wrapper_Compression=4
#AutoIt3Wrapper_Res_Description=CygwinPortable
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.8
#AutoIt3Wrapper_Res_LegalCopyright=CybeSystems
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_File_Add=resources/cs_sidebar.bmp, rt_bitmap, CYBESYSTEMS_SIDEBAR
#EndRegion ;**** Directives created by AutoIt3Wrapper_GUI ****
#Region AutoIt3Wrapper directives section
;===============================================================================================================
;** AUTOIT3 settings
#AutoIt3Wrapper_Run_Debug_Mode=n                ;(Y/N)Run Script with console debugging. Default=N
;===============================================================================================================
;** AUT2EXE settings
;===============================================================================================================
;** Target program Resource info
;===============================================================================================================
; Obfuscator
;===============================================================================================================
#EndRegion AutoIt3Wrapper directives section

#include <File.au3>
#Include <Array.au3>
#include <Process.au3>
#include "resources\resources.au3"
#include "resources\_ModernMenuRaw.au3"
#include "resources\_SysTray.au3"

EnvSet("PATH",  @ScriptDir & "\bin")
EnvSet("ALLUSERSPROFILE",  "C:\ProgramData")
EnvSet("ProgramData",  "C:\ProgramData")
EnvSet("CYGWIN",  "nodosfilewarning")
EnvSet("HOME",  "/home/cygwin")

Run(@ScriptDir & "\bin\bash /Other/user_setup.sh", @SW_HIDE)

Global $szDrive, $szDir, $szFName, $szExt, $cygdrive,$cygfolder,$cygfolder1,$cygfile, $executableExtension, $executable, $exitAfterExec, $setContextMenu, $cygwinUsername

$executable = False
$exitAfterExec = True
$setContextMenu = False
$cygwinNoMsgBox = False

Local $iniMain = IniReadSection(@ScriptDir & "\CygwinPortable.ini", "Main")
If @error Then
	MsgBox(4096, "", "CygwinPortable.ini not found")
Else
	For $iniMainValue = 1 To $iniMain[0][0]
		;Close console after execution ?
		if $iniMain[$iniMainValue][0] == 'ExitAfterExec' Then
			$exitAfterExec = $iniMain[$iniMainValue][1]
		EndIf
		if $iniMain[$iniMainValue][0] == 'SetContextMenu' Then
			$setContextMenu = $iniMain[$iniMainValue][1]
		EndIf
		if $iniMain[$iniMainValue][0] == 'Username' Then
			$cygwinUsername = $iniMain[$iniMainValue][1]
			EnvSet("HOME",  "/home/" & $cygwinUsername)
		EndIf
		if $iniMain[$iniMainValue][0] == 'TrayMenu' Then
			$cygwinTrayMenu = $iniMain[$iniMainValue][1]
		EndIf
		if $iniMain[$iniMainValue][0] == 'NoMsgBox' Then
			$cygwinNoMsgBox = $iniMain[$iniMainValue][1]
		EndIf
	Next
EndIf

ReadCmdLineParams()

Global $tray_ReStartApache,$tray_phpMyAdmin,$AppsStopped,$tray_TrayExit,$tray_menu_seperator,$tray_menu_seperator2,$nSideItem3,$nTrayIcon1,$nTrayMenu1,$tray_openCygwinConfig,$tray_sub_QuickLaunch,$tray_sub_Drives,$tray_sub_QuickLink,$tray_menu_seperator_quick_launch,$tray_openXServer

if $cygwinTrayMenu == True and $CmdLine[0] == 0 Then
BuildTrayMenu()
BuildMenu()
While 1
	Sleep(1000)
WEnd
EndIf

if $setContextMenu == True Then
	cygwinSetContextMenu()
Else
	cygwinUnSetContextMenu()
EndIf


Func MenuRebuild()
	DeleteMenu()
	BuildMenu()
EndFunc   ;==>MMOwningRebuild

Func DeleteMenu()
	_TrayDeleteItem($tray_openCygwinConfig)
	_TrayDeleteItem($tray_TrayExit)
	_TrayDeleteItem($tray_menu_seperator)
	_TrayDeleteItem($tray_menu_seperator2)
	_TrayDeleteItem($tray_phpMyAdmin)
	_TrayDeleteItem($tray_openXServer)
	_TrayDeleteItem($tray_ReStartApache)
	_TrayDeleteItem($tray_sub_QuickLaunch)
	_TrayDeleteItem($tray_sub_Drives)
	_TrayDeleteItem($tray_sub_QuickLink)
EndFunc   ;==>DeleteMenu

Func BuildTrayMenu()
	Opt("GUIOnEventMode", 1)
	$nTrayIcon1 = _TrayIconCreate("CygwinPortable.exe", "CygwinPortable.exe", "MMO_ICON")
	$nTrayMenu1 = _TrayCreateContextMenu()
	$nSideItem3 = _CreateSideMenu($nTrayMenu1)
	_SetSideMenuText($nSideItem3, "CygwinPortable")
	_SetSideMenuColor($nSideItem3, 0x00FFFF)
	_SetSideMenuBkColor($nSideItem3, 0xb6b6b6)
	_SetSideMenuBkGradColor($nSideItem3, 0xb6b6b6)
	_SetTrayBkColor(0xe6e6e6)
	_SetTrayIconBkColor(0xe6e6e6)
	_SetTraySelectBkColor(0xb5b6b6)
	_SetTraySelectTextColor(0xffffff)
	_SetSideMenuImage($nSideItem3, "CygwinPortable.exe", "CYBESYSTEMS_SIDEBAR")
EndFunc

Func BuildMenu()

	$tray_sub_QuickLaunch = _TrayCreateMenu("Scripte")
	_TrayItemSetIcon(-1, @ScriptDir & "\App\AppInfo\appicon1.ico")

	$FolderList=_FileListToArray(@ScriptDir & "\quicklaunch\", "*")
	If Not @error Then
		$count = $FolderList[0]
		for $x = 1 to $count
			_PathSplit(@ScriptDir & "\quicklaunch\" & $FolderList[$x], $szDrive, $szDir, $szFName, $szExt)
			if $szExt <> ".ico" and $szExt <> ".lnk" Then
				local $quicklaunch = _TrayCreateItem($FolderList[$x], $tray_sub_QuickLaunch)
				If FileExists(@ScriptDir & "\quicklaunch\" & $FolderList[$x] & ".ico") then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\quicklaunch\" & $FolderList[$x] & ".ico")
				ElseIf $szExt == '.sh' Then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\App\AppInfo\appicon1.ico")
				ElseIf $szExt == '.bat' Then
					_TrayItemSetIcon($quicklaunch, "shell32.dll", -72)
				ElseIf $szExt == '.exe' Then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\quicklaunch\" & $FolderList[$x])
				Else
					_TrayItemSetIcon($quicklaunch, "shell32.dll", -3)

				EndIf
				GUICtrlSetOnEvent(-1, "cygwinOpenGuiQuicklaunch")
			EndIf
			if $szExt == ".lnk" Then
				Local $aDetails = FileGetShortcut(@ScriptDir & "\quicklinks\" & $FolderList[$x])
				If Not @error Then
					if $szExt == ".lnk" Then
						local $quicklink = _TrayCreateItem($szFName, $tray_sub_QuickLaunch)
						;_TrayItemSetIcon($quicklink, $aDetails[4])
						_TrayItemSetIcon($quicklink, $aDetails[0])
						ConsoleWrite($aDetails[5])
					EndIf
					GUICtrlSetOnEvent(-1, "cygwinOpenGuiQuickkinks")
				EndIf
			EndIf

		Next
	EndIf

	$tray_sub_QuickLink = _TrayCreateMenu("Shortcuts")
	_TrayItemSetIcon(-1, "shell32.dll", -264)

	$QuickLinksFolderList=_FileListToArray(@ScriptDir & "\quicklinks\", "*")
	If Not @error Then
		$count = $QuickLinksFolderList[0]
		for $x = 1 to $count
			_PathSplit(@ScriptDir & "\quicklinks\" & $QuickLinksFolderList[$x], $szDrive, $szDir, $szFName, $szExt)
			Local $aDetails = FileGetShortcut(@ScriptDir & "\quicklinks\" & $QuickLinksFolderList[$x])
			If Not @error Then
				if $szExt == ".lnk" Then
					local $quicklink = _TrayCreateItem($szFName, $tray_sub_QuickLink)
					;_TrayItemSetIcon($quicklink, $aDetails[4])
					_TrayItemSetIcon($quicklink, $aDetails[0])
					ConsoleWrite($aDetails[5])
				EndIf
				GUICtrlSetOnEvent(-1, "cygwinOpenGuiQuickkinks")
			EndIf
		Next
	EndIf

	$tray_sub_Drives = _TrayCreateMenu("Drives")
	_TrayItemSetIcon(-1, "shell32.dll", -9)

	$DriveArray = DriveGetDrive("all")
	If Not @error Then
		$DriveInfo = ""
		For $DriveCount = 1 To $DriveArray[0]
			local $quickdrive = _TrayCreateItem(StringUpper($DriveArray[$DriveCount]), $tray_sub_Drives)
			_TrayItemSetIcon($quickdrive, "shell32.dll", -9)
			GUICtrlSetOnEvent(-1, "cygwinOpenGuiDrive")
		Next
	EndIf

	$tray_menu_seperator = _TrayCreateItem("")
	_TrayItemSetIcon($tray_menu_seperator, "", 0)

	$tray_phpMyAdmin = _TrayCreateItem("phpMyAdmin")
	_TrayItemSetIcon($tray_phpMyAdmin, "shell32.dll", -15)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openXServer = _TrayCreateItem("open XServer")
	_TrayItemSetIcon($tray_openXServer, "shell32.dll", -15)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openCygwinConfig = _TrayCreateItem("Open Cygwin Setup")
	_TrayItemSetIcon($tray_openCygwinConfig, "shell32.dll", -58)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_menu_seperator2 = _TrayCreateItem("")
	_TrayItemSetIcon($tray_menu_seperator2, "", 0)

	$tray_TrayExit = _TrayCreateItem("Beenden")
	_TrayItemSetIcon($tray_TrayExit, "shell32.dll", -28)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	_TrayIconSetState()
	;TrayMenuRightClick()
EndFunc   ;==>BuildMenu

Func cygwinOpenGuiQuicklaunch()
	cygwinOpen(@ScriptDir & "\quicklaunch\" & _GetMenuText(@GUI_CtrlId))
EndFunc   ;==>TrayEvent

Func cygwinOpenGuiDrive()
	cygwinOpen(_GetMenuText(@GUI_CtrlId))
EndFunc   ;==>TrayEvent

Func cygwinOpenGuiQuickkinks()
	$QuickLinksFolderList=_FileListToArray(@ScriptDir & "\quicklinks\", "*")
	$count = $QuickLinksFolderList[0]
	for $x = 1 to $count
		_PathSplit(@ScriptDir & "\quicklinks\" & $QuickLinksFolderList[$x], $szDrive, $szDir, $szFName, $szExt)
		if $szFName == _GetMenuText(@GUI_CtrlId) Then
			Local $aDetails = FileGetShortcut(@ScriptDir & "\quicklinks\" & $QuickLinksFolderList[$x])
				cygwinOpen($aDetails[0])
		EndIf
	Next
EndFunc   ;==>TrayEvent


Func TrayEvent()
	Local $Msg = @GUI_CtrlId
	Switch $Msg
		Case $tray_TrayExit
			While ProcessExists("httpd.exe")
				ProcessClose("httpd.exe")
			WEnd
			_TrayIconDelete($nTrayIcon1)
			CleanUpSysTray()
			Exit
		Case $tray_phpMyAdmin
			ShellExecute("http://127.0.0.1/phpMyAdmin")
		Case $tray_openCygwinConfig
			OpenConfig()
		Case $tray_openXServer
			Run (@ScriptDir & "\bin\run.exe /bin/bash.exe -c '/usr/bin/startxwin.exe -- -nolock -unixkill'", "", @SW_HIDE )
	EndSwitch
EndFunc   ;==>TrayEvent

Func OpenConfig()
	ShellExecute(@ScriptDir & "\cygwinConfig.exe", " -R " & @ScriptDir & " -l " & @ScriptDir & "\packages -n -d -N -s ftp://lug.mtu.edu/cygwin" , @ScriptDir, "")
EndFunc

Func CleanUpSysTray()
	$count = _SysTrayIconCount()
	For $i = $count - 1 To 0 Step -1
		$handle = _SysTrayIconHandle($i)
		$visible = _SysTrayIconVisible($i)
		$pid = WinGetProcess($handle)
		$name = _ProcessGetName($pid)
		$title = WinGetTitle($handle)
		$tooltip = _SysTrayIconTooltip($i)
		If $pid = -1 Then _SysTrayIconRemove($i)
	Next

	If @OSVersion = "WIN_7" Then
		$countwin7 = _SysTrayIconCount(2)
		For $i = $countwin7 - 1 To 0 Step -1
			$handle = _SysTrayIconHandle($i, 2)
			$visible = _SysTrayIconVisible($i, 2)
			$pid = WinGetProcess($handle)
			$name = _ProcessGetName($pid)
			$title = WinGetTitle($handle)
			$tooltip = _SysTrayIconTooltip($i, 2)
			If $pid = -1 Then _SysTrayIconRemove($i, 2)
		Next
	EndIf
EndFunc   ;==>CleanUpSysTray

Func ReadCmdLineParams() 	;Read in the optional switch set in the users profile and set a variable - used in case selection
	;;Loop through every arguement
	;;$cmdLine[0] is an integer that is eqaul to the total number of arguements that we passwed to the command line

	Local $noCorrectParameter = True

	;Set Global Variables True/False first
	for $i = 1 to $cmdLine[0]
		select
			case $cmdLine[$i] = "-exit"
				if StringStripWS($CmdLine[$i + 1], 3) == 0 Then
					$exitAfterExec = False
				Else
					$exitAfterExec = True
				EndIf
				$noCorrectParameter = False
			case $cmdLine[$i] = "-config"
				OpenConfig()
				Exit
		EndSelect
	Next

	for $i = 1 to $cmdLine[0]
		select
			;;If the arguement equal -h
			case $CmdLine[$i] = "-h"
				;check for missing argument
				if $i == $CmdLine[0] Then cmdLineHelpMsg()

				;Make sure the next argument is not another paramter
				if StringLeft($cmdline[$i+1], 1) == "-" Then
					cmdLineHelpMsg()
				Else
					;;Stip white space from the begining and end of the input
					;;Not alway nessary let it in just in case
					$msgHeader = StringStripWS($CmdLine[$i + 1], 3)
				endif
				$noCorrectParameter = False

			;;If the arguement equal  -path
			case $CmdLine[$i] = "-path"
				if $i == $CmdLine[0] Then cmdLineHelpMsg()
				if StringLeft($cmdline[$i+1], 1) == "-" Then
					cmdLineHelpMsg()
				Else
					cygwinOpen(StringStripWS($CmdLine[$i + 1], 3))
				EndIf
				$noCorrectParameter = False
		EndSelect
	Next

	;if no correct startup parameter is given try to use first parameter with path (needed for open with)
	If $CmdLine[0] <> 0 And $noCorrectParameter == True Then
			cygwinOpen($cmdLine[1])
	EndIf

EndFunc

Func cmdLineHelpMsg()
	ConsoleWrite('CybeSystems Cygwin Portable Launcher' & @LF & @LF & _
					'Syntax:' & @tab & 'CygwinPortable.exe [options]' & @LF & @LF & _
					'Default:' & @tab & 'Display help message.' & @LF & @LF & _
					'Optional Options:' & @LF & _
					'-path ["path"]' & @tab & '-path "C:\Windows" open Windows folder' & @lf & _
					'-exit [0/1]' & @tab &  '-exit 0 let the cygwin window open, -exit 1 close the cygwin window after execution' & @lf)
	Exit
EndFunc


Func cygwinOpen($cygwinOpenPath="")
	ConsoleWrite($cygwinOpenPath)

	Local $correctPath = StringInStr($cygwinOpenPath, ":/")
	Local $correctPath2 = StringInStr($cygwinOpenPath, ":\")

	if $correctPath == 0 and $correctPath2 == 0 Then
		if $cygwinNoMsgBox == False Then
			MsgBox(16, "Error", $cygwinOpenPath & " is not a correct Windows path", 16)
		 EndIf
		 Exit
	 EndIf

	if FileExists ($cygwinOpenPath)<> True Then
		if $cygwinNoMsgBox == False Then
			MsgBox(16, "Error", $cygwinOpenPath & " is not a existing file or directory", 16)
		 EndIf
		 Exit
	 EndIf

	if $cygwinOpenPath <> "" Then
		$fullPath = $cygwinOpenPath
		_PathSplit($fullPath, $szDrive, $szDir, $szFName, $szExt)
		$cygdrive = "/cygdrive/" & StringReplace($szDrive, ":", "" )
		$cygfile = $szFName & $szExt

		;Check for windows lnk files
		if $szExt == ".lnk" Then
			Local $aDetails = FileGetShortcut($fullPath)
			$fullPath = $aDetails[0]
			_PathSplit($fullPath, $szDrive, $szDir, $szFName, $szExt)
			$cygdrive = "/cygdrive/" & StringReplace($szDrive, ":", "" )
			$cygfile = $szFName & $szExt
		EndIf

		;Check if selected file or folder
		if $szExt <> "" Then
			$cygfolder1 = StringReplace($szDir & "\", "\", "/" )
		else
			$cygfolder1 = StringReplace($szDir & $szFName, "\", "/" )
		EndIf

		$cygfolder = StringReplace($cygfolder1, " ", "\ " )

		;Is the selected file executable ?
		For $iniMainValue = 1 To $iniMain[0][0]
			;Is the selected file executable ?
			if $iniMain[$iniMainValue][0] == 'ExecutableExtension' Then
				$executableExtension = StringSplit($iniMain[$iniMainValue][1], ",")
				for $iniMainExecutableExtensionArray=1 to ubound($executableExtension,1) -1
					if $executableExtension[$iniMainExecutableExtensionArray] == StringReplace($szExt, ".", "" ) Then
						$executable = True
					EndIf
				next
			EndIf
		Next

		if $cygfile <> "" and $executable == True Then
			if $exitAfterExec == False Then
				Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";./" & $cygfile & ";exec /bin/bash.exe'")
			Else
				Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";./" & $cygfile & "'")
			EndIf
		Else
			Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & "/; exec /bin/bash.exe'")
			;Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";echo " &$cygdrive & $cygfolder &"; exec /bin/bash.exe'")
			FileWrite ( @ScriptDir & "\TEST.txt",$cygdrive & $cygfolder )
		EndIf
	Else
	   Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd C:;exec /bin/bash.exe'")
	EndIf
EndFunc


Func cygwinSetContextMenu()
	;Run File
	RegWrite('HKEY_CLASSES_ROOT\*\shell\Run in Cygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" -path "%1"')
	RegWrite('HKEY_CLASSES_ROOT\*\shell\Run in Cygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Folder
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin', '', 'REG_SZ', 'Open Folder in Cygwin')
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" -path "%L"')
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Drive
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin', '', 'REG_SZ', 'Open Drive in Cygwin')
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" -path "%1"')
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Folder (Background)
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', '', 'REG_SZ', 'Open Drive in Cygwin')
	;RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', 'Extended', 'REG_SZ', '')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" -path "%v"')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
EndFunc

Func cygwinUnSetContextMenu()
	RegDelete("HKEY_CLASSES_ROOT\*\shell\Run in Cygwin")
	RegDelete("HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin")
	RegDelete("HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin")
EndFunc

Exit