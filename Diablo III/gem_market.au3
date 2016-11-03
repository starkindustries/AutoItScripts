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
$process = "Diablo III.exe"
$processID = ProcessExists($process)
If @error Then
	ConsoleWrite("Process does not exist! Error: " & @error & @LF)
EndIf

; Open the process in memory
Local $d3 = _MemoryOpen($processID)
If @Error Then
	ConsoleWrite("ERROR when opening $d3: " & @error & @LF)
	ConsoleWrite("ERROR processID: " & $processID & @LF)
	ConsoleWrite("ERROR $d3: " & $d3 & @LF)
    Exit
Else
	ConsoleWrite("$d3: " & $d3 & @LF)
EndIf

; save the Cheat Engine Tutorial Step 2 value's address to a variable
$addr = "0x1FBA7C60"
ConsoleWrite("Address of Gem: " & $addr & @LF)

; Read mem at that address
$value = _MemoryRead($addr, $d3)
If @Error Then
	ConsoleWrite("ERROR when reading " & $addr & ": " & @error & @LF)
EndIf
ConsoleWrite("Value at " & $addr & ": " & $value & @LF)

; close handle
_MemoryClose($d3)