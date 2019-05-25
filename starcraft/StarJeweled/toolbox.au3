#include-once
#include <Array.au3>

#comments-start
SYNTAX AND API NOTES
- to concatenate strings use the ampersand: "this" & $and & "that"
- PixelChecksum(): Generates a checksum for a selection of pixels
- _ScreenCapture_CaptureWnd
- _ScreenCapture_SaveImage
- PixelCoordMode; 0=relative coords to defined window, 1=absolute, 2 relative coords to client area
#comments-end

; set this so that variables must be
; explicitly declared before use
AutoItSetOption("MustDeclareVars", 1)

; use this to find mouse location
Func GetMousePos()
   Local $pos = MouseGetPos()
   ; MsgBox(0, "Mouse x,y:", $pos[0] & "," & $pos[1])
   Local $message = "Mouse x,y: " & $pos[0] & "," & $pos[1] & @CR
   ConsoleWrite($message)
EndFunc

; use this to find the pixel color where the mouse is pointing
Func GetColor()
   Local $pos = MouseGetPos()
   Local $color = PixelGetColor($pos[0], $pos[1])
   ConsoleWrite("The decimal color is " & $color & @CR)
   ConsoleWrite("The hex color is " & Hex($color, 6) & @CR)
   ConsoleWrite("Mouse x, y: " & $pos[0] & "," & $pos[1] & @CR)
EndFunc

; displays a 2D array of coordinates (i.e. it displays a 2D array of 1D arrays)
; params are: the 2D array, max x-index, max y-index
Func Display2DArrayOfCoords($array, $maxX, $maxY)
   Local $temp[$maxX+1][$maxY+1]
   For $i = 0 To $maxX Step 1
	  For $j = 0 To $maxY Step 1
			Local $coord = $array[$i][$j]
			$temp[$i][$j] = String("(" & $coord[0] & "," & $coord[1] & ")")
	  Next
   Next
   _ArrayDisplay($temp, "$grid coordinates", -1, 1)
EndFunc

Func ExitProgram()
	Exit
EndFunc

Func LeftClick($pos, $speed = 10, $sleep = 0)
   ; MouseClick("button", x, y, clicks, speed)
   MouseClick("left", $pos[0], $pos[1], 1, $speed)
   Sleep($sleep)
EndFunc