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

; use this to get color at current mouse position
; getColor()
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

While(True)
   ; Syntax: _MouseSetOnEvent($iEvent, $sFuncName="", $sParam1="", $sParam2="", $hTargetWnd=0, $iBlockDefProc=1)
   _MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT, "MousePrimaryDown_Event", "", "", 0, 0)   
   _MouseSetOnEvent($MOUSE_PRIMARYUP_EVENT, "MousePrimaryUp_Event", "", "", 0, 0)   
WEnd

; _MouseSetOnEvent($MOUSE_PRIMARYDOWN_EVENT) ;Enable mouse button back.
; _MouseSetOnEvent($MOUSE_SECONDARYUP_EVENT) ;Enable mouse button back.

Func MousePrimaryDown_Event()
   $dif = TimerDiff($startTime)
   $dif = Round($dif, 0)
   $startTime = TimerInit() 
   $mouseDownPos = MouseGetPos() ; use this to get mouse position
   ; ConsoleWrite("Time between clicks: " & $dif & "ms" & @LF)
   ConsoleWrite("Sleep(" & $dif & ")" & @LF);
   ; ConsoleWrite("Primary Mouse Down @ " & $mouseDownPos[0] & ":" & $mouseDownPos[1] & @LF)
EndFunc

Func MousePrimaryUp_Event()
   $dif = TimerDiff($startTime)
   $dif = Round($dif, 0)
   $mouseUpPos = MouseGetPos() ; use this to get mouse position
   ; ConsoleWrite("Primary Mouse Up @ " & $mouseUpPos[0] & ":" & $mouseUpPos[1] & @LF)
   ; ConsoleWrite("That click took " & $dif & "ms" & @LF)
   If ($mouseUpPos[0] == $mouseDownPos[0] And $mouseUpPos[1] == $mouseDownPos[1]) Then
	  ; If the two mouse positions are the same, then it was an in place click
	  ; ConsoleWrite("ITS AN IN PLACE CLICK!!" & @LF)
	  ; MouseClick("button", x, y, #clicks, speed)	  
	  ConsoleWrite("MouseClick(""left"", " & $mouseUpPos[0] & ", " & $mouseUpPos[1] & ", 1, $speed)" & @LF)	  
	  ; double quotes escapes them so "" outputs "
   Else	  
	  ; ConsoleWrite("ITS NOT AN IN PLACE CLICK!!!" & @LF)
	  ; LEFT OFF HERE!!!!!!!!!*************************
	  ; also, start thinking of how you want to follow the mouse position (think of this later)	  
	  ConsoleWrite('MouseClickDrag("left", ' & $mouseDownPos[0] & ', ' & $mouseDownPos[1] & ', ' & $mouseUpPos[0] & ', ' & $mouseUpPos[1] & ', $speed)' & @LF)
   EndIf
   $startTime = TimerInit()
EndFunc

Func MouseSecondaryUp_Event()
   Local $coord = MouseGetPos() ; use this to get mouse position
   ConsoleWrite("Secondary Mouse Up @ " & $coord[0] & ":" & $coord[1] & @LF)
EndFunc

; **************************************************************** END