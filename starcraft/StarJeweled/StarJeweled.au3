; StarJeweled
#include <toolbox.au3>
#include <Array.au3>

HotKeySet("{f2}","ExitProgram")
HotKeySet("{ESC}","ExitProgram")

Local $debug = false

; *****************
; The Jewel Grid
; *****************
; Use GetMousePos() to find initial topLeft & bottomRight coordinates
; GetMousePos()

; The top left and bottom right coordinates of the jewel grid
Local $topLeft[2] = [1286, 118]
Local $bottomRight[2] = [1831, 660]

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

; Color array      [yellow, purple, red, blue, green, gray]
Local $colors[6] = [0xBF9105, 0x720987, 0xD22E0A, 0x53C8FC, 0x6DFE3C, 0x353A3E]
Local $colorAbbreviation[6] = ["yl", "pr", "rd", "bl", "gr", "gy"]

; *****************
; Gem Array
; *****************
; This var holds all the gem values
Local $gems[8][8]

UpdateGemArray()

If $debug Then
	VerifySampleGemArray()
	_ArrayDisplay($gems, "Gems")
EndIf

; *******************
; Find & Click Match
; *******************
; Strategy
; https://www.bigfishgames.com/blog/match-3-tips/
; 1. Match horizontally
; 2. Match lower on the board
; 3. Match more than 3 if possible

; Type 'F' to start the search
HotKeySet("{5}","FindMatch")

Local $shouldSearch = false

While True
	if ($shouldSearch) Then
		FindAndClickMatch()
		$shouldSearch = false
	EndIf
WEnd

; *****************
; Functions
; *****************
Func FindMatch()
	ConsoleWrite("FindMatch Command Acknowledged!" & @CR)
	$shouldSearch = true
EndFunc

Func FindAndClickMatch()
	ConsoleWrite("FindAndClickMatch" & @CR)
	UpdateGemArray()
	Local $match = FindHorizontalMatches()
	If @error Then
		ConsoleWrite("No matches found." & @CR)
	Else
		Local $pos1 = GetBoxPos($match[0][0], $match[0][1])
		Local $pos2 = GetBoxPos($match[1][0], $match[1][1])
		LeftClick($pos1)
		LeftClick($pos2)
	EndIf
	MouseMove($topLeft[0]-100, $topLeft[1])
EndFunc

; Note this function first finds two in a row and then searches for a third adjacent match
; ** TODO **
; Search for [a][b][a][a] patterns
; Search for:
; [a][b][a]
;    [a]
Func FindHorizontalMatches()
	Local $allSwaps[1]
	; Search from bottom up
	For $y=7 to 0 Step -1
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

					; Check left top; mfake sure y is within bounds
					If $y > 0 Then
						If $gems[$y-1][$x-1] == $color Then
							; [$x-1, $y-1] this is the 3rd matching gem
							; [$x-1, $y]   this is the cell just below the matching gem
							ConsoleWrite("MATCH FOUND1" & @CR)
							ConsoleWrite("[" & $x-1 & ", " & $y-1 & "] & [" & $x-1 & ", " & $y & "]" & @CR)
							Local $swaps[2][2] = [[$x-1, $y-1], [$x-1, $y]]
							Return $swaps
						EndIf
					EndIf

					; Check left bottom; make sure y is within bounds
					If $y < 7 Then
						If $gems[$y+1][$x-1] == $color Then
							; [$x-1, $y+1] this is the 3rd matching gem
							; [$x-1, $y]   this is the cell just above the matching gem
							ConsoleWrite("MATCH FOUND2" & @CR)
							ConsoleWrite("[" & $x-1 & ", " & $y+1 & "] & [" & $x-1 & ", " & $y & "]" & @CR)
							Local $swaps[2][2] = [[$x-1, $y+1], [$x-1, $y]]
							Return $swaps
						EndIf
					EndIf
				EndIf

				; Now check the right side of the gems
				If $x < 6 Then

					; Check right top
					If $y > 0 Then
						If $gems[$y-1][$x+2] == $color Then
							; [$x+2, $y-1] this is the 3rd matching gem
							; [$x+2, $y]   this is the cell just below the matching gem
							ConsoleWrite("MATCH FOUND3" & @CR)
							ConsoleWrite("[" & $x+2 & ", " & $y-1 & "] & [" & $x+2 & ", " & $y & "]" & @CR)
							Local $swaps[2][2] = [[$x+2, $y-1], [$x+2, $y]]
							Return $swaps
						EndIf
					EndIf

					; Check right bottom
					If $y < 7 Then
						If $gems[$y+1][$x+2] == $color Then
							; [$x+2, $y+1] this is the 3rd matching gem
							; [$x+2, $y]   this is the cell just above the matching gem
							ConsoleWrite("MATCH FOUND4" & @CR)
							ConsoleWrite("[" & $x+2 & ", " & $y+1 & "] & [" & $x+2 & ", " & $y & "]" & @CR)
							Local $swaps[2][2] = [[$x+2, $y+1], [$x+2, $y]]
							Return $swaps
						EndIf
					EndIf
				EndIf

			EndIf
		Next
	Next
	SetError(1) ; No match found
EndFunc

; This function will compares a screenshot to values obtained from UpdateGemArray
Func VerifySampleGemArray()
	; Sample screenshot values:
	Local $sampleGems[8][8] = [ _
		["gy", "pr", "rd", "yl", "gy", "gy", "pr", "rd"], _
		["rd", "yl", "gy", "rd", "rd", "gr", "bl", "gr"], _
		["yl", "bl", "bl", "gr", "yl", "yl", "gy", "gy"], _
		["yl", "rd", "gy", "pr", "rd", "gy", "yl", "rd"], _
		["pr", "yl", "gy", "gy", "pr", "gy", "yl", "rd"], _
		["rd", "yl", "rd", "gr", "pr", "rd", "pr", "gy"], _
		["yl", "pr", "yl", "gy", "yl", "gr", "gr", "gy"], _
		["pr", "bl", "yl", "gr", "yl", "rd", "gr", "yl"]]

	For $y=0 To 7 Step 1
		For $x=0 To 7 Step 1
			If $sampleGems[$y][$x] == $gems[$y][$x] Then
				; good
			Else
				; error
				ConsoleWrite("Non-match found at: [" & $x & ", " & $y & "] " & $sampleGems[$y][$x] & " vs " & $gems[$y][$x])
			EndIf
		Next
	Next
EndFunc

Func UpdateGemArray()
	; loop from left to right, top down
	For $y=0 To 7 Step 1
		For $x=0 To 7 Step 1
			Local $box = GetBoxPos($x, $y)
			Local $colorIndex = GetBoxColorIndex($box)
			If Not @error Then
				$gems[$y][$x] = $colorAbbreviation[$colorIndex]
				; ConsoleWrite("[" & $x & ", " & $y & "]: " & $colorAbbreviation[$colorIndex] & @CR)
			Else
				$gems[$y][$x] = -1
			EndIf
		Next
	Next
EndFunc

; Pixel Search
; https://www.autoitscript.com/autoit3/docs/functions/PixelSearch.htm
Func GetBoxColorIndex($box)
	; Pixel search properties
	Local $len = 10
	Local $shadeVariation = 20
	Local $step = 2

	For $i=0 To 5 Step 1
		Local $color = $colors[$i]

		; To visualize the pixel search, enable these two lines
		If $debug Then
			MouseMove($box[0]-$len, $box[1]-$len, 10)
			MouseMove($box[0]+$len, $box[1]+$len, 10)
		EndIf

		; PixelSearch ( left, top, right, bottom, color [, shade-variation = 0 [, step = 1 [, hwnd]]] )
		Local $coord = PixelSearch($box[0]-$len, $box[1]-$len, $box[0]+$len, $box[1]+$len, $color, $shadeVariation, $step)
		If Not @error Then
			Return $i
		EndIf
	Next
	SetError(1) ; No matching color found
EndFunc

Func CheckPositions()
	LeftClick($topLeft)
	ToolTip("Top Left")

	For $y=0 To 7 Step 1
		For $x=0 To 7 Step 1
			Local $pos = GetBoxPos($x, $y)
			LeftClick($pos, 10)
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