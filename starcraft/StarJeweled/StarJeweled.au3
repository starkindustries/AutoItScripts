; StarJeweled
#include <toolbox.au3>
#include <Array.au3>
#include <Color.au3>

HotKeySet("{f2}","ExitProgram")
HotKeySet("{1}", "CastWarpCell")
HotKeySet("{2}", "CastTimeBomb")
HotKeySet("{3}", "CastHeal")
HotKeySet("{4}", "CastStorm")
HotKeySet("{5}","ToggleJewelSearch")

; MouseCoordMode
; https://www.autoitscript.com/autoit3/docs/functions/AutoItSetOption.htm#MouseCoordMode
; Sets the way coords are used in the mouse functions, either absolute coords or coords
; relative to the current active window:
; 0 = relative coords to the active window
AutoItSetOption("MouseCoordMode", 0)
; PixelCoordMode
; Sets the way coords are used in the pixel functions, either absolute coords or coords relative to the window defined by hwnd
AutoItSetOption("PixelCoordMode", 0)

Local $debug = False

Local $hWnd = WinWait("StarCraft")
WinActivate($hWnd)

; *****************
; The Jewel Grid
; *****************
; Use GetMousePos() to find initial topLeft & bottomRight coordinates
; GetMousePos()

; The top left and bottom right coordinates of the jewel grid
Local $topLeft[2] = [593, 103]
Local $bottomRight[2] = [1005, 512]

; The total width (x) and height (y) of the jewel grid
Local $xLength = $bottomRight[0] - $topLeft[0]
Local $yLength = $bottomRight[1] - $topLeft[1]
ConsoleWrite($xLength & @CR)
ConsoleWrite($yLength & @CR)

; The width and height of one jewel box
Local $boxWidth = $xLength/8
Local $boxHeight = $yLength/8
ConsoleWrite("box height: " & $boxHeight & @CR)
ConsoleWrite("box width: " & $boxWidth & @CR)

; ** TODO: The jewel grid is a square. Simplify to use just width. **
Local $boxCenter[2] = [$boxWidth/2, $boxHeight/2]

; Verify Grid Positions
If $debug Then
	CheckPositions()
EndIf

; *****************
; Colors
; *****************
; Use GetColor() to determine jewel colors
; GetColor()

; Note: search for yellow first because the triangle has two colors yellow and light blue
; * Yellow protoss 0xBF9105
; * Purp zerg 0x720987, 0x590A73
; * Reddish chevron 0xD22E0A
; * Blue ice 0x53C8FC
; * Green gas 0x9AFE53, 0x6DFE3C
; * Black/white/gray skull 0x353A3E

; Color array      [yellow,   purple,   red,      blue,     green,    gray]
Local $colors[6] = [0xFEFD61, 0x983DB8, 0xFE430F, 0x53C8FC, 0x6DFE3C, 0x52595C]
; Abbreviations: y=yellow, p=purple, r=red, b=blue, g=green, a=gray
Local $colorAbbreviation[6] = ["y", "p", "r", "b", "g", "a"]
Local $yellowRGB = _ColorGetRGB($colors[0])
Local $purpleRGB = _ColorGetRGB($colors[1])
Local $redRGB    = _ColorGetRGB($colors[2])
Local $blueRGB   = _ColorGetRGB($colors[3])
Local $greenRGB  = _ColorGetRGB($colors[4])
Local $grayRGB   = _ColorGetRGB($colors[5])

; *****************
; Gem Array
; *****************
; This var holds all the gem values
Local $gems[8][8]
Local $rawColors[8][8]

;~ UpdateGemArray()

;~ If $debug Then
;~ 	_ArrayDisplay($rawColors, "Colors")
;~ 	_ArrayDisplay($gems, "Colors")
;~ EndIf

; *******************
; Find & Click Match
; *******************
; Strategy
; https://www.bigfishgames.com/blog/match-3-tips/
; 1. Match horizontally
; 2. Match lower on the board
; 3. Match more than 3 if possible

; Type 'F' to start the search
; This is defined at the top: HotKeySet("{5}","FindMatch")

Local $shouldSearch = false

;~ While True
;~ 	if ($shouldSearch) Then
;~ 		FindAndClickMatch()
;~ 	EndIf
;~ WEnd

; *****************
; Functions
; *****************
; Disables Target
Func CastWarpCell()
	MouseClick("left", 750, 745, 1, 5)
	MouseClick("left", 298, 386, 1, 5)
EndFunc

; Slows enemies
Func CastTimeBomb()
	MouseClick("left", 799, 745, 1, 5)
	MouseClick("left", 298, 386, 1, 5)
EndFunc

Func CastHeal()
	MouseClick("left", 846, 745, 1, 5)
	MouseClick("left", 298, 386, 1, 5)
EndFunc

Func CastStorm()
	MouseClick("left", 896, 745, 1, 5)
	MouseClick("left", 298, 386, 1, 5)
EndFunc

Func ToggleJewelSearch()
	$shouldSearch = Not $shouldSearch
	If $shouldSearch Then
		ConsoleWrite("ToggleJewelSearch: Search ON" & @CR)
	Else
		ConsoleWrite("ToggleJewelSearch: Search OFF" & @CR)
	EndIf
EndFunc

Func FindAndClickMatch($boxes)
	ConsoleWrite("FindAndClickMatch" & @CR)

	; Find horizontal matches
	UpdateGemArray($boxes)
	Local $horizontalMatchFound = FindMatches(True)
	If $horizontalMatchFound Then
		MouseMove($topLeft[0]-100, $topLeft[1], 0)
	Else
		; Find vertical matches
		UpdateGemArray($boxes)
		FindMatches(False)
		MouseMove($topLeft[0]-100, $bottomRight[1], 0)
	EndIf
EndFunc

Local $clickSpeed = 100

Func SwapPositions($swaps, $horizontal)
	If $horizontal Then
		Local $pos1 = GetBoxPos($swaps[0][0], $swaps[0][1])
		Local $pos2 = GetBoxPos($swaps[1][0], $swaps[1][1])
		LeftClick($pos1, $clickSpeed)
		LeftClick($pos2, $clickSpeed)
	Else
		Local $pos1 = GetBoxPos($swaps[0][1], $swaps[0][0])
		Local $pos2 = GetBoxPos($swaps[1][1], $swaps[1][0])
		LeftClick($pos1, $clickSpeed)
		LeftClick($pos2, $clickSpeed)
	EndIf
EndFunc

; Note this function first finds two in a row and then searches for a third adjacent match
Func FindMatches($horizontal=True)
	Local $matchFound = false

	If $horizontal Then
		; do nothing
	Else
		_ArrayTranspose($gems)
	EndIf

	; Search from top to bottom
	For $y=0 to 7 Step 1
		For $x=0 To 6 Step 1

			Local $color = $gems[$y][$x]

			; If gem is the same as the gem to the right, we found two in a row
			If $gems[$y][$x+1] == $color Then

				if $debug Then
					ToolTip("Two in a row")
					Local $pos = GetBoxPos($x, $y)
					MouseMove($pos[0], $pos[1], 100)
				EndIf

				; Check to see if a match can be made with the two gems found
				; First check left side of gems
				If $x > 0 Then

					; Check for this pattern (top left):
					; [x]
					; [ ][x][x]
					; Make sure y is within bounds
					If $y > 0 Then
						If $gems[$y-1][$x-1] == $color Then
							; [$x-1, $y-1] this is the 3rd matching gem
							; [$x-1, $y]   this is the cell just below the matching gem
							ConsoleWrite("FOUND PATTERN #1" & @CR)
							Local $swaps[2][2] = [[$x-1, $y-1], [$x-1, $y]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf

					; Check for this pattern (bottom left):
					; [ ][x][x]
					; [x]
					If $y < 7 Then
						If $gems[$y+1][$x-1] == $color Then
							; [$x-1, $y+1] this is the 3rd matching gem
							; [$x-1, $y]   this is the cell just above the matching gem
							ConsoleWrite("FOUND PATTERN #2" & @CR)
							Local $swaps[2][2] = [[$x-1, $y+1], [$x-1, $y]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf
				EndIf

				; Now check the right side of the gems
				If $x < 6 Then

					; Check for this pattern (top right):
					;       [x]
					; [x][x][ ]
					If $y > 0 Then
						If $gems[$y-1][$x+2] == $color Then
							; [$x+2, $y-1] this is the 3rd matching gem
							; [$x+2, $y]   this is the cell just below the matching gem
							ConsoleWrite("FOUND PATTERN #3" & @CR)
							Local $swaps[2][2] = [[$x+2, $y-1], [$x+2, $y]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf

					; Check for this pattern (bottom right):
					; [x][x][ ]
					;       [x]
					If $y < 7 Then
						If $gems[$y+1][$x+2] == $color Then
							; [$x+2, $y+1] this is the 3rd matching gem
							; [$x+2, $y]   this is the cell just above the matching gem
							ConsoleWrite("FOUND PATTERN #4" & @CR)
							Local $swaps[2][2] = [[$x+2, $y+1], [$x+2, $y]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf
				EndIf

				; Check for pattern:
				; [x][ ][x][x]
				If $x > 1 Then
					If $gems[$y][$x-2] == $color Then
						ConsoleWrite("FOUND PATTERN #5" & @CR)
						Local $swaps[2][2] = [[$x-2, $y], [$x-1, $y]]
						SwapPositions($swaps, $horizontal)
						$matchFound = true
					EndIf
				EndIf

				; Check for pattern:
				; [x][x][ ][x]
				If $x < 5 Then
					If $gems[$y][$x+3] == $color Then
						ConsoleWrite("FOUND PATTERN #6" & @CR)
						Local $swaps[2][2] = [[$x+3, $y], [$x+2, $y]]
						SwapPositions($swaps, $horizontal)
						$matchFound = true
					EndIf
				EndIf
			EndIf

			; Check for the middle patterns
			If $x < 6 Then
				If $gems[$y][$x+2] == $color Then

					; Check
					;    [x]
					; [x][ ][x]
					If $y > 0 Then
						If $gems[$y-1][$x+1] == $color Then
							ConsoleWrite("FOUND PATTERN #7" & @CR)
							Local $swaps[2][2] = [[$x+1, $y], [$x+1, $y-1]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf

					; Check
					; [x][ ][x]
					;    [x]
					If $y < 7 Then
						If $gems[$y+1][$x+1] == $color Then
							ConsoleWrite("FOUND PATTERN #8" & @CR)
							Local $swaps[2][2] = [[$x+1, $y], [$x+1, $y+1]]
							SwapPositions($swaps, $horizontal)
							$matchFound = true
						EndIf
					EndIf
				EndIf
			EndIf

		Next
	Next

	return $matchFound
EndFunc

Func UpdateGemArray($boxes)
	; loop from left to right, top down
	For $x=0 To 7 Step 1
		For $y=0 To 7 Step 1
			Local $colorIndex = GetBoxColorAndIndex($x, $y)
			$gems[$y][$x] = $colorIndex[0]
			Local $index = $colorIndex[1]
			GUICtrlSetBkColor($boxes[$y][$x], $colors[$index])
		Next
	Next
EndFunc

Func GetBoxColorAndIndex($x, $y)
	Local $box = GetBoxPos($x, $y)
	Local $yOffset = -18

	; To visualize the checked color location, enable this line
	; MouseMove($box[0], $box[1]+$yOffset)

	Local $color = PixelGetColor($box[0], $box[1] + $yOffset, $hWnd)
	$rawColors[$y][$x] = Hex($color)

	; Calculate the color differences
	Local $rgb = _ColorGetRGB($color)
	Local $diffs[6]
	$diffs[0] = CalculateColorDiff($rgb, $yellowRGB)
	$diffs[1] = CalculateColorDiff($rgb, $purpleRGB)
	$diffs[2] = CalculateColorDiff($rgb, $redRGB)
	$diffs[3] = CalculateColorDiff($rgb, $blueRGB)
	$diffs[4] = CalculateColorDiff($rgb, $greenRGB)
	$diffs[5] = CalculateColorDiff($rgb, $grayRGB)

	Local $minIndex = _ArrayMinIndex($diffs)

	If $debug Then
		ConsoleWrite("[" & $x & ", " & $y & "]: " & $color & @CR)
		ConsoleWrite("RGB: " & $rgb[0] & " " & $rgb[1] & " " & $rgb[2] & @CR)
		ConsoleWrite("Min difference: " & $diffs[$minIndex] & @CR)
	EndIf

	Local $colorAndIndex[2] = [$colorAbbreviation[$minIndex], $minIndex]
	return $colorAndIndex
EndFunc

; Color Difference
; https://en.wikipedia.org/wiki/Color_difference#Euclidean
; Formula:
; (r2-r1)^2 + (g2-g1)^2 + (b2-b1)^2
Func CalculateColorDiff($rgb1, $rgb2)
	Local $diff = ($rgb2[0]-$rgb1[0])^2 + ($rgb2[1]-$rgb1[1])^2 + ($rgb2[2]-$rgb1[2])^2
	return $diff
EndFunc

Func CheckPositions()
	MouseMove($topLeft[0], $topLeft[1], 0)
	ToolTip("Top Left")

	For $y=0 To 7 Step 1
		For $x=0 To 7 Step 1
			Local $pos = GetBoxPos($x, $y)
			MouseMove($pos[0], $pos[1], 0)
			ToolTip("Box [" & $x & ", " & $y & "]")
			ConsoleWrite("[" & $pos[0] & ", " & $pos[1] & "]" & @CR)
		Next
	Next
EndFunc

Func GetBoxPos($x, $y)
	Local $xPos = $boxWidth * $x + $topLeft[0] + $boxCenter[0]
	Local $yPos = $boxHeight * $y + $topLeft[1] + $boxCenter[1]
	Local $pos[2] = [$xPos, $yPos]
	Return $pos
EndFunc