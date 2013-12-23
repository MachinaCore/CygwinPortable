;********************************************************************
; ModernMenu UDF by Holger Kotsch modified 08 August 2008 from ProgAndy
; Version-date: 06.05.2008
; Cybetech Changes
; Line 417 changed
;********************************************************************

#include-once

Global $sLOGFONT						=	"int;" & _ ; Height
											"int;" & _ ; Average width
											"int;" & _ ; Excapement
											"int;" & _ ; Orientation
											"int;" & _ ; Weight
											"byte;" & _ ; Italic
											"byte;" & _ ; Underline
											"byte;" & _ ; Strikeout
											"byte;" & _ ; Charset
											"byte;" & _ ; Outprecision
											"byte;" & _ ; Clipprecision
											"byte;" & _ ; Quality
											"byte;" & _ ; Pitch & Family
											"wchar[32]" ; Font name

Global Const $sNONCLIENTMETRICS			=	"uint;" & _ ; Struct size
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Caption LogFont structure
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Small caption LogFont structure
											"int;" & _ ;
											"int;" & _ ;
											$sLOGFONT & ";" & _ ; Menu LogFont structure
											$sLOGFONT & ";" & _ ; Statusbar LogFont structure
											$sLOGFONT ; Message box LogFont structure


Global Const $sMENUITEMINFO				=	"uint;" & _ ;
											"uint;" & _ ;
											"uint;" & _ ;
											"uint;" & _ ;
											"uint;" & _ ;
											"hwnd;" & _ ;
											"hwnd;" & _ ;
											"hwnd;" & _ ;
											"long;" & _ ;
											"ptr;" & _ ;
											"uint;" & _ ;
											"hwnd"


;**********************************************************************
; NotifyIconData struct
;**********************************************************************
Global $sNOTIFYICONDATAW					=	"dword;" & _ ; Struct size
												"hwnd;" & _ ; Callback window handle
												"uint;" & _ ; Icon ID
												"uint;" & _ ; Flags
												"uint;" & _ ; Callback message ID
												"hwnd;" ; Icon handle

Switch @OSVersion
	Case "WIN_95", "WIN_98", "WIN_NT4"
		$sNOTIFYICONDATAW &= "wchar[64]" ; ToolTip text

	Case Else
		$sNOTIFYICONDATAW &= "wchar[128];" & _ ; ToolTip text
							"dword;" & _ ; Icon state
							"dword;" & _ ; Icon state mask
							"wchar[256];" & _ ; Balloon ToolTip text
							"uint;" & _ ; Timeout / Version -> NIM_SETVERSION values 0, 3, 4
							"wchar[64];" & _ ; Balloon ToolTip title text
							"dword" ; Balloon ToolTip info flags
EndSwitch


;**********************************************************************
; Notify icon constants
;**********************************************************************
If Not IsDeclared("NIN_SELECT")				Then Global Const $NIN_SELECT = 0x0400
If Not IsDeclared("NINF_KEY")				Then Global Const $NINF_KEY = 0x1
If Not IsDeclared("NIN_KEYSELECT")			Then Global Const $NIN_KEYSELECT = BitOr($NIN_SELECT, $NINF_KEY)
If Not IsDeclared("NIN_BALLOONSHOW")		Then Global Const $NIN_BALLOONSHOW = 0x0400 + 2
If Not IsDeclared("NIN_BALLOONHIDE")		Then Global Const $NIN_BALLOONHIDE = 0x0400 + 3
If Not IsDeclared("NIN_BALLOONTIMEOUT")		Then Global Const $NIN_BALLOONTIMEOUT = 0x0400 + 4
If Not IsDeclared("NIN_BALLOONUSERCLICK")	Then Global Const $NIN_BALLOONUSERCLICK = 0x0400 + 5
If Not IsDeclared("NIN_POPUPOPEN")			Then Global Const $NIN_POPUPOPEN = 0x0400 + 6
If Not IsDeclared("NIN_POPUPCLOSE")			Then Global Const $NIN_POPUPCLOSE = 0x0400 + 7

If Not IsDeclared("NIM_ADD")				Then Global Const $NIM_ADD = 0x00000000
If Not IsDeclared("NIM_MODIFY")				Then Global Const $NIM_MODIFY = 0x00000001
If Not IsDeclared("NIM_DELETE")				Then Global Const $NIM_DELETE = 0x00000002
If Not IsDeclared("NIM_SETFOCUS")			Then Global Const $NIM_SETFOCUS = 0x00000003
If Not IsDeclared("NIM_SETVERSION")			Then Global Const $NIM_SETVERSION = 0x00000004

If Not IsDeclared("NIF_MESSAGE")			Then Global Const $NIF_MESSAGE = 0x00000001
If Not IsDeclared("NIF_ICON")				Then Global Const $NIF_ICON = 0x00000002
If Not IsDeclared("NIF_TIP")				Then Global Const $NIF_TIP = 0x00000004
If Not IsDeclared("NIF_STATE")				Then Global Const $NIF_STATE = 0x00000008
If Not IsDeclared("NIF_INFO")				Then Global Const $NIF_INFO = 0x00000010
If Not IsDeclared("NIF_REALTIME")			Then Global Const $NIF_REALTIME = 0x00000040
If Not IsDeclared("NIF_SHOWTIP")			Then Global Const $NIF_SHOWTIP = 0x00000080

If Not IsDeclared("NIS_HIDDEN")				Then Global Const $NIS_HIDDEN = 0x00000001
If Not IsDeclared("NIS_SHAREDICON")			Then Global Const $NIS_SHAREDICON = 0x00000002

If Not IsDeclared("NIIF_NONE")				Then Global Const $NIIF_NONE = 0x00000000
If Not IsDeclared("NIIF_INFO")				Then Global Const $NIIF_INFO = 0x00000001
If Not IsDeclared("NIIF_WARNING")			Then Global Const $NIIF_WARNING = 0x00000002
If Not IsDeclared("NIIF_ERROR")				Then Global Const $NIIF_ERROR = 0x00000003
If Not IsDeclared("NIIF_USER")				Then Global Const $NIIF_USER = 0x00000004
If Not IsDeclared("NIIF_ICON_MASK")			Then Global Const $NIIF_ICON_MASK = 0x0000000F
If Not IsDeclared("NIIF_NOSOUND")			Then Global Const $NIIF_NOSOUND = 0x00000010
If Not IsDeclared("NIIF_LARGE_ICON")		Then Global Const $NIIF_LARGE_ICON = 0x00000020


;**********************************************************************
; Constants for LoadIcon()
;**********************************************************************
;If Not IsDeclared("IDI_APPLICATION")		Then Global Const $IDI_APPLICATION = 32512
;If Not IsDeclared("IDI_HAND")				Then Global Const $IDI_HAND = 32513
;If Not IsDeclared("IDI_QUESTION")			Then Global Const $IDI_QUESTION = 32514
;If Not IsDeclared("IDI_EXCLAMATION")		Then Global Const $IDI_EXCLAMATION = 32515
;If Not IsDeclared("IDI_ASTERISK")			Then Global Const $IDI_ASTERISK = 32516
;If Not IsDeclared("IDI_WINLOGO")			Then Global Const $IDI_WINLOGO = 32517


;**********************************************************************
; Mouse constants
;**********************************************************************
If Not IsDeclared("WM_MOUSEMOVE")			Then Global Const $WM_MOUSEMOVE = 0x0200
If Not IsDeclared("WM_LBUTTONDOWN")			Then Global Const $WM_LBUTTONDOWN = 0x0201
If Not IsDeclared("WM_LBUTTONUP")			Then Global Const $WM_LBUTTONUP = 0x0202
If Not IsDeclared("WM_LBUTTONDBLCLK")		Then Global Const $WM_LBUTTONDBLCLK = 0x0203
If Not IsDeclared("WM_RBUTTONDOWN")			Then Global Const $WM_RBUTTONDOWN = 0x0204
If Not IsDeclared("WM_RBUTTONUP")			Then Global Const $WM_RBUTTONUP = 0x0205
If Not IsDeclared("WM_RBUTTONDBLCLK")		Then Global Const $WM_RBUTTONDBLCLK = 0x0206
If Not IsDeclared("WM_MBUTTONDOWN")			Then Global Const $WM_MBUTTONDOWN = 0x0207
If Not IsDeclared("WM_MBUTTONUP")			Then Global Const $WM_MBUTTONUP = 0x0208
If Not IsDeclared("WM_MBUTTONDBLCLK")		Then Global Const $WM_MBUTTONDBLCLK = 0x0209


;********************************************************************
; Main Creation Part
;********************************************************************
Global $hComctl32Dll				= DllOpen("comctl32.dll")
Global $hGdi32Dll					= DllOpen("gdi32.dll")
Global $hKernel32Dll				= DllOpen("kernel32.dll")
Global $hShell32Dll					= DllOpen("shell32.dll")
Global $hUser32Dll					= DllOpen("user32.dll")
Global $hMsimg32Dll					= DllOpen("msimg32.dll")


Global $bUseAdvMenu					= TRUE
Global $bUseAdvTrayMenu				= TRUE
Global $bUseRGBColors				= FALSE

; Set default color values if not given
Global $nMenuBkClr					= 0xFFFFFF
Global $nMenuIconBkClr				= 0xDBD8D8
Global $nMenuSelectBkClr			= 0xD2BDB6
Global $nMenuSelectRectClr			= 0x854240
Global $nMenuSelectTextClr			= 0x000000
Global $nMenuTextClr				= 0x000000
Global $nMenuSideBkClr				= 0xD00000
Global $nMenuSideTxtClr				= 0xFFFFFF

Global $nTrayBkClr					= 0xFFFFFF
Global $nTrayIconBkClr				= 0xD1D8DB
Global $nTraySelectBkClr			= 0xD2BDB6
Global $nTraySelectRectClr			= 0x854240
Global $nTraySelectTextClr			= 0x000000
Global $nTrayTextClr				= 0x000000

If $bUseRGBColors Then
	$nMenuIconBkClr					= 0xD8D8DB
	$nMenuSelectBkClr				= 0xB6BDD2
	$nMenuSelectRectClr				= 0x404285
	$nMenuSideBkClr					= 0x0000D0

	$nTrayIconBkClr					= 0xDBD8D1
	$nTraySelectBkClr				= 0xB6BDD2
	$nTraySelectRectClr				= 0x404285
EndIf

Global $nMenuIconBkClr2				= $nMenuIconBkClr
Global $nMenuSideBkClr2				= $nMenuSideBkClr
Global $nTrayIconBkClr2				= $nTrayIconBkClr


; Store here the menu item:
; ID/Text/IconIndex/ParentMenu/Tray/SelIconIndex/IsMenu
Global $arMenuItems[1][8]
$arMenuItems[0][0] = 0
Global $nMenuItemsRedim				= 10

; Store here the side item:
; MenuHandle/Text/TextColor/BkColor/GradientColor/IsBitmap/BitmapHandle/Width/Height/Stretch
Global $arSideItems[1][10]
$arSideItems[0][0] = 0

; Create a usable font for using in ownerdrawn menus
Global $hMenuFont					= 0
_CreateMenuFont($hMenuFont)

; Create an image list for saving/drawing our menu icons
Global $hMenuImageList	= ImageList_Create(16, 16, BitOr(0x0001, 0x0020), 0, 1)

Global $hBlankIcon					= 0

; Store here the tray icon:
; NotifyID/TrayIcon/Menu/Click/ToolTip/Callback/OnlyMsg/Flash/FlashBlank
Global $TRAYNOTIFYIDS[1][9]
$TRAYNOTIFYIDS[0][0] = 0
Global $TRAYMSGWND					= 0
Global $TRAYNOTIFYID				= -1
Global $TRAYLASTID					= -1
Global $MENULASTITEM				= -1
Global $TRAYLASTITEM				= -1
Global $TRAYLASTMENU				= -1
Global $TRAYTIPMSG					= 0x0400 + 1 ; This message ID will be used in a GUIRegisterMsg() procdure
Global $FLASHTIMERID				= 3
Global $FLASHTIMEOUT				= 750
Global $sDefaultTT					= "AutoIt - " & @ScriptName

GUIRegisterMsg(0x002B, "WM_DRAWITEM")
GUIRegisterMsg(0x002C, "WM_MEASUREITEM")
GUIRegisterMsg($TRAYTIPMSG, "_TrayWndProc")
GUIRegisterMsg(0x001A, "WM_SETTINGCHANGE")
GUIRegisterMsg(0x0113, "WM_TIMER")

; Cleanup
Func OnAutoItExit()
	For $i = 0 To UBound($TRAYNOTIFYIDS)-1
		_TrayIconDelete($TRAYNOTIFYIDS[ $i ][0])
	Next
	ImageList_Destroy($hMenuImageList)
	DeleteObject($hMenuFont)

	For $i = 1 To $arSideItems[0][0]
		If $arSideItems[$i][6] <> 0 Then _
			DeleteObject($arSideItems[$i][6])
	Next

	DllClose($hComctl32Dll)
	DllClose($hGdi32Dll)
	DllClose($hKernel32Dll)
	DllClose($hShell32Dll)
	DllClose($hUser32Dll)
	DllClose($hMsimg32Dll)

	$arMenuItems	= 0
	$arSideItems	= 0
	$TRAYNOTIFYIDS	= 0
EndFunc


;********************************************************************
; Define the colors for the menu/selection bar
;********************************************************************
Func _SetMenuBkColor($nColor)
	$nMenuBkClr				= _GetBGRColor($nColor)
EndFunc

Func _SetMenuIconBkColor($nColor)
	$nMenuIconBkClr			= _GetBGRColor($nColor)
	$nMenuIconBkClr2		= $nMenuIconBkClr
EndFunc

Func _SetMenuIconBkGrdColor($nColor)
	$nMenuIconBkClr2		= _GetBGRColor($nColor)
EndFunc

Func _SetMenuSelectBkColor($nColor)
	$nMenuSelectBkClr		= _GetBGRColor($nColor)
EndFunc

Func _SetMenuSelectRectColor($nColor)
	$nMenuSelectRectClr		= _GetBGRColor($nColor)
EndFunc

Func _SetMenuSelectTextColor($nColor)
	$nMenuSelectTextClr		= _GetBGRColor($nColor)
EndFunc

Func _SetMenuTextColor($nColor)
	$nMenuTextClr			= _GetBGRColor($nColor)
EndFunc

Func _SetTrayBkColor($nColor)
	$nTrayBkClr				= _GetBGRColor($nColor)
EndFunc

Func _SetTrayIconBkColor($nColor)
	$nTrayIconBkClr			= _GetBGRColor($nColor)
	$nTrayIconBkClr2		= $nMenuIconBkClr
EndFunc

Func _SetTrayIconBkGrdColor($nColor)
	$nTrayIconBkClr2		= _GetBGRColor($nColor)
EndFunc

Func _SetTraySelectBkColor($nColor)
	$nTraySelectBkClr		= _GetBGRColor($nColor)
EndFunc

Func _SetTraySelectRectColor($nColor)
	$nTraySelectRectClr		= _GetBGRColor($nColor)
EndFunc

Func _SetTraySelectTextColor($nColor)
	$nTraySelectTextClr		= _GetBGRColor($nColor)
EndFunc

Func _SetTrayTextColor($nColor)
	$nTrayTextClr			= _GetBGRColor($nColor)
EndFunc

Func _SetSideMenuColor($nIdx, $nColor = -2)
	Return _SetSideMenuColors($nIdx, _GetBGRColor($nColor))
EndFunc

Func _SetSideMenuBkColor($nIdx, $nColor = -2)
	Return _SetSideMenuColors($nIdx, -1, _GetBGRColor($nColor))
EndFunc

Func _SetSideMenuBkGradColor($nIdx, $nColor = -2)
	Return _SetSideMenuColors($nIdx, -1, -1, _GetBGRColor($nColor))
EndFunc

Func _SetFlashTimeOut($nTime = 750)
	$FLASHTIMEOUT = $nTime
	If $FLASHTIMEOUT < 50 Then $FLASHTIMEOUT = 50
EndFunc


;**********************************************************************
; Return an BGR color to a given RGB color
;**********************************************************************
Func _GetBGRColor($nColor)
	If $bUseRGBColors And $nColor <> -2 Then
		Return BitOr(BitShift(BitAnd($nColor, 0xFF), -16), BitAnd($nColor, 0xFF00), BitShift($nColor, 16))
	Else
		Return $nColor
	EndIf
EndFunc


;**********************************************************************
; Get the icon ID like in newer Autoit versions
;**********************************************************************
Func _GetIconID($nID, $sFile)
	If StringRight($sFile, 4) = ".exe" Then
		If $nID < 0 Then
			$nID = - ($nID + 1)
		ElseIf $nID > 0 Then
			$nID = - $nID
		EndIf
	ElseIf StringRight($sFile, 4) = ".icl" And $nID < 0 Then
		$nID = - ($nID + 1)
	Else
		If $nID > 0 Then
			$nID = - $nID
		ElseIf $nID < 0 Then
			$nID = - ($nID + 1)
		EndIf
	EndIf

	Return $nID
EndFunc


;**********************************************************************
; Main functions:
;**********************************************************************
Func _TrayWndProc($hWnd, $Msg, $wParam, $lParam)
	If $hWnd = $TRAYMSGWND Then
		_TrayNotifyIcon($hWnd, $Msg, $wParam, $lParam)
	EndIf
EndFunc


Func _TrayNotifyIcon($hWnd, $Msg, $wParam, $lParam)
	Local $nClick = 0
	Local $nID = $wParam

	If $TRAYNOTIFYIDS[$nID][5] <> "" And _
		($TRAYNOTIFYIDS[$nID][6] = 0 Or _
		$TRAYNOTIFYIDS[$nID][6] = $lParam) Then
		Call($TRAYNOTIFYIDS[$nID][5], $nID, $lParam)
	EndIf

	Switch $lParam
		Case $WM_LBUTTONDOWN
			$nClick = 1
		case $WM_LBUTTONUP
			$nClick = 2
		case $WM_LBUTTONDBLCLK
			$nClick = 4
		case $WM_RBUTTONDOWN
			$nClick = 8
		case $WM_RBUTTONUP
			$nClick = 16
		case $WM_RBUTTONDBLCLK
			$nClick = 32
		case $WM_MOUSEMOVE
			$nClick = 64
	EndSwitch

	If BitAnd($nClick, $TRAYNOTIFYIDS[$nID][3]) And $TRAYNOTIFYIDS[$nID][2] > 0 Then
		Local $hMenu = GUICtrlGetHandle($TRAYNOTIFYIDS[$nID][2])
		If $hMenu <> 0 Then
			Local $stPoint = DllStructCreate("int;int")
			GetCursorPos(DllStructGetPtr($stPoint))
;######################################################################### CybeTech Change -> Trigger Rebuild #########################################################################
	MenuRebuild()
	;ConsoleWrite("Trigger" & @LF)
;######################################################################### CybeTech Change -> Trigger Rebuild #########################################################################
			SetForegroundWindow($hWnd)

			TrackPopupMenuEx($hMenu, 0, DllStructGetData($stPoint, 1), DllStructGetData($stPoint, 2), $hWnd, 0)

			PostMessage($hWnd, 0, 0, 0)
		EndIf
	EndIf
EndFunc


;**********************************************************************
; Create a new tray notify ID
;**********************************************************************
Func _GetNewTrayIndex()
	Local $i, $bFreeFound = FALSE

	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $TRAYNOTIFYIDS[$i][0] = 0 Then
			$bFreeFound = TRUE
			ExitLoop
		EndIf
	Next

	If Not $bFreeFound Then
		$TRAYNOTIFYIDS[0][0] += 1
		Local $nSize = UBound($TRAYNOTIFYIDS)

		If $TRAYNOTIFYIDS[0][0] > $nSize - 10 Then _
			Redim $TRAYNOTIFYIDS[$nSize + 10][9]
		$i = $TRAYNOTIFYIDS[0][0]
	EndIf

	Return $i
EndFunc


;**********************************************************************
; Check for existing tray notify ID
;**********************************************************************
Func _GetTrayNotifyIdx($nID)
	If $TRAYMSGWND = 0 Then Return 0

	Local $i, $nResult = 0

	If $nID = -1 Then $nID = $TRAYLASTID

	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $TRAYNOTIFYIDS[$i][0] = $nID Then
			$nResult = $i
			ExitLoop
		EndIf
	Next

	Return $nResult
EndFunc


;********************************************************************
; Change the menu item icon
;********************************************************************
Func _TrayItemSetIcon($nMenuID, $sIconFile = "", $nIconID = -1)
	If $nMenuID = -1 Then $nMenuID = $TRAYLASTITEM
	If $nMenuID <= 0 Then Return 0

	$nIconID = _GetIconID($nIconID, $sIconFile)

	Local $i, $sText = "", $hMenu = 0

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$sText = $arMenuItems[$i][1]
			$hMenu = $arMenuItems[$i][3]

			If $sIconFile = "" And $nIconID = -1 Then
				$arMenuItems[$i][2] = -1

				_SetOwnerDrawn($hMenu, $nMenuID, $sText, FALSE)
				GUICtrlSetData($nMenuID, $sText)
			Else
				If $sIconFile <> "" Then
					$arMenuItems[$i][2] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					$arMenuItems[$i][2] = -1
				EndIf

				_SetOwnerDrawn($hMenu, $nMenuID, $sText)
			EndIf

			Return 1
		EndIf
	Next

	Return 0
EndFunc


;********************************************************************
; Set the selected menu item icon
;********************************************************************
Func _TrayItemSetSelIcon($nMenuID, $sIconFile = "", $nIconID = -1)
	If $nMenuID = -1 Then $nMenuID = $TRAYLASTITEM
	If $nMenuID <= 0 Then Return 0

	$nIconID = _GetIconID($nIconID, $sIconFile)

	Local $i, $sText = "", $hMenu = 0

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$sText = $arMenuItems[$i][1]
			$hMenu = $arMenuItems[$i][3]

			If $sIconFile = "" And $nIconID = -1 Then
				$arMenuItems[$i][6] = -1

				_SetOwnerDrawn($hMenu, $nMenuID, $sText, FALSE)
				GUICtrlSetData($nMenuID, $sText)
			Else
				If $sIconFile <> "" Then
					$arMenuItems[$i][6] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					$arMenuItems[$i][6] = -1
				EndIf

				_SetOwnerDrawn($hMenu, $nMenuID, $sText)
			EndIf

			Return 1
		EndIf
	Next

	Return 0
EndFunc


;********************************************************************
; Set the text of an menu item
;********************************************************************
Func _TrayItemSetText($nMenuID = -1, $sText = "")
	If $nMenuID = -1 Then $nMenuID = $TRAYLASTITEM
	If $nMenuID <= 0 Then Return 0

	Local $i

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$arMenuItems[$i][1] = $sText
			;_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText, FALSE)
			GUICtrlSetData($nMenuID, $sText)
			;_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText)
			Return 1
		EndIf
	Next

	Return 0
EndFunc


;**********************************************************************
; _TrayIconCreate([ToolTip [, IconFile [, IconID]]])
;**********************************************************************
Func _TrayIconCreate($sToolTip = "", $sIconFile = @AutoItExe, $nIconID = 0, $sCallback = "", $nMsg = 0, $hIcon = 0)
	If $sToolTip = "" Then $sToolTip = $sDefaultTT

	$nIconID = _GetIconID($nIconID, $sIconFile)

	If $sIconFile = "" Then
		If $hIcon = 0 Then
			If $nIconID = 0 Then
				$sIconFile = @AutoItExe
			Else
				$hIcon = LoadIcon(0, $nIconID)
			EndIf
		EndIf
	EndIf

	If $sIconFile <> "" Then
		Local $stIcon = DllStructCreate("hwnd")

		If ExtractIconExW($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1) > 0 Then
			$hIcon = DllStructGetData($stIcon, 1)
		Else
			$hIcon = LoadIcon(0, 32516)
		EndIf
	EndIf

	If $TRAYMSGWND = 0 Then
		$TRAYMSGWND = GUICreate("", 1, 1, 9999, 9999, -1, 0x00000080)
		GUISetState()
		ShowWindow($TRAYMSGWND, @SW_HIDE)
	EndIf

	Local $nNID = _GetNewTrayIndex()
	If $nNID = 0 Then
		DestroyIcon($hIcon)
		Return 0
	EndIf

	$TRAYNOTIFYIDS[$nNID][0] = $nNID
	$TRAYNOTIFYIDS[$nNID][1] = $hIcon
	$TRAYNOTIFYIDS[$nNID][2] = 0
	$TRAYNOTIFYIDS[$nNID][3] = 9
	$TRAYNOTIFYIDS[$nNID][4] = $sToolTip
	$TRAYNOTIFYIDS[$nNID][5] = $sCallback
	$TRAYNOTIFYIDS[$nNID][6] = $nMsg
	$TRAYNOTIFYIDS[$nNID][7] = FALSE
	$TRAYNOTIFYIDS[$nNID][8] = FALSE

	$TRAYLASTID = $nNID

	Return $nNID
EndFunc


;**********************************************************************
; _TrayIconDelete($NotificationID)
;**********************************************************************
Func _TrayIconDelete($nID)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)

	Local $nResult = 0

	Local $i
	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $nID = $TRAYNOTIFYIDS[$i][0] Then
			Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

			DllStructSetData($stNID, 1, DllStructGetSize($stNID))
			DllStructSetData($stNID, 2, $TRAYMSGWND)
			DllStructSetData($stNID, 3, $nID)

			$nResult = Shell_NotifyIcon($NIM_DELETE, DllStructGetPtr($stNID))

			DestroyIcon($TRAYNOTIFYIDS[$i][1])
			$TRAYNOTIFYIDS[$i][8] = FALSE
			$TRAYNOTIFYIDS[$i][7] = FALSE
			$TRAYNOTIFYIDS[$i][6] = 0
			$TRAYNOTIFYIDS[$i][5] = ""
			$TRAYNOTIFYIDS[$i][4] = ""
			$TRAYNOTIFYIDS[$i][3] = 0

			If $TRAYNOTIFYIDS[$i][2] <> 0 Then GUIDelete($TRAYNOTIFYIDS[$i][2])

			$TRAYNOTIFYIDS[$i][2] = 0
			$TRAYNOTIFYIDS[$i][1] = 0
			$TRAYNOTIFYIDS[$i][0] = 0

			ExitLoop
		EndIf
	Next

	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetState($NotificationID, $NewState)
;**********************************************************************
Func _TrayIconSetState($nID = -1, $nState = 1)
	If $nState = 0 Then Return 1 ; No change

	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	Local $i, $nResult = 0, $bFound = FALSE

	For $i = 1 To $TRAYNOTIFYIDS[0][0]
		If $nID = $TRAYNOTIFYIDS[$i][0] Then
			$bFound = TRUE
			ExitLoop
		EndIf
	Next

	If Not $bFound Then Return 0

	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

	If BitAnd($nState, 1) Then
		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)
		DllStructSetData($stNID, 4, BitOr($NIF_ICON, $NIF_MESSAGE))
		DllStructSetData($stNID, 5, $TRAYTIPMSG)
		DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])

		$nResult = Shell_NotifyIcon($NIM_ADD, DllStructGetPtr($stNID))
		If $nResult Then _TrayIconSetToolTip($nID, $TRAYNOTIFYIDS[$nID][4])
	ElseIf BitAnd($nState, 2) Then
		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)

		$nResult = Shell_NotifyIcon($NIM_DELETE, DllStructGetPtr($stNID))
	EndIf

	If BitAnd($nState, 4) Then
		If Not $TRAYNOTIFYIDS[$nID][7] Then
			If $hBlankIcon = 0 Then _CreateBlankIcon()
			If $hBlankIcon <> 0 Then
				SetTimer($TRAYMSGWND, $FLASHTIMERID, $FLASHTIMEOUT, 0)
				$TRAYNOTIFYIDS[$nID][7] = TRUE
			EndIf
		EndIf
	ElseIf BitAnd($nState, 8) Then
		KillTimer($TRAYMSGWND, $FLASHTIMERID)

		DllStructSetData($stNID, 1, DllStructGetSize($stNID))
		DllStructSetData($stNID, 2, $TRAYMSGWND)
		DllStructSetData($stNID, 3, $nID)
		DllStructSetData($stNID, 4, $NIF_ICON)
		DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])

		$nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))

		$TRAYNOTIFYIDS[$nID][7] = FALSE
		$TRAYNOTIFYIDS[$nID][8] = FALSE
	EndIf

	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetIcon($NotificationID, IconFile [, IconID])
;**********************************************************************
Func _TrayIconSetIcon($nID = -1, $sIconFile = @AutoItExe, $nIconID = 0)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	$nIconID = _GetIconID($nIconID, $sIconFile)

	Local $hIcon = 0

	If $sIconFile = "" Then
		If $nIconID = 0 Then
			$sIconFile = @AutoItExe
		Else
			$hIcon = LoadIcon(0, $nIconID)
		EndIf
	EndIf

	If $sIconFile <> "" Then
		Local $stIcon = DllStructCreate("hwnd")

		If ExtractIconExW($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1) > 0 Then
			$hIcon = DllStructGetData($stIcon, 1)
		Else
			$hIcon = LoadIcon(0, 32516)
		EndIf
	EndIf

	Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_ICON)
	DllStructSetData($stNID, 6, $hIcon)

	DestroyIcon($TRAYNOTIFYIDS[$nID][1])

	Local $nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
	If $nResult Then
		$TRAYNOTIFYIDS[$nID][1] = $hIcon
	Else
		DestroyIcon($hIcon)
		$TRAYNOTIFYIDS[$nID][1] = 0
	EndIf

	Return $nResult
EndFunc


;**********************************************************************
; _TrayIconSetToolTip($NotificationID, $sToolTip)
;**********************************************************************
Func _TrayIconSetToolTip($nID = -1, $sToolTip = $sDefaultTT)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_TIP)
	DllStructSetData($stNID, 7, $sToolTip)

	Return Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
EndFunc


;**********************************************************************
; _TrayGetMenuHandle($NotificationID)
;**********************************************************************
Func _TrayGetMenuHandle($nID)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	Return $TRAYNOTIFYIDS[$nID][2]
EndFunc


;**********************************************************************
; Return a free index in the item array or create a new index
;**********************************************************************
Func _GetNewItemIndex()
	Local $i = 0, $bFreeFound = FALSE

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = 0 Then
			$bFreeFound = TRUE
			ExitLoop
		EndIf
	Next

	If Not $bFreeFound Then
		$arMenuItems[0][0] += 1
		Local $nSize = UBound($arMenuItems)

		If $arMenuItems[0][0] > $nSize - $nMenuItemsRedim Then _
			Redim $arMenuItems[$nSize + $nMenuItemsRedim][8]
		$i = $arMenuItems[0][0]
	EndIf

	Return $i
EndFunc


;**********************************************************************
; Return a free index in the item array or create a new index
;**********************************************************************
Func _GetNewSideItemIndex()
	Local $i = 0, $bFreeFound = FALSE

	For $i = 1 To $arSideItems[0][0]
		If $arSideItems[$i][0] = 0 Then
			$bFreeFound = TRUE
			ExitLoop
		EndIf
	Next

	If Not $bFreeFound Then
		$arSideItems[0][0] += 1
		Local $nSize = UBound($arSideItems)

		If $arSideItems[0][0] > $nSize - $nMenuItemsRedim Then _
			Redim $arSideItems[$nSize + $nMenuItemsRedim][10]
		$i = $arSideItems[0][0]
	EndIf

	Return $i
EndFunc


;**********************************************************************
; Create a context menu for a tray notify ID
;**********************************************************************
Func _TrayCreateContextMenu($nID = -1)
	Local $nIdx = _GetTrayNotifyIdx($nID)
	If $nIdx = 0 Then Return 0

	Local $nContext = 0

	If $TRAYNOTIFYIDS[$nIdx][2] = 0 Then
		Local $nDummy = GUICtrlCreateDummy()
		$nContext = GUICtrlCreateContextMenu($nDummy)
		$TRAYNOTIFYIDS[$nIdx][2] = $nContext

		$TRAYLASTMENU = $nContext
	EndIf

	Return $nContext
EndFunc


;**********************************************************************
; Create a (context) menu for a tray notify ID
;**********************************************************************
Func _TrayCreateMenu($sText, $nMenuID = -1, $nMenuEntry = -1)
	If $nMenuID = -1 Then $nMenuID = $TRAYLASTMENU

	Local $nMenu = GUICtrlCreateMenu($sText, $nMenuID, $nMenuEntry)

	If $nMenu > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$TRAYLASTITEM = $nMenu

		Local $hMenu = GUICtrlGetHandle($nMenuID)

		$arMenuItems[$nIdx][0] = $nMenu
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = -1
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = 0
		$arMenuItems[$nIdx][5] = TRUE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = TRUE
	EndIf

	Return $nMenu
EndFunc


;**********************************************************************
; Create a menuitem for a tray notify ID
;**********************************************************************
Func _TrayCreateItem($sText, $nMenuID = -1, $nMenuEntry = -1, $bRadio = 0)
	If $nMenuID = -1 Then $nMenuID = $TRAYLASTMENU

	Local $nMenuItem = GUICtrlCreateMenuItem($sText, $nMenuID, $nMenuEntry, $bRadio)

	If $nMenuItem > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$TRAYLASTITEM = $nMenuItem

		Local $hMenu = GUICtrlGetHandle($nMenuID)

		$arMenuItems[$nIdx][0] = $nMenuItem
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = -1
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = $bRadio
		$arMenuItems[$nIdx][5] = TRUE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = FALSE
	EndIf

	Return $nMenuItem
EndFunc


;**********************************************************************
; Delete a menu (item)
;**********************************************************************
Func _GUICtrlODMenuItemDelete($nID)
	Return _TrayDeleteItem($nID)
EndFunc


Func _TrayDeleteItem($nID)
	Local $i, $k, $nResult = 0, $bFound = FALSE

	Local $hMenu = GUICtrlGetHandle($nID)
	Local $bIsMenu = FALSE
	If $hMenu <> 0 Then $bIsMenu = TRUE

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = 0 Then ContinueLoop

		If $bIsMenu Then
			For $k = 1 To $arMenuItems[0][0]
				If $arMenuItems[$k][3] = $hMenu And _
					$arMenuItems[$i][0] <> $arMenuItems[$k][0] Then _TrayDeleteItem($arMenuItems[$k][0])
					;$k <> $i Then _TrayDeleteItem($arMenuItems[$k][0])
			Next
		EndIf

		If $arMenuItems[$i][0] = $nID Then
			If GUICtrlDelete($nID) Then
				$arMenuItems[$i][0] = 0
				$arMenuItems[$i][1] = ""
				$arMenuItems[$i][2] = -1
				$arMenuItems[$i][3] = 0
				$arMenuItems[$i][4] = 0
				$arMenuItems[$i][5] = FALSE
				$arMenuItems[$i][6] = -1
				$arMenuItems[$i][7] = FALSE

				$nResult = 1
				$bFound = TRUE
			EndIf

			ExitLoop
		EndIf
	Next

	If Not $bFound And $nID <> 0 Then GUICtrlDelete($nID)

	Return $nResult
EndFunc


;**********************************************************************
; Sets the possible clicks
;**********************************************************************
Func _TrayIconSetClick($nID, $nClicks)
	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	$TRAYNOTIFYIDS[$nID][3] = $nClicks
EndFunc


;**********************************************************************
; TrayTip()
;**********************************************************************
Func _TrayTip($nID, $sTitle, $sText, $nTimeOut = 10, $nInfoFlags = 0)
	If @OSType <> "WIN32_NT" Then Return 0
	If @OSVersion = "WIN_NT4" Then Return 0

	If $nID = -1 Then $nID = $TRAYLASTID
	If $TRAYMSGWND = 0 Or $nID <= 0 Then Return 0

	Local $stNID = DllStructCreate($sNOTIFYICONDATAW)

	DllStructSetData($stNID, 1, DllStructGetSize($stNID))
	DllStructSetData($stNID, 2, $TRAYMSGWND)
	DllStructSetData($stNID, 3, $nID)
	DllStructSetData($stNID, 4, $NIF_INFO)
	DllStructSetData($stNID, 10, $sText)
	DllStructSetData($stNID, 11, $nTimeOut * 1000)
	DllStructSetData($stNID, 12, $sTitle)
	DllStructSetData($stNID, 13, $nInfoFlags)

 	Local $nResult = Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))

 	Return $nResult
EndFunc


;********************************************************************
; WM_MEASURE procedure
;********************************************************************
Func WM_MEASUREITEM($hWnd, $Msg, $wParam, $lParam)
	Local $nResult = FALSE

	Local $stMeasureItem = DllStructCreate("uint;uint;uint;uint;uint;dword", $lParam)

	If DllStructGetData($stMeasureItem, 1) = 1 Then

		Local $nIconSize	= 0
		Local $nCheckX		= 0
		Local $nSpace		= 2

		_GetMenuInfos($nIconSize, $nCheckX)

		If $nIconSize < $nCheckX Then $nIconSize = $nCheckX

		Local $nMenuItemID	= DllStructGetData($stMeasureItem, 3)

		Local $hDC			= GetDC($hWnd)

		Local $hMenu		= _GetMenuHandle($nMenuItemID)

		Local $nState		= GetMenuState($hMenu, $nMenuItemID, 0)

		; Reassign the current menu font to the menuitem
		Local $hMFont		= 0
		Local $bBoldFont	= FALSE

		If BitAnd($nState, 0x00001000) And Not BitAnd($nState, 0x00000010) Then
			_CreateMenuFont($hMFont, TRUE)
			$bBoldFont	= TRUE
		Else
			$hMFont = $hMenuFont
		EndIf

		Local $hFont		= SelectObject($hDC, $hMFont)

		Local $sText		= _GetMenuText($nMenuItemID)
		Local $nSideIdx		= _GetSideMenuIndex($hMenu)
		Local $sSideText	= _GetSideMenuText($nSideIdx)
		Local $hSideImage	= _GetSideMenuImage($nSideIdx)
		Local $nSideWidth	= 0

		If $sSideText <> "" Then
			If $hSideImage = 0 Then
				Local $hSideFont = 0
				_CreateMenuFont($hSideFont, TRUE, TRUE)
				Local $hOldObj = SelectObject($hDC, $hSideFont)

				$nSideWidth = _GetSideMenuTextWidth($hDC, $sSideText) + 2 ; 1 x 1 left + right
				SelectObject($hDC, $hOldObj)
				DeleteObject($hSideFont)
			Else
				Local $nSideHeight	= 0
				Local $bStretch		= FALSE

				_GetSideMenuImageSize($nSideIdx, $nSideWidth, $nSideHeight, $bStretch)
			EndIf
		EndIf

		Local $nMaxTextWidth	= 0
		Local $nMaxTextAccWidth	= 0

		_GetMenuMaxTextWidth($hDC, $hMenu, $nMaxTextWidth, $nMaxTextAccWidth)
		If $nMaxTextAccWidth > 0 Then $nMaxTextAccWidth += 4

		Local $nHeight		= 2 * $nSpace + $nIconSize
		Local $nWidth		= 0

		; Set a default separator height
		If $sText = "" Then
			$nHeight = 4
		Else
			$nWidth	= 6 * $nSpace + 2 * $nIconSize + $nMaxTextWidth + $nMaxTextAccWidth + $nSideWidth
			If $hMenu = "TOP" Then $nWidth	= 4 * $nSpace+$nMaxTextWidth + $nMaxTextAccWidth
			; Maybe this differs - have no emulator here at the moment
			If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then
				$nWidth = $nWidth - $nCheckX + 1
			EndIf
		EndIf

		DllStructSetData($stMeasureItem, 4, $nWidth)	; ItemWidth
		DllStructSetData($stMeasureItem, 5, $nHeight)	; ItemHeight

		SelectObject($hDC, $hFont)
		If $bBoldFont Then DeleteObject($hMFont)

		ReleaseDC($hWnd, $hDC)
		$nResult = TRUE
	EndIf

	$stMeasureItem	= 0

	Return $nResult
EndFunc


;********************************************************************
; WM_DRAWITEM procedure
;********************************************************************

Func WM_DRAWITEM($hWnd, $Msg, $wParam, $lParam)
	Local $nResult		= FALSE

	Local $stDrawItem	= DllStructCreate("uint;uint;uint;uint;uint;dword;dword;int[4];dword", $lParam)

	If DllStructGetData($stDrawItem, 1) = 1 Then
		Local $nMenuItemID	= DllStructGetData($stDrawItem, 3)
		Local $nAction		= DllStructGetData($stDrawItem, 4)
		Local $nState		= DllStructGetData($stDrawItem, 5)
		Local $hMenu		= DllStructGetData($stDrawItem, 6)
		Local $hDC			= DllStructGetData($stDrawItem, 7)

		Local $bChecked		= BitAnd($nState, 0x0008)
		Local $bGrayed		= BitAnd($nState, 0x0002)
		Local $bSelected	= BitAnd($nState, 0x0001)
		Local $bDefault		= BitAnd($nState, 0x0020)
		Local $bNoAcc		= BitAnd($nState, 0x0100)
		Local $bIsRadio		= _GetMenuIsRadio($nMenuItemID)

		Local $nSideIdx		= _GetSideMenuIndex($hMenu)
		Local $sSideText	= _GetSideMenuText($nSideIdx)
		Local $hSideImage	= _GetSideMenuImage($nSideIdx)
		Local $hSideFont	= 0
		Local $hOldObj		= 0
		Local $nSideWidth	= 0
		Local $nSideHeight	= 0
		Local $bHasSide		= FALSE
		Local $bStretch		= FALSE

		If $sSideText <> "" Then
			If $hSideImage = 0 Then
				_CreateMenuFont($hSideFont, TRUE, TRUE)
				$hOldObj = SelectObject($hDC, $hSideFont)
				$nSideWidth = _GetSideMenuTextWidth($hDC, $sSideText) + 2 ; 1 left + 1 right
				SelectObject($hDC, $hOldObj)
			Else
				_GetSideMenuImageSize($nSideIdx, $nSideWidth, $nSideHeight, $bStretch)
			EndIf

			$bHasSide = TRUE
		EndIf

		Local $arIR[4]
		$arIR[0]			= DllStructGetData($stDrawItem, 8, 1) + $nSideWidth
		$arIR[1]			= DllStructGetData($stDrawItem, 8, 2)
		$arIR[2]			= DllStructGetData($stDrawItem, 8, 3)
		$arIR[3]			= DllStructGetData($stDrawItem, 8, 4)

		Local $stItemRect	= DllStructCreate("int;int;int;int")
		_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])

		; Set default menu values if info function fails
		Local $nIconSize	= 16
		Local $nCheckX		= 16
		Local $nSpace		= 2

		_GetMenuInfos($nIconSize, $nCheckX)

		Local $nMBkClr			= $nMenuBkClr
		Local $nMIconBkClr		= $nMenuIconBkClr
		Local $nMIconBkClr2		= $nMenuIconBkClr2
		Local $nMSelectBkClr	= $nMenuSelectBkClr
		Local $nMSelectRectClr	= $nMenuSelectRectClr
		Local $nMSelectTextClr	= $nMenuSelectTextClr
		Local $nMTextClr		= $nMenuTextClr

		Local $bIsTrayItem		= _IsTrayItem($nMenuItemID)

		Local $IsMenuBarItem = (_GetMenuHandle($nMenuItemID)== "TOP") And Not $bIsTrayItem
		If $nState = 320 And $IsMenuBarItem Then
			$nMBkClr = $nMSelectBkClr
			$nMTextClr = $nMSelectTextClr
		EndIf

		If $bIsTrayItem Then
			$nMBkClr			= $nTrayBkClr
			$nMIconBkClr		= $nTrayIconBkClr
			$nMIconBkClr2		= $nTrayIconBkClr2
			$nMSelectBkClr		= $nTraySelectBkClr
			$nMSelectRectClr	= $nTraySelectRectClr
			$nMSelectTextClr	= $nTraySelectTextClr
			$nMTextClr			= $nTrayTextClr
		EndIf

		; Select our at beginning selfcreated menu font into the item device context
		Local $hMFont		= 0
		Local $bBoldFont	= FALSE

		If $bDefault Then
			_CreateMenuFont($hMFont, TRUE)
			$bBoldFont = TRUE
		Else
			$hMFont = $hMenuFont
		EndIf

		Local $hBrush		= 0
		Local $hOldBrush	= 0
		Local $nClrSel		= 0
		Local $hBorderBrush	= 0
		Local $nLen			= 0
		Local $stSize		= 0

		; Show side menu only if action = ODA_DRAWENTIRE
		If $nAction = 1 Then
			Local $nCount = GetMenuItemCount($hMenu)
			Local $nID = GetMenuItemID($hMenu, $nCount - 1)

			If $nID = -1 Then
				Local $stMII = DllStructCreate($sMENUITEMINFO)
				DllStructSetData($stMII, 1, DllStructGetSize($stMII))
				DllStructSetData($stMII, 2, 0x00000002) ; MIIM_ID
				If GetMenuItemInfo($hMenu, $nCount - 1, TRUE, DllStructGetPtr($stMII)) Then _
					$nID = DllStructGetData($stMII, 5)
			EndIf

			If $nID = $nMenuItemID And $bHasSide Then
				Local $stSideRect = DllStructCreate("int;int;int;int")
				_SetItemRect($stSideRect, 0, 0, $nSideWidth, $arIR[3])

				Local $nSideClr		= $nMenuSideTxtClr
				Local $nSideBkClr	= $nMenuSideBkClr
				Local $nSideBkClr2	= $nMenuSideBkClr2

				_GetSideMenuColors($nSideIdx, $nSideClr, $nSideBkClr, $nSideBkClr2)

				If $nSideBkClr <> -1 Then
					If $nSideBkClr = $nSideBkClr2 Or _
						$nSideBkClr2 = -1 Then
						SetBkColor($hDC, $nSideBkClr)

						$hBrush	= CreateSolidBrush($nSideBkClr)
						$hOldBrush = SelectObject($hDC, $hBrush)

						FillRect($hDC, DllStructGetPtr($stSideRect), $hBrush)

						SelectObject($hDC, $hOldBrush)
						DeleteObject($hBrush)

						$hBrush		= 0
						$hOldBrush	= 0
					Else
						_FillGradientRect($hDC, $stSideRect, $nSideBkClr2, $nSideBkClr, TRUE)
					EndIf
				EndIf

				If $hSideImage = 0 Then
					$nLen	= StringLen($sSideText)
					$stSize	= DllStructCreate("int;int")

					$stSideText = DllStructCreate("wchar[" & $nLen + 1 & "]")
					DllStructSetData($stSideText, 1, $sSideText)

					$hOldObj = SelectObject($hDC, $hSideFont)

					Local $nOldMode = SetBkMode($hDC, 1)
					SetTextColor($hDC, $nSideClr)

					DllStructSetData($stSideRect, 2, 8)
					DllStructSetData($stSideRect, 4, DllStructGetData($stSideRect, 4) + 8)

					DrawTextW($hDC, DllStructGetPtr($stSideText), _
									StringLen($sSideText), _
									DllStructGetPtr($stSideRect), _
									BitOr(0x00000008, 0x00000020, 0x00000100))

					SetBkMode($hDC, $nOldMode)
					SelectObject($hDC, $hOldObj)
				Else
					Local $hCDC = CreateCompatibleDC($hDC)
					$hObjOld = SelectObject($hCDC, $hSideImage)

					If $bStretch Then
						StretchBlt($hDC, 0, 0, $nSideWidth, $arIR[3], $hCDC, 0, 0, $nSideWidth, $nSideHeight, 0x00CC0020)
					Else
						BitBlt($hDC, 0, 0, $nSideWidth, $arIR[3], $hCDC, 0, $nSideHeight - $arIR[3], 0x00CC0020)
					EndIf

					SelectObject($hCDC, $hObjOld)
					DeleteDC($hCDC)
				EndIf
			EndIf
		EndIf

		If $hSideFont <> 0 Then DeleteObject($hSideFont)

		Local $hFont = SelectObject($hDC, $hMFont)

		; Only show a menu bar when the item is enabled
		If $bSelected Then ;And Not $bGrayed Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$hBorderBrush	= CreateSolidBrush($nMSelectRectClr)
				If $bGrayed Then
					$hBrush		= CreateSolidBrush($nMBkClr)
					$nClrSel	= $nMBkClr
				Else
					$hBrush		= CreateSolidBrush($nMSelectBkClr) ; BGR color value
					$nClrSel	= $nMSelectBkClr
				EndIf

			Else
				$hBrush			= GetSysColorBrush(13)
				$nClrSel		= GetSysColor(13)
			EndIf
		Else
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$hBrush			= CreateSolidBrush($nMBkClr)
				$nClrSel		= $nMBkClr
			Else
				$hBrush			= GetSysColorBrush(4)
				$nClrSel		= GetSysColor(4)
			EndIf
		EndIf

		Local $nClrTxt		= 0

		If $bSelected And Not $bGrayed Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$nClrTxt	= SetTextColor($hDC, $nMSelectTextClr)
			Else
				$nClrTxt	= SetTextColor($hDC, GetSysColor(14))
			EndIf
		ElseIf $bGrayed Then
			$nClrTxt		= SetTextColor($hDC, GetSysColor(17))
		Else
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				$nClrTxt	= SetTextColor($hDC, $nMTextClr)
			Else
				$nClrTxt	= SetTextColor($hDC, GetSysColor(7))
			EndIf
		EndIf

		Local $nClrBk		= SetBkColor($hDC, $nClrSel)
		$hOldBrush			= SelectObject($hDC, $hBrush)

		FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
		SelectObject($hDC, $hOldBrush)
		DeleteObject($hBrush)

		If $IsMenuBarItem Then
			$nIconSize	= 0
			$nCheckX		= 0
			$nSpace		= 2
		EndIf

		If Not $IsMenuBarItem And ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
			; Create a small gray edge
			If Not $bSelected Or $bGrayed Then
				; Reassign the item rect
				_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[0] + 2 * $nSpace + $nIconSize + 1, $arIR[3])

				If $nMIconBkClr = $nMIconBkClr2  Or _
					$nMIconBkClr2 = -1 Then
					$hBrush		= CreateSolidBrush($nMIconBkClr)
					$hOldBrush	= SelectObject($hDC, $hBrush)

					FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)

					SelectObject($hDC, $hOldBrush)
					DeleteObject($hBrush)
				Else
					_FillGradientRect($hDC, $stItemRect, $nMIconBkClr, $nMIconBkClr2)
				EndIf
			EndIf
		EndIf

		If $bChecked Then
			_SetItemRect($stItemRect, $arIR[0] + 1, $arIR[1] + 1, $arIR[0] + $nIconSize + $nSpace + 1, $arIR[1] + $nIconSize + $nSpace + 1)

			If $bSelected Then
				If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
					$hBrush		= CreateSolidBrush($nMSelectBkClr)
				Else
					$hBrush		= GetSysColorBrush(13)
				EndIf
			Else
				If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
					$hBrush		= CreateSolidBrush($nMBkClr)
				Else
					$hBrush		= GetSysColorBrush(4)
				EndIf
			EndIf

			$hOldBrush	= SelectObject($hDC, $hBrush)
			FillRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
			SelectObject($hDC, $hOldBrush)
			DeleteObject($hBrush)

			; Create a checkmark/bullet for the checked/radio items
			Local $hDCBitmap	= CreateCompatibleDC($hDC)
			Local $hbmpCheck	= CreateBitmap($nIconSize, $nIconSize, 1, 1, 0)
			Local $hbmpOld		= SelectObject($hDCBitmap, $hbmpCheck)

			Local $x = DllStructGetData($stItemRect, 1) + ($nIconSize + $nSpace - $nCheckX) / 2
			Local $y = DllStructGetData($stItemRect, 2) + ($nIconSize + $nSpace - $nCheckX) / 2 - $nSpace

			_SetItemRect($stItemRect, 0, 0, $nIconSize, $nIconSize)

			Local $nCtrlStyle = 0x0001

			If $bIsRadio Then $nCtrlStyle = 0x0002

			DrawFrameControl($hDCBitmap, DllStructGetPtr($stItemRect), 2, $nCtrlStyle)

			BitBlt($hDC, $x, $y + 1, $nCheckX, $nCheckX, $hDCBitmap, 0, 0, 0x00CC0020)

			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				_SetItemRect($stItemRect, $arIR[0] + 1, $arIR[1] + 1, $arIR[0] + $nIconSize + $nSpace + 1, $arIR[1] + $nIconSize + $nSpace + 1)
				$hBrush	= CreateSolidBrush($nMSelectRectClr)
				$hOldBrush	= SelectObject($hDC, $hBrush)
				FrameRect($hDC, DllStructGetPtr($stItemRect), $hBrush)
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBrush)
			EndIf

			SelectObject($hDCBitmap, $hbmpOld)
			DeleteObject($hbmpCheck)
			DeleteDC($hDCBitmap)
		EndIf

		; Reassign the item rect
		_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])

		If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
			;If $bSelected And Not $bGrayed Then
			If $bSelected Then ; Show also a rect around a disabled item
				$hOldBrush	= SelectObject($hDC, $hBorderBrush)
				FrameRect($hDC, DllStructGetPtr($stItemRect), $hBorderBrush)
				SelectObject($hDC, $hOldBrush)
				DeleteObject($hBorderBrush)
			EndIf
		EndIf

		Local $sText	= _GetMenuText($nMenuItemID)
		If $bNoAcc Then $sText = StringReplace($sText, "&", "")

		Local $nWidth	= 0
		Local $sAcc		= ""
		Local $arText	= StringSplit($sText, @Tab)
		Local $bTab		= FALSE

		If IsArray($arText) And $arText[0] > 1 Then
			$sText	= $arText[1]
			$sAcc	= $arText[2]
			$bTab	= TRUE
		EndIf

		$nLen			= StringLen($sText)
		Local $stText	= DllStructCreate("wchar[" & $nLen + 1 & "]")
		DllStructSetData($stText, 1, $sText)

		Local $nSaveLeft	= DllStructGetData($stItemRect, 1)
		Local $nLeft		= $nSaveLeft
		$nLeft += $nSpace		; Left border
		$nLeft += $nSpace		; Space after gray border
		$nLeft += $nIconSize	; Icon width
		$nLeft += $nSpace + 2	; Right after the icon

		DllStructSetData($stItemRect, 1, $nLeft)

		Local $nFlags		= BitOr(0x00000100, 0x00000020, 0x00000004)

		DrawTextW($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stItemRect), $nFlags)

		; Draw accelerator text
		If $bTab Then
			Local $nMaxTextWidth	= 0
			Local $nMaxTextAccWidth	= 0

			_GetMenuMaxTextWidth($hDC, $hMenu, $nMaxTextWidth, $nMaxTextAccWidth)
			If $nMaxTextAccWidth > 0 Then $nMaxTextAccWidth += 4

			$nWidth	= 6 * $nSpace + 2 * $nIconSize + $nMaxTextWidth

			; Maybe this differs - have no emulator here at the moment
			If @OSVersion <> "WIN_98" And @OSVersion <> "WIN_ME" Then
				$nWidth = $nWidth - $nCheckX + 1
			EndIf

			$nLen = StringLen($sAcc)
			$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
			DllStructSetData($stText, 1, $sAcc)

			; Set rect for acc text
			_SetItemRect($stItemRect, $arIR[0] + $nWidth, $arIR[1], $arIR[0] + $nWidth + $nMaxTextAccWidth, $arIR[3])

			DrawTextW($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stItemRect), $nFlags)

			; Reset rect values
			_SetItemRect($stItemRect, $arIR[0], $arIR[1], $arIR[2], $arIR[3])
		EndIf

		Local $nNoSelIconIndex = -1
		Local $nSelIconIndex = -1

		_GetMenuIconIndex($nMenuItemID, $nNoSelIconIndex, $nSelIconIndex)

		Local $nIconIndex = $nNoSelIconIndex
		If $bSelected And $nSelIconIndex > -1 Then $nIconIndex = $nSelIconIndex

		If $nIconIndex > -1 Then
			If Not $bChecked Then
				If $bGrayed Then
					; An easy way to draw something that looks deactivated
					ImageList_DrawEx($hMenuImageList, _
									$nIconIndex, _
									$hDC, _
									$nSpace + $nSideWidth, _
									DllStructGetData($stItemRect, 2) + 2, _
									0, _
									0, _
									0xFFFFFFFF, _
									0xFFFFFFFF, _
									BitOr(0x0004, 0x0001))
				Else
					; Draw the icon "normal"
					ImageList_Draw($hMenuImageList, _
								$nIconIndex, _
								$hDC, _
								$nSpace + $nSideWidth, _
								DllStructGetData($stItemRect, 2) + 2, _
								0x0001)
				EndIf
			EndIf
		EndIf

		DllStructSetData($stItemRect, 1, $nSaveLeft)

		; Draw a "line" for a separator item
		If StringLen($sText) = 0 Then
			If ($bUseAdvMenu And $bIsTrayItem = FALSE) Or ($bUseAdvTrayMenu And $bIsTrayItem) Then
				DllStructSetData($stItemRect, 1, DllStructGetData($stItemRect, 1) + 4 * $nSpace + $nIconSize)
			Else
				DllStructSetData($stItemRect, 1, DllStructGetData($stItemRect, 1))
			EndIf
			DllStructSetData($stItemRect, 2, DllStructGetData($stItemRect, 2) + 1)
			DllStructSetData($stItemRect, 4, DllStructGetData($stItemRect, 1) + 2)
			DrawEdge($hDC, DllStructGetPtr($stItemRect), 0x0006, 0x0002)
		EndIf

		$stText		= 0
		$stItemRect	= 0

		SelectObject($hDC, $hFont)
		If $bBoldFont Then DeleteObject($hMFont)

		SetTextColor($hDC, $nClrTxt)
		SetBkColor($hDC, $nClrBk)

		$nResult = TRUE
	EndIf

	$stDrawItem	= 0

	Return $nResult
EndFunc


;********************************************************************
; Get color part
;********************************************************************
Func _ColorGetClr($nColor, $nMode)
	Local $nClr = $nColor

	If $bUseRGBColors Then $nClr = _GetBGRColor($nColor)

	Switch $nMode
		Case 1
			$nClr = BitShift($nClr, 16)
		Case 2
			$nClr = BitShift(BitAnd($nClr, 0xFF00), 8)
		Case 3
			$nClr = BitAnd($nClr, 0xFF)
	EndSwitch

	Return $nClr
EndFunc


;********************************************************************
; Fill background rect with gradient colors
;********************************************************************
Func _FillGradientRect($hDC, $stRect, $nClr1, $nClr2, $bVert = FALSE)
	Local $stVert = DllStructCreate("long;long;ushort;ushort;ushort;ushort;" & _
									"long;long;ushort;ushort;ushort;ushort")

	DllStructSetData($stVert, 1, DllStructGetData($stRect, 1))
	DllStructSetData($stVert, 2, DllStructGetData($stRect, 2))
	DllStructSetData($stVert, 3, BitShift(_ColorGetClr($nClr1, 3), -8))
	DllStructSetData($stVert, 4, BitShift(_ColorGetClr($nClr1, 2), -8))
	DllStructSetData($stVert, 5, BitShift(_ColorGetClr($nClr1, 1), -8))
	DllStructSetData($stVert, 6, 0)

	DllStructSetData($stVert, 7, DllStructGetData($stRect, 3))
	DllStructSetData($stVert, 8, DllStructGetData($stRect, 4))
	DllStructSetData($stVert, 9, BitShift(_ColorGetClr($nClr2, 3), -8))
	DllStructSetData($stVert, 10, BitShift(_ColorGetClr($nClr2, 2), -8))
	DllStructSetData($stVert, 11, BitShift(_ColorGetClr($nClr2, 1), -8))
	DllStructSetData($stVert, 12, 0)

	Local $stGradRect = DllStructCreate("ulong;ulong")
	DllStructSetData($stGradRect, 1, 0)
	DllStructSetData($stGradRect, 2, 1)

	If $bVert Then
		GradientFill($hDC, DllStructGetPtr($stVert), 2, DllStructGetPtr($stGradRect), 1, 1)
	Else
		GradientFill($hDC, DllStructGetPtr($stVert), 2, DllStructGetPtr($stGradRect), 1, 0)
	EndIf
EndFunc


;********************************************************************
; Sets 4 values to a itemrect struct
;********************************************************************
Func _SetItemRect(ByRef $stStruct, $p1, $p2, $p3, $p4)
	DllStructSetData($stStruct, 1, $p1)
	DllStructSetData($stStruct, 2, $p2)
	DllStructSetData($stStruct, 3, $p3)
	DllStructSetData($stStruct, 4, $p4)
EndFunc


;********************************************************************
; WM_SETTINGCHANGE procedure
;********************************************************************
Func WM_SETTINGCHANGE($hWnd, $Msg, $wParam, $lParam)
	If $wParam = 0x002A Then _CreateMenuFont($hMenuFont)
EndFunc


;********************************************************************
; WM_TIMER procedure
;********************************************************************
Func WM_TIMER($hWnd, $Msg, $wParam, $lParam)
	Local $nID = Number($wParam)

	If $TRAYNOTIFYIDS[$nID][0] > 0 Then
		If $TRAYNOTIFYIDS[$nID][7] Then
			Local $stNID	= DllStructCreate($sNOTIFYICONDATAW)
			DllStructSetData($stNID, 1, DllStructGetSize($stNID))
			DllStructSetData($stNID, 2, $TRAYMSGWND)
			DllStructSetData($stNID, 3, $nID)
			DllStructSetData($stNID, 4, $NIF_ICON)

			If $TRAYNOTIFYIDS[$nID][8] Then
				DllStructSetData($stNID, 6, $hBlankIcon)
				$TRAYNOTIFYIDS[$nID][8] = FALSE
			Else
				DllStructSetData($stNID, 6, $TRAYNOTIFYIDS[$nID][1])
				$TRAYNOTIFYIDS[$nID][8] = TRUE
			EndIf

			Shell_NotifyIcon($NIM_MODIFY, DllStructGetPtr($stNID))
		EndIf
	EndIf

	KillTimer($TRAYMSGWND, $FLASHTIMERID)
	SetTimer($TRAYMSGWND, $FLASHTIMERID, $FLASHTIMEOUT, 0)
EndFunc


;********************************************************************
; Create a menu item and set its style to OwnerDrawn
;********************************************************************
Func _GUICtrlCreateODMenuItem($sMenuItemText, $nParentMenu, $sIconFile = "", $nIconID = 0, $bRadio = 0)
	Local $nMenuItem	= GUICtrlCreateMenuItem($sMenuItemText, $nParentMenu, -1, $bRadio)

	$nIconID = _GetIconID($nIconID, $sIconFile)

	If $nMenuItem > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$MENULASTITEM = $nMenuItem

		Local $hMenu		= GUICtrlGetHandle($nParentMenu)

		$arMenuItems[$nIdx][0] = $nMenuItem
		$arMenuItems[$nIdx][1] = $sMenuItemText
		$arMenuItems[$nIdx][2] = _AddMenuIcon($sIconFile, $nIconID)
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = $bRadio
		$arMenuItems[$nIdx][5] = FALSE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = FALSE

		_SetOwnerDrawn($hMenu, $nMenuItem, $sMenuItemText)
	EndIf

	Return $nMenuItem
EndFunc


;********************************************************************
; Create a menu and set its style to OwnerDrawn
;********************************************************************
Func _GUICtrlCreateODMenu($sText, $nParentMenu, $sIconFile = "", $nIconID = 0)
	If $nParentMenu = "" Then
		Local $nMenu	= GUICtrlCreateMenu($sText)
	Else
		Local $nMenu	= GUICtrlCreateMenu($sText, $nParentMenu)
	EndIf

	$nIconID = _GetIconID($nIconID, $sIconFile)

	If $nMenu > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$MENULASTITEM = $nMenu

		Local $hMenu	= GUICtrlGetHandle($nParentMenu)

		$arMenuItems[$nIdx][0] = $nMenu
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = _AddMenuIcon($sIconFile, $nIconID)
		$arMenuItems[$nIdx][3] = $hMenu
		$arMenuItems[$nIdx][4] = 0
		$arMenuItems[$nIdx][5] = FALSE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = TRUE

		_SetOwnerDrawn($hMenu, $nMenu, $sText)
	EndIf

	Return $nMenu
EndFunc

Func _GUICtrlCreateODTopMenu($sText, $nParentGUI)
	Local $nMenu	= GUICtrlCreateMenu($sText)


	If $nMenu > 0 Then
		Local $nIdx = _GetNewItemIndex()
		If $nIdx = 0 Then Return 0

		$MENULASTITEM = $nMenu
		$hMenu = DllCall("User32.dll", "hwnd", "GetMenu", "hwnd", $nParentGUI)
		If @error Or $hMenu[0]=0 Then Return SetError(1,0,0)
;~ 		GetMenuItemInfo(GUICtrlGetHandle($nMenu)
		$arMenuItems[$nIdx][0] = $nMenu
		$arMenuItems[$nIdx][1] = $sText
		$arMenuItems[$nIdx][2] = -1
		$arMenuItems[$nIdx][3] = "TOP"
		$arMenuItems[$nIdx][4] = 0
		$arMenuItems[$nIdx][5] = FALSE
		$arMenuItems[$nIdx][6] = -1
		$arMenuItems[$nIdx][7] = TRUE

		_SetOwnerDrawn($hMenu[0], $nMenu, $sText)
		MenuBarBKColor($hMenu[0],$nMenuBkClr)
	EndIf

	Return $nMenu
EndFunc
Func _GUIMenuBarSetBkColor($nParentGUI,$nMenuBkClr)
	Local $hMenu = DllCall("User32.dll", "hwnd", "GetMenu", "hwnd", $nParentGUI)
	If @error Then Return 0
	Local $r = MenuBarBKColor($hMenu[0],$nMenuBkClr)
	DllCall("User32.dll", "int", "DrawMenuBar", "hwnd",$nParentGUI)
	DllCall("User32.dll", "int", "RedrawWindow", "hwnd", $nParentGUI, "ptr", 0, "int", 0, "int", 0x400)
	Return $r
EndFunc

;********************************************************************
; Set the text of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetText($nMenuID, $sText)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0

	Local $i

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			$arMenuItems[$i][1] = $sText
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText, FALSE)
			GUICtrlSetData($nMenuID, $sText)
			_SetOwnerDrawn($arMenuItems[$i][3], $nMenuID, $sText)
			Return 1
		EndIf
	Next
EndFunc


;********************************************************************
; Set the icon of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetIcon($nMenuID, $sIconFile = "", $nIconID = 0)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0

	$nIconID = _GetIconID($nIconID, $sIconFile)

	Local $i

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			If $sIconFile = "" Then
				$arMenuItems[$i][2] = -1
			Else
				If $arMenuItems[$i][2] = -1 Then
					$arMenuItems[$i][2] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					_ReplaceMenuIcon($sIconFile, $nIconID, $arMenuItems[$i][2])
				EndIf
			EndIf

			Return 1
		EndIf
	Next

	Return 0
EndFunc


;********************************************************************
; Set the selected icon of an menu item
;********************************************************************
Func _GUICtrlODMenuItemSetSelIcon($nMenuID, $sIconFile = "", $nIconID = 0)
	If $nMenuID = -1 Then $nMenuID = $MENULASTITEM
	If $nMenuID <= 0 Then Return 0

	$nIconID = _GetIconID($nIconID, $sIconFile)

	Local $i

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuID Then
			If $sIconFile = "" Then
				$arMenuItems[$i][6] = -1
			Else
				If $arMenuItems[$i][6] = -1 Then
					$arMenuItems[$i][6] = _AddMenuIcon($sIconFile, $nIconID)
				Else
					_ReplaceMenuIcon($sIconFile, $nIconID, $arMenuItems[$i][6])
				EndIf
			EndIf

			Return 1
		EndIf
	Next

	Return 0
EndFunc


;********************************************************************
; Add an icon to our menu image list
;********************************************************************
Func _AddMenuIcon($sIconFile, $nIconID)
	If IsHWnd($sIconFile) Or Number($sIconFile)>0 Then Return ImageList_AddIcon($hMenuImageList, $sIconFile)

	Local $stIcon	= DllStructCreate("hwnd")

	Local $nCount	= ExtractIconExW($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)

	Local $nIndex	= -1

	If $nCount > 0 Then
		$nIndex	= ImageList_AddIcon($hMenuImageList, DllStructGetData($stIcon, 1))
		DestroyIcon(DllStructGetData($stIcon, 1))
	EndIf

	$stIcon = 0

	Return $nIndex
EndFunc


;********************************************************************
; Replace an icon in our menu image list
;********************************************************************
Func _ReplaceMenuIcon($sIconFile, $nIconID, $nReplaceIndex)
	If $nReplaceIndex < 0 Then Return -1

	If IsHWnd($sIconFile) Or Number($sIconFile)>0 Then Return ImageList_ReplaceIcon($hMenuImageList, $nReplaceIndex, $sIconFile)

	Local $stIcon	= DllStructCreate("hwnd")

	Local $nCount	= ExtractIconExW($sIconFile, $nIconID, 0, DllStructGetPtr($stIcon), 1)

	Local $nIndex	= -1

	If $nCount > 0 Then
		ImageList_ReplaceIcon($hMenuImageList, $nReplaceIndex, DllStructGetData($stIcon, 1))
		DestroyIcon(DllStructGetData($stIcon, 1))
	EndIf

	$stIcon = 0

	Return 1
EndFunc


;********************************************************************
; Get the parent menu handle for a menu item
;********************************************************************
Func _GetMenuHandle($nMenuItemID)
	Local $i, $hMenu = 0

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$hMenu = $arMenuItems[$i][3]
			ExitLoop
		EndIf
	Next

	Return $hMenu
EndFunc


;********************************************************************
; Get the index of a menu item in our store
;********************************************************************
Func _GetMenuIndex($hMenu, $nMenuItemID)
	Local $nIndex	= -1
	Local $nCount	= GetMenuItemCount($hMenu)
	Local $nPos, $nID

	For $nPos = 0 To $nCount[0] - 1
		$nID = GetMenuItemID($hMenu, $nPos)
		If $nID = $nMenuItemID Then
			$nIndex = $nPos
			ExitLoop
		EndIf
	Next

	Return $nIndex
EndFunc


;********************************************************************
; Get the menu item text
;********************************************************************
Func _GetMenuText($nMenuItemID)
	Local $i, $sText = ""

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$sText = $arMenuItems[$i][1]
			ExitLoop
		EndIf
	Next

	Return $sText
EndFunc


;********************************************************************
; Creates a menu side
;********************************************************************
Func _CreateSideMenu($nMenuID)
	If $nMenuID <= 0 Then Return 0

	Local $hMenu = GUICtrlGetHandle($nMenuID)
	If $hMenu = 0 Then Return 0

	Local $i = _GetNewSideItemIndex()
	If $i = 0 Then Return 0

	$arSideItems[$i][0] = $hMenu
	$arSideItems[$i][1] = ""
	$arSideItems[$i][2] = -1
	$arSideItems[$i][3] = -1
	$arSideItems[$i][4] = -1
	$arSideItems[$i][5] = FALSE
	$arSideItems[$i][6] = 0
	$arSideItems[$i][7] = 0
	$arSideItems[$i][8] = 0
	$arSideItems[$i][9] = FALSE

	Return $i
EndFunc


;********************************************************************
; Check menu side index
;********************************************************************
Func _IsSideMenuIdx($nIdx)
	If $nIdx <= 0 Or $nIdx > $arSideItems[0][0] Then Return FALSE
	If $arSideItems[$nIdx][0] = 0 Then Return FALSE

	Return TRUE
EndFunc


;********************************************************************
; Delete menu side
;********************************************************************
Func _DeleteSideMenu($nIdx)
	If Not _IsSideMenuIdx($nIdx) Then Return FALSE

	$arSideItems[$nIdx][0] = 0
	$arSideItems[$nIdx][1] = ""
	$arSideItems[$nIdx][2] = -1
	$arSideItems[$nIdx][3] = -1
	$arSideItems[$nIdx][4] = -1
	If $arSideItems[$nIdx][5] And $arSideItems[$nIdx][6] <> 0 Then _
		DeleteObject($arSideItems[$nIdx][6])
	$arSideItems[$nIdx][5] = FALSE
	$arSideItems[$nIdx][6] = 0
	$arSideItems[$nIdx][7] = 0
	$arSideItems[$nIdx][8] = 0
	$arSideItems[$nIdx][9] = FALSE

	If $nIdx = $arSideItems[0][0] Then $arSideItems[0][0] -= 1

	Return TRUE
EndFunc


;********************************************************************
; Get a menu side index
;********************************************************************
Func _GetSideMenuIndex($hMenu)
	Local $i

	For $i = 1 To $arSideItems[0][0]
		If $arSideItems[$i][0] = $hMenu Then
			Return $i
			ExitLoop
		EndIf
	Next

	Return 0
EndFunc


;********************************************************************
; Get a menu side text
;********************************************************************
Func _GetSideMenuText($nIdx)
	If Not _IsSideMenuIdx($nIdx) Then Return ""

	Return $arSideItems[$nIdx][1]
EndFunc


;********************************************************************
; Get a menu side image
;********************************************************************
Func _GetSideMenuImage($nIdx)
	If Not _IsSideMenuIdx($nIdx) Then Return 0

	If Not $arSideItems[$nIdx][5] Then Return 0

	Return $arSideItems[$nIdx][6]
EndFunc


;********************************************************************
; Get a menu side image dimensions
;********************************************************************
Func _GetSideMenuImageSize($nIdx, ByRef $nWidth, ByRef $nHeight, ByRef $bStretch)
	If Not _IsSideMenuIdx($nIdx) Then Return FALSE

	If Not $arSideItems[$nIdx][5] Then Return FALSE

	$nWidth		= $arSideItems[$nIdx][7]
	$nHeight	= $arSideItems[$nIdx][8]
	$bStretch	= $arSideItems[$nIdx][9]

	Return TRUE
EndFunc


;********************************************************************
; Set menu side bitmap
;********************************************************************
Func _SetSideMenuImage($nIdx, $sFile, $sResName = "", $bStretch = FALSE)
	Return _SetSideMenuText($nIdx, $sFile, $sResName, TRUE, $bStretch)
EndFunc


;********************************************************************
; Set menu side text
;********************************************************************
Func _SetSideMenuText($nIdx, $sText, $sResName = "", $bIsBitmap = FALSE, $bStretch = FALSE)
	If Not _IsSideMenuIdx($nIdx) Then Return FALSE

	Local $i

	Local $hBitmap	= 0
	Local $nW		= 0
	Local $nH		= 0

	If $bIsBitmap Then
		Local $stFile = DllStructCreate("wchar[" & StringLen($sText) + 1 & "]")
		DllStructSetData($stFile, 1, $sText)

		If $sResName = "" Then
			$hBitmap = LoadImageW(0, DllStructGetPtr($stFile), 0, 0, 0, _
							BitOr(0x0010, 0x0040, 0x2000, 0x0020))
		Else
			Local $hLib = LoadLibraryExW(DllStructGetPtr($stFile), 0, 0x00000002)
			If $hLib <> 0 Then
				If IsNumber($sResName) Then
					$hBitmap = LoadImageW($hLib, $sResName, 0, 0, 0, _
									BitOr(0x0040, 0x2000, 0x0020))
				Else
					Local $stRes = DllStructCreate("wchar[" & StringLen($sResName) + 1 & "]")
					DllStructSetData($stRes, 1, $sResName)

					$hBitmap = LoadImageW($hLib, DllStructGetPtr($stRes), 0, 0, 0, _
									BitOr(0x0040, 0x2000, 0x0020))
				EndIf

				FreeLibrary($hLib)
			EndIf
		EndIf

		If $hBitmap = 0 Then
			Return FALSE
		Else
			Local $nSize = GetObjectW($hBitmap, 0, 0)
			Local $stBMP = DllStructCreate("long;long;long;long;ushort;ushort")

			If GetObjectW($hBitmap, $nSize, DllStructGetPtr($stBMP)) = 0 Then
				DeleteObject($hBitmap)
				Return FALSE
			Else
				$nW = DllStructGetData($stBMP, 2)
				$nH = DllStructGetData($stBMP, 3)
			EndIf
		EndIf
	EndIf

	$arSideItems[$nIdx][1] = $sText

	If $bIsBitmap Then
		If $arSideItems[$nIdx][5] <> 0 Then DeleteObject($arSideItems[$nIdx][5])
		$arSideItems[$nIdx][5] = TRUE
		$arSideItems[$nIdx][6] = $hBitmap
		$arSideItems[$nIdx][7] = $nW
		$arSideItems[$nIdx][8] = $nH
		If $bStretch Then
			$arSideItems[$nIdx][9] = TRUE
		Else
			$arSideItems[$nIdx][9] = FALSE
		EndIf
	Else
		$arSideItems[$nIdx][5] = FALSE
		$arSideItems[$nIdx][6] = 0
	EndIf

	Return TRUE
EndFunc


;********************************************************************
; Set menu side colors
;********************************************************************
Func _SetSideMenuColors($nIdx, $nColor = -1, $nBkColor = -1, $nBkGrdColor = -1)
	If Not _IsSideMenuIdx($nIdx) Then Return FALSE

	If $nColor <> -1 Then
		If $nColor = -2 Then
			$arSideItems[$nIdx][2] = $nMenuSideTxtClr
		Else
			$arSideItems[$nIdx][2] = $nColor
		EndIf
	EndIf

	If $nBkColor <> -1 Then
		If $nBkColor = -2 Then
			$arSideItems[$nIdx][3] = $nMenuSideBkClr
		Else
			$arSideItems[$nIdx][3] = $nBkColor
		EndIf
	EndIf

	If $nBkGrdColor <> -1 Then
		If $nBkGrdColor = -2 Then
			$arSideItems[$nIdx][4] = $nMenuSideBkClr2
		Else
			$arSideItems[$nIdx][4] = $nBkGrdColor
		EndIf
	EndIf

	Return 1
EndFunc


;********************************************************************
; Get menu side colors
;********************************************************************
Func _GetSideMenuColors($nIdx, ByRef $nColor, ByRef $nBkColor, ByRef $nBkGradColor)
	If $nIdx = 0 Then Return 0

	$nColor			= $arSideItems[$nIdx][2]
	$nBkColor		= $arSideItems[$nIdx][3]
	$nBkGradColor	= $arSideItems[$nIdx][4]

	Return 1
EndFunc


;********************************************************************
; Get the maximum text width in a menu
;********************************************************************
Func _GetMenuMaxTextWidth($hDC, $hMenu, ByRef $nMaxWidth, ByRef $nMaxAccWidth)
	Local $i, $stSize, $stText, $nLen, $nAccLen
	Local $nWidth		= 0
	Local $nAccWidth	= 0
	Local $arString

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][3] = $hMenu Then
			$arString = StringSplit($arMenuItems[$i][1], @Tab)
			If Not IsArray($arString) Then ContinueLoop

			If $arString[0] > 1 Then
				$nLen	= StringLen($arString[2])
				$stSize	= DllStructCreate("int;int")

				$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
				DllStructSetData($stText, 1, $arString[2])

				GetTextExtentPoint32W($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stSize))

				$nAccWidth = DllStructGetData($stSize, 1)
				$stText	= 0
				$stSize	= 0

				If $nAccWidth > $nMaxAccWidth Then $nMaxAccWidth = $nAccWidth
			EndIf

			$nLen	= StringLen($arString[1])
			$stSize	= DllStructCreate("int;int")

			$stText = DllStructCreate("wchar[" & $nLen + 1 & "]")
			DllStructSetData($stText, 1, $arString[1])

			GetTextExtentPoint32W($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stSize))

			$nWidth = DllStructGetData($stSize, 1)
			$stText	= 0
			$stSize	= 0

			If $nWidth > $nMaxWidth Then $nMaxWidth = $nWidth
		EndIf
	Next
EndFunc


;********************************************************************
; Get the maximum side text width
;********************************************************************
Func _GetSideMenuTextWidth($hDC, $sText)
	If $sText = "" Then Return 0

	Local $nLen		= StringLen($sText)
	Local $stSize	= DllStructCreate("int;int")
	Local $stText	= DllStructCreate("wchar[" & $nLen + 1 & "]")
	DllStructSetData($stText, 1, $sText)

	GetTextExtentPoint32W($hDC, DllStructGetPtr($stText), $nLen, DllStructGetPtr($stSize))

	Return DllStructGetData($stSize, 2)
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************
Func _GetMenuIsRadio($nMenuItemID)
	Local $i, $bRadio = 0

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$bRadio = $arMenuItems[$i][4]
			ExitLoop
		EndIf
	Next

	Return $bRadio
EndFunc


;********************************************************************
; Get the index of an icon from our store
;********************************************************************
Func _GetMenuIconIndex($nMenuItemID, ByRef $nIconIndex, ByRef $nSelIconIndex)
	Local $i

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$nIconIndex = $arMenuItems[$i][2]
			$nSelIconIndex = $arMenuItems[$i][6]
			ExitLoop
		EndIf
	Next
EndFunc


;********************************************************************
; Check if the item is from a tray menu
;********************************************************************
Func _IsTrayItem($nMenuItemID)
	Local $i, $bTray = FALSE

	For $i = 1 To $arMenuItems[0][0]
		If $arMenuItems[$i][0] = $nMenuItemID Then
			$bTray = $arMenuItems[$i][5]
			ExitLoop
		EndIf
	Next

	Return $bTray
EndFunc


;********************************************************************
; Get some system menu constants
;********************************************************************
Func _GetMenuInfos(ByRef $nS, ByRef $nX)
	$nS	= GetSystemMetrics(49)
	$nX	= GetSystemMetrics(71)
EndFunc


;********************************************************************
; Convert a normal menu item to an ownerdrawn menu item
;********************************************************************
Func _SetOwnerDrawn($hMenu, $MenuItemID, $sText, $bOwnerDrawn = TRUE)
	Local $nType = 0 ; MF_STRING

	If StringLen($sText) = 0 Then $nType = 0x00000800

	If $bOwnerDrawn Then $nType = BitOr($nType, 0x00000100)

	Local $stMII = DllStructCreate($sMENUITEMINFO)
	DllStructSetData($stMII, 1, DllStructGetSize($stMII))
	DllStructSetData($stMII, 2, 0x00000010) ; MIIM_TYPE
	DllStructSetData($stMII, 3, $nType)

	Local $stTypeData = DllStructCreate("uint")
	DllStructSetData($stTypeData, 1, $MenuItemID)
	DllStructSetData($stMII, 10, DllStructGetPtr($stTypeData))

	SetMenuItemInfo($hMenu, $MenuItemID, FALSE, DllStructGetPtr($stMII))
EndFunc


;********************************************************************
; Get the default menu font
;********************************************************************
Func _CreateMenuFont(ByRef $hFont, $bBold = FALSE, $bSide = FALSE)
	Local $stNCM = DllStructCreate($sNONCLIENTMETRICS)
	DllStructSetData($stNCM, 1, DllStructGetSize($stNCM))

	If SystemParametersInfo(0x0029, DllStructGetSize($stNCM), DllStructGetPtr($stNCM), 0) Then
		Local $stMenuLogFont = DllStructCreate($sLOGFONT)

		Local $i
		For $i = 1 To 14
			DllStructSetData($stMenuLogFont, $i, DllStructGetData($stNCM, $i + 38))
		Next

		If $bSide Then
			DllStructSetData($stMenuLogFont, 3, 900)
			DllStructSetData($stMenuLogFont, 4, 900)
		EndIf

		If $bBold Then DllStructSetData($stMenuLogFont, 5, 700)

		If $hFont > 0 Then DeleteObject($hFont)

		$hFont = CreateFontIndirect(DllStructGetPtr($stMenuLogFont))
		If $hFont = 0 Then $hFont = _CreateMenuFontByName("MS Sans Serif")
	EndIf
EndFunc


Func _CreateMenuFontByName($sFontName, $nHeight = 8, $nWidth = 400)
	Local $stFontName = DllStructCreate("char[260]")
	DllStructSetData($stFontName, 1, $sFontName)

	Local $hDC		= GetDC(0) ; Get the Desktops DC
	Local $nPixel	= GetDeviceCaps($hDC, 90)

	$nHeight	= 0 - MulDiv($nHeight, $nPixel, 72)

	ReleaseDC(0, $hDC)

	Local $hFont = CreateFont($nHeight, _
								0, _
								0, _
								0, _
								$nWidth, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								0, _
								DllStructGetPtr($stFontName))

	$stFontName = 0

	Return $hFont
EndFunc


;********************************************************************
; Create a blank icon for flash functionality
;********************************************************************
Func _CreateBlankIcon()
	If $hBlankIcon = 0 Then
		If @OSVersion = "WIN_VISTA" Or @OSVersion = "WIN_2008" Then
			Local $stIcon = DllStructCreate("hwnd")

			If ExtractIconExW("shell32.dll", 50, 0, DllStructGetPtr($stIcon), 1) Then _
				$hBlankIcon = DllStructGetData($stIcon, 1)
		Else
			Local $stAndMask = DllStructCreate("byte[64]")
			memset(DllStructGetPtr($stAndMask), 0xFF, 64)

        	Local $stXorMask = DllStructCreate("byte[64]")
			memset(DllStructGetPtr($stXorMask), 0x0, 64)

			$hBlankIcon = CreateIcon(0, 16, 16, 1, 1, DllStructGetPtr($stAndMask), DllStructGetPtr($stXorMask))
		EndIf
	EndIf

	Return $hBlankIcon
EndFunc


;********************************************************************
; CommCtrl.h - functions
;********************************************************************
Func ImageList_Create($nImageWidth, $nImageHeight, $nFlags, $nInitial, $nGrow)
	Local $hImageList = DllCall($hComctl32Dll, "hwnd", "ImageList_Create", _
														"int", $nImageWidth, _
														"int", $nImageHeight, _
														"int", $nFlags, _
														"int", $nInitial, _
														"int", $nGrow)
	Return $hImageList[0]
EndFunc


Func ImageList_AddIcon($hIml, $hIcon)
	Local $nIndex = DllCall($hComctl32Dll, "int", "ImageList_AddIcon", _
													"hwnd", $hIml, _
													"hwnd", $hIcon)
	Return $nIndex[0]
EndFunc


Func ImageList_Destroy($hIml)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_Destroy", _
													"hwnd", $hIml)
	Return $bResult[0]
EndFunc


Func ImageList_Draw($hIml, $nIndex, $hDC, $nX, $nY, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_Draw", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hDC, _
													"int", $nX, _
													"int", $nY, _
													"int", $nStyle)
	Return $bResult[0]
EndFunc


Func ImageList_DrawEx($hIml, $nIndex, $hDC, $nX, $nY, $nDx, $nDy, $nBkClr, $nFgClr, $nStyle)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_DrawEx", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hDC, _
													"int", $nX, _
													"int", $nY, _
													"int", $nDx, _
													"int", $nDy, _
													"int", $nBkClr, _
													"int", $nFgClr, _
													"int", $nStyle)
	Return $bResult[0]
EndFunc


Func ImageList_ReplaceIcon($hIml, $nIndex, $hIcon)
	Local $bResult = DllCall($hComctl32Dll, "int", "ImageList_ReplaceIcon", _
													"hwnd", $hIml, _
													"int", $nIndex, _
													"hwnd", $hIcon)
	Return $bResult[0]
EndFunc


;********************************************************************
; ShellApi.h - functions
;********************************************************************
Func ExtractIconExW($sIconFile, $nIconID, $ptrIconLarge, $ptrIconSmall, $nIcons)
	Local $nCount = DllCall($hShell32Dll, "int", "ExtractIconExW", _
												"wstr", $sIconFile, _
												"int", $nIconID, _
												"ptr", $ptrIconLarge, _
												"ptr", $ptrIconSmall, _
												"int", $nIcons)
	Return $nCount[0]
EndFunc


Func Shell_NotifyIcon($nMessage, $pNID)
	Local $nResult = DllCall($hShell32Dll, "int", "Shell_NotifyIconW", _
													"int", $nMessage, _
													"ptr", $pNID)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinBase.h - functions
;********************************************************************
Func MulDiv($nInt1, $nInt2, $nInt3)
	$nResult = DllCall("kernel32.dll", "int", "MulDiv", _
											"int", $nInt1, _
											"int", $nInt2, _
											"int", $nInt3)
	Return $nResult[0]
EndFunc


Func LoadLibraryExW($pFile, $hFile, $nFlags)
	$hResult = DllCall($hKernel32Dll, "hwnd", "LoadLibraryExW", _
												"ptr", $pFile, _
												"hwnd", $hFile, _
												"dword", $nFlags)
	Return $hResult[0]
EndFunc


Func FreeLibrary($hLib)
	$nResult = DllCall($hKernel32Dll, "int", "FreeLibrary", _
												"hwnd", $hLib)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinGDI.h - functions
;********************************************************************
Func SelectObject($hDC, $hObj)
	Local $hOldObj = DllCall($hGdi32Dll, "int", "SelectObject", _
												"hwnd", $hDC, _
												"hwnd", $hObj)
	Return $hOldObj[0]
EndFunc


Func DeleteObject($hObj)
	Local $bResult = DllCall($hGdi32Dll, "int", "DeleteObject", _
												"hwnd", $hObj)
	Return $bResult[0]
EndFunc


Func GetObjectW($hObj, $nSize, $pObj)
	Local $nResult = DllCall($hGdi32Dll, "int", "GetObjectW", _
												"hwnd", $hObj, _
												"int", $nSize, _
												"ptr", $pObj)
	Return $nResult[0]
EndFunc


Func CreateFont($nHeight, $nWidth, $nEscape, $nOrientn, $fnWeight, $bItalic, $bUnderline, $bStrikeout, $nCharset, $nOutputPrec, $nClipPrec, $nQuality, $nPitch, $ptrFontName)
	Local $hFont = DllCall($hGdi32Dll, "hwnd", "CreateFont", _
												"int", $nHeight, _
												"int", $nWidth, _
												"int", $nEscape, _
												"int", $nOrientn, _
												"int", $fnWeight, _
												"long", $bItalic, _
												"long", $bUnderline, _
												"long", $bStrikeout, _
												"long", $nCharset, _
												"long", $nOutputPrec, _
												"long", $nClipPrec, _
												"long", $nQuality, _
												"long", $nPitch, _
												"ptr", $ptrFontName)
	Return $hFont[0]
EndFunc


Func CreateFontIndirect($pLogFont)
	Local $hFont = DllCall($hGdi32Dll, "hwnd", "CreateFontIndirectW", _
												"ptr", $pLogFont)
	Return $hFont[0]
EndFunc


Func GetTextExtentPoint32W($hDC, $ptrText, $nTextLength, $ptrSize)
	Local $bResult = DllCall($hGdi32Dll, "int", "GetTextExtentPoint32W", _
												"hwnd" ,$hDC, _
												"ptr", $ptrText, _
												"int", $nTextLength, _
												"ptr", $ptrSize)
	Return $bResult[0]
EndFunc


Func SetBkColor($hDC, $nColor)
	Local $nOldColor = DllCall($hGdi32Dll, "int", "SetBkColor", _
												"hwnd", $hDC, _
												"int", $nColor)
	Return $nOldColor[0]
EndFunc


Func SetTextColor($hDC, $nColor)
	Local $nOldColor = DllCall($hGdi32Dll, "int", "SetTextColor", _
												"hwnd", $hDC, _
												"int", $nColor)
	Return $nOldColor[0]
EndFunc


Func CreateSolidBrush($nColor)
	Local $hBrush = DllCall($hGdi32Dll, "hwnd", "CreateSolidBrush", _
												"int", $nColor)
	Return $hBrush[0]
EndFunc


Func GetDeviceCaps($hDC, $nIndex)
	Local $nResult = DllCall($hGdi32Dll, "int", "GetDeviceCaps", _
												"hwnd", $hDC, _
												"int", $nIndex)
	Return $nResult[0]
EndFunc


Func CreateCompatibleDC($hDC)
	Local $hCompDC = DllCall($hGdi32Dll, "hwnd", "CreateCompatibleDC", _
												"hwnd", $hDC)
	Return $hCompDC[0]
EndFunc


Func DeleteDC($hDC)
	Local $bResult = DllCall($hGdi32Dll, "int", "DeleteDC", _
												"hwnd", $hDC)
	Return $bResult[0]
EndFunc


Func CreateBitmap($nWidth, $nHeight, $nCPlanes, $nCBitsPerPixel, $ptrCData)
	Local $hBitmap = DllCall($hGdi32Dll, "hwnd", "CreateBitmap", _
												"int", $nWidth, _
												"int", $nHeight, _
												"int", $nCPlanes, _
												"int", $nCBitsPerPixel, _
												"ptr", $ptrCData)
	Return $hBitmap[0]
EndFunc


Func BitBlt($hDCDest, $nXDest, $nYDest, $nWDest, $nHDest, $hDCSrc, $nXSrc, $nYSrc, $nOpCode)
	Local $bResult = DllCall($hGdi32Dll, "int", "BitBlt", _
												"hwnd", $hDCDest, _
												"int", $nXDest, _
												"int", $nYDest, _
												"int", $nWDest, _
												"int", $nHDest, _
												"hwnd", $hDCSrc, _
												"int", $nXSrc, _
												"int", $nYSrc, _
												"long", $nOpCode)
	Return $bResult[0]
EndFunc


Func StretchBlt($hDCDest, $nXDest, $nYDest, $nWDest, $nHDest, $hDCSrc, $nXSrc, $nYSrc, $nWSrc, $nHSrc, $nOpCode)
	Local $bResult = DllCall($hGdi32Dll, "int", "StretchBlt", _
												"hwnd", $hDCDest, _
												"int", $nXDest, _
												"int", $nYDest, _
												"int", $nWDest, _
												"int", $nHDest, _
												"hwnd", $hDCSrc, _
												"int", $nXSrc, _
												"int", $nYSrc, _
												"int", $nWSrc, _
												"int", $nHSrc, _
												"long", $nOpCode)
	Return $bResult[0]
EndFunc


Func SetBkMode($hDC, $nMode)
	Local $nResult = DllCall($hGdi32Dll, "int", "SetBkMode", _
												"hwnd", $hDC, _
												"int", $nMode)
	Return $nResult[0]
EndFunc


Func GradientFill($hDC, $pVert, $nNumVert, $pRect, $nNumRect, $nFillMode)
	Local $nResult = DllCall($hMsimg32Dll, "int", "GradientFill", _
													"hwnd", $hDC, _
													"ptr", $pVert, _
													"ulong", $nNumVert, _
													"ptr", $pRect, _
													"ulong", $nNumRect, _
													"ulong", $nFillMode)
	Return $nResult[0]
EndFunc


;********************************************************************
; WinUser.h - functions
;********************************************************************
Func GetDC($hWnd)
	Local $hDC = DllCall($hUser32Dll, "hwnd", "GetDC", _
											"hwnd", $hWnd)
	Return $hDC[0]
EndFunc


Func ReleaseDC($hWnd, $hDC)
	Local $bResult = DllCall($hUser32Dll, "int", "ReleaseDC", _
												"hwnd", $hWnd, _
												"hwnd", $hDC)
	Return $bResult[0]
EndFunc


Func GetSysColor($nIndex)
	Local $nColor = DllCall($hUser32Dll, "int", "GetSysColor", _
												"int", $nIndex)
	Return $nColor[0]
EndFunc


Func GetSysColorBrush($nIndex)
	Local $hBrush = DllCall($hUser32Dll, "hwnd", "GetSysColorBrush", _
												"int", $nIndex)
	Return $hBrush[0]
EndFunc


Func LoadIcon($hInstance, $nIcon)
	Local $hIcon = DllCall($hUser32Dll, "hwnd", "LoadIcon", _
												"hwnd", $hInstance, _
												"int", $nIcon)
	Return $hIcon[0]
EndFunc


Func DestroyIcon($hIcon)
	Local $bResult = DllCall($hUser32Dll, "int", "DestroyIcon", _
												"hwnd", $hIcon)
	Return $bResult[0]
EndFunc


Func CreateIcon($hInstance, $nWidth, $nHeight, $nPlanes, $nBitsPixel, $pAndBits, $pXorBits)
	Local $hResult = DllCall($hUser32Dll, "hwnd", "CreateIcon", _
													"hwnd", $hInstance, _
													"int", $nWidth, _
													"int", $nHeight, _
													"byte", $nPlanes, _
													"byte", $nBitsPixel, _
													"ptr", $pAndBits, _
													"ptr", $pXorBits)
	Return $hResult[0]
EndFunc


Func GetSystemMetrics($nIndex)
	Local $nResult = DllCall($hUser32Dll, "int", "GetSystemMetrics", _
												"int", $nIndex)
	Return $nResult[0]
EndFunc


Func DrawTextW($hDC, $ptrText, $nLenText, $ptrRect, $nFlags)
	Local $nHeight = DllCall($hUser32Dll, "int", "DrawTextW", _
												"hwnd", $hDC, _
												"ptr", $ptrText, _
												"int", $nLenText, _
												"ptr", $ptrRect, _
												"int", $nFlags)
	Return $nHeight[0]
EndFunc


Func GetMenuItemCount($hMenu)
	Local $nCount = DllCall($hUser32Dll, "int", "GetMenuItemCount", _
												"hwnd", $hMenu)
	Return $nCount[0]
EndFunc


Func GetMenuItemID($hMenu, $nPos)
	Local $nID = DllCall($hUser32Dll, "int", "GetMenuItemID", _
											"hwnd", $hMenu, _
											"int", $nPos)
	Return $nID[0]
EndFunc


Func GetMenuItemInfo($hMenu, $nID, $bPos, $pMII)
	Local $nResult = DllCall($hUser32Dll, "int", "GetMenuItemInfo", _
												"hwnd", $hMenu, _
												"uint", $nID, _
												"int", $bPos, _
												"ptr", $pMII)
	Return $nResult[0]
EndFunc


Func SetMenuItemInfo($hMenu, $nID, $bPos, $pMII)
	Local $nResult = DllCall($hUser32Dll, "int", "SetMenuItemInfo", _
												"hwnd", $hMenu, _
												"uint", $nID, _
												"int", $bPos, _
												"ptr", $pMII)
	Return $nResult[0]
EndFunc


Func GetMenuState($hMenu, $nID, $nFlags)
	Local $nState = DllCall($hUser32Dll, "int", "GetMenuState", _
												"hwnd", $hMenu, _
												"int", $nID, _
												"int", $nFlags)
	Return $nState[0]
EndFunc


Func FillRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall($hUser32Dll, "int", "FillRect", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"hwnd", $hBrush)
	Return $bResult[0]
EndFunc


Func DrawEdge($hDC, $ptrRect, $nEdgeType, $nBorderFlag)
	Local $bResult = DllCall($hUser32Dll, "int", "DrawEdge", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"int", $nEdgeType, _
												"int", $nBorderFlag)
	Return $bResult[0]
EndFunc


Func FrameRect($hDC, $ptrRect, $hBrush)
	Local $bResult = DllCall($hUser32Dll, "int", "FrameRect", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"hwnd", $hBrush)
	Return $bResult[0]
EndFunc


Func DrawFrameControl($hDC, $ptrRect, $nType, $nState)
	Local $bResult = DllCall($hUser32Dll, "int", "DrawFrameControl", _
												"hwnd", $hDC, _
												"ptr", $ptrRect, _
												"int", $nType, _
												"int", $nState)
	Return $bResult[0]
EndFunc


Func SystemParametersInfo($nAction, $nParam, $pParam, $nWinini)
	Local $nResult = DllCall($hUser32Dll, "int", "SystemParametersInfoW", _
												"uint", $nAction, _
												"uint", $nParam, _
												"ptr", $pParam, _
												"uint", $nWinini)
	Return $nResult[0]
EndFunc


Func GetCursorPos($pPoint)
	Local $nResult = DllCall($hUser32Dll, "int", "GetCursorPos", _
											"ptr", $pPoint)
	Return $nResult[0]
EndFunc


Func SetForegroundWindow($hWnd)
	Local $nResult = DllCall($hUser32Dll, "int", "SetForegroundWindow", _
													"hwnd", $hWnd)
	Return $nResult[0]
EndFunc


Func TrackPopupMenuEx($hMenu, $nFlags, $nX, $nY, $hWnd, $pParams)
    Local $nResult = DllCall($hUser32Dll, "int", "TrackPopupMenuEx", _
    												"hwnd", $hMenu, _
    												"uint", $nFlags, _
    												"int", $nX, _
    												"int", $nY, _
    												"hwnd", $hWnd, _
    												"ptr", $pParams)
    Return $nResult[0]
EndFunc


Func PostMessage($hWnd, $nMsg, $wParam, $lParam)
    Local $nResult = DllCall($hUser32Dll, "int", "PostMessage", _
    												"hwnd", $hWnd, _
    												"uint", $nMsg, _
    												"dword", $wParam, _
    												"dword", $lParam)
    Return $nResult[0]
EndFunc


Func ShowWindow($hWnd, $nState)
	DllCall($hUser32Dll, "int", "ShowWindow", _
								"hwnd", $hWnd, _
								"int", $nState)
EndFunc


Func SetTimer($hWnd, $nID, $nTimeOut, $pFunc)
	Local $nResult = DllCall($hUser32Dll, "uint", "SetTimer", _
													"hwnd", $hWnd, _
													"uint", $nID, _
													"uint", $nTimeOut, _
													"ptr", $pFunc)
	Return $nResult[0]
EndFunc


Func KillTimer($hWnd, $nID)
	Local $nResult = DllCall($hUser32Dll, "int", "KillTimer", _
													"hwnd", $hWnd, _
													"uint", $nID)
	Return $nResult[0]
EndFunc


Func LoadImageW($hInst, $pName, $nType, $nX, $nY, $nLoad)
	Local $hResult = DllCall($hUser32Dll, "hwnd", "LoadImageW", _
													"hwnd", $hInst, _
													"dword", $pName, _
													"uint", $nType, _
													"int", $nX, _
													"int", $nY, _
													"uint", $nLoad)
	Return $hResult[0]
EndFunc


Func memset($pDest, $nChr, $nCount)
	Local $pResult = DllCall("msvcrt.dll", "ptr:cdecl", "memset", _
														"ptr", $pDest, _
														"int", $nChr, _
														"int", $nCount)
	Return $pResult[0]
EndFunc


Func MenuBarBKColor($hMenu, $nColor)
	Local $tInfo,$aResult
	Local $hBrush = DllCall('gdi32.dll', 'hwnd', 'CreateSolidBrush', 'int', $nColor)
	If @error Then Return
	$tInfo = DllStructCreate("int Size;int Mask;int Style;int YMax;int hBack;int ContextHelpID;ptr MenuData")
	DllStructSetData($tInfo, "Mask", 2)
	DllStructSetData($tInfo, "hBack", $hBrush[0])
	DllStructSetData($tInfo, "Size", DllStructGetSize($tInfo))
	$aResult = DllCall("User32.dll", "int", "SetMenuInfo", "hwnd", $hMenu, "ptr", DllStructGetPtr($tInfo))
	Return $aResult[0] <> 0
EndFunc   ;==>_GUICtrlMenu_SetMenuBackground