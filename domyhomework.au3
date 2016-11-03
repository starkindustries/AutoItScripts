#include <toolbox.au3>

HotKeySet("{f2}","exitProgram")
HotKeySet("{ESC}","exitProgram")

; Automates the DSCA course on JKO (DCRF online training)
; https://jkodirect.jten.mil/Atlas2/html/scorm2004/course/Course_main.jsp?OWASP_CSRFTOKEN=NXW5-7CAB-NTN7-ZD7I-SKR8-YV0D-BKX2-V5WG

;getColor() ; use this to find the pixel color where the mouse is pointing
;getMousePos() ; use this to get the mouse position you want
;Exit

While True
   doHomework()
WEnd

; Send("{CTRLDOWN}1{CTRLUP}")
; Send("{CTRLDOWN}5{CTRLUP}")


Func doHomework()
	Local $numLessons = 2000
	; click the next button
	For $i=1 to $numLessons Step 1
		For $j=0 to 10 Step 1
			Sleep(1000)
			ToolTip($j)
		Next
	  ; MouseClick("button", x, y, clicks, speed)
		MouseClick("left", 1367, 784, 1, 0)
		ToolTip('Click #' & $i)
		Sleep(1000)
	Next
	; click the next lesson button
	; MouseClick("left", 208, 168, 1, 0)
	; Sleep(10000)
EndFunc
