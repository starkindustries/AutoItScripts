#include "MouseOnEvent.au3"

HotKeySet("^q", "_Quit")

Global $iLimit_Coord_Left 		= 0
Global $iLimit_Coord_Top 		= 40
Global $iLimit_Coord_Width 		= 350
Global $iLimit_Coord_Height 	= 25

_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "MousePrimaryDown_Event", "", "", 0, -1)

While 1
	Sleep(100)
WEnd

Func MousePrimaryDown_Event()
	Local $aMPos = MouseGetPos()
	
	If ($aMPos[0] >= $iLimit_Coord_Left And $aMPos[0] <= $iLimit_Coord_Left + $iLimit_Coord_Width) And _
		($aMPos[1] >= $iLimit_Coord_Top And $aMPos[1] <= $iLimit_Coord_Top + $iLimit_Coord_Height) Then Return 1 ;Block mouse click
	
	Return 0
EndFunc

Func _Quit()
	Exit
EndFunc
