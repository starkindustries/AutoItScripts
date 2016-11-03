#include-once
#include <Array.au3>

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)

; use this to find the pixel color at a given coordinate
Func getColorAtCoord($x, $y)
	Local $color = PixelGetColor($x, $y)
	MsgBox(0,"The hex color is", Hex($color, 6))
	MsgBox(0, "x,y:", $x & "," & $y)
EndFunc

; use this to find mouse location
Func getMousePos()
	Local $pos = MouseGetPos()
	MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])
	return $pos
EndFunc

; use this to find the pixel color where the mouse is pointing
Func getColor()
	Local $pos = MouseGetPos()
	Local $color = PixelGetColor($pos[0], $pos[1])	
	MsgBox(0,"The hex color is", Hex($color, 6))
	MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])
EndFunc

; displays a 2D array of coordinates (i.e. it displays a 2D array of 1D arrays)
; params are: the 2D array, max x-index, max y-index
Func display2DArrayOfCoords($array, $maxX, $maxY)
	Local $temp[$maxX+1][$maxY+1]
	For $i = 0 To $maxX Step 1
		For $j = 0 To $maxY Step 1
			Local $coord = $array[$i][$j]
			$temp[$i][$j] = String("(" & $coord[0] & "," & $coord[1] & ")")
		Next
	Next
	_ArrayDisplay($temp, "$grid coordinates", -1, 1)	
EndFunc