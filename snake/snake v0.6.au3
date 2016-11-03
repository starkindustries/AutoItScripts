; Zion's AutoIt Snake Script
#include <Debug.au3>
#include <Array.au3>

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)
; press f2 to exit
HotKeySet("{f2}","exitProgram")

#comments-start
; USE THIS TO FIND MOUSE LOCATION
Local $pos = MouseGetPos()
MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])
Exit
#comments-end

#comments-start
; USE THIS TO FIND PIXEL COLOR
Local $pos = MouseGetPos()
Local $color = PixelGetColor($pos[0], $pos[1])
MsgBox(0,"The decimal color is", $color)
MsgBox(0,"The hex color is", Hex($color, 6))
MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])
Exit
#comments-end

#comments-start
; USE THIS TO DO A PIXEL SEARCH FROM BOTTOM-TO-TOP, RIGHT-TO-LEFT
Local $pos = PixelSearch($rightLimit, $botLimit, $leftLimit, $topLimit, $blue)
MouseMove($pos[0], $pos[1])
Exit
#comments-end

#comments-start
IMPORTANT INFORMATION:
- each snake cube is 7 pixels long on one side
- each gray divider is 1 pixel long
- from topLimit (454) to botLimit (710) is 256+1 pixels (includes black border)
- from leftLimit (1555) to rightLimit (2066) is 511+1 pixels (includes (black border)
- from left to right, there are 64 grid boxes (boxes 0-63)
- from top to bottom, there are about 32 grid boxes (boxes 0-31)
#comments-end
; number of grid boxes on the x and y axes
Local Const $totalNumBoxesX = 64
Local Const $totalNumBoxesY = 32
; for dual screen: top-left = (1555, 454)
Local Const $leftLimit  = 1555
Local Const $topLimit   = 454
; for dual screen: bot-right = (2066, 710)
Local Const $botLimit   = 710
Local Const $rightLimit = 2066
; color vars
Local Const $red   = 0xFF0000
Local Const $blue  = 0x555588
Local Const $gray  = 0xEEEEEE
Local Const $black = 0x000000
Local Const $white = 0xFFFFFF
; small little deviation var
Local Const $dy = 3

; call the initialize function
Local Const $grid = initializeGrid()
; _ArrayDisplay($grid, "$grid coordinates", -1, 1)
; _ArrayDisplay($grid[0][0], "$grid coordinates", -1, 1)
; Exit

; move mouse around box
MouseMove($leftLimit, $topLimit) ; top left
MouseMove($rightLimit, $topLimit) ; top right
MouseMove($rightLimit, $botLimit) ; bot right
MouseMove($leftLimit, $botLimit) ; bot left
MouseMove($leftLimit, $topLimit) ; top left

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
Sleep(500)

; here we define direction/state vars
Local Const $up        = 0
Local Const $down      = 1
Local Const $right     = 2
Local Const $left      = 3
Local Const $rightdown = 4
Local Const $leftup	   = 5
; this is the grid position of the red box
Local $gbox[2]
; this is the number of redboxes eatin
Local $kills = 0

#cs SNAKE MOVEMENT:
Snake will now move and be tracked according to grid square.
#comments-end
; this is the snake's head's position at the very beginning
; it only contains grid coordinates (0<=x<64, 0<=y<32)
Local $gpos[2]
$gpos = searchGridForSnake() 
If @error Then
	MsgBox(0, "ERROR", "Snake could not be found")
	Exit
EndIf
; ToolTip("gridpos: (" & $gridpos[0] & "," & $gridpos[1] & ")")

; this is the direction the snake is going.
; assume snake always starts off going in one direction.
; you choose that starting direction here:
Local $dir = $up
; this is the snake's desired destination
Local $dest[2]

; now start the while loop
While(True)
	If($dir == $up) Then
		$dest[0] = $gpos[0]
		$dest[1] = 0 ; topLimit
		$gpos = waitForSnake($gpos, $dest, $dir)		
		Send("{RIGHT}")
		ToolTip("RIGHT")
		$dir = $right
	ElseIf($dir == $right) Then
		$dest[0] = $totalNumBoxesX-1 ; rightLimit
		$dest[1] = $gpos[1]
		$gpos = waitForSnake($gpos, $dest, $dir)
		Send("{DOWN}")
		ToolTip("DOWN")
		$dir = $down
	ElseIf($dir == $down) Then
		; edit the down reaction to account for kills
		; if less than 20 kills, then do the normal thing:
		If($kills < 20) Then 
			$dest[0] = $gpos[0]
			$dest[1] = $totalNumBoxesY-1 ; botLimit
			$gpos = waitForSnake($gpos, $dest, $dir)
			Send("{LEFT}")
			ToolTip("LEFT")
			$dir = $left
		Else ; else if kills is greater than 20 do this:
			For $i=0 To Round($kills/10) Step 1
				; if kills > 20 then do one up-down loop
				; wait for snake to hit bottom
				$dest[0] = $gpos[0] ; same x
				$dest[1] = $totalNumBoxesY-1 ; botLimit			
				$gpos = waitForSnake($gpos, $dest, $down)
				Send("{LEFT}")
				Send("{UP}")			
				$gpos[0] = $gpos[0]-1 ; because of the left-up
				; wait for snake to hit topLimit + 1
				$dest[0] = $gpos[0]
				$dest[1] = 1 ; topLimit(0) + 1			
				$gpos = waitForSnake($gpos, $dest, $up)				
				Send("{LEFT}")
				Send("{DOWN}")				
				$gpos[0] = $gpos[0]-1 ; because of the left-down
			Next ; end of for loop $i to kills/10
			; wait for snake to hit bottom
			$dest[0] = $gpos[0]
			$dest[1] = $totalNumBoxesY-1 ; botLimit			
			$gpos = waitForSnake($gpos, $dest, $down)
			Send("{LEFT}")
			ToolTip("LEFT")
			$dir = $left
		EndIf ; end if kills < 20
	ElseIf($dir == $left) Then		
		$gbox = searchGridForRed()
		If Not @error And ($gbox[0] < $gpos[0]) And Not($gbox[0] == 1)  Then					
			$dest[0] = $gbox[0]
			$dest[1] = $gpos[1]
			; wait for snake to be aligned with box
			$gpos = waitForSnake($gpos, $dest, $dir)
			Send("{UP}")			
			; now wait for snake to eat the redbox
			$gpos = waitForSnake($gpos, $gbox, $up)
			Send("{LEFT}")				
			Send("{DOWN}")			
			$gpos[0] = $gpos[0]-1; minus 1 because of the left-down
			; now wait for snake to return back down
			$dest[0] = $gpos[0]
			$dest[1] = $totalNumBoxesY-1 ; botLimit
			$gpos = waitForSnake($gpos, $dest, $down)
			Send("{LEFT}")			
			$dir = $left
			$kills = $kills+1
			ToolTip($kills & " kills")
		ElseIf Not @error And ($gbox[0] < $gpos[0]) And ($gbox[0] == 1) Then
			$dest[0] = $gbox[0]
			$dest[1] = $gpos[1]
			; wait for snake to be aligned with box
			$gpos = waitForSnake($gpos, $dest, $dir)
			Send("{UP}")			
			$dir = $up
			$kills = $kills+1
			ToolTip($kills & " kills")
		Else
			$dest[0] = 0 ; leftLimit
			$dest[1] = $gpos[1]
			$gpos = waitForSnake($gpos, $dest, $dir)
			Send("{UP}")
			ToolTip("UP")
			$dir = $up			
		EndIf ; end if not @error
	EndIf ; end if $dir == $up/$right/$down/$left
WEnd

#comments-start
This will wait till snake travels from its src to dest
#comments-end
Func waitForSnake($src, $dest, $dir)	
	Local $diffx = $dest[0]-$src[0]
	Local $diffy = $dest[1]-$src[1]
	Local $diff, $step, $init, $pxpos, $gpos, $pos	
	; verify that the src and destination are 
	; either vertical or horizontal paths:	
	_Assert($diffx == 0 Or $diffy == 0)
	; check if source and dest are the same
	If($diffx == 0 And $diffy == 0) Then
		Return $dest
	ElseIf($dir == $up) Then		
		_Assert(($diffx == 0) And ($diffy < 0))
		$diff = $diffy
		$init = -1
		$step = -1
	ElseIf($dir == $down) Then
		_Assert(($diffx == 0) And ($diffy > 0))
		$diff = $diffy
		$init = 1
		$step = 1
	ElseIf($dir == $left) Then
		_Assert(($diffx < 0) And ($diffy == 0))
		$diff = $diffx
		$init = -1
		$step = -1
	ElseIf($dir == $right) Then
		_Assert(($diffx > 0) And ($diffy == 0))
		$diff = $diffx
		$init = 1
		$step = 1
	EndIf
	; now wait for the snake to hit the dest
	If($dir == $left Or $dir == $right) Then
		For $i = $init to $diff Step $step
			$pxpos = $grid[$src[0]+$i][$src[1]]
			$pos = waitTillBlueFound($pxpos[0]-3, $pxpos[1]-3, $pxpos[0]+3, $pxpos[1]+3)
		Next
	ElseIf($dir == $up Or $dir == $down) Then
		For $i = $init to $diff Step $step
			$pxpos = $grid[$src[0]][$src[1]+$i]
			$pos = waitTillBlueFound($pxpos[0]-3, $pxpos[1]-3, $pxpos[0]+3, $pxpos[1]+3)
		Next
	EndIf
	Return convertPixelToGrid($pos)
EndFunc

#comments-start
This will search a specific square to see if the snake is there
#comments-end
Func searchSquareForSnake($x, $y)
	; first convert grid to pixel coords
	Local $pixelPos = $grid[$x][$y]
	MouseMove($pixelPos[0], $pixelPos[1], 0) ; for Debug purposes
	If(PixelGetColor($pixelPos[0], $pixelPos[1]) == $blue) Then		
		Return True
	Else
		Return False
	EndIf
EndFunc

#comments-start
This will search the entire grid for the snake's position
#comments-end
Func searchGridForSnake()
	Local $pxpos = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $blue)
	If @error Then
		SetError(1)
		Return
	EndIf	
	; for Debug purposes:
	MouseMove($pxpos[0], $pxpos[1], 0)
	; now convert pixel to grid coords:
	Return convertPixelToGrid($pxpos)
EndFunc

#comments-start
This will search the entire grid for the redbox
#comments-end
Func searchGridForRed()
	Local $pxpos = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $red)
	If @error Then
		SetError(1)
		Return
	EndIf
	; for Debug purposes:
	MouseMove($pxpos[0], $pxpos[1], 0)
	; now convert pixel to grid coords:
	Local $gpos = convertPixelToGrid($pxpos)
	If($gpos[0] = 0 Or $gpos[0] = $totalNumBoxesX-1 Or $gpos[1] = 0 Or $gpos[1] = $totalNumBoxesY-1) Then
		SetError(1)
		Return
	Else
		Return $gpos
	EndIf
EndFunc

#comments-start
This function converts pixel to grid coordinates
#comments-end
Func convertPixelToGrid($pxpos)
	; add $dy to make it closer to the grid square's center
	$pxpos[0] = $pxpos[0] + $dy
	$pxpos[1] = $pxpos[1] + $dy
	; create local var to store the grid coords
	Local $gridpos[2]
	; convert the X coord
	; $pxposX = $leftLimit+($xBoxIndex)*($rightLimit-$leftLimit+1)/($totalNumBoxesX)+$dy	
	; $pxposX-$leftLimit-$dy = ($xBoxIndex)*($rightLimit-$leftLimit+1)/($totalNumBoxesX)	
	; ($pxposX-$leftLimit-$dy)*($totalNumBoxesX) = ($xBoxIndex)*($rightLimit-$leftLimit+1)
	; ($pxposX-$leftLimit-$dy)*($totalNumBoxesX)/($rightLimit-$leftLimit+1) = ($xBoxIndex)
	; ($xBoxIndex) = ($pxposX-$leftLimit-$dy)*($totalNumBoxesX)/($rightLimit-$leftLimit+1)		
	$gridpos[0] = Round(($pxpos[0]-$leftLimit-$dy)*($totalNumBoxesX)/($rightLimit-$leftLimit+1))
	; convert the Y coord
	; $pxposY = $topLimit+($yBoxIndex)*($botLimit-$topLimit)/($totalNumBoxesY)+$dy
	; $pxposY-$topLimit-$dy = ($yBoxIndex)*($botLimit-$topLimit)/($totalNumBoxesY)
	; ($pxposY-$topLimit-$dy)*($totalNumBoxesY) = ($yBoxIndex)*($botLimit-$topLimit)
	; ($pxposY-$topLimit-$dy)*($totalNumBoxesY)/($botLimit-$topLimit) = ($yBoxIndex)
	; $yBoxIndex = ($pxposY-$topLimit-$dy)*($totalNumBoxesY)/($botLimit-$topLimit)
	$gridpos[1] = Round(($pxpos[1]-$topLimit-$dy)*($totalNumBoxesY)/($botLimit-$topLimit))	
	Return $gridpos	
EndFunc	

#comments-start
The program would be faster if it did not have to calculate
pixel coordinates every single time. So this function will
calculate all coordinates at the start and return a 2D
array containing all grid coordinates.
- $info[0] = $totalNumBoxesX
- $info[1] = $totalNumBoxesY
#comments-end
Func initializeGrid()	
	Local $grid[$totalNumBoxesX][$totalNumBoxesY]
	; create iterator vars
	Local $i, $j	
	; iterate through all x-boxes
	For $i = 0 to ($totalNumBoxesX-1) Step 1
		For $j = 0 to ($totalNumBoxesY-1) Step 1
			$grid[$i][$j] = getPixelCoords($i, $j)
		Next ; end for j to totalNumBoxesY
	Next ; end for i to totalNumBoxesX
	return $grid
EndFunc

#comments-start
- formaula for the x-pos of a box's center:
	- $leftLimit+($xBoxIndex)*($rightLimit-$leftLimit+1)/$totalNumBoxesX+$dy
	- $totalNumBoxesY = 64, $dy = 4, $boxIndex is the box you want
- formula for the y-pos of a box's center: 
	- $topLimit+($yBoxIndex)*($botLimit-$topLimit)/$totalNumBoxesY+$dy
	- $totalNumBoxesY = 32, $dy = 4, $boxIndex is the box you want
* use this to convert x,y box coordinates to pixel coordinates.
* returns an array of x,y pixel coordinates.
#comments-end
Func getPixelCoords($xBoxIndex, $yBoxIndex)
	; make some assertions
	_Assert($xBoxIndex >= 0 & $xBoxIndex < $totalNumBoxesX)
	_Assert($yBoxIndex >= 0 & $yBoxIndex < $totalNumBoxesY)	
	; create the return array xy:
	Local $xy[2]
	; calculate the x coordinate
	$xy[0] = $leftLimit+($xBoxIndex)*($rightLimit-$leftLimit+1)/($totalNumBoxesX)+$dy
	; calculate the y coordinate
	$xy[1] = $topLimit+($yBoxIndex)*($botLimit-$topLimit)/($totalNumBoxesY)+$dy
	Return $xy
EndFunc

; This function searches for blue within the bounds
; given with params $x0-$x3. It will wait till blue
; is found and move the mouse to that position.
Func waitTillBlueFound($x0, $x1, $x2, $x3)
	; Local Const $sleep = 10
	Local $pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	While(@error) ; while blue is NOT found, search again
		; Sleep($sleep)
		$pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	WEnd
	MouseMove($pos[0], $pos[1], 0)
	return $pos
EndFunc

; this is the exit function
Func exitProgram()
	Exit
EndFunc
