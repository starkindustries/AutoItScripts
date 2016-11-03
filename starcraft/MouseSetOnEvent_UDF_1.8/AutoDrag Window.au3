#include <GUIConstantsEx.au3>
#include <StaticConstants.au3>
#include <WindowsConstants.au3>

#include "MouseOnEvent.au3"

Global $iDrag_Is_Active = False

Opt("GUIOnEventMode", 1)

$Form1 = GUICreate("Form1", 500, 40)
GUISetOnEvent($GUI_EVENT_CLOSE, "_Exit")

$Label1 = GUICtrlCreateLabel("Click on title, and move the mouse", 10, 10, 480, 20)
GUICtrlSetFont(-1, 12, 400, 0, "Arial")

GUISetState(@SW_SHOW)

_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "_PrimaryDown", "", "", $Form1, -1)
_MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT, "_PrimaryUp", "", "", $Form1, -1)

While 1
	Sleep(10)
WEnd

Func _Exit()
	;GUIDelete()
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT)
	_MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT)
	
	Exit
EndFunc

Func _PrimaryDown()
	GUICtrlSetData($Label1, "Mouse Left Down")
	
	Return 0 ;Do not Block the default processing
EndFunc

Func _PrimaryUp()
	If GUICtrlRead($Label1) = "Mouse Left Down" Then Send("{Enter}")
	GUICtrlSetData($Label1, "Mouse Left Up - Drag the window and press ENTER, or click again.")
	
	Return 1 ;Block the default processing
EndFunc
