; Zion's AutoIt Snake Script
#include-once
#include <Debug.au3>
#include "../toolbox.au3"

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)
; press f2 to exit
HotKeySet("{f2}","exitProgram")
HotKeySet("{ESC}","exitProgram")

; Local $coord = getMousePos() ; use this to get mouse position
; getColor() ; use this to get color
; getColorAt($coord)
; Exit 

#comments-start
IMPORTANT INFORMATION:
- each snake cube is 7 pixels long on one side
- each gray divider is 1 pixel long
- from topLimit (454) to botLimit (710) is 256+1 pixels (includes black border)
- from leftLimit (1555) to rightLimit (2066) is 511+1 pixels (includes (black border)
- from left to right, there are 64 grid boxes (boxes 0-63)
- from top to bottom, there are about 32 grid boxes (boxes 0-31)
- single screen: top-left(275,454); bot-right(786, 709)
#comments-end
; declare a bool var to account for dual or single screen
Local Const $singlescreen = False
; number of grid boxes on the x and y axes
Local Const $totalNumBoxesX = 64
Local Const $totalNumBoxesY = 32
; set the snake box limits
Local $leftLimit, $topLimit, $rightLimit, $botLimit
; color vars
Local Const $red   	   = 0xFF0000
Local Const $blue  	   = 0x555588
Local Const $gray      = 0xEEEEEE
Local Const $black     = 0x000000
Local Const $white     = 0xFFFFFF
; small little deviation var
Local Const $dy = 3
; var for the default top left position
Local Const $default[2] = [0,0]
; create a var for maxdelay
Local $maxdelay = 0
; create a var for number of snake loops
; this is the number of times the snake has
; to fold itself so that it wont hit itself
Local $loops = 0
; we need the index to where the snake will eventually fold itself		
; call this variable trl (temporary right limit)
Local $trl = $totalNumBoxesX - 1

; calibrate the screen
calibrateScreen()
; call the initialize function
Local Const $grid = initializeGrid()
; use this to display the grid:
; display2DArrayOfCoords($grid, $totalNumBoxesX-1, $totalNumBoxesY-1)

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
MouseMove($rightLimit+50, $centerY, 0)
; press space bar to start
Send("{SPACE}");
; delay a bit to let the box reset
Sleep(500)

; here we define direction/state vars
Local Const $up       = 0
Local Const $down     = 1
Local Const $right    = 2
Local Const $left     = 3
Local Const $rightup  = 4
Local Const $leftdown = 5
; this is the grid position of the red box
Local $redbox[2]
$redbox = getRedBox()

; this is the snake's head's position at the very beginning
; it only contains grid coordinates (0<=x<64, 0<=y<32)
Local $gpos[2]
$gpos = searchGridForSnake() 
If @error Then
	MsgBox(0, "ERROR", "Snake could not be found")
	Exit
EndIf
; this is the direction the snake is going.
; assume snake always starts off going in one direction.
; you choose that starting direction here:
Local $dir = $up
; this is the snake's desired destination
Local $dest[2]

slither() ; MOVE THE SNAKE

#cs SNAKE MOVEMENT:
Snake will now move and be tracked according to grid square.
#comments-end
Func slither()
	; now start the while loop
	While(True)	
		; search for the redbox
		$redbox = searchGridForRed()
		; execute a direction:
		If($dir == $up) Then			
			$dest[0] = $gpos[0]
			$dest[1] = 0 ; topLimit
			$gpos = waitForSnakeToGoUp($gpos, $dest)
			Send("{RIGHT}")
			ToolTip("RIGHT")
			$dir = $right
		ElseIf($dir == $right) Then				
			; check if redbox is at the 2nd right-most column or on edge
			; if it is then continue guiding along the wall's edge
			If($redbox[0] == 0) Or ($redbox[0] == $totalNumBoxesX-1) Or ($redbox[1] == 0) Or ($redbox[1] == $totalNumBoxesY-1) Or ($redbox[0] == $totalNumBoxesX-2) Then
				ToolTip("redbox on edge!")
				$dest[0] = $totalNumBoxesX - 1 ; rightLimit
				$dest[1] = $gpos[1]
				$gpos = waitForSnakeToGoRight($gpos, $dest)
				Send("{DOWN}")
				ToolTip("DOWN")
				$dir = $down
			; Here we must check several things:
			; 1) check if box is ahead of snake
			; 2) make sure box is behind where the snake could eventually fold itself (trl, see above)
			; 3) make sure snake body is not beside the box because if it is then it will collide with the snake head		
			ElseIf($redbox[0] > $gpos[0]) And ($redbox[0] < $trl) And Not(searchSquareForSnake($redbox[0]+1, $redbox[1])) Then
				ToolTip("target acquired!")
				$dest[0] = $redbox[0]
				$dest[1] = $gpos[1]
				; wait for snake to be aligned with box
				$gpos = waitForSnakeToGoRight($gpos, $dest)
				Send("{DOWN}")						
				ToolTip("DOWN")
				; now wait for snake to eat the redbox
				$gpos = waitForSnakeToGoDown($gpos, $redbox)
				Send("{RIGHT}")
				Send("{UP}")
				ToolTip("UP")
				$gpos[0] = $gpos[0]+1; plus 1 because of the right-up
				; now wait for snake to go back up
				$dest[0] = $gpos[0]
				$dest[1] = 0 ; toplimit
				$gpos = waitForSnakeToGoUp($gpos, $dest)
				Send("{RIGHT}")
				ToolTip("RIGHT")
				$dir = $right
			; here we check if the column before the box is clear
			ElseIf($redbox[0] > $gpos[0]) And ($redbox[0] < $trl) And Not(searchSquareForSnake($redbox[0]-1, $redbox[1])) Then
				ToolTip("target locked!")
				$dest[0] = $redbox[0]-1
				$dest[1] = $gpos[1]
				; wait for snake to be at column just before box
				$gpos = waitForSnakeToGoRight($gpos, $dest)
				Send("{DOWN}")						
				ToolTip("DOWN")		
				; now wait for snake to level with the redbox
				$gpos = waitForSnakeToGoDown($gpos, $redbox)
				Send("{RIGHT}")
				Send("{UP}")
				ToolTip("UP")
				$gpos[0] = $gpos[0]+1; plus 1 because of the right-up
				; now wait for snake to go back up
				$dest[0] = $gpos[0]
				$dest[1] = 0 ; toplimit
				$gpos = waitForSnakeToGoUp($gpos, $dest)
				Send("{RIGHT}")
				ToolTip("RIGHT")
				$dir = $right		
			Else ; redbox not in range
				;ToolTip("redbox not in range")
				ToolTip($gpos[0] & " < " & $redbox[0] & " < " & $trl)
				$dest[0] = $totalNumBoxesX-1 ; rightLimit(64-1)
				$dest[1] = $gpos[1]
				$gpos = waitForSnakeToGoRight($gpos, $dest)
				Send("{DOWN}")		
				ToolTip("DOWN")
				$dir = $down
			EndIf ; end if redbox
		ElseIf($dir == $down) Then
			; edit the down reaction to account for snake-length	
			Local $contLoop
			Local $numloops = 0
			If squareIsGray($trl) Then ; if top left square is gray
				ToolTip("Grid(" & $trl & ",0) is GRAY!")
				; then exit the loop
				$contLoop = False
			Else
				$contLoop = True
			EndIf
			While($contLoop And $numloops < 32)
				; while $contloop is true, do one up-down loop
				; wait for snake to hit bottom
				$dest[0] = $gpos[0] ; same x
				$dest[1] = $totalNumBoxesY-1 ; botLimit			
				$gpos = waitForSnakeToGoDown($gpos, $dest)
				Send("{LEFT}")
				Send("{UP}")
				ToolTip("UP")			
				$gpos[0] = $gpos[0]-1 ; because of the left-up
				; wait for snake to hit topLimit + 1
				$dest[0] = $gpos[0]
				$dest[1] = 1 ; topLimit(0) + 1			
				$gpos = waitForSnakeToGoUp($gpos, $dest)
				Send("{LEFT}")
				Send("{DOWN}")
				ToolTip("DOWN")				
				$gpos[0] = $gpos[0]-1 ; because of the left-down			
				; this is to record the number of iterations
				$numloops = $numloops + 1
				; check if all is clear
				If squareIsGray($trl) Then ; if square($trl,0) is gray				
					ToolTip("Grid(" & $trl & ",0) is GRAY!")
					; then exit the loop
					$contLoop = False
				EndIf			
			WEnd ; end of while(contloop)
			; wait for snake to hit bottom
			$dest[0] = $gpos[0]
			$dest[1] = $totalNumBoxesY-1 ; botLimit			
			$gpos = waitForSnakeToGoDown($gpos, $dest)
			Send("{LEFT}")						
			ToolTip("LEFT")
			$dir = $left
			; record the number of iterations
			$loops = $numloops
			; calculate the temporary right limit
			$trl = ($totalNumBoxesX-1) - ($loops*2 + 2) - 1
		ElseIf($dir == $left) Then
			If($redbox[0] == 0) Or ($redbox[0] == $totalNumBoxesX-1) Or ($redbox[1] == 0) Or ($redbox[1] == $totalNumBoxesY-1) Then
				ToolTip("redbox on edge!")
				$dest[0] = 0 ; leftLimit
				$dest[1] = $gpos[1]
				$gpos = waitForSnakeToGoLeft($gpos, $dest)
				Send("{UP}")
				ToolTip("UP")
				$dir = $up		
			ElseIf($redbox[0] < $gpos[0]) And Not($redbox[0] == 1) Then			
				$dest[0] = $redbox[0]
				$dest[1] = $gpos[1]
				; wait for snake to be aligned with box
				$gpos = waitForSnakeToGoLeft($gpos, $dest)
				Send("{UP}")						
				ToolTip("UP")		
				; now wait for snake to eat the redbox
				$gpos = waitForSnakeToGoUp($gpos, $redbox)
				Send("{LEFT}")
				Send("{DOWN}")
				ToolTip("DOWN")
				$gpos[0] = $gpos[0]-1; minus 1 because of the left-down
				; now wait for snake to return back down
				$dest[0] = $gpos[0]
				$dest[1] = $totalNumBoxesY-1 ; botLimit
				$gpos = waitForSnakeToGoDown($gpos, $dest)
				Send("{LEFT}")
				ToolTip("LEFT")
				$dir = $left
			ElseIf($redbox[0] < $gpos[0]) And ($redbox[0] == 1) Then			
				$dest[0] = $redbox[0]
				$dest[1] = $gpos[1]
				; wait for snake to be aligned with box
				$gpos = waitForSnakeToGoLeft($gpos, $dest)
				Send("{UP}")
				ToolTip("UP")
				$dir = $up			
			Else ; redbox not found?
				ToolTip("redbox out of range!")
				$dest[0] = 0 ; leftLimit
				$dest[1] = $gpos[1]
				$gpos = waitForSnakeToGoLeft($gpos, $dest)
				Send("{UP}")
				ToolTip("UP")
				$dir = $up	
			EndIf ; end if not @error		
		EndIf ; end if $dir == $up/$right/$down/$left
	WEnd
EndFunc

#comments-start
These functions will wait till snake travels from its src to dest
#comments-end
Func waitForSnakeToGoDown($src, $dest)
	Local $diffx = $dest[0]-$src[0]
	Local $diffy = $dest[1]-$src[1]
	Local $pxpos
	; check if source and dest are the same
	If($diffx == 0 And $diffy == 0) Then
		; if same, return dest
		Return $dest
	EndIf
	; verify that diffy > 0
	; _Assert(($diffx == 0) And ($diffy > 0))			
	; create a deviation var for convenience
	Local Const $dy = 3
	; now wait for the snake to hit the dest	
	For $i = 1 to $diffy Step 1
		$pxpos = $grid[$src[0]][$src[1]+$i]
		waitTillBlueFound($pxpos[0]-$dy, $pxpos[1]-$dy, $pxpos[0]+$dy, $pxpos[1]+$dy)
	Next
	; return destination
	Return $dest
EndFunc

Func waitForSnakeToGoUp($src, $dest)
	Local $diffx = $dest[0]-$src[0]
	Local $diffy = $dest[1]-$src[1]
	Local $pxpos	
	; check if source and dest are the same
	If($diffx == 0 And $diffy == 0) Then
		; if same, return dest
		Return $dest
	EndIf
	; verify that diffy < 0
	; _Assert(($diffx == 0) And ($diffy < 0))			
	; create a deviation var for convenience
	Local Const $dy = 3
	; now wait for the snake to hit the dest	
	For $i = -1 to $diffy Step -1
		$pxpos = $grid[$src[0]][$src[1]+$i]
		waitTillBlueFound($pxpos[0]-$dy, $pxpos[1]-$dy, $pxpos[0]+$dy, $pxpos[1]+$dy)		
	Next
	; return the destination
	Return $dest
EndFunc

Func waitForSnakeToGoLeft($src, $dest)
	Local $diffx = $dest[0]-$src[0]
	Local $diffy = $dest[1]-$src[1]
	Local $pxpos	
	; check if source and dest are the same
	If($diffx == 0 And $diffy == 0) Then
		; if they are, return dest
		Return $dest
	EndIf
	; verify that diffx < 0
	; _Assert(($diffx < 0) And ($diffy == 0))		
	; create a deviation var for convenience
	Local Const $dy = 3
	; now wait for the snake to hit the dest	
	For $i = -1 to $diffx Step -1
		$pxpos = $grid[$src[0]+$i][$src[1]]
		waitTillBlueFound($pxpos[0]-$dy, $pxpos[1]-$dy, $pxpos[0]+$dy, $pxpos[1]+$dy)
	Next
	; return the destination
	Return $dest
EndFunc

Func waitForSnakeToGoRight($src, $dest)
	Local $diffx = $dest[0]-$src[0]
	Local $diffy = $dest[1]-$src[1]
	Local $pxpos
	; check if source and dest are the same
	If($diffx == 0 And $diffy == 0) Then
		; if they are, return dest
		Return $dest
	EndIf
	; verify that diffx is > 0 and diffy = 0
	; _Assert(($diffx > 0) And ($diffy == 0))				
	; create a deviation var for convenience
	Local Const $dy = 3
	; now wait for the snake to hit the dest	
	For $i = 1 to $diffx Step 1
		$pxpos = $grid[$src[0]+$i][$src[1]]
		waitTillBlueFound($pxpos[0]-$dy, $pxpos[1]-$dy, $pxpos[0]+$dy, $pxpos[1]+$dy)
	Next
	; return the destination
	Return $dest
EndFunc

; This function searches for blue within the bounds
; given with params $x0-$x3. It will wait till blue
; is found and move the mouse to that position.
Func waitTillBlueFound($x0, $x1, $x2, $x3)		
	Local $pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	While(@error) ; while blue is NOT found, search again		
		$pos = PixelSearch($x0, $x1, $x2, $x3, $blue)
	WEnd		
EndFunc

#comments-start
This will search a specific square to see if the snake is there
#comments-end
Func searchSquareForSnake($x, $y)	
	; declare a local deviation var for convenience
	Local Const $dy = 2
	; first convert grid to pixel coords
	Local $pxpos = $grid[$x][$y]
	; MouseMove($pxpos[0], $pxpos[1], 0)
	; set x and y their pixel positions for readability
	$x = $pxpos[0]
	$y = $pxpos[1]
	; MouseMove($pixelPos[0], $pixelPos[1], 0) ; for Debug purposes
	PixelSearch($x-$dy, $y-$dy, $x+$dy, $y+$dy, $blue)
	If Not @error Then ; if blue found then snake is there
		Return True
	Else ; else if blue is not found, then it must be gray (or red)
		Return False
	EndIf
EndFunc

#comments-start
This will search the entire grid for the snake's position.
#comments-end
Func searchGridForSnake()
	Local $pxpos = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $blue)
	If @error Then
		SetError(1)
		Return
	EndIf	
	; for Debug purposes:
	; MouseMove($pxpos[0], $pxpos[1], 0)
	; now convert pixel to grid coords:
	Return convertPixelToGrid($pxpos)
EndFunc

#comments-start
This will return true if the specified square is gray
Takes in param $trl (temp right limit), which is x-position
that the snake must be past
#comments-end
Func squareIsGray($trl)
	; declare a local deviation var for convenience
	Local Const $dy = 2
	; first convert grid to pixel coords
	Local $pxpos = $grid[$trl][0]
	; MouseMove($pxpos[0], $pxpos[1], 0)
	; set x and y their pixel positions for readability
	Local $x = $pxpos[0]
	Local $y = $pxpos[1]
	; MouseMove($pixelPos[0], $pixelPos[1], 0) ; for Debug purposes
	PixelSearch($x-$dy, $y-$dy, $x+$dy, $y+$dy, $blue)
	If Not @error Then ; if blue found then return false
		Return False
	Else ; else if blue is not found, then it must be gray (or red)
		Return True
	EndIf
EndFunc

#comments-start
This is used once at the beginning to find the redbox
and store its position.
#comments-end
Func getRedbox()
	Local $pxpos = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $red)
	If @error Then
		; return the default [0,0] position
		Return $default
	Else
		; for Debug purposes:
		; MouseMove($pxpos[0], $pxpos[1], 0)
		; now convert pixel to grid coords:
		Local $gpos = convertPixelToGrid($pxpos)
		Return $gpos
	EndIf
EndFunc

#comments-start
This will search the entire grid for the redbox
#comments-end
Func searchGridForRed()
	Local $pxpos = PixelSearch($leftLimit, $topLimit, $rightLimit, $botLimit, $red)
	If @error Then
		; return the default [0,0] position
		Return $default
	EndIf
	Return convertPixelToGrid($pxpos)	
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
	; _Assert($xBoxIndex >= 0 & $xBoxIndex < $totalNumBoxesX)
	; _Assert($yBoxIndex >= 0 & $yBoxIndex < $totalNumBoxesY)	
	; create the return array xy:
	Local $xy[2]
	; calculate the x coordinate
	$xy[0] = $leftLimit+($xBoxIndex)*($rightLimit-$leftLimit+1)/($totalNumBoxesX)+$dy
	; calculate the y coordinate
	$xy[1] = $topLimit+($yBoxIndex)*($botLimit-$topLimit)/($totalNumBoxesY)+$dy
	Return $xy
EndFunc

; this function finds the snake's sandbox
Func calibrateScreen()
	Local $grayfound = False
	Local $graypos, $pos
	Local $y = 400
	; first find gray
	While Not $grayfound
		$graypos = PixelSearch(0, $y, 1280, $y, $gray)
		If Not @error Then			
			MouseMove($graypos[0], $graypos[1])
			; ToolTip("FOUND GRAY HERE!")
			$grayfound = True
		Else
			$y = $y + 50
			If($y >= 800) Then
				MsgBox(0, "ERROR", "Could not find gray!")
				Exit
			EndIf
		EndIf
	WEnd
	; now find the top black border
	$pos = PixelSearch($graypos[0], $graypos[1], $graypos[0], 0, $black)
	If Not @error Then
		MouseMove($pos[0], $pos[1])
		$topLimit = $pos[1]
		ToolTip("top limit: " & $topLimit)
	Else
		MsgBox(0, "ERROR", "Could not find top limit!")
		Exit
	EndIf
	; find the bottom black border
	$pos = PixelSearch($graypos[0], $graypos[1], $graypos[0], 800, $black)
	If Not @error Then
		MouseMove($pos[0], $pos[1])
		$botLimit = $pos[1]
		ToolTip("bottom limit: " & $botLimit)
	Else
		MsgBox(0, "ERROR", "Could not find bottom limit!")
		Exit
	EndIf
	; find the left black border
	$pos = PixelSearch($graypos[0], $graypos[1], 0, $graypos[1], $black)
	If Not @error Then
		MouseMove($pos[0], $pos[1])
		$leftLimit = $pos[0]
		ToolTip("left limit: " & $leftLimit)
	Else
		MsgBox(0, "ERROR", "Could not find left limit!")
		Exit
	EndIf
	; find the right black border
	$pos = PixelSearch($graypos[0], $graypos[1], 1280, $graypos[1], $black)
	If Not @error Then
		MouseMove($pos[0], $pos[1])
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
	; MsgBox(0, "Max delay", $maxdelay) ; maxdelay so far: 167ms
	Exit
EndFunc
