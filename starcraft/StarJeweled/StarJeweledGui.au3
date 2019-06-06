#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#Region ### START Koda GUI section
### Form=c:\users\zionp\desktop\playgrounds\autoitscripts\starcraft\starjeweled\starjeweledgui.kxf
Local $StarJeweledGUI = GUICreate("StarJeweledGUI", 274, 274, 1390, 50)

Local $boxes[8][8]
Local $boxSize = 32
Local $origin = 8

; Create the box graphics
For $x=0 To 7 Step 1
	For $y=0 To 7 Step 1
		; GUICtrlCreateGraphic ( left, top [, width [, height [, style]]] )
		Local $left = $origin + $x * $boxSize
		Local $top  = $origin + $y * $boxSize
		$boxes[$y][$x] = GUICtrlCreateGraphic($left, $top, $boxSize-1, $boxSize-1)
		GUICtrlSetBkColor(-1, 0x00ff00)
	Next
Next
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

#include <StarJeweled.au3>

While 1
	Local $nMsg = GUIGetMsg()
	Switch $nMsg
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
	if ($shouldSearch) Then
		FindAndClickMatch($boxes)
	EndIf
WEnd