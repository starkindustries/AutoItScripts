;;================================================================================
;;================================================================================
;;	Diablo 3 Movement and Interaction UDF 
;;  For personal study purposes only.
;;
;;================================================================================
;;================================================================================

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
if $Admin <> 1 Then
	MsgBox(0x30,"ERROR","This program require administrative rights!")
	Exit
EndIf

;;--------------------------------------------------------------------------------
;;	Includes
;;--------------------------------------------------------------------------------
#include <NomadMemory.au3>
#Include <math.au3>
#Include <String.au3>
#Include <Array.au3>
; AutoItSetOption("MustDeclareVars", 1) <======== FIX LATER!!!!!!!!!!!!!!


SeDebugPrivilege()
$sExecutable = 'Tutorial-i386.exe'
$hProcess = OpenProcess(ProcessExists($sExecutable))
MsgBox(0, '', _
ProcessModuleGetBaseAddress($hProcess, $sExecutable))
CloseHandle($hProcess)
Func SeDebugPrivilege()
Local $iTokenIndex = 1
Local $Struct = DllStructCreate('DWORD;int')
Local $TOKEN_PRIVILEGES = DllStructCreate('DWORD;DWORD[' & (3 * 1) & ']')
DllStructSetData($TOKEN_PRIVILEGES, 1, 1)
While $iTokenIndex <= 1
  Local $bPrivilegeValue = DllCall('advapi32.dll', _
    'BOOL', 'LookupPrivilegeValue', _
    'str', '', _
    'str', 'SeDebugPrivilege', _ ;SE_DEBUG_NAME
    'ptr', DllStructGetPtr($Struct))
  If $bPrivilegeValue[0] Then
   DllStructSetData($TOKEN_PRIVILEGES, 2, 0x00000002, (3 * $iTokenIndex)) ;SE_PRIVILEGE_ENABLED
   DllStructSetData($TOKEN_PRIVILEGES, 2, DllStructGetData($Struct, 1), (3 * ($iTokenIndex - 1)) + 1)
   DllStructSetData($TOKEN_PRIVILEGES, 2, DllStructGetData($Struct, 2), (3 * ($iTokenIndex - 1)) + 2)
   DllStructSetData($Struct, 1, 0)
   DllStructSetData($Struct, 2, 0)
  EndIf
  $iTokenIndex += 1
WEnd
Local $hCurrentProcess = DllCall('kernel32.dll', _
   'HANDLE', 'GetCurrentProcess')
Local $hProcessToken = DllCall('advapi32.dll', _
   'BOOL', 'OpenProcessToken', _
   'HANDLE', $hCurrentProcess[0], _
   'DWORD', 0x00000020 + 0x00000008, _ ;TOKEN_ADJUST_PRIVILEGES + TOKEN_QUERY
   'HANDLE*', '')
Local $NEWTOKEN_PRIVILEGES = DllStructCreate('DWORD;DWORD[' & (3 * 1) & ']')
DllCall('advapi32.dll', _
   'BOOL', 'AdjustTokenPrivileges', _
   'HANDLE', $hProcessToken[3], _
   'BOOL', False, _
   'ptr', DllStructGetPtr($TOKEN_PRIVILEGES), _
   'DWORD', DllStructGetSize($NEWTOKEN_PRIVILEGES), _
   'ptr', '', _
   'DWORD*', '')
DllCall('kernel32.dll', _
   'BOOL', 'CloseHandle', _
   'HANDLE', $hProcessToken[3])
EndFunc
Func OpenProcess($iProcessID)
Local $hProcess = DllCall('kernel32.dll', _
   'HANDLE', 'OpenProcess', _
   'DWORD', 0x1F0FFF, _ ;DesiredAccess = PROCESS_ALL_ACCESS
   'BOOL', True, _ ;InheritHandle = True
   'DWORD', $iProcessID)
Return $hProcess[0]
EndFunc
Func ProcessModuleGetBaseAddress($hProcess, $sModuleName)
Local $ModulesMax = DllStructCreate('ptr[1024]')
Local $iProcessModules = DllCall('psapi.dll', _
   'BOOL', 'EnumProcessModules', _
   'HANDLE', $hProcess, _
   'ptr', DllStructGetPtr($ModulesMax), _
   'DWORD', DllStructGetSize($ModulesMax), _
   'DWORD*', '')
Local $sModuleBaseName
For $i = 1 To $iProcessModules[4] / 4
  $sModuleBaseName = DllCall('psapi.dll', _
    'DWORD', 'GetModuleBaseNameW', _
    'HANDLE', $hProcess, _
    'ptr', DllStructGetData($ModulesMax, 1, $i), _
    'wstr', '', _
    'DWORD', 256)
  If $sModuleBaseName[3] = $sModuleName Then Return DllStructGetData($ModulesMax, 1, $i)
Next
EndFunc
Func CloseHandle($hProcess)
Local $bResult = DllCall('kernel32.dll', _
   'BOOL', 'CloseHandle', _
   'HANDLE', $hProcess)
Return $bResult[0]
EndFunc





