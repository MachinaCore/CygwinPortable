#include-once
; ----------------------------------------------------------------------------
;
; AutoIt Version: 3.3.1.2
; Author:         Tuape
; Modified:       Erik Pilsits
;
; Script Function:
;   Systray UDF - Functions for reading icon info from system tray / removing
;   any icon.
;
; Last Update: 1/13/11
;
; ----------------------------------------------------------------------------

;===============================================================================
;
; Function Name:    _SysTrayIconCount($iWin = 1)
; Description:      Returns number of icons on systray
;                   Note: Hidden icons are also reported
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns number of icons found
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconCount($iWin = 1)
    Local Const $TB_BUTTONCOUNT = 1048
    Local $hWnd = _FindTrayToolbarWindow($iWin)
    If $hWnd = -1 Then Return -1
    Local $count = DllCall("user32.dll", "int", "SendMessageW", "hwnd", $hWnd, "uint", $TB_BUTTONCOUNT, "wparam", 0, "lparam", 0)
    If @error Then Return -1
    Return $count[0]
EndFunc   ;==>_SysTrayIconCount

;===============================================================================
;
; Function Name:    _SysTrayIconTitles($iWin = 1)
; Description:      Get list of all window titles that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all window titles
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconTitles($iWin = 1)
    Local $count = _SysTrayIconCount($iWin)
    If $count <= 0 Then Return -1
    Local $titles[$count]
    ; Get icon owner window"s title
    For $i = 0 To $count - 1
        $titles[$i] = WinGetTitle(_SysTrayIconHandle($i, $iWin))
    Next
    Return $titles
EndFunc   ;==>_SysTrayIconTitles

;===============================================================================
;
; Function Name:    _SysTrayIconPids($iWin = 1)
; Description:      Get list of all processes id's that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process id's
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPids($iWin = 1)
    Local $count = _SysTrayIconCount($iWin)
    If $count <= 0 Then Return -1
    Local $processes[$count]
    For $i = 0 To $count - 1
        $processes[$i] = WinGetProcess(_SysTrayIconHandle($i, $iWin))
    Next
    Return $processes
EndFunc   ;==>_SysTrayIconPids

;===============================================================================
;
; Function Name:    _SysTrayIconProcesses($iWin = 1)
; Description:      Get list of all processes that have systray icon
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns an array with all process names
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconProcesses($iWin = 1)
    Local $pids = _SysTrayIconPids($iWin)
    If Not IsArray($pids) Then Return -1
    Local $processes[UBound($pids)]
    ; List all processes
    Local $list = ProcessList()
    For $i = 0 To UBound($pids) - 1
        For $j = 1 To $list[0][0]
            If $pids[$i] = $list[$j][1] Then
                $processes[$i] = $list[$j][0]
                ExitLoop
            EndIf
        Next
    Next
    Return $processes
EndFunc   ;==>_SysTrayIconProcesses

;===============================================================================
;
; Function Name:    _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
; Description:      Get list of all processes id"s that have systray icon
; Parameter(s):     $test       - process name / window title text / process PID
;                   $mode
;                   | 0         - get index by process name (default)
;                   | 1         - get index by window title
;                   | 2         - get index by process PID
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
; Requirement(s):
; Return Value(s):  On Success - Returns index of found icon
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconIndex($test, $mode = 0, $iWin = 1)
    Local $ret = -1, $compare = -1
    If $mode < 0 Or $mode > 2 Or Not IsInt($mode) Then Return -1
    Switch $mode
        Case 0
            $compare = _SysTrayIconProcesses($iWin)
        Case 1
            $compare = _SysTrayIconTitles($iWin)
        Case 2
            $compare = _SysTrayIconPids($iWin)
    EndSwitch
    If Not IsArray($compare) Then Return -1
    For $i = 0 To UBound($compare) - 1
        If $compare[$i] = $test Then
            $ret = $i
            ExitLoop
        EndIf
    Next
    Return $ret
EndFunc   ;==>_SysTrayIconIndex

; INTERNAL =====================================================================
;
; Function Name:    _SysTrayGetButtonInfo($iIndex = 0, $iWin = 1, $iInfo = 0)
; Description:      Gets Tray Button Info
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;                   $iInfo      - Info to return
;                   | 0         - TBBUTTON structure
;                   | 1         - owner handle
;                   | 2         - button tooltip
;                   | 3         - icon position
;                   | 4         - icon visibility
;                   $iHide      - extra param to hide/show a button
;                   | 0         - show button
;                   | 1         - hide button
; Requirement(s):
; Return Value(s):  On Success - Returns requested info
;                   On Failure - Returns -1 in error situations
;
; Author(s):        Erik Pilsits, Tuape
;
;===============================================================================
Func _SysTrayGetButtonInfo($iIndex, $iWin = 1, $iInfo = 0, $iHide = -1)
    ;=========================================================
    ;   Create the struct _TBBUTTON
    ;   struct {
    ;   int         iBitmap;
    ;    int         idCommand;
    ;    BYTE     fsState;
    ;    BYTE     fsStyle;
    ;
    ;   #ifdef _WIN64
    ;    BYTE     bReserved[6]     // padding for alignment
    ;   #elif defined(_WIN32)
    ;    BYTE     bReserved[2]     // padding for alignment
    ;   #endif
    ;    DWORD_PTR   dwData;
    ;    INT_PTR          iString;
    ;   }
    ;=========================================================
    Local Const $TB_GETBUTTON = 1047
;~  Local Const $TB_GETBUTTONTEXT = 1099
;~  Local Const $TB_GETBUTTONINFO = 1089
    Local Const $TB_HIDEBUTTON = 1028 ; WM_USER +4
    Local Const $TB_GETITEMRECT = 1053
    Local $taglocalTBBUTTON
    If @OSArch = "X86" Then
        $taglocalTBBUTTON = "int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[2];uint dwData;int iString"
    Else ; X64
        $taglocalTBBUTTON = "int iBitmap;int idCommand;byte fsState;byte fsStyle;byte bReserved[6];uint64 dwData;int64 iString"
    EndIf
    Local Const $ACCESS = BitOR(0x0008, 0x0010, 0x0400) ; VM_OPERATION, VM_READ, QUERY_INFORMATION
    Local $TBBUTTON = DllStructCreate($taglocalTBBUTTON)
    Local $ExtraData = DllStructCreate("hwnd[2]")
    Local $trayHwnd = _FindTrayToolbarWindow($iWin)
    Local $return = -1
    If $trayHwnd = -1 Then Return -1
    Local $ret = DllCall("user32.dll", "dword", "GetWindowThreadProcessId", "hwnd", $trayHwnd, "dword*", 0)
    If @error Or Not $ret[2] Then Return -1
    Local $pId = $ret[2]
    Local $procHandle = DllCall("kernel32.dll", "ptr", "OpenProcess", "dword", $ACCESS, "int", False, "dword", $pId)
    If @error Or Not $procHandle[0] Then Return -2
    Local $lpData = DllCall("kernel32.dll", "ptr", "VirtualAllocEx", "ptr", $procHandle[0], "ptr", 0, "ulong", DllStructGetSize($TBBUTTON), "dword", 0x1000, "dword", 0x04)
    If Not @error And $lpData[0] Then
        DllCall("user32.dll", "int", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETBUTTON, "wparam", $iIndex, "lparam", $lpData[0])
        DllCall("kernel32.dll", "int", "ReadProcessMemory", "ptr", $procHandle[0], "ptr", $lpData[0], "ptr", DllStructGetPtr($TBBUTTON), "ulong", DllStructGetSize($TBBUTTON), "ulong*", 0)
        Switch $iInfo
            Case 0
                ; TBBUTTON / hide
                If $iHide <> -1 Then
                    ;hide/show button
                    Local $visible = Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
                    If ($iHide And Not $visible) Or (Not $iHide And $visible) Then
                        $return = 0
                    Else
                        $ret = DllCall("user32.dll", "int", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_HIDEBUTTON, "wparam", DllStructGetData($TBBUTTON, 2), "lparam", $iHide)
                        If @error Or Not $ret[0] Then
                            $return = -1
                        Else
                            $return = $ret[0]
                        EndIf
                    EndIf
                Else
                    ; return structure
                    $return = $TBBUTTON
                EndIf
            Case 1
                ; owner handle
                DllCall("kernel32.dll", "int", "ReadProcessMemory", "ptr", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 6), "ptr", DllStructGetPtr($ExtraData), "ulong", DllStructGetSize($ExtraData), "ulong*", 0)
                $return = DllStructGetData($ExtraData, 1, 1)
            Case 2
                ; tooltip
                $return = ""
                If BitShift(DllStructGetData($TBBUTTON, 7), 16) <> 0 Then
                    Local $intTip = DllStructCreate("wchar[1024]")
                    ; we have a pointer to a string, otherwise it is an internal resource identifier
                    DllCall("kernel32.dll", "int", "ReadProcessMemory", "ptr", $procHandle[0], "ptr", DllStructGetData($TBBUTTON, 7), "ptr", DllStructGetPtr($intTip), "ulong", DllStructGetSize($intTip), "ulong*", 0)
                    $return = DllStructGetData($intTip, 1)
                    If $return = "" Then $return = "No tooltip text."
                ;else internal resource
                EndIf
            Case 3
                ; icon position
                If Not BitAND(DllStructGetData($TBBUTTON, 3), 8) Then ; 8 = TBSTATE_HIDDEN
                    Local $pos[2], $RECT = DllStructCreate("int;int;int;int")
                    DllCall("user32.dll", "int", "SendMessageW", "hwnd", $trayHwnd, "uint", $TB_GETITEMRECT, "wparam", $iIndex, "lparam", $lpData[0])
                    DllCall("kernel32.dll", "int", "ReadProcessMemory", "ptr", $procHandle[0], "ptr", $lpData[0], "ptr", DllStructGetPtr($RECT), "ulong", DllStructGetSize($RECT), "ulong*", 0)
                    $ret = DllCall("user32.dll", "int", "MapWindowPoints", "hwnd", $trayHwnd, "int", 0, "ptr", DllStructGetPtr($RECT), "int", 2)
                    $pos[0] = DllStructGetData($RECT, 1)
                    $pos[1] = DllStructGetData($RECT, 2)
                    $return = $pos
                Else
                    $return = -1
                EndIf
            Case 4
                ; is visible
                $return = Not BitAND(DllStructGetData($TBBUTTON, 3), 8) ;TBSTATE_HIDDEN
        EndSwitch
        DllCall("kernel32.dll", "int", "VirtualFreeEx", "ptr", $procHandle[0], "ptr", $lpData[0], "ulong", 0, "dword", 0x8000)
    Else
        $return = -3
    EndIf
    DllCall("kernel32.dll", "int", "CloseHandle", "ptr", $procHandle[0])
    Return $return
EndFunc   ;==>_SysTrayGetButtonInfo

;===============================================================================
;
; Function Name:    _SysTrayIconHandle($iIndex, $iWin = 1)
; Description:      Gets hwnd of window associated with systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns hwnd of found icon
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHandle($iIndex, $iWin = 1)
    Return _SysTrayGetButtonInfo($iIndex, $iWin, 1)
EndFunc   ;==>_SysTrayIconHandle

;===============================================================================
;
; Function Name:    _SysTrayIconTooltip($iIndex, $iWin = 1)
; Description:      Gets the tooltip text of systray icon of given index
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns tooltip text of icon
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconTooltip($iIndex, $iWin = 1)
    Return _SysTrayGetButtonInfo($iIndex, $iWin, 2)
EndFunc   ;==>_SysTrayIconTooltip

;===============================================================================
;
; Function Name:    _SysTrayIconPos($iIndex, $iWin = 1)
; Description:      Gets x & y position of systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns x [0] and y [1] position of icon
;                   On Failure - Returns -1, also if icon is hidden (Autohide on XP etc.)
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconPos($iIndex, $iWin = 1)
    Return _SysTrayGetButtonInfo($iIndex, $iWin, 3)
EndFunc   ;==>_SysTrayIconPos

;===============================================================================
;
; Function Name:    _SysTrayIconVisible($iIndex, $iWin = 1)
; Description:      Gets the visibility of a systray icon
; Parameter(s):     $iIndex     - icon index (Note: starting from 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns True (visible) or False (hidden)
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconVisible($iIndex, $iWin = 1)
    Return _SysTrayGetButtonInfo($iIndex, $iWin, 4)
EndFunc   ;==>_SysTrayIconVisible

;===============================================================================
;
; Function Name:    _SysTrayIconHide($index, $iFlag, $iWin)
; Description:      Hides / unhides any icon on systray
;
; Parameter(s):     $index      - icon index. Can be queried with _SysTrayIconIndex()
;                   $iFlag      - hide (1) or show (0) icon
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):
; Return Value(s):  On Success - Returns 1 if operation was successfull or 0 if
;                   icon was already hidden/unhidden
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconHide($index, $iFlag, $iWin = 1)
    Return _SysTrayGetButtonInfo($index, $iWin, 0, $iFlag)
EndFunc   ;==>_SysTrayIconHide

;===============================================================================
;
; Function Name:    _SysTrayIconMove($curPos, $newPos)
; Description:      Moves systray icon
;
; Parameter(s):     $curPos     - icon's current index (0 based)
;                   $newPos     - icon's new position
;                                 ($curPos+1 = one step to right, $curPos-1 = one step to left)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):   AutoIt3 Beta
; Return Value(s):  On Success - Returns 1 if operation was successfull
;                   On Failure - If invalid parameters, returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconMove($curPos, $newPos, $iWin = 1)
    Local Const $TB_MOVEBUTTON = 1106 ; WM_USER +82
    Local $iconCount = _SysTrayIconCount($iWin)
    If $iconCount <= 0 Then Return -1
    If $curPos < 0 Or $newPos < 0 Or $curPos > $iconCount - 1 Or $newPos > $iconCount - 1 Or Not IsInt($curPos) Or Not IsInt($newPos) Then Return -1
    Local $hWnd = _FindTrayToolbarWindow($iWin)
    If $hWnd = -1 Then Return -1
    Local $ret = DllCall("user32.dll", "int", "SendMessageW", "hwnd", $hWnd, "uint", $TB_MOVEBUTTON, "wparam", $curPos, "lparam", $newPos)
    If @error Or Not $ret[0] Then Return -1
    Return $ret[0]
EndFunc   ;==>_SysTrayIconMove

;===============================================================================
;
; Function Name:    _SysTrayIconRemove($index=0)
; Description:      Removes systray icon completely.
;
; Parameter(s):     $index      - Icon index (first icon is 0)
;                   $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):   AutoIt3 Beta
; Return Value(s):  On Success - Returns 1 if icon successfully removed
;                   On Failure - Returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _SysTrayIconRemove($index, $iWin = 1)
    Local Const $TB_DELETEBUTTON = 1046
    If $index < 0 Or $index > _SysTrayIconCount($iWin) - 1 Then Return -1
    Local $hWnd = _FindTrayToolbarWindow($iWin)
    If $hwnd = -1 Then Return -1
    Local $ret = DllCall("user32.dll", "int", "SendMessageW", "hwnd", $hWnd, "uint", $TB_DELETEBUTTON, "wparam", $index, "lparam", 0)
    If @error Or Not $ret[0] Then Return -1
    Return $ret[0]
EndFunc   ;==>_SysTrayIconRemove

;===============================================================================
;
; Function Name:    _FindTrayToolbarWindow
; Description:      Utility function for finding Toolbar window hwnd
; Parameter(s):     $iWin
;                   | 1         - ToolbarWindow32, Win2000+
;                   | 2         - NotifyIconOverflowWindow, Win7+
;
; Requirement(s):   AutoIt3 Beta
; Return Value(s):  On Success - Returns Toolbar window hwnd
;                   On Failure - returns -1
;
; Author(s):        Tuape, Erik Pilsits
;
;===============================================================================
Func _FindTrayToolbarWindow($iWin = 1)
    Local $hwnd, $ret = -1
    If $iWin = 1 Then
        $hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "Shell_TrayWnd", "ptr", 0)
        If @error Then Return -1
        $hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "TrayNotifyWnd", "ptr", 0)
        If @error Then Return -1
        If @OSVersion <> "WIN_2000" Then
            $hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "SysPager", "ptr", 0)
            If @error Then Return -1
        EndIf
        $hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
        If @error Then Return -1
        $ret = $hwnd[0]
    ElseIf $iWin = 2 Then
        ; NotifyIconOverflowWindow for Windows 7
        $hWnd = DllCall("user32.dll", "hwnd", "FindWindow", "str", "NotifyIconOverflowWindow", "ptr", 0)
        If @error Then Return -1
        $hWnd = DllCall("user32.dll", "hwnd", "FindWindowEx", "hwnd", $hWnd[0], "hwnd", 0, "str", "ToolbarWindow32", "ptr", 0)
        If @error Then Return -1
        $ret = $hwnd[0]
    EndIf
    Return $ret
EndFunc   ;==>_FindTrayToolbarWindow