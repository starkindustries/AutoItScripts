; Zion's AutoIt Tower Stack Script
#include-once
#include <Debug.au3>
#include "../toolbox.au3"

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)
; press f2 to exit
HotKeySet("{f2}","exitProgram")
HotKeySet("{ESC}","exitProgram")

; getMousePos() ; use this to get mouse position
; getColor() ; use this to get color
; Exit 

; color vars
Local Const $green = 0x73B911
Local Const $white = 0xFFFFFF
Local Const $teal  = 0x00AAAA
Local Const $cable = 0x20110F
; start button coordinates:
Local $playButtonx, $playButtony
; tower stack box limits: (top, right, bottom, left):(244, 831, 645, 230)
Local $topLimit = 244
Local $botLimit = 645
Local $leftLimit = 230
Local $rightLimit = 831
; Local $leftLimit, $topLimit, $rightLimit, $botLimit
Local Const $dy = 5
Local $pos

; calibrate the screen
; calibrateScreen()
; trace the screen to confirm calibration
traceBox()
; set the cable coordinates
Local Const $blackx = ($leftLimit + $rightLimit)/2
Local Const $blacky = $topLimit + 20
; move mouse to cable coords to confirm location
MouseMove($blackx, $blacky)
; start the game:
clickPlay()
; get the first green box onto the platform:
waitForCable()	
MouseMove($playButtonx, $playButtony, 0)
click()
; now run the game logic:
While(true)
	Local $topBlock = findTopBlock()
	$pos = waitForCable()
	MouseMove($playButtonx, $playButtony, 0)
	click()	
	ToolTip("i clicked! now sleeping...")
	Sleep(1000)
WEnd

Func findTopBlock()
	Local $center = ($leftLimit + $rightLimit)/2
	Local $blockfound = False
	Local $blockpos, $y
	While Not $blockfound	
		$blockpos = PixelSearch(0, $y, 1280, $y, $green, 10)
		If Not @error Then
			MouseMove($blockpos[0], $blockpos[1])						
			$blockfound = True			
		Else
			MouseMove(400, $y)
			$y = $y - 10
			If($y <= 0) Then
				MsgBox(0, "ERROR", "Could not find block!")				
			EndIf
		EndIf
	WEnd
EndFunc

; this is used to click the mouse but for a
; longer period of time (100ms)
Func click()
	MouseDown("left")
	Sleep(100)
	MouseUp("left")
EndFunc

; this just clicks the play button
Func clickPlay()	
	MouseMove($playButtonx, $playButtony)
	click()
EndFunc

Func waitForCable()	
	Local $pos = PixelSearch($blackx-$dy, $blacky-$dy, $blackx+$dy, $blacky+$dy, $cable)
	While(@error) ; while color is NOT found, search again		
		ToolTip("waiting for black..")
		$pos = PixelSearch($blackx-$dy, $blacky-$dy, $blackx+$dy, $blacky+$dy, $cable)
	WEnd
	return $pos
EndFunc

Func traceBox()
	; move mouse around box
	MouseMove($leftLimit, $topLimit) ; top left
	MouseMove($rightLimit, $topLimit) ; top right
	MouseMove($rightLimit, $botLimit) ; bot right
	MouseMove($leftLimit, $botLimit) ; bot left
	MouseMove($leftLimit, $topLimit) ; top left
EndFunc

Func calibrateScreen()
	Local $tealfound = False
	Local $tealpos, $pos
	Local $y = 600
	; first find teal
	While Not $tealfound		
		$tealpos = PixelSearch(0, $y, 1280, $y, $green, 10)
		If Not @error Then
			MouseMove($tealpos[0], $tealpos[1])
			; set the play button coordinates
			$playButtonx = $tealpos[0] + 20
			$playButtony = $tealpos[1] - 20
			; ToolTip("FOUND TEAL HERE!")
			; Sleep(2000)
			$tealfound = True
			; move tealpos-x to the left of where it was found
			$tealpos[0] = $tealpos[0] - 20			
		Else
			MouseMove(400, $y)
			$y = $y - 10
			If($y <= 0) Then
				MsgBox(0, "ERROR", "Could not find teal!")
				Exit
			EndIf
		EndIf
	WEnd
	; find the left white border
	$pos = PixelSearch($tealpos[0], $tealpos[1], 0, $tealpos[1], $white)
	If Not @error Then
		; reset tealpos-x to be towards the left edge
		$tealpos[0] = $pos[0] + 10
		; MouseMove($pos[0], $pos[1])
		$leftLimit = $pos[0]
		ToolTip("left limit: " & $leftLimit)
	Else
		MsgBox(0, "ERROR", "Could not find left limit!")
		Exit
	EndIf
	; now find the top white border
	$pos = PixelSearch($tealpos[0], $tealpos[1], $tealpos[0], 0, $white)
	If Not @error Then
		; reset tealpos-y to be towards the top edge
		$tealpos[1] = $pos[1] + 10
		; MouseMove($pos[0], $pos[1])
		$topLimit = $pos[1]
		ToolTip("top limit: " & $topLimit)
	Else
		MsgBox(0, "ERROR", "Could not find top limit!")
		Exit
	EndIf
	; find the bottom white border
	$pos = PixelSearch($tealpos[0], $tealpos[1], $tealpos[0], 800, $white)
	If Not @error Then
		; MouseMove($pos[0], $pos[1])
		$botLimit = $pos[1]
		ToolTip("bottom limit: " & $botLimit)
	Else
		MsgBox(0, "ERROR", "Could not find bottom limit!")
		Exit
	EndIf	
	; find the right white border
	$pos = PixelSearch($tealpos[0], $tealpos[1], 1280, $tealpos[1], $white)
	If Not @error Then
		; MouseMove($pos[0], $pos[1])
		$rightLimit = $pos[0]
		ToolTip("right limit: " & $rightLimit)
	Else
		MsgBox(0, "ERROR", "Could not find right limit!")
		Exit
	EndIf
	; if you got here then you're done calibrating
EndFunc

; this is the exit function
Func exitProgram()
	; MsgBox(0, "top, right, bot, left: ", $topLimit & " " & $rightLimit & " " & $botLimit & " " & $leftLimit)
	Exit
EndFunc