#NoTrayIcon
#Region ;**** Directives created by AutoIt3Wrapper_GUI ****
#AutoIt3Wrapper_Icon=App\AppInfo\appicon1.ico
#AutoIt3Wrapper_UseUpx=n
#AutoIt3Wrapper_Res_Description=CygwinPortable
#AutoIt3Wrapper_Res_Fileversion=0.8.0.0
#AutoIt3Wrapper_Res_ProductVersion=0.8
#AutoIt3Wrapper_Res_LegalCopyright=CybeSystems
#AutoIt3Wrapper_Res_Language=1031
#AutoIt3Wrapper_Res_Icon_Add=App\AppInfo\appicon1.ico
#AutoIt3Wrapper_Res_File_Add=other\source\Resources\cs_sidebar.bmp, rt_bitmap, CYBESYSTEMS_SIDEBAR
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
#include "other\source\resources\resources.au3"
#include "other\source\resources\_ModernMenuRaw.au3"
#include "other\source\resources\_SysTray.au3"
#include <ButtonConstants.au3>
#include <ComboConstants.au3>
#include <EditConstants.au3>
#include <GUIConstantsEx.au3>
#include <TabConstants.au3>
#include <StaticConstants.au3>
#Include <Misc.au3>

#include "other\source\resources\_InetGetGUI.au3"

Run(@ScriptDir & "\app\cygwin\bin\bash /Other/helper/user_setup.sh", @SW_HIDE)



Global $szDrive, $szDir, $szFName, $szExt, $cygdrive,$cygfolder,$cygfolder1,$cygfile, $executableExtension, $executable, $exitAfterExec, $setContextMenu, $cygwinUsername,$cygwinTrayMenu,$shell,$cygwinNoMsgBox,$cygwinMirror,$cygwinPortsMirror,$cygwinFirstInstallAdditions
Global $cygwinFirstInstallDeleteUnneeded, $cygwinDeleteInstallation, $installUnofficial,$cygwinDeleteInstallationFolders,$tray_openCygwinPortableConfig,$windowsPathToCygwin,$windowsAdditionalPath,$windowsPythonPath
Global $WS_GROUP

;create Cygwin Folder
If Not FileExists(@ScriptDir & "\app\cygwin") then
	DirCreate(@ScriptDir & "\app\Cygwin")
EndIf


Func Folder2CygFolder($winFolder)
	;ConsoleWrite($winFolder)

	$fullPath = $winFolder
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
	Return($cygdrive & $cygfolder)

EndFunc


Local $cygScriptDir = Folder2CygFolder(@ScriptDir)

Local $iniMain = IniReadSection(@ScriptDir & "\CygwinPortable.ini", "Main")
Local $iniFile = @ScriptDir & "\CygwinPortable.ini"
If @error Then
	MsgBox(4096, "", "CygwinPortable.ini not found")
Else
	ReadSettings()
EndIf

Func ReadSettings()
	$exitAfterExec = IniRead($iniFile, "Main", "ExitAfterExec", True)
	$setContextMenu = IniRead($iniFile, "Main", "SetContextMenu", False)
	$cygwinTrayMenu = IniRead($iniFile, "Main", "TrayMenu", True)
	$shell = IniRead($iniFile, "Main", "Shell", "mintty")
	$cygwinNoMsgBox = IniRead($iniFile, "Main", "NoMsgBox", False)
	$executableExtension = IniRead($iniFile, "Main", "ExecutableExtension", "exe,bat,sh,pl,bat")
	$cygwinMirror = IniRead($iniFile, "Main", "CygwinMirror", "ftp://lug.mtu.edu/cygwin")
	$cygwinPortsMirror = IniRead($iniFile, "Main", "CygwinPortsMirror", "ftp://ftp.cygwinports.org/pub/cygwinports")
	$cygwinFirstInstallAdditions = IniRead($iniFile, "Main", "CygwinFirstInstallAdditions", "")
	$cygwinFirstInstallDeleteUnneeded = IniRead($iniFile, "Main", "CygwinFirstInstallDeleteUnneeded", True)
	$installUnofficial = IniRead($iniFile, "Main", "InstallUnofficial", False)
	$windowsPathToCygwin = IniRead($iniFile, "Main", "WindowsPathToCygwin", True)
	$windowsAdditionalPath = IniRead($iniFile, "Main", "WindowsAdditionalPath", True)
	$windowsPythonPath = IniRead($iniFile, "Main", "WindowsPythonPath", True)
	$cygwinUsername = IniRead($iniFile, "Static", "Username", "")
	$cygwinDeleteInstallation = IniRead($iniFile, "Expert", "CygwinDeleteInstallation", False)
	$cygwinDeleteInstallationFolders = IniRead($iniFile, "Expert", "CygwinDeleteInstallationFolders", False)
EndFunc

If $shell == "ConEmu" and Not FileExists(@ScriptDir & "\app\ConEmu\ConEmu.exe") then
	$shell = "mintty"
EndIf


if $cygwinUsername == "" Then
	Global $username_form,$username_input_username,$username_btn_save,$username_btn_save
	#Region ### START Koda GUI section ###
	$username_form = GUICreate("Username", 234, 89, -1, -1)
	$username_lbl_username = GUICtrlCreateLabel("Please enter a username for Cygwin Portable", 8, 8, 215, 17)
	$username_input_username = GUICtrlCreateInput("cygwin", 8, 32, 217, 21)
	$username_btn_save = GUICtrlCreateButton("Save", 72, 56, 75, 25, $WS_GROUP)
	$username_btn_exit = GUICtrlCreateButton("Exit", 152, 56, 75, 25, $WS_GROUP)
	GUISetState(@SW_SHOW)
	#EndRegion ### END Koda GUI section ###
	GUICtrlSetOnEvent($username_btn_save, "UsernameSave")
	GUICtrlSetOnEvent($username_btn_exit, "UsernameExit")
EndIf

Func UsernameSave()
	if StringIsAlpha (GuiCtrlRead($username_input_username)) == 1 Then
		$cygwinUsername = GuiCtrlRead($username_input_username)
		IniWrite(@ScriptDir & "\CygwinPortable.ini", "Static", "Username", GuiCtrlRead($username_input_username))
		GUIDelete($username_form)
		ReadSettings()
	Else
		MsgBox(16,"Error","The username contains invalid characters (only alphabetic characters allowed)",16)
	EndIf
EndFunc

Func UsernameExit()
	GUIDelete($username_form)
EndFunc


_PathSplit(@ScriptDir, $szDrive, $szDir, $szFName, $szExt)
if $windowsPathToCygwin == True then
	$path = EnvGet("PATH")
	If StringRight($path, 1) <> ";" Then
		$path &= ";"
	EndIf
	if $windowsAdditionalPath <> "" then
		$path &= $windowsAdditionalPath & ";"
	EndIf
	;ConsoleWrite($path)
	EnvSet("PATH",$path & @ScriptDir & "\app\cygwin\bin")
Else
	EnvSet("PATH",@ScriptDir & "\app\cygwin\bin")
EndIf
EnvSet("ALLUSERSPROFILE",  "C:\ProgramData")
EnvSet("ProgramData",  "C:\ProgramData")
EnvSet("CYGWIN",  "nodosfilewarning1")
EnvSet("USERNAME",  $cygwinUsername)
EnvSet("HOME",  "/home/" & $cygwinUsername)
EnvSet("USBDRV",  $szDrive)
EnvSet("USBDRVPATH",  $szDrive)
if $windowsPythonPath <> "" then
	EnvSet("PYTHONPATH",$windowsPythonPath & ";")
EndIf
;~ If Not FileExists(@ScriptDir & "\app\cygwin\bin\python2.7.exe") then
;~ 	$pythonpath = EnvGet("PYTHONPATH")
;~ 	ConsoleWrite($pythonpath)
;~ EndIf
$TwoFoldersUp = _PathFull(@ScriptDir & "..\..\..\")
If FileExists($TwoFoldersUp & "\StartPortableApps.exe") then
	EnvSet("PORTABLEAPPS",  "true")
Else
	EnvSet("PORTABLEAPPS",  "false")
EndIf


Func Bool(Const ByRef $checkbox)
    If GUICtrlRead($checkbox) = $GUI_CHECKED Then
        Return True
    ElseIf GUICtrlRead($checkbox) = $GUI_UNCHECKED Then
        Return False
    EndIf
EndFunc

Func CygwinPortableSettingsGUI()
	Global $settings_form,$settings_chk_ExitAfterExec,$settings_chk_SetContextMenu,$settings_chk_TrayMenu, $settings_dropdown_shell, $settings_chk_NoMsgBox, $settings_input_ExecutableExtension,$settings_input_CygwinMirror,$settings_input_CygwinPortsMirror,$settings_chk_windows_to_cygwinpath
	Global $settings_input_CygwinFirstInstallAdditions, $settings_chk_CygwinFirstInstallDeleteUnneeded, $settings_chk_InstallUnofficial, $settings_chk_CygwinDeleteInstallation,$settings_input_CygwinDeleteInstallationFolders,$settings_input_Username,$settings_btn_save,$settings_btn_cancel
	#Region ### START Koda GUI section ###
	$settings_form_1 = GUICreate("Cygwin Portable Launcher Settings", 412, 247, -1, -1)
	GUISetIcon("D:\005.ico")
	$PageControl1 = GUICtrlCreateTab(8, 8, 396, 200)
	GUICtrlSetFont(-1, 8, 400, 0, "MS Sans Serif")
	GUICtrlSetResizing(-1, $GUI_DOCKWIDTH+$GUI_DOCKHEIGHT)
	$TabSheet1 = GUICtrlCreateTabItem("Settings")
	$settings_chk_ExitAfterExec = GUICtrlCreateCheckbox("Exit after Execution", 24, 135, 233, 17)
	$settings_chk_SetContextMenu = GUICtrlCreateCheckbox("Set Windows Context Menus (registry)", 24, 87, 313, 17)
	$settings_chk_TrayMenu = GUICtrlCreateCheckbox("Use TrayMenu", 24, 111, 97, 17)
	$settings_dropdown_shell = GUICtrlCreateCombo("mintty", 168, 39, 225, 25)
	GUICtrlSetData(-1, "ConEmu")
	$settings_chk_NoMsgBox = GUICtrlCreateCheckbox("Disable Message Boxes (errors will not be show !)", 24, 159, 337, 17)
	$settings_lbl_shell = GUICtrlCreateLabel("Shell:", 24, 39, 30, 17)
	$settings_lbl_ExecutableExtension = GUICtrlCreateLabel("Executable File Extensions:", 24, 63, 133, 17)
	$settings_input_ExecutableExtension = GUICtrlCreateInput("settings_input_ExecutableExtension", 168, 63, 225, 21)
	$settings_chk_windows_to_cygwinpath = GUICtrlCreateCheckbox("Add Windows PATH variables to Cygwin", 24, 184, 361, 17)
	$TabSheet2 = GUICtrlCreateTabItem("Installer")
	$settings_lbl_CygwinMirror = GUICtrlCreateLabel("Cygwin Mirror:", 16, 39, 70, 17)
	$settings_input_CygwinMirror = GUICtrlCreateInput("settings_input_CygwinMirror", 128, 39, 257, 21)
	$settings_lbl_CygwinPortsMirror = GUICtrlCreateLabel("Cygwin Ports Mirror:", 16, 63, 97, 17)
	$settings_input_CygwinPortsMirror = GUICtrlCreateInput("settings_input_CygwinPortsMirror", 128, 63, 257, 21)
	$settings_lbl_CygwinFirstInstallAdditions = GUICtrlCreateLabel("First install additions:", 16, 87, 100, 17)
	$settings_input_CygwinFirstInstallAdditions = GUICtrlCreateInput("settings_input_CygwinFirstInstallAdditions", 128, 87, 257, 21)
	$settings_chk_CygwinFirstInstallDeleteUnneeded = GUICtrlCreateCheckbox("Delete unneeded files", 16, 111, 145, 17)
	$settings_chk_InstallUnofficial = GUICtrlCreateCheckbox("Install unofficial Cygwin Tools", 16, 135, 241, 17)
	$TabSheet3 = GUICtrlCreateTabItem("Expert")
	$settings_chk_CygwinDeleteInstallation = GUICtrlCreateCheckbox("Delete complete installation (Reinstall)", 16, 63, 225, 17)
	$settings_lbl_Warning = GUICtrlCreateLabel("WARNING: Dont change anything here if not not exactly know what you doing", 16, 39, 376, 17)
	$settings_lbl_CygwinDeleteInstallationFolders = GUICtrlCreateLabel("Drop these folders on Reinstall:", 16, 87, 151, 17)
	$settings_input_CygwinDeleteInstallationFolders = GUICtrlCreateInput("settings_input_CygwinDeleteInstallationFolders", 176, 87, 209, 21)
	$settings_input_Username = GUICtrlCreateInput("settings_input_Username", 176, 111, 209, 21)
	$settings_lbl_username = GUICtrlCreateLabel("Username:", 16, 111, 55, 17)
	GUICtrlCreateTabItem("")
	$settings_btn_save = GUICtrlCreateButton("&Save", 246, 216, 75, 25, $WS_GROUP)
	$settings_btn_cancel = GUICtrlCreateButton("&Cancel", 326, 216, 75, 25, $WS_GROUP)

	#EndRegion ### END Koda GUI section ###


	if $exitAfterExec == True Then
		GUICtrlSetState($settings_chk_ExitAfterExec, $GUI_CHECKED)
	EndIf
	if $setContextMenu == True Then
		GUICtrlSetState($settings_chk_SetContextMenu, $GUI_CHECKED)
	EndIf
	if $cygwinTrayMenu == True Then
		GUICtrlSetState($settings_chk_TrayMenu, $GUI_CHECKED)
	EndIf
	if $cygwinNoMsgBox == True Then
		GUICtrlSetState($settings_chk_NoMsgBox, $GUI_CHECKED)
	EndIf
	if $cygwinFirstInstallDeleteUnneeded == True Then
		GUICtrlSetState($settings_chk_CygwinFirstInstallDeleteUnneeded, $GUI_CHECKED)
	EndIf
	if $installUnofficial == True Then
		GUICtrlSetState($settings_chk_InstallUnofficial, $GUI_CHECKED)
	EndIf
	if $cygwinDeleteInstallation == True Then
		GUICtrlSetState($settings_chk_CygwinDeleteInstallation, $GUI_CHECKED)
	EndIf
	if $windowsPathToCygwin == True Then
		GUICtrlSetState($settings_chk_windows_to_cygwinpath, $GUI_CHECKED)
	EndIf

	;Set variables
	GUICtrlSetData($settings_dropdown_shell,$shell)
	GUICtrlSetData($settings_input_ExecutableExtension,$executableExtension)
	GUICtrlSetData($settings_input_CygwinMirror,$cygwinMirror)
	GUICtrlSetData($settings_input_CygwinPortsMirror,$cygwinPortsMirror)
	GUICtrlSetData($settings_input_Username,$cygwinUsername)
	GUICtrlSetData($settings_input_CygwinFirstInstallAdditions,$cygwinFirstInstallAdditions)
	GUICtrlSetData($settings_input_CygwinDeleteInstallationFolders,$cygwinDeleteInstallationFolders)
	GUICtrlSetOnEvent($settings_btn_save, "ConfigSave")
	GUICtrlSetOnEvent($settings_btn_cancel, "ConfigExit")

	GUISetState(@SW_SHOW)
EndFunc


Func ConfigSave()
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "ExitAfterExec", Bool($settings_chk_ExitAfterExec))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "SetContextMenu", Bool($settings_chk_SetContextMenu))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "TrayMenu", Bool($settings_chk_TrayMenu))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "Shell", GuiCtrlRead($settings_dropdown_shell))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "NoMsgBox", Bool($settings_chk_NoMsgBox))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "ExecutableExtension", GuiCtrlRead($settings_input_ExecutableExtension))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "CygwinMirror", GuiCtrlRead($settings_input_CygwinMirror))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "CygwinPortsMirror", GuiCtrlRead($settings_input_CygwinPortsMirror))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "CygwinFirstInstallAdditions", GuiCtrlRead($settings_input_CygwinFirstInstallAdditions))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "CygwinFirstInstallDeleteUnneeded", Bool($settings_chk_CygwinFirstInstallDeleteUnneeded))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "InstallUnofficial", Bool($settings_chk_InstallUnofficial))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Main", "WindowsPathToCygwin", Bool($settings_chk_windows_to_cygwinpath))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Expert", "CygwinDeleteInstallation", Bool($settings_chk_CygwinDeleteInstallation))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Expert", "CygwinDeleteInstallationFolders", GuiCtrlRead($settings_input_CygwinDeleteInstallationFolders))
	IniWrite(@ScriptDir & "\CygwinPortable.ini", "Static", "Username", GuiCtrlRead($settings_input_Username))
	GUIDelete($settings_form)
	ReadSettings()
EndFunc

Func ConfigExit()
	GUIDelete($settings_form)
EndFunc   ;==>ConfigExit

;crate Userfolder
If Not FileExists(@ScriptDir & "\app\cygwin\home\" & $cygwinUsername) and FileExists(@ScriptDir & "\app\cygwin\bin\bash.exe") then
	DirCreate(@ScriptDir & "\app\cygwin\home\" & $cygwinUsername)
	ShellExecuteWait(@ScriptDir & "\app\cygwin\bin\bash.exe", "--login -i -c 'exit'" , @ScriptDir, "")
	FileDelete (@ScriptDir & "/app/cygwin/home/" & $cygwinUsername & "/.bashrc")
	FileDelete (@ScriptDir & "/app/cygwin/home/" & $cygwinUsername & "/.minttyrc")
	FileDelete (@ScriptDir & "/app/cygwin/etc/profile")
	ShellExecute(@ScriptDir & "\app\cygwin\bin\bash.exe", "--login -i -c 'ln -s /Other/profile/bashrc ~/.bashrc;ln -s /Other/profile/dircolors ~/.dircolors;ln -s /Other/profile/minttyrc ~/.minttyrc;ln -s /Other/profile/profile /etc/profile;ln -s /Other/helper/cyg-wrapper.sh /bin/cyg-wrapper.sh;ln -s /Other/helper/startSumatra.sh /bin/startSumatra.sh;exec /bin/bash.exe'" , @ScriptDir, "")
	;ShellExecute(@ScriptDir & "\app\cygwin\bin\bash.exe", "--login -i -c 'ln -s " & $cygScriptDir & "/Other/bashrc ~/.bashrc;ln -s " & $cygScriptDir & "/Other/dircolors ~/.dircolors;ln -s " & $cygScriptDir & "/Other/minttyrc ~/.minttyrc;ln -s " & $cygScriptDir & "/Other/profile /etc/profile;ln -s " & $cygScriptDir & "/Other/cyg-wrapper.sh /bin/cyg-wrapper.sh;ln -s /Other/startSumatra.sh /bin/startSumatra.sh;exec /bin/bash.exe'" , @ScriptDir, "")
EndIf

If Not FileExists(@ScriptDir & "\Data") then
	DirCopy (@ScriptDir & "\app\defaultdata", @ScriptDir & "\Data" )
EndIf

;Delete Installation ?
if $cygwinDeleteInstallation == True Then
	$DeleteInstallation = MsgBox (4, "Delete/Reinstall Cygwin" ,"Do you REALLY want to delete and reinstall your Cygwin installation ?")
	If $DeleteInstallation = 6 Then
		For $iniMainValue = 1 To $iniMain[0][0]
			;Is the selected file executable ?
			if $iniMain[$iniMainValue][0] == 'CygwinDeleteInstallationFolders' Then
				$cygwinDeleteInstallationFolders = StringSplit($iniMain[$iniMainValue][1], ",")
				for $iniMainExecutableExtensionArray=1 to ubound($cygwinDeleteInstallationFolders,1) -1
					FileDelete (@ScriptDir & "\App\Cygwin\CygwinConfig.exe")
					DirRemove ( @ScriptDir & "\" & $cygwinDeleteInstallationFolders[$iniMainExecutableExtensionArray], 1)
				next
			EndIf
		Next
	ElseIf $DeleteInstallation = 7 Then
		MsgBox(16, "Error", "Cygwin environment setup canceled. Can't continue", 16)
		Exit
	EndIf
EndIf

If Not FileExists(@ScriptDir & "\App\Cygwin\CygwinConfig.exe") then
	DownloadSetup()
 Endif

Func DownloadSetup()
    Local $sFilePathURL = "http://cygwin.com/setup-x86.exe"
    Local $hGUI, $iButton, $iLabel, $iProgressBar, $sFilePath

    $hGUI = GUICreate("Cygwin setup.exe Downloader", 370, 90, -1, -1)
    $iLabel = GUICtrlCreateLabel("Cygwin setup.exe is missing - This file is needed!", 5, 5, 270, 40)
    $iButton = GUICtrlCreateButton("&Download", 275, 2.5, 90, 25)
    $iProgressBar = GUICtrlCreateProgress(5, 60, 360, 20)
    GUISetState(@SW_SHOW, $hGUI)
	Local $downloadSuccess = False
    While $downloadSuccess == False
                $sFilePath = _InetGetGUI($sFilePathURL, $iLabel, $iProgressBar, $iButton, @ScriptDir)
                If @error Then
                    Switch @extended ; Check what the actual error was by using the @extended command.
                        Case 0
                            MsgBox(64, "Error", "Check the URL or your Internet Connection!")

                        Case 1
                            MsgBox(64, "Fail", "Seems the download was canecelled, but the file was >> " & $sFilePath)

                    EndSwitch
                Else
                    ;MsgBox(64, "Success", "Downloaded >> " & $sFilePath & @CRLF & @CRLF & "Please restart this program")
					FileMove(@ScriptDir & "\setup-x86.exe",@ScriptDir & "\App\Cygwin\CygwinConfig.exe",1)
					GUISetState(@SW_HIDE, $hGUI)
					$downloadSuccess = True
                EndIf
    WEnd
EndFunc

if $installUnofficial == True Then
	$installUnofficialFileList=_FileListToArray(@ScriptDir & "\other\unofficial\", "*")
	If Not @error Then
		$count = $installUnofficialFileList[0]
		for $x = 1 to $count
			If Not @error Then
				if Not FileExists(@ScriptDir & "\app\cygwin\bin\" & $installUnofficialFileList[$x]) then
					FileCopy(@ScriptDir & "\other\unofficial\" & $installUnofficialFileList[$x], @ScriptDir & "\app\cygwin\bin\" & $installUnofficialFileList[$x])
					Run (@ScriptDir & "\app\cygwin\bin\mintty --config /home/" & $cygwinUsername & "/.minttyrc -e /bin/bash.exe -c 'chmod +x /bin/" & $installUnofficialFileList[$x] & "'")
				EndIf
			EndIf
		Next
	EndIf
EndIf

;Copy Batch Files
If Not FileExists(@ScriptDir & "\app\cygwin\CygwinPortableConfig.bat") then
	 FileCopy(@ScriptDir & "\other\batch\*.bat", @ScriptDir & "\app\cygwin")
 EndIf

if StringInStr(@ScriptDir, " ") Then
	MsgBox (0, "Path Error" ,@ScriptDir & " contain spaces in pathname" & @CRLF & "Cygwin path does not allow spaces - Please move folder")
	exit
EndIf

If Not FileExists(@ScriptDir & "\app\cygwin\bin\bash.exe") then
	$DownloadCygwinEnvironment = MsgBox (4, "Download cygwin Environment" ,"This is the first launch of Cygwin portable. Download the default cygwin packages (incl. X11) now ?")
	If $DownloadCygwinEnvironment = 6 Then

		ShellExecuteWait(@ScriptDir & "\App\Cygwin\CygwinConfig.exe", " -R " & @ScriptDir & "\app\cygwin\ -l " & @ScriptDir & "\app\cygwin\packages -n -d -N -s " & $cygwinMirror & " -q" & " -P " & $cygwinFirstInstallAdditions, @ScriptDir, "")

		if $cygwinFirstInstallDeleteUnneeded == True Then
			FileDelete (@ScriptDir & "\Cygwin.ico")
			FileDelete (@ScriptDir & "\Cygwin.bat")
			FileDelete (@ScriptDir & "\setup.log")
			FileDelete (@ScriptDir & "\setup.log.full")
		EndIf
		If IsAdmin() = 0 Then
			$admin = MsgBox(0, "Cygwin Portable", "User " & @UserName & " does not have admin rights" & @CRLF & " You must restart Cygwin Portable after installation is finished")
			Exit
		Else
			if FileExists(@ScriptDir & "\CygwinPortable.exe") then
				ShellExecute(@ScriptDir & "\CygwinPortable.exe", "", @ScriptDir, "")
				Exit
			EndIf
		EndIf
	ElseIf $DownloadCygwinEnvironment = 7 Then
		MsgBox(16, "Error", "Cygwin environment setup canceled. Can't continue", 16)
		Exit
	EndIf

;~ 	ShellExecuteWait(@ScriptDir & "\cygwinConfig.exe", " -R " & @ScriptDir & " -l " & @ScriptDir & "\packages -n -d -N -s " & $cygwinMirror & " -q" & " -P " & $cygwinFirstInstallAdditions, @ScriptDir, "")
 Endif

ReadCmdLineParams()

Global $tray_ReStartApache,$tray_openbash,$AppsStopped,$tray_TrayExit,$tray_menu_seperator,$tray_menu_seperator2,$nSideItem3,$nTrayIcon1,$nTrayMenu1,$tray_openCygwinConfig,$tray_sub_QuickLaunch,$tray_sub_Drives,$tray_sub_QuickLink,$tray_menu_seperator_quick_launch,$tray_openXServer,$tray_openCygwinConfigPorts

if $setContextMenu == True Then
    If IsAdmin() = 0 Then
        $admin = MsgBox(0, "Admin Rights", "User " & @UserName & " does not have admin rights" & @CRLF & "Set Context Menu needs admin right - Please restart Cygwin Portable with admin rights")
	EndIf
	cygwinSetContextMenu()
Else
	cygwinUnSetContextMenu()
EndIf

if $cygwinTrayMenu == True and $CmdLine[0] == 0  and not _Singleton("CygwinPortable.exe", 1) = 0 Then
BuildTrayMenu()
BuildMenu()
While 1
	Sleep(1000)
WEnd
EndIf


Func MenuRebuild()
	DeleteMenu()
	BuildMenu()
EndFunc   ;==>MMOwningRebuild

Func DeleteMenu()
	_TrayDeleteItem($tray_openCygwinConfig)
	_TrayDeleteItem($tray_openCygwinPortableConfig)
	_TrayDeleteItem($tray_openCygwinConfigPorts)
	_TrayDeleteItem($tray_TrayExit)
	_TrayDeleteItem($tray_menu_seperator)
	_TrayDeleteItem($tray_menu_seperator2)
	_TrayDeleteItem($tray_openbash)
	_TrayDeleteItem($tray_openXServer)
	_TrayDeleteItem($tray_ReStartApache)
	_TrayDeleteItem($tray_sub_QuickLaunch)
	_TrayDeleteItem($tray_sub_Drives)
	_TrayDeleteItem($tray_sub_QuickLink)
EndFunc   ;==>DeleteMenu

Func BuildTrayMenu()
	Opt("GUIOnEventMode", 1)
	$nTrayIcon1 = _TrayIconCreate("CygwinPortable.exe", "CygwinPortable.exe")
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

	$FolderList=_FileListToArray(@ScriptDir & "\data\ShellScript\", "*")
	If Not @error Then
		$count = $FolderList[0]
		for $x = 1 to $count
			_PathSplit(@ScriptDir & "\data\ShellScript\" & $FolderList[$x], $szDrive, $szDir, $szFName, $szExt)
			if $szExt <> ".ico" and $szExt <> ".lnk" Then

				local $quicklaunch = _TrayCreateItem($FolderList[$x], $tray_sub_QuickLaunch)
				If FileExists(@ScriptDir & "\data\ShellScript\" & $FolderList[$x] & ".ico") then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\data\ShellScript\" & $FolderList[$x] & ".ico")
				ElseIf $szExt == '.sh' Then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\App\AppInfo\appicon1.ico")
				ElseIf $szExt == '.bat' Then
					_TrayItemSetIcon($quicklaunch, "shell32.dll", -72)
				ElseIf $szExt == '.exe' Then
					_TrayItemSetIcon($quicklaunch, @ScriptDir & "\data\ShellScript\" & $FolderList[$x])
				Else
					_TrayItemSetIcon($quicklaunch, "shell32.dll", -3)

				EndIf
				GUICtrlSetOnEvent(-1, "cygwinOpenShellScript")
			EndIf
			if $szExt == ".lnk" Then
				Local $aDetails = FileGetShortcut(@ScriptDir & "\data\ShellScript\" & $FolderList[$x])
				If Not @error Then
					if $szExt == ".lnk" Then
						local $quicklink = _TrayCreateItem($szFName, $tray_sub_QuickLaunch)
						;_TrayItemSetIcon($quicklink, $aDetails[4])
						_TrayItemSetIcon($quicklink, $aDetails[0])
					EndIf
					GUICtrlSetOnEvent(-1, "cygwinOpenGuiQuickkinks")
				EndIf
			EndIf

		Next
	EndIf

	$tray_sub_QuickLink = _TrayCreateMenu("Shortcuts")
	_TrayItemSetIcon(-1, "shell32.dll", -264)

	$QuickLinksFolderList=_FileListToArray(@ScriptDir & "\data\Shortcuts\", "*")
	If Not @error Then
		$count = $QuickLinksFolderList[0]
		for $x = 1 to $count
			_PathSplit(@ScriptDir & "\data\Shortcuts\" & $QuickLinksFolderList[$x], $szDrive, $szDir, $szFName, $szExt)
			Local $aDetails = FileGetShortcut(@ScriptDir & "\data\Shortcuts\" & $QuickLinksFolderList[$x])
			If Not @error Then
				if $szExt == ".lnk" Then
					local $quicklink = _TrayCreateItem($szFName, $tray_sub_QuickLink)
					;_TrayItemSetIcon($quicklink, $aDetails[4])
					_TrayItemSetIcon($quicklink, $aDetails[0])
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

	$tray_openbash = _TrayCreateItem("Open Bash (C:\)")
	_TrayItemSetIcon($tray_openbash, @ScriptDir & "\App\AppInfo\appicon2.ico")
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openXServer = _TrayCreateItem("open XServer")
	_TrayItemSetIcon($tray_openXServer, @ScriptDir & "\App\AppInfo\appicon3.ico")
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openCygwinConfig = _TrayCreateItem("Open Cygwin Setup")
	_TrayItemSetIcon($tray_openCygwinConfig, "shell32.dll", -58)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openCygwinConfigPorts = _TrayCreateItem("Open Cygwin Setup (cygwinports)")
	_TrayItemSetIcon($tray_openCygwinConfigPorts, "shell32.dll", -58)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	$tray_openCygwinPortableConfig = _TrayCreateItem("CygwinPortable Settings")
	_TrayItemSetIcon($tray_openCygwinPortableConfig, "shell32.dll", -58)
	GUICtrlSetOnEvent(-1, "TrayEvent")



	$tray_menu_seperator2 = _TrayCreateItem("")
	_TrayItemSetIcon($tray_menu_seperator2, "", 0)

	$tray_TrayExit = _TrayCreateItem("Beenden")
	_TrayItemSetIcon($tray_TrayExit, "shell32.dll", -28)
	GUICtrlSetOnEvent(-1, "TrayEvent")

	_TrayIconSetState()
	;TrayMenuRightClick()
EndFunc   ;==>BuildMenu

Func cygwinOpenShellScript()
	cygwinOpen(@ScriptDir & "\data\ShellScript\" & _GetMenuText(@GUI_CtrlId))
EndFunc   ;==>TrayEvent

Func cygwinOpenGuiDrive()
	cygwinOpen(_GetMenuText(@GUI_CtrlId))
EndFunc   ;==>TrayEvent

Func cygwinOpenGuiQuickkinks()
	$QuickLinksFolderList=_FileListToArray(@ScriptDir & "\data\Shortcuts\", "*")
	$count = $QuickLinksFolderList[0]
	for $x = 1 to $count
		_PathSplit(@ScriptDir & "\data\Shortcuts\" & $QuickLinksFolderList[$x], $szDrive, $szDir, $szFName, $szExt)
		if $szFName == _GetMenuText(@GUI_CtrlId) Then
			Local $aDetails = FileGetShortcut(@ScriptDir & "\data\Shortcuts\" & $QuickLinksFolderList[$x])
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
		Case $tray_openbash
			cygwinOpen("C:\")
		Case $tray_openCygwinConfig
			OpenConfig()
		Case $tray_openCygwinConfigPorts
			OpenConfigPorts()
		Case $tray_openCygwinPortableConfig
			CygwinPortableSettingsGUI()
		Case $tray_openXServer
			Run (@ScriptDir & "\app\cygwin\bin\run.exe /bin/bash.exe -c '/usr/bin/startxwin.exe -- -nolock -unixkill'", "", @SW_HIDE )
	EndSwitch
EndFunc   ;==>TrayEvent

Func OpenConfig()
	ShellExecute(@ScriptDir & "\App\Cygwin\CygwinConfig.exe", " -R " & @ScriptDir & " -l " & @ScriptDir & "\packages -n -d -N -s " & $cygwinMirror , @ScriptDir, "")
EndFunc

Func OpenConfigPorts()
	ShellExecute(@ScriptDir & "\App\Cygwin\CygwinConfig.exe", " -K http://cygwinports.org/ports.gpg -R " & @ScriptDir & " -l " & @ScriptDir & "\packages -n -d -N -s " & $cygwinPortsMirror, @ScriptDir, "")
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

	Local $correctPath = StringInStr($cygwinOpenPath, ":")
	Local $existingPath = FileExists ($cygwinOpenPath)

	if $correctPath == 0 Then
		if $cygwinNoMsgBox == False Then
			MsgBox(16, "Error", $cygwinOpenPath & " is not a correct Windows path", 16)
		 EndIf
	 EndIf

	if FileExists ($cygwinOpenPath)<> True Then
		if $cygwinNoMsgBox == False Then
			MsgBox(16, "Error", $cygwinOpenPath & " is not a existing file or directory", 16)
		 EndIf
	 EndIf

	if $cygwinOpenPath <> "" and $correctPath <> 0 and $existingPath <> False Then
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
				$executableExtensionRun = StringSplit($iniMain[$iniMainValue][1], ",")
				for $iniMainExecutableExtensionArray=1 to ubound($executableExtensionRun,1) -1
					if $executableExtensionRun[$iniMainExecutableExtensionArray] == StringReplace($szExt, ".", "" ) Then
						$executable = True
					EndIf
				next
			EndIf
		Next
		;Run (@ScriptDir & "\app\ConEmu\ConEmu.exe /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c cd C:")
		;ShellExecute(@ScriptDir & "\app\ConEmu\ConEmu.exe", " /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c 'cd /home;exec /bin/bash.exe" , @ScriptDir, "")
		if $cygfile <> "" and $executable == True Then
			local $executeCommand = ";./" & $cygfile
			if $szExt == "py" Then
				local $executeCommand = "python " & $cygfile
			EndIf

			if $exitAfterExec == False Then
				if $shell == "ConEmu" Then
					ShellExecute(@ScriptDir & "\app\ConEmu\ConEmu.exe", " /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c 'cd " & $cygdrive & $cygfolder & $executeCommand & ";exec /bin/bash.exe'" , @ScriptDir, "")
				Else
					Run (@ScriptDir & "\app\cygwin\bin\mintty --config /home/" & $cygwinUsername & "/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & $executeCommand & ";exec /bin/bash.exe'")
				EndIf
			Else
				if $shell == "ConEmu" Then
					ShellExecute(@ScriptDir & "\app\ConEmu\ConEmu.exe", " /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c 'cd " & $cygdrive & $cygfolder & $executeCommand & "'" , @ScriptDir, "")
				Else
					Run (@ScriptDir & "\app\cygwin\bin\mintty --config /home/" & $cygwinUsername & "/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & $executeCommand & "'")
				EndIf
			EndIf
		Else
			if $shell == "ConEmu" Then
				ShellExecute(@ScriptDir & "\app\ConEmu\ConEmu.exe", " /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c 'cd " & $cygdrive & $cygfolder & "/; exec /bin/bash.exe'", @ScriptDir, "")
			Else
				Run (@ScriptDir & "\app\cygwin\bin\mintty --config /home/" & $cygwinUsername & "/.minttyrc -e /bin/bash.exe -c 'cd " & $cygdrive & $cygfolder & "/; exec /bin/bash.exe'")
			EndIf
		EndIf
	ElseIf $correctPath <> 0 and $existingPath <> False Then
		if $shell == "ConEmu" Then
			ShellExecute(@ScriptDir & "\app\ConEmu\ConEmu.exe", " /cmd " & @ScriptDir & "\app\cygwin\bin\bash.exe --login -i -c 'cd C:;exec /bin/bash.exe'", @ScriptDir, "")
		Else
			Run (@ScriptDir & "\app\cygwin\bin\mintty --config /home/" & $cygwinUsername & "/.minttyrc -e /bin/bash.exe -c 'cd C:;exec /bin/bash.exe'")
		EndIf
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
	RegWrite('HKEY_LOCAL_MACHINE\SOFTWARE\Classes\Directory\Background\shell\OpenDirectoryInCygwinBackground', '', 'REG_SZ', 'Open Folder/Drive in Cygwin')
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