; Zion's AutoIt Snake Script

; use this find mouse location
; $pos = MouseGetPos()
; MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])

; use this find pixel color
; $color = PixelGetColor($pos[0], $pos[1])
; MsgBox(0,"The decimal color is", $color)
; MsgBox(0,"The hex color is", Hex($color, 6))

; for dual screen: top-left = (1555, 455)
; for dual screen: bot-rigt = (2065, 710) 
Local $left_lim  = 1555
Local $top_lim   = 455
Local $right_lim = 2065
Local $bot_lim   = 710

Local $red   = 0xFF0000
Local $blue  = 0x555588

; move mouse around box
MouseMove($left_lim, $top_lim) ; top left
MouseMove($right_lim, $top_lim) ; top right
MouseMove($right_lim, $bot_lim) ; bot right
MouseMove($left_lim, $bot_lim) ; bot left
MouseMove($left_lim, $top_lim) ; top left

; (510, 576) is approx center of snake box(single screen)
; move mouse here:
Local $centerX = ($left_lim+$right_lim)/2
Local $centerY = ($top_lim+$bot_lim)/2
MouseMove($centerX, $centerY)
; click here:
MouseClick("left")
; move mouse out of the way
MouseMove(0, 0, 0)
; press space bar to start
Send("{SPACE}");

; here we define direction vars
Local $up    = 0
Local $down  = 1
Local $right = 2
Local $left  = 3
; this is the direction the snake is going
; assume snake always starts off going up
Local $dir = $up
; Send("{RIGHT}")
; this is the snake's head's position
Local $pos
; this is the slight offset used to keep
; the snake within the box boundaries
Local $delta = 5
; this is the cpu sleep time
Local $sleep = 10

#cs
Here we will attempt to guide the snake along
the outermost limits of the snake's box
#ce 
While(true)
	; first get the snake's head location
	If($dir == $up) Then
		; Get initial checksum
		; PixelChecksum(left, top, right, bottom)
		$checksum = PixelChecksum($left_lim, $top_lim, $right_lim, $top_lim+$delta)
		; Wait for the region to change
		While $checksum = PixelChecksum($left_lim, $top_lim, $right_lim, $top_lim+$delta)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go right..
		Send("{RIGHT}")		
		$dir = $right
	ElseIf($dir == $right) Then		
		; Get initial checksum		
		$checksum = PixelChecksum($right_lim-$delta, $top_lim, $right_lim, $bot_lim)
		; Wait for the region to change
		While $checksum = PixelChecksum($right_lim-$delta, $top_lim, $right_lim, $bot_lim)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go down..
		Send("{DOWN}")
		$dir = $down
	ElseIf($dir == $down) Then
		; Get initial checksum		
		$checksum = PixelChecksum($left_lim, $bot_lim-$delta, $right_lim, $bot_lim)
		; Wait for the region to change
		While $checksum = PixelChecksum($left_lim, $bot_lim-$delta, $right_lim, $bot_lim)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go left..
		Send("{LEFT}")
		$dir = $left
	ElseIf($dir == $left) Then
		; Get initial checksum		
		$checksum = PixelChecksum($left_lim, $top_lim, $left_lim+$delta, $bot_lim)
		; Wait for the region to change
		While $checksum = PixelChecksum($left_lim, $top_lim, $left_lim+$delta, $bot_lim)
			; the region is checked every 100ms to reduce CPU load
			Sleep($sleep)
		WEnd
		; something changed! now go up..
		Send("{UP}")
		$dir = $up
	EndIf; end if dir == up/down/left/right
WEnd

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