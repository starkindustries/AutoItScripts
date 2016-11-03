; Zion's AutoIt Snake Script
AutoItSetOption("MustDeclareVars", 1)
; press f2 to exit
HotKeySet("{f2}","exitProgram")


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
Local Const $leftLimit  = 1555
Local Const $topLimit   = 455
; for dual screen: bot-right = (2065, 710)
Local Const $botLimit   = 710
Local Const $rightLimit = 2065
; color vars
Local Const $red   = 0xFF0000
Local Const $blue  = 0x555588
; small little deviation var
Local Const $dy = 2
; this is the slight offset used to keep
; the snake within the box boundaries
Local Const $delta = 5
; dbox is delta-box, the dist. between 
; the centers of two snake cubes
Local Const $dbox = 8

; move mouse around box
MouseMove($leftLimit, $topLimit) ; top left
MouseMove($rightLimit, $topLimit) ; top right
MouseMove($rightLimit, $botLimit) ; bot right
MouseMove($leftLimit, $botLimit) ; bot left
MouseMove($leftLimit, $topLimit) ; top left

#comments-start
; set dy = 3, delta = 8
; A dy of 3 will give the perfect dy,dx deviation from a cube's top-left
; position to get to the cube's center.
; A delta of 8 is the distance between one snake-cube center to the next.
Local $col = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $blue)
MouseMove($col[0]+$dy, $col[1]+$dy)
MouseMove($col[0]+$dy+$delta, $col[1]+$dy)
MouseMove($col[0]+$dy+2*$delta, $col[1]+$dy)
MouseMove($col[0]+$dy+3*$delta, $col[1]+$dy)
MouseMove($col[0]+$dy+4*$delta, $col[1]+$dy)
Exit
#comments-end

; (510, 576) is approx center of snake box(single screen)
; move mouse here:
Local Const $centerX = ($leftLimit+$rightLimit)/2
Local Const $centerY = ($topLimit+$botLimit)/2
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
Local Const $leftup	   = 5
; this is the direction the snake is going
; assume snake always starts off going in one direction
; you choose that direction here:
Local $dir = $up
; this is the snake's head's position
Local $pos = waitTillBlueFound($leftLimit, $topLimit, $rightLimit, $botLimit)
; this is the cpu sleep time
Local Const $sleep = 10
; checksum used to see if there was a change in a region
Local $checksum
; this is the position of the red box
Local $redbox
; value of boxes to eat
Local $value = 20

#cs
snake movement:
Snake will keep along the box's edges and when it's at
the bottom edge, the snake will seek and attack a red
food block if one is available.
#ce 
Local $counter = 0
While($counter < $value)
	If($dir == $leftup) Then ; snake wants to get to left-edge then go up
		$pos = waitTillBlueFound($leftLimit, $botLimit-$delta, $leftLimit+$delta, $botLimit)		
		Send("{UP}")
		$dir = $up
	ElseIf($dir == $up) Then
		waitTillBlueFound($pos[0], $topLimit, $pos[0]+$delta, $topLimit+$delta)
		; got here! so that means blue was found!
		Send("{RIGHT}")		
		$dir = $right
	ElseIf($dir == $right) Then
		waitTillBlueFound($rightLimit-$delta, $topLimit, $rightLimit, $topLimit+$delta)
		Send("{DOWN}")		
		$dir = $down
	ElseIf($dir == $down) Then
		; wait till blue has crossed the center-right
		waitTillBlueFound($rightLimit-$delta, $centerY-$delta, $rightLimit, $centerY+$delta)
		; wait till blue has reached the bottom-right
		waitTillBlueFound($rightLimit-$delta, $botLimit-$delta, $rightLimit, $botLimit)		
		; got here! so that means blue was found!
		Send("{LEFT}")		
		$dir = $left
	ElseIf($dir == $left) Then		
		$redbox = PixelSearch($leftLimit+(2*$delta), $topLimit, $rightLimit-(2*$delta), $botLimit, $red)
		If Not @error Then ; if not at error then the redbox was found!
			MouseMove($redbox[0], $redbox[1], 0)
			 ; if redbox's x-pos is past 3/4ths of the box from the right then just go up
			If($redbox[0] < ($leftLimit+$centerX)/2) Then
				; first find the snake's head position
				; since it's at the bottom, search for it along the bottom limit
				; along the redbox's x-pos
				waitTillBlueFound($redbox[0], $botLimit-$delta, $redbox[0]+$delta, $botLimit)
				Send("{UP}")
				; wait till redbox is eaten
				$pos = waitTillBlueFound($redbox[0], $redbox[1], $redbox[0]+$dbox, $redbox[1]+$dbox)
				$counter = $counter + 1 ; a redbox has been eaten, increment
				$dir = $up
			Else ; if redbox's x-pos is on the right 3/4ths of the box then
				; first check if the head of the snake is past the box's x-pos
				$pos = waitTillBlueFound($leftLimit, $botLimit-$delta, $rightLimit, $botLimit)
				If($pos[0] > $redbox[0]) Then ; if snake has NOT past the redbox then do this:
					; Do these steps: Step1: go up, Step2: get the redbox, step3: go back down, step4: cont. left
					; Step1: wait till aligned with redbox then go up
					$pos = waitTillBlueFound($redbox[0], $botLimit-$delta, $redbox[0]+$delta, $botLimit)
					Send("{UP}")
					; Step2: get the redbox
					$pos = waitTillBlueFound($redbox[0], $redbox[1]-$dbox, $redbox[0]+$dbox, $redbox[1])
					$counter = $counter + 1 ; a redbox has been eaten, increment
					; Step3: go back down
					Send("{LEFT}")
					Send("{DOWN}")
					; Step4: continue going left
					$pos = waitTillBlueFound($redbox[0]-$dbox, $botLimit-$delta, $redbox[0]-$delta, $botLimit)
					Send("{LEFT}")
					$dir = $left
				Else
					$dir = $leftup
				EndIf ; end if pos[0] < redbox[0]
			EndIf
		Else; else if redbox was NOT found
			$pos = waitTillBlueFound($leftLimit, $botLimit-$delta, $leftLimit+$delta, $botLimit)
			; got here! so that means blue was found!
			Send("{UP}")
			$dir = $up			
		EndIf ; end if not @error				
	EndIf; end if dir == up/down/left/right		
WEnd

#cs
snake movement: special pattern that allows for a really long snake
#ce 
While(true)
	; first get the snake's head location
	If($dir == $rightdown) Then
		waitTillBlueFound($rightLimit-$delta, $topLimit, $rightLimit, $topLimit+$delta)
		; got here! so that means blue was found!
		Send("{DOWN}")		
		$dir = $down
	ElseIf($dir == $up) Then
		waitTillBlueFound($pos[0], $topLimit, $pos[0]+$delta, $topLimit+$delta)
		; got here! so that means blue was found!
		Send("{RIGHT}")		
		$dir = $rightdown
	ElseIf($dir == $right) Then
		; search perimeter for the snake
		$pos = waitTillBlueFound($leftLimit, $topLimit, $rightLimit, $botLimit)
		; got here! so that means blue was found!
		; now obtain the y-position, if y <= (topLimit+delta), it is on top
		If($pos[1] <= ($topLimit + $delta)) Then ; if true, then snake is on top
			$dir = $rightdown
		Else ; else snake is not on top, so send the up-left
			; look for the snake in the right-most region, with its found y-position			
			waitTillBlueFound($rightLimit-(2*$delta), $pos[1]-$dy, $rightLimit, $pos[1]+$dy)
			Send("{UP}")
			Send("{LEFT}")
			$dir = $left
		EndIf		
	ElseIf($dir == $down) Then		
		waitTillBlueFound($rightLimit-$delta, $botLimit-$delta, $rightLimit, $botLimit)
		; got here! so that means blue was found!
		Send("{LEFT}")		
		$dir = $left
	ElseIf($dir == $left) Then		
		waitTillBlueFound($leftLimit, $topLimit, $leftLimit+$delta, $botLimit)
		; got here! so that means blue was found!
		Send("{UP}")
		Send("{RIGHT}")
		$dir = $right
	EndIf; end if dir == up/down/left/right
WEnd

; This function searches for blue within the bounds
; given with params $x0-$x3. It will wait till blue
; is found and move the mouse to that position.
Func waitTillBlueFound($x0, $x1, $x2, $x3)
	Local $pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	While(@error) ; while blue is NOT found, search again
		Sleep($sleep)
		$pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	WEnd
	MouseMove($pos[0], $pos[1], 0)
	return $pos
EndFunc

; this is the exit function
Func exitProgram()	
	Exit
EndFunc
