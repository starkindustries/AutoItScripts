; http://forum.cheatengine.org/viewtopic.php?t=517600&sid=11b70866fb9d4a2b265cb53050cc9055
#RequireAdmin ;User Account must have Administrator privlidges
; #AutoIt3Wrapper_UseX64=n
#include <NomadMemory.au3> ;Include the NomadMemory functions in this script
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
AutoItSetOption("MustDeclareVars", 1)

Global $hMemory ;A global variable

#region ### START Koda GUI section ###
; Create the main GUI box
;------------- GUICreate("title______________", width, height, left, top, style, exstyle, parent)
Global $hGUI = GUICreate("CE Tutorial Trainer", 245,   225,    192,  124)
; Create the attach button
;---------------- GUICtrlCreateButton("text__", left, top, width, height, style, exstyle)
Global $hAttach = GUICtrlCreateButton("Attach", 5,    5,   75,    25,     $WS_GROUP)
; Create the detach button
;---------------- GUICtrlCreateButton("text__", left, top, width, height, style, exstyle)
Global $hDetach = GUICtrlCreateButton("Detach", 85,   5,   75,    25,     $WS_GROUP)
; Set the Detach button to disabled
GUICtrlSetState($hDetach, $GUI_DISABLE)
; create the quit button
;-------------- GUICtrlCreateButton("text_______", left, top, width, height, style, exstyle)
Global $hQuit = GUICtrlCreateButton("Quit",        165,  5,   75,    25,     $WS_GROUP)
; create the Patch button
;--------------- GUICtrlCreateButton("text_______", left, top, width, height, style, exstyle)
Global $hStep2 = GUICtrlCreateButton("Patch Step2", 5,    35,  235,   25,     $WS_GROUP)
; create an edit box for output
;---------------- GUICtrlCreateButton("text___________", left, top, width, height, style, exstyle)
Global $textBox = GUICtrlCreateEdit("",                  5,    65,  235,   125,    $WS_GROUP)
GUICtrlSetState($textBox, $GUI_DISABLE)
; create a clear button for the text box
Global $clear = GUICtrlCreateButton("Clear Text", 5, 195, 235, 25, $WS_GROUP)
; Display the GUI!
GUISetState(@SW_SHOW)
#endregion ### END Koda GUI section ###

Global $process = "Tutorial-i386.exe"

While 1
	; the GUI listener
	Switch GUIGetMsg()
		Case $hAttach ; if the attach button is pressed then
			; check if the process exists and get the process ID
			Local $processId = ProcessExists($process)
			If $processId = 0 Then ; if process does not exist then send an error msg
				MsgBox(0, "Error", "Process does not exist! Process will now close.")
				Exit
			Else ; if the process does exist open it up with _MemoryOpen
				$hMemory = _MemoryOpen($processId)
				GUICtrlSetData($textBox, "The Process ID is: " & $processId & @CRLF, 1); write to output box
				GUICtrlSetState($hDetach, $GUI_ENABLE); enable the Detach button
				GUICtrlSetState($hAttach, $GUI_DISABLE); disable the Attach button
			EndIf
		Case $hDetach
			_MemoryClose($hMemory); close the process
			GUICtrlSetState($hAttach, $GUI_ENABLE); enable attach button
			GUICtrlSetState($hDetach, $GUI_DISABLE); disable detach button
		Case $hStep2
			_PatchStep2()
		Case $clear
			GUICtrlSetData($textBox, "")
		Case $hQuit
			Exit
		Case $GUI_EVENT_CLOSE
			Exit
	EndSwitch
WEnd

Func _PatchStep2()
	;Get Base Address
	Local $baseAddress = _MemoryGetBaseAddress($hMemory)
	If $BaseAddress = 0 Then
		Select
			Case @error = 1
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
			Case @error = 2
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
			Case @error = 3
				MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
		EndSelect
	Else
		GUICtrlSetData($textBox, "The Base Address is: " & $BaseAddress & @CRLF, 1);
	EndIf

	;;==============================================================
	;; CHANGE THIS ADDRESS TO THE CORRECT ADDRESS IN CHEAT ENGINE ==
	Local $address = "0x0182F56C";                                ==
	;;==============================================================
	Local $value = _MemoryRead($address, $hMemory)
	If Not @error Then
		GUICtrlSetData($textBox, "The address " & $address & " has the value " & $value & @CRLF, 1);
	Else
		MsgBox(0, "Error:", @error)
	EndIf

	Local $write = _MemoryWrite($address, $hMemory, "1000", 'int')
	If @error Then
		MsgBox(0, "Error:", @error)
	EndIf
EndFunc   ;==>_PatchStep2

; http://www.autoitscript.com/forum/topic/139368-workaround-for-nomadmemory-in-windows-7-x64/
Func _NewMemRead($Addr1, $Proc1, $type1)
	If $type1 = "int" Then ;I only used int, if you use uint or any other integer representation, add them in here
		Return (Dec(Hex(StringRegExpReplace(_MemoryRead($Addr1, $Proc1, $type1), "00000000", "", 1))))
	Else
		Return _MemoryRead($Addr1, $Proc1, $type1)
	EndIf
EndFunc   ;==>_NewMemRead

Func _NewMemPointerRead($iv_Address, $ah_Handle, $av_offset)
	Return (Dec(Hex(StringRegExpReplace(_MemoryPointerRead($iv_Address, $ah_Handle, $av_offset), "00000000", "", 1))))
EndFunc   ;==>_NewMemPointerRead