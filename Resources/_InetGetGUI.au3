; #AutoIt3Wrapper_Au3Check_Parameters=-d -w 1 -w 2 -w 3 -w 4 -w 5 -w 6 -w 7
; #INDEX# =======================================================================================================================
; Title .........: _InetGetGUI
; AutoIt Version : v3.3.2.0 or higher
; Language ......: English
; Description ...: Download a file updating a GUICtrlCreateProgress.
; Note ..........:
; Author(s) .....: guinness
; Remarks .......:
; ===============================================================================================================================

; #CURRENT# =====================================================================================================================
; _InetGetGUI: Download a file updating a GUICtrlCreateProgress.
; ===============================================================================================================================

; #INTERNAL_USE_ONLY#============================================================================================================
; _ByteSuffix ......; Convert bytes to the largest measure. Thanks to Spliff69 - http://www.autoitscript.com/forum/topic/...ync-tool/page__view__findpost_
; ===============================================================================================================================

; #FUNCTION# =========================================================================================================
; Name...........: _InetGetGUI()
; Description ...: Download a file updating a GUICtrlCreateProgress().
; Syntax.........: _InetGetGUI($sURL, $iLabel, $iProgress, $iButton, [$sDirectory = @ScriptDir])
;                 $sURL - A valid URL that contains the filename too.
;                 $iLabel - ControlID of a GUICtrlCreateLabel.
;                 $iProgress - ControlID of a GUICtrlCreateProgress.
;                 $iButton - ControlID of a GUICtrlCreateButton.
;                 $sDirectory - [Optional] Directory of where to download to. Default = @ScriptDir
; Parameters ....: None
; Requirement(s).: v3.3.2.0 or higher
; Return values .: Success - Downloaded filename.
;                  Failure - Returns downloaded filename & sets @error = 1 (@extended = 0 if internal error or @extended = 1 if cancelled was selected.)
; Author ........: guinness
; Example........; Yes
;=====================================================================================================================
Func _InetGetGUI($sURL, $iLabel, $iProgress, $iButton, $sDirectory = @ScriptDir)
    Local $hDownload, $iBytesRead = 0, $iError = 0, $iFileSize, $iPercentage, $iSpeed = 0, $iTimer = 0, $sFilePath, $sProgressText, $sRead = GUICtrlRead($iButton), $sSpeed
    $sFilePath = StringRegExpReplace($sURL, "^.*/", "")
    If @error Then
        Return SetError(1, 0, $sFilePath)
    EndIf

    $sDirectory = StringRegExpReplace($sDirectory, "[\\/]+\z", "") & "\" & $sFilePath
    $iFileSize = InetGetSize($sURL, 1)
    $hDownload = InetGet($sURL, $sDirectory, 0, 1)
    If @error Then
        Return SetError(1, $iError, $sFilePath)
    EndIf
    GUICtrlSetData($iButton, "&Cancel")

    $sSpeed = "Current Speed: " & _ByteSuffix($iBytesRead - $iSpeed) & "/s"
    $iTimer = TimerInit()
    While InetGetInfo($hDownload, 2) = 0
        Switch GUIGetMsg()
            Case $GUI_EVENT_CLOSE, $iButton
                GUICtrlSetData($iLabel, "Download Cancelled!")
                $iError = 1
                ExitLoop
        EndSwitch

        $iBytesRead = InetGetInfo($hDownload, 0)
        $iPercentage = $iBytesRead * 100 / $iFileSize
        $sProgressText = "Downloading " & _ByteSuffix($iBytesRead, 0) & " Of " & _ByteSuffix($iFileSize, 0) & @LF & $sSpeed
        GUICtrlSetData($iLabel, $sProgressText)
        GUICtrlSetData($iProgress, $iPercentage)

        If TimerDiff($iTimer) > 1000 Then
            $sSpeed = "Current Speed: " & _ByteSuffix($iBytesRead - $iSpeed) & "/s"
            $iSpeed = $iBytesRead
            $iTimer = TimerInit()
        EndIf
        Sleep(100)
    WEnd
    InetClose($hDownload)
    GUICtrlSetData($iButton, $sRead)
    Return SetError($iError, $iError, $sFilePath)
EndFunc   ;==>_InetGetGUI

; #INTERNAL_USE_ONLY#============================================================================================================
Func _ByteSuffix($iBytes, $iRound = 2)
    Local $A, $aArray[9] = [" B", " KB", " MB", " GB", " TB", " PB", " EB", " ZB", " YB"]
    While $iBytes > 1023
        $A += 1
        $iBytes /= 1024
    WEnd
    Return Round($iBytes, $iRound) & $aArray[$A]
EndFunc   ;==>_ByteSuffix
; #INTERNAL_USE_ONLY#============================================================================================================