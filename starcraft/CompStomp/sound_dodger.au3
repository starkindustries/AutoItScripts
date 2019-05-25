; Zion's AutoIt Snake Script
;
; NOTES:
; ******************************************************
; MouseClickDrag ( "button", x1, y1, x2, y2 [, speed] )
; MouseClick ( "button" [, x, y [, clicks [, speed]]] )

#include-once
#include <Debug.au3>
#include "MouseSetOnEvent_UDF_1.8/MouseOnEvent.au3"
#include "../toolbox.au3"

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)
; press f2 to exit
HotKeySet("{f2}","exitProgram")
HotKeySet("{ESC}","exitProgram")


; getColor() ; use this to get color at current mouse position
; getMousePos() ; use this to get mouse position
; Exit

; **************************************************************** START
; http://www.autoitscript.com/forum/topic/64738-mousesetonevent-udf/

Local $startTime = 0
Local $dif = 0
Local $mouseDownPos[2] = [0,0]
Local $mouseUpPos[2] = [0,0]

; MouseCoordMode
Local Const $activeWindow = 0
Local Const $absolute     = 1
AutoItSetOption("MouseCoordMode", $absolute); choose $activeWindow or $absolute

; sleep constant
Local Const $delay = 5

MouseClick("left", 956, 498, 1, 10)

While(True)
	MouseMove(765, 545, 0)
	Sleep($delay)
	MouseMove(1150, 545, 0)
	Sleep($delay)
WEnd