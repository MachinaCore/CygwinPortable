#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_icon=App\AppInfo\appicon1.ico
#AutoIt3Wrapper_UseUpx=N
#AutoIt3Wrapper_Res_Description=CygwinPortable
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.8
#AutoIt3Wrapper_Res_LegalCopyright=LORDofDOOM
#AutoIt3Wrapper_Res_Language=1031
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


EnvSet("PATH",  @ScriptDir & "\bin")
EnvSet("ALLUSERSPROFILE",  "C:\ProgramData")
EnvSet("ProgramData",  "C:\ProgramData")
EnvSet("CYGWIN",  "nodosfilewarning")
EnvSet("HOME",  "/home/cygwin")

Run(@ScriptDir & "\bin\bash /Other/user_setup.sh", @SW_HIDE)

If $CmdLine[0] <> 0 Then
	$fullPath = $CmdLine[1]
	local $szDrive, $szDir, $szFName, $szExt, $cygdrive,$cygfolder,$cygfolder1,$cygfile, $executableExtension, $executable, $exitAfterExec, $setContextMenu, $cygwinUsername
	_PathSplit($fullPath, $szDrive, $szDir, $szFName, $szExt)

	$executable = False
	$exitAfterExec = True
	$setContextMenu = False
	$cygdrive = "/cygdrive/" & StringReplace($szDrive, ":", "" )
	$cygfile = $szFName & $szExt

	;Check if selected file or folder
	if $szExt <> "" Then
		$cygfolder1 = StringReplace($szDir & "\", "\", "/" )
	else
		$cygfolder1 = StringReplace($szDir & $szFName, "\", "/" )
	EndIf

	$cygfolder = StringReplace($cygfolder1, " ", "\ " )

	Local $iniMain = IniReadSection(@ScriptDir & "\CygwinPortable.ini", "Main")
	If @error Then
		MsgBox(4096, "", "CygwinPortable.ini not found")
	Else
		For $iniMainValue = 1 To $iniMain[0][0]
			;Is the selected file executable ?
			if $iniMain[$iniMainValue][0] == 'ExecutableExtension' Then
				$executableExtension = StringSplit($iniMain[$iniMainValue][1], ",")
				for $iniMainExecutableExtensionArray=1 to ubound($executableExtension,1) -1
					if $executableExtension[$iniMainExecutableExtensionArray] == StringReplace($szExt, ".", "" ) Then
						$executable = True
						;ConsoleWrite($executableExtension[$iniMainExecutableExtensionArray])
					EndIf
				next
			EndIf
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

		Next
	EndIf

if $setContextMenu == True Then
	;Run File
	RegWrite('HKEY_CLASSES_ROOT\*\shell\Run in Cygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" "%1"')
	RegWrite('HKEY_CLASSES_ROOT\*\shell\Run in Cygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Folder
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin', '', 'REG_SZ', 'Open Folder in Cygwin')
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" "%L"')
	RegWrite('HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Drive
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin', '', 'REG_SZ', 'Open Drive in Cygwin')
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" "%1"')
	RegWrite('HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
	;Open Folder (Background)
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', '', 'REG_SZ', 'Open Drive in Cygwin')
	;RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', 'Extended', 'REG_SZ', '')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground\command', '', 'REG_SZ', '"' & @ScriptDir & '\CygwinPortable.exe" "%v"')
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', 'Icon', 'REG_EXPAND_SZ', '' & @ScriptDir & '\CygwinPortable.exe')
Else
	 RegDelete("HKEY_CLASSES_ROOT\*\shell\Run in Cygwin")
	 RegDelete("HKEY_CLASSES_ROOT\Directory\shell\OpenDirectoryInCygwin")
	 RegDelete("HKEY_CLASSES_ROOT\Drive\shell\OpenDriveInCygwin")
EndIf

	if $cygfile <> "" and $executable == True Then
		if $exitAfterExec == False Then
			Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";./" & $cygfile & ";exec /bin/bash.exe'")
			FileWrite ( @ScriptDir & "\TEST.txt","FILE" )
		Else
			Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";./" & $cygfile & "'")
			FileWrite ( @ScriptDir & "\TEST.txt","FOLDER" )
		EndIf
	Else
		Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & "/; exec /bin/bash.exe'")
		;Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & ";echo " &$cygdrive & $cygfolder &"; exec /bin/bash.exe'")
		FileWrite ( @ScriptDir & "\TEST.txt",$cygdrive & $cygfolder )
	EndIf
Else
   Run (@ScriptDir & "\bin\mintty --config /home/ntmoe/.minttyrc -e /bin/bash.exe -c 'cd C:;exec /bin/bash.exe'")
EndIf

Exit