#include <GDIPlus.au3>
#include <WindowsConstants.au3>
#include <WinAPI.au3>
#include <Constants.au3>

Opt("TrayMenuMode", 1)
Opt("TrayOnEventMode", 1)

Global $dial = 0, $aD, $m_nWidth, $m_nHeight, $hourNeedle = 0, $aH, $minuteNeedle = 0, $aM, $secondNeedle = 0, $aS
Global $hClock, $aThemes

_Main()

Exit

Func _Main()
	_GDIPlus_Startup()
	$hClock = _CreateClockWindow()
	_CreateTrayMenu()
	_LoadTheme()

	While True
		Sleep(60000)
	WEnd
EndFunc   ;==>_Main

Func _ShutDown()
	_GDIPlus_ImageDispose($secondNeedle)
	_GDIPlus_ImageDispose($minuteNeedle)
	_GDIPlus_ImageDispose($hourNeedle)
	_GDIPlus_Shutdown()
	_WinAPI_DestroyWindow($hClock)
	Exit
EndFunc   ;==>_ShutDown

Func _DrawClock()
	Local $rc = _WinAPI_GetWindowRect($hClock)
	Local $ptSrc = DllStructCreate($tagPOINT)
	DllStructSetData($ptSrc, "X", 0)
	DllStructSetData($ptSrc, "Y", 0)
	Local $ptWinPos = DllStructCreate($tagPOINT)
	DllStructSetData($ptWinPos, "X", DllStructGetData($rc, "left"))
	DllStructSetData($ptWinPos, "Y", DllStructGetData($rc, "top"))
	Local $szWin = DllStructCreate($tagSIZE)
	DllStructSetData($szWin, "X", $m_nWidth)
	DllStructSetData($szWin, "Y", $m_nHeight)
	Local $stBlend = DllStructCreate($tagBLENDFUNCTION)
	DllStructSetData($stBlend, 1, 0x00)
	DllStructSetData($stBlend, 2, 0x00)
	DllStructSetData($stBlend, 3, 0xff)
	DllStructSetData($stBlend, 4, 0x01)

	Local $hDC = _WinAPI_GetDC($hClock)
	Local $hdcMemory = _WinAPI_CreateCompatibleDC($hDC)

	Local $tagBITMAPINFOHEADER = "dword biSize;long biWidth;long biHeight;short biPlanes;short biBitCount;"
	$tagBITMAPINFOHEADER &= "dword biCompression;dword biSizeImage;long biXPelsPerMeter;long biYPelsPerMeter;"
	$tagBITMAPINFOHEADER &= "dword biClrUsed;dword biClrImportant"
	Local $bmih = DllStructCreate($tagBITMAPINFOHEADER)
	Local $nBytesPerLine = BitShift((($m_nWidth * 32 + 31) & (-31)), -3)
	DllStructSetData($bmih, "biSize", DllStructGetSize($bmih))
	DllStructSetData($bmih, "biWidth", $m_nWidth)
	DllStructSetData($bmih, "biHeight", $m_nHeight)
	DllStructSetData($bmih, "biPlanes", 1)
	DllStructSetData($bmih, "biBitCount", 32)
	DllStructSetData($bmih, "biCompression", 0)
	DllStructSetData($bmih, "biClrUsed", 0)
	DllStructSetData($bmih, "biSizeImage", $nBytesPerLine * $m_nHeight)

	$aRet = DllCall("Gdi32.dll", "hwnd", "CreateDIBSection", "ptr", 0, "ptr", DllStructGetPtr($bmih), _
			"uint", 0, "ptr*", 0, "ptr", 0, "dword", 0)
	Local $hbmpMem = $aRet[0]
	Local $pvBits = $aRet[4]

	If $hbmpMem Then
		Local $hbmpOld = _WinAPI_SelectObject($hdcMemory, $hbmpMem)
		Local $graph = _GDIPlus_GraphicsCreateFromHDC($hdcMemory)
		_GDIPlus_GraphicsSetSmoothingMode($graph, 3)

		Local $hBrush = _GDIPlus_BrushCreateSolid(0xa0000000)
		_GDIPlus_GraphicsFillRect($graph, 0, 0, $m_nWidth, $m_nHeight, $hBrush)
		_DrawNeedle($graph, $hourNeedle, $m_nWidth / 4, $m_nHeight / 4, @HOUR * 30 + (@MIN / 2), 4)
		_DrawNeedle($graph, $minuteNeedle, $m_nWidth / 4, $m_nHeight / 4, @MIN * 6 + (@SEC / 10), 2)
		_DrawNeedle($graph, $secondNeedle, $m_nWidth / 4, $m_nHeight / 4, @SEC * 6, 1)

		_WinAPI_UpdateLayeredWindow($hClock, $hDC, DllStructGetPtr($ptWinPos), DllStructGetPtr($szWin), $hdcMemory, _
				DllStructGetPtr($ptSrc), 0, DllStructGetPtr($stBlend), 2)

		_GDIPlus_GraphicsReleaseDC($graph, $hdcMemory)
		_WinAPI_SelectObject($hdcMemory, $hbmpOld)
		_WinAPI_DeleteObject($hbmpMem)
		
		_GDIPlus_BrushDispose($hBrush)
	EndIf

	_WinAPI_DeleteDC($hdcMemory)
	_WinAPI_DeleteDC($hDC)

EndFunc   ;==>_DrawClock

Func _DrawNeedle($graph, $pNeedle, $nNeedleCenterX, $nNeedleCenterY, $rAngle, $needleWidth)
	Local $status = DllCall($ghGDIPDll, "int", "GdipRotateWorldTransform", "hwnd", $graph, "float", $rAngle, "int", 1)
	$status = DllCall($ghGDIPDll, "int", "GdipTranslateWorldTransform", "hwnd", $graph, "float", $m_nWidth / 2, "float", $m_nHeight / 2, "int", 1)
	
	$hBrush = _GDIPlus_PenCreate(0xFFFFFFFF, $needleWidth)
	
	_GDIPlus_GraphicsDrawLine($graph, - ($rAngle = 180), - ($rAngle = 180), $nNeedleCenterX, $nNeedleCenterY, $hBrush)
	;_GDIPlus_GraphicsDrawImageRect($graph, $pNeedle, -$nNeedleCenterX - ($rAngle = 180), -$nNeedleCenterY - ($rAngle = 180), _
	;		_GDIPlus_ImageGetWidth($pNeedle), _GDIPlus_ImageGetHeight($pNeedle))
	$status = DllCall($ghGDIPDll, "int", "GdipResetWorldTransform", "hwnd", $graph)
		
	_GDIPlus_PenDispose($hBrush)

EndFunc   ;==>_DrawNeedle

Func _CreateClockWindow()
	Local Const $CS_VREDRAW = 1
	Local Const $CS_HREDRAW = 2
	Local $sClassName = "ClockWndClass"
	Local $hWndProc = DllCallbackRegister("_MyWndProc", "int", "hwnd;int;wparam;lparam")
	Local $tagWNDCLASS = "uint cbSize;uint style;ptr lpfnWndProc;int cbClsExtra;int cbWndExtra;hwnd hInstance;"
	$tagWNDCLASS &= "hwnd hIcon;hwnd hCursor;hwnd hbrBackground;ptr lpszMenuName;ptr lpszClassName;hwnd hIconSm"
	Local $tWndClassEx = DllStructCreate($tagWNDCLASS)
	Local $tClassName = DllStructCreate("char[" & StringLen($sClassName) + 1 & "]")
	DllStructSetData($tClassName, 1, $sClassName)
	DllStructSetData($tWndClassEx, "cbSize", DllStructGetSize($tWndClassEx))
	DllStructSetData($tWndClassEx, "style", BitOR($CS_VREDRAW, $CS_HREDRAW))
	DllStructSetData($tWndClassEx, "lpfnWndProc", DllCallbackGetPtr($hWndProc))
	DllStructSetData($tWndClassEx, "cbClsExtra", 0)
	DllStructSetData($tWndClassEx, "cbWndExtra", 0)
	DllStructSetData($tWndClassEx, "hInstance", _WinAPI_GetModuleHandle(""))
	DllStructSetData($tWndClassEx, "hIcon", 0)
	DllStructSetData($tWndClassEx, "hCursor", _WinAPI_LoadCursor(0, 32512))
	DllStructSetData($tWndClassEx, "hbrBackground", 6)
	DllStructSetData($tWndClassEx, "lpszMenuName", 0)
	DllStructSetData($tWndClassEx, "lpszClassName", DllStructGetPtr($tClassName))
	DllStructSetData($tWndClassEx, "hIconSm", 0)
	Local $aRet = DllCall("user32.dll", "dword", "RegisterClassEx", "ptr", DllStructGetPtr($tWndClassEx))
	$aRet = DllCall("user32.dll", "hwnd", "CreateWindowEx", "dword", BitOR($WS_EX_LAYERED, $WS_EX_TRANSPARENT, $WS_EX_TOPMOST, $WS_EX_TOOLWINDOW), _
			"ptr", DllStructGetPtr($tClassName), "ptr", 0, "dword", $WS_VISIBLE, "int", 0, "int", 0, "int", 100, _
			"int", 100, "hwnd", 0, "hwnd", 0, "hwnd", _WinAPI_GetModuleHandle(""), "ptr", 0)
	_WinAPI_ShowWindow($aRet[0], @SW_HIDE)
	Local $rc = _WinAPI_GetWindowRect($hClock)
	_WinAPI_MoveWindow($aRet[0], _
			(_WinAPI_GetSystemMetrics($SM_CXSCREEN) - (DllStructGetData($rc, "right") - DllStructGetData($rc, "left"))) / 2, _
			(_WinAPI_GetSystemMetrics($SM_CYSCREEN) - (DllStructGetData($rc, "bottom") - DllStructGetData($rc, "top"))) / 2, _
			DllStructGetData($rc, "right") - DllStructGetData($rc, "left"), _
			DllStructGetData($rc, "bottom") - DllStructGetData($rc, "top"), False)
	DllCall("user32.dll", "ptr", "SetTimer", "hwnd", $aRet[0], "ptr", 0xff00, "uint", 1000, "ptr", 0)
	_WinAPI_ShowWindow($aRet[0], @SW_SHOWNORMAL)
	_WinAPI_UpdateWindow($aRet[0])
	Return $aRet[0]
EndFunc   ;==>_CreateClockWindow

Func _MyWndProc($hWnd, $iMessage, $wParam, $lParam)
	Switch $iMessage
		Case $WM_PAINT, $WM_TIMER
			_DrawClock()
		Case 0x0201 ; $WM_LBUTTONDOWN
			_SendMessage($hWnd, 0x00a1, 2, 2) ; $WM_NCLBUTTONDOWN
	EndSwitch
	Return _WinAPI_DefWindowProc($hWnd, $iMessage, $wParam, $lParam)
EndFunc   ;==>_MyWndProc

Func _WinAPI_LoadCursor($hInstance, $lpCursorName)
	Local $aRet = DllCall("user32.dll", "hwnd", "LoadCursor", "hwnd", $hInstance, "ptr", $lpCursorName)
	Return $aRet[0]
EndFunc   ;==>_WinAPI_LoadCursor

Func _LoadTheme()
	$m_nWidth = 300
	$m_nHeight = 300

	_WinAPI_SetWindowPos($hClock, 0, 0, 0, $m_nWidth, $m_nHeight, $SWP_NOMOVE + $SWP_NOZORDER)
	_DrawClock()
EndFunc   ;==>_LoadTheme

Func _CreateTrayMenu()
	Global $mExit = TrayCreateItem("Exit")
	TrayItemSetOnEvent($mExit, "_ShutDown")
EndFunc   ;==>_CreateTrayMenu