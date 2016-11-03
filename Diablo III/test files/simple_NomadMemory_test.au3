;;================================================================================
;; PRE FUNCTIONS
;;================================================================================
;;--------------------------------------------------------------------------------
;;	Make sure you are running as admin, as in run SciTE Script Editor as admin!!
;;--------------------------------------------------------------------------------
$_debug = 1
#RequireAdmin
#AutoIt3Wrapper_UseX64=n
$Admin = IsAdmin()
If $Admin <> 1 Then
	MsgBox(0x30, "ERROR", "This program require administrative rights!")
	Exit
EndIf

;;--------------------------------------------------------------------------------
;;	Includes
;;--------------------------------------------------------------------------------
#include <NomadMemory.au3>
#include <math.au3>
#include <String.au3>
#include <Array.au3>

; get the Process ID
$process = "Tutorial-i386.exe"
$processID = ProcessExists($process)
If @error Then
	ConsoleWrite("Process does not exist! Error: " & @error & @LF)
EndIf

; Open the process in memory
Local $ce_tut = _MemoryOpen($processID)
If @Error Then
	ConsoleWrite("ERROR when opening ce_tut: " & @error & @LF)
	ConsoleWrite("ERROR processID: " & $processID & @LF)
	ConsoleWrite("ERROR ce_tut: " & $ce_tut & @LF)
    Exit
Else
	ConsoleWrite("ce_tut: " & $ce_tut & @LF)
EndIf

; save the Cheat Engine Tutorial Step 2 value's address to a variable
$addr = "0x0182F56C"
ConsoleWrite("Address of Step 2 value: " & $addr & @LF)

; Read mem at that address
$value = _MemoryRead($addr, $ce_tut)
If @Error Then
	ConsoleWrite("ERROR when reading " & $addr & ": " & @error & @LF)
 EndIf
ConsoleWrite("Value at " & $addr & ": " & $value & @LF)

; close handle
_MemoryClose($ce_tut)