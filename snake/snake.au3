; Zion's AutoIt Snake Script
AutoItSetOption("MustDeclareVars", 1)

; use this find mouse location
; $pos = MouseGetPos()
; MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])

; use this find pixel color
; $color = PixelGetColor($pos[0], $pos[1])
; MsgBox(0,"The decimal color is", $color)
; MsgBox(0,"The hex color is", Hex($color, 6))

Local Const $searchx = 1674
Local Const $searchy = 114

; for dual screen: top-left = (1555, 455)
Local Const $left_lim  = 1555
Local Const $top_lim   = 455
; for dual screen: bot-right = (2065, 710)
Local Const $bot_lim   = 710
Local Const $right_lim = 2065
; color vars
Local Const $red   = 0xFF0000
Local Const $blue  = 0x555588
; small little deviation var
Local Const $dy = 2
; this is the slight offset used to keep
; the snake within the box boundaries
Local Const $delta = 5

; move mouse around box
MouseMove($left_lim, $top_lim) ; top left
MouseMove($right_lim, $top_lim) ; top right
MouseMove($right_lim, $bot_lim) ; bot right
MouseMove($left_lim, $bot_lim) ; bot left
MouseMove($left_lim, $top_lim) ; top left

; move mouse for each snake-colored-box
MouseMove($left_lim+$dy, $top_lim+$dy)
Sleep(1000);
MouseMove($left_lim+$dy, $top_lim+$dy+$delta)
MouseMove($left_lim+$dy, $top_lim+$dy+(2*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(3*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(4*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(5*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(6*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(7*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(8*$delta))
MouseMove($left_lim+$dy, $top_lim+$dy+(9*$delta))

; (510, 576) is approx center of snake box(single screen)
; move mouse here:
Local Const $centerX = ($left_lim+$right_lim)/2
Local Const $centerY = ($top_lim+$bot_lim)/2
MouseMove($centerX, $centerY)
; click here:
MouseClick("left")
; move mouse out of the way
MouseMove(0, 0, 0)
; press space bar to start
Send("{SPACE}");
; delay a bit to let the box reset
Sleep(100)

; here we define direction/state vars
Local Const $up        = 0
Local Const $down      = 1
Local Const $right     = 2
Local Const $left      = 3
Local Const $rightdown = 4
; this is the direction the snake is going
; assume snake always starts off going in one direction
; you choose that direction here:
Local $dir = $up
; this is the snake's head's position
Local $pos
; this is the cpu sleep time
Local Const $sleep = 10
; checksum used to see if there was a change in a region
Local $checksum

#cs
snake movement:
#ce 
While(true)
	; first get the snake's head location
	If($dir == $rightdown) Then
		WaitTillBlueFound($right_lim-$delta, $top_lim, $right_lim, $top_lim+$delta, $blue)
		; got here! so that means blue was found!
		Send("{DOWN}")
		MouseMove($pos[0], $pos[1], 0)
		$dir = $down
	ElseIf($dir == $up) Then
		; Get initial checksum
		; PixelChecksum(left, top, right, bottom)
		$checksum = PixelChecksum($left_lim, $top_lim, $right_lim, $top_lim+$delta)
		; Wait for the region to change
		While $checksum == PixelChecksum($left_lim, $top_lim, $right_lim, $top_lim+$delta)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go right..
		Send("{RIGHT}")		
		$dir = $right
	ElseIf($dir == $right) Then		
		; Get initial checksum		
		$checksum = PixelChecksum($right_lim-(2*$delta), $top_lim, $right_lim, $bot_lim)
		; then wait for blue to enter 2nd-to-the-right-most limit
		While $checksum == PixelChecksum($right_lim-(2*$delta), $top_lim, $right_lim, $bot_lim)
			; the region is checked every 100ms to reduce CPU load				
			Sleep($sleep)
			$pos = PixelSearch($left_lim, $top_lim, $right_lim, $top_lim+$delta, $blue)
			If Not @error Then ; if color was found at the top limit then
				MouseMove($pos[0], $pos[1], 0)
				$dir = $rightdown
				ExitLoop
			EndIf	
		WEnd
		If Not($dir == $rightdown) Then
			; something changed!
			Send("{UP}")
			Send("{LEFT}")
			$dir = $left
		EndIf				
	ElseIf($dir == $down) Then
		; Get initial checksum		
		$checksum = PixelChecksum($left_lim, $bot_lim-$delta, $right_lim, $bot_lim)
		; Wait for the region to change
		While $checksum == PixelChecksum($left_lim, $bot_lim-$delta, $right_lim, $bot_lim)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go left..
		Send("{LEFT}")
		MouseMove($right_lim, $bot_lim, 0)
		$dir = $left
	ElseIf($dir == $left) Then
		; Get initial checksum		
		$checksum = PixelChecksum($left_lim, $top_lim, $left_lim+$delta, $bot_lim)
		; Wait for the region to change
		While $checksum == PixelChecksum($left_lim, $top_lim, $left_lim+$delta, $bot_lim)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go up..
		Send("{UP}")
		Send("{RIGHT}")
		$dir = $right
	EndIf; end if dir == up/down/left/right
WEnd

; This function searches for blue within the bounds
; given with params $x0-$x3. It will wait till blue
; is found and move the mouse to that position.
Func WaitTillBlueFound($x0, $x1, $x2, $x3)
	Local $pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	While(@error) ; while blue is NOT found, search again
		Sleep($sleep)
		$pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	WEnd
	MouseMove($pos[0], $pos[1], 0)
EndFunc

#comments-start
While(true)
Sleep($sleep)
	; first get the snake's head location
	If($dir == $up) Then
		$pos = PixelSearch($left, $top, $right, $bot, $blue)	
		If Not @error Then ; if color was found then
			MouseMove($pos[0], $pos[1], 1); move mouse
			If($pos[0] > ($top - $delta)) Then
				Send("{RIGHT}");
				$dir = $right
			EndIf; end if pos > (top-delta)
		EndIf; end if Not @error
	ElseIf($dir == $right) Then		
		$pos = PixelSearch($left, $top, $right, $bot, $blue)	
		If Not @error Then ; if color was found then
			MouseMove($pos[0], $pos[1], 1); move mouse
			If($pos[0] > ($top - $delta)) Then
				Send("{RIGHT}");
				$dir = $right
			EndIf; end if pos > (top-delta)
		EndIf; end if Not @error
	ElseIf($dir == $up) Then
		$pos = PixelSearch($left, $top, $right, $bot, $blue)
		If Not @error Then ; if color was found then
			MouseMove($pos[0], $pos[1], 1); move mouse
			If($pos[0] > ($top - $delta)) Then
				Send("{RIGHT}");
				$dir = $right
			EndIf; end if pos > (top-delta)
		EndIf; end if Not @error
	ElseIf($dir == $up) Then
		$pos = PixelSearch($left, $top, $right, $bot, $blue)	
		If Not @error Then ; if color was found then
			MouseMove($pos[0], $pos[1], 1); move mouse
			If($pos[0] > ($top - $delta)) Then
				Send("{RIGHT}");
				$dir = $right
			EndIf; end if pos > (top-delta)
		EndIf; end if Not @error	
	EndIf; end if dir == up/down/left/right
WEnd
#comments-end

Exit