; http://forum.cheatengine.org/viewtopic.php?t=517600&sid=11b70866fb9d4a2b265cb53050cc9055
#RequireAdmin ;User Account must have Administrator privlidges
; #AutoIt3Wrapper_UseX64=n
#include <NomadMemory.au3> ;Include the NomadMemory functions in this script
#include <ButtonConstants.au3>
#include <GUIConstantsEx.au3>
#include <WindowsConstants.au3>
AutoItSetOption("MustDeclareVars", 1)

Global $hMemory ;A global variable

#Region ### START Koda GUI section ###
; Create the main GUI box
;------------- GUICreate("title______________", width, height, left, top, style, exstyle, parent)
Global $hGUI = GUICreate("CE Tutorial Trainer", 259,   75,     192,  124)
; Create the attach button
;---------------- GUICtrlCreateButton("text__", left, top, width, height, style, exstyle)
Global $hAttach = GUICtrlCreateButton("Attach", 8,    8,   75,    25,     $WS_GROUP)
; Create the detach button
Global $hDetach = GUICtrlCreateButton("Detach", 88, 8, 83, 25, $WS_GROUP)
; Set the Detach button to disabled
GUICtrlSetState($hDetach, $GUI_DISABLE)
; create the Patch button
Global $hStep2 = GUICtrlCreateButton("Patch Step2", 8, 40, 243, 25, $WS_GROUP)
; create the quit button
Global $hQuit = GUICtrlCreateButton("Quit", 176, 8, 75, 25, $WS_GROUP)
GUISetState(@SW_SHOW)
#EndRegion ### END Koda GUI section ###

While 1

   Switch GUIGetMsg()
	  Case $hAttach
		 If ProcessExists("Tutorial-i386.exe") = 0 Then
			MsgBox(0, "Error", "Process does not exist!")
		Else
			MsgBox(0, "Success", "Process does exist: " & ProcessExists("Tutorial-i386.exe"))
			$hMemory = _MemoryOpen(7192)
			GUICtrlSetState($hDetach,$GUI_ENABLE)
			GUICtrlSetState($hAttach,$GUI_DISABLE)
		 EndIf

      Case $hDetach
         _MemoryClose($hMemory)
         GUICtrlSetState($hAttach,$GUI_ENABLE)
         GUICtrlSetState($hDetach,$GUI_DISABLE)
      Case $hStep2
         _PatchStep2()
      Case $hQuit
         Exit
      Case $GUI_EVENT_CLOSE
         Exit
   EndSwitch
WEnd

Func _PatchStep2()
   Local $Offset[2] = [0, Dec(464)]

   ;Get Base Address
   Local $BaseAddress = Dec(Hex(StringRegExpReplace(_MemoryGetBaseAddress($hMemory, 1), "00000000", "", 1)))
   If $BaseAddress = 0 Then
      Select
         Case @error = 1
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Invalid handle to open process")
         Case @error = 2
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to find correct allocation address")
         Case @error = 3
            MsgBox(0, "Error", "Error getting base address: " & @CRLF & "Failed to read from the specified process")
      EndSelect
   EndIf

   ;Calculate and Write
   Local $StaticOffset = Dec("0x00690320") - $BaseAddress
   Local $FinalAddress = "0x" & Hex($BaseAddress + $StaticOffset)
   Local $Write = _MemoryPointerWrite($FinalAddress, $hMemory, $Offset, "1000")
   MsgBox(0, "Write Value:", $Write)
   Local $read = _NewMemRead("0x0184EF34", $hMemory, "int")
   MsgBox(0, "Read Value:", $read)

   Local $var1 = "0x12345678" ;Bad, auto-converts to x64 representation
   MsgBox(0, "var1:", $var1)
   Local $var2 = hex("12345678") ;Good, stays as needed for x32
   MsgBox(0, "var2:", $var2)
EndFunc

; http://www.autoitscript.com/forum/topic/139368-workaround-for-nomadmemory-in-windows-7-x64/
Func _NewMemRead($Addr1, $Proc1, $type1)
   If $type1 = "int" Then ;I only used int, if you use uint or any other integer representation, add them in here
	  Return (Dec(Hex(StringRegExpReplace(_MemoryRead($Addr1, $Proc1, $type1), "00000000", "", 1))))
   Else
	  Return _MemoryRead($Addr1, $Proc1, $type1)
   EndIf
EndFunc   ;==>_NewMemRead

Func _NewMemPointerRead($iv_Address, $ah_Handle, $av_offset)
   Return (Dec(Hex(StringRegExpReplace(_MemoryPointerRead($iv_Address, $ah_Handle, $av_Offset), "00000000", "", 1))))
EndFunc