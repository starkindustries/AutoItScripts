#include <GUIConstantsEx.au3>

#include "MouseOnEvent.au3"

HotKeySet("^q", "_Quit")

_Example_Intro()
_Example_Limit_Window()

Func _Example_Intro()
	MsgBox(64, "Attention!", _
		"Now we disable Primary mouse button down, and call our function when mouse button down event is recieved.", 5)
	
	;Disable Wheel mouse button *scrolling* up/down, and call our function when wheel mouse button scroll up/down event is recieved
	_MouseSetOnEvent($MOUSE_WHEELSCROLLDOWN_EVENT, "MouseWheel_Events", 1)
	_MouseSetOnEvent($MOUSE_WHEELSCROLLUP_EVENT, "MouseWheel_Events", 2)
	;Disable Primary mouse button *down*, and call our function when mouse button *down* event is recieved
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "MousePrimaryDown_Event")
	
	Sleep(3000)
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT) ;Enable mouse button back.
	_MouseSetOnEvent($MOUSE_WHEELSCROLLDOWN_EVENT)
	_MouseSetOnEvent($MOUSE_WHEELSCROLLUP_EVENT)
	
	ToolTip("")
	
	MsgBox(64, "Attention!", _
		"And now we disable Secondary mouse button up, and call our function when mouse button up event is recieved.", 5)
	
	;Disable Secondary mouse button *up*, and call our function when mouse button *up* event is recieved
	_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT, "MouseSecondaryUp_Event")
	Sleep(5000)
	_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT) ;Enable mouse button back.
	
	ToolTip("")
EndFunc

Func _Example_Limit_Window()
	Local $hGUI = GUICreate("MouseSetOnEvent_UDF Example - Limit on specific window")
	
	GUICtrlCreateLabel("Try to click on that specific GUI window", 40, 40, 300, 30)
	GUICtrlSetFont(-1, 12, 800)
	
	GUICtrlCreateLabel("Press <CTRL + Q> to exit", 10, 10)
	
	GUISetState()
	
	;A little(?) buggy when you mix different events :(
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "MousePrimaryDown_Event", "", "", $hGUI)
	;_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT, "MouseSecondaryUp_Event", "", "", $hGUI)
	
	While 1
		Switch GUIGetMsg()
			Case $GUI_EVENT_CLOSE
				ExitLoop
			Case $GUI_EVENT_PRIMARYDOWN
				MsgBox(0, "", "Should be shown ;)")
		EndSwitch
	WEnd
	
	_MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT)
	;_MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT)
EndFunc

Func MouseWheel_Events($iMode)
	Switch $iMode
		Case 1
			ToolTip("Wheel Mouse Button (scroll) DOWN Blocked")
		Case 2
			ToolTip("Wheel Mouse Button (scroll) UP Blocked")
	EndSwitch
EndFunc

Func MousePrimaryDown_Event()
	ToolTip("Primary Mouse Button Down Blocked")
EndFunc

Func MouseSecondaryUp_Event()
	ToolTip("Secondary Mouse Button Up Blocked")
EndFunc

Func _Quit()
	Exit
EndFunc
