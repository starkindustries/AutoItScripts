#include "MouseOnEvent.au3"

HotKeySet("^q", "_Quit")

Global $hClock_Wnd
Global $iLimit_Coord_Left, $iLimit_Coord_Top, $iLimit_Coord_Width, $iLimit_Coord_Height

_Example_1()
;_Example_2()

Func _Example_1()
	$hClock_Wnd = ControlGetHandle("[CLASS:Shell_TrayWnd]", "", "TrayClockWClass1")
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse_Event_Exmp1", "", "", 0, -1)
	;_MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT, "_Mouse_Event_Exmp1", "", "", 0, -1) ;Not really needed
	_MouseSetOnEvent($MOUSE_SECONDARYDOWN_EVENT, "_Mouse_Event_Exmp1", "", "", 0, -1)
	_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT, "_Mouse_Event_Exmp1", "", "", 0, -1)
	
	While 1
		Sleep(100)
	WEnd
EndFunc

Func _Example_2()
	$aClock_Pos = ControlGetPos("[CLASS:Shell_TrayWnd]", "", "TrayClockWClass1")
	
	$iLimit_Coord_Left = $aClock_Pos[0]
	$iLimit_Coord_Top = $aClock_Pos[1]
	$iLimit_Coord_Width = $aClock_Pos[2]
	$iLimit_Coord_Height = $aClock_Pos[3]
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_Mouse_Event_Exmp2", "", "", 0, -1)
	;_MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT, "_Mouse_Event_Exmp2", "", "", 0, -1) ;Not really needed
	_MouseSetOnEvent($MOUSE_SECONDARYDOWN_EVENT, "_Mouse_Event_Exmp2", "", "", 0, -1)
	_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT, "_Mouse_Event_Exmp2", "", "", 0, -1)
	
	While 1
		Sleep(100)
	WEnd
EndFunc

Func _Mouse_Event_Exmp1()
	Local $aMouse_Pos = MouseGetPos()
	
	Local $aRet = DllCall("User32.dll", "int", "WindowFromPoint", _
		"long", $aMouse_Pos[0], _
		"long", $aMouse_Pos[1])
	
	If $aRet[0] = $hClock_Wnd Then Return 1 ;Block mouse click
EndFunc

Func _Mouse_Event_Exmp2()
	Opt("MouseCoordMode", 0)
	
	Local $aMPos = MouseGetPos()
	
	If ($aMPos[0] >= $iLimit_Coord_Left And $aMPos[0] <= $iLimit_Coord_Left + $iLimit_Coord_Width) And _
		($aMPos[1] >= $iLimit_Coord_Top And $aMPos[1] <= $iLimit_Coord_Top + $iLimit_Coord_Height) Then
		
		ToolTip('MouseClicks are disabled', 0, 0)
		
		Return 1 ;Block mouse click
	EndIf
	
	ToolTip('MouseClicks are enabled', 0, 0)
	
	Return 0
EndFunc

Func _Quit()
	Exit
EndFunc
