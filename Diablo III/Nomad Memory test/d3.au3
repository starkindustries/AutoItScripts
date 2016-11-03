;;================================================================================
;;================================================================================
;;	Diablo 3 Movement and Interaction UDF 
;;  For personal study purposes only.
;;
;;  By UnknOwned 2012
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
$Admin = IsAdmin() 
if $Admin <> 1 Then
	MsgBox(0x30,"ERROR","This program require administrative rights!")
	Exit
EndIf

;;--------------------------------------------------------------------------------
;;	Includes
;;--------------------------------------------------------------------------------
#include <NomadMemory.au3> ;THIS IS EXTERNAL, GET IT AT THE AUTOIT WEBSITE
#Include <math.au3>
#Include <String.au3>
#Include <Array.au3>

;;--------------------------------------------------------------------------------
;;	Open the process
;;--------------------------------------------------------------------------------
Opt("WinTitleMatchMode", -1)
SetPrivilege("SeDebugPrivilege", 1)
Global $ProcessID = WinGetProcess("Diablo III","")
Local $d3 = _MemoryOpen($ProcessID)
If @Error Then
	MsgBox(4096, "ERROR", "Failed to open memory for process;" & $ProcessID)
    Exit
EndIf

;;--------------------------------------------------------------------------------
;;	Initialize the offsets
;;--------------------------------------------------------------------------------
Offsetlist()


;;================================================================================
;; SAMPLE CODE
;;================================================================================


;//The following will display a list of all actors in the console
IterateObjectList(1)
Exit

;//The following will loot everything on the ground near you, including gold.
while 1
	$OBject = IterateObjectList(0)
	$foundobject = 0	
	for  $i = 0 to UBound ( $OBject ,1 )-1
		_ArraySort($OBject, 0 , 0 , 0 ,8)
		if $OBject[$i][6] = 2 and $OBject[$i][7] = -1 and $OBject[$i][1] <> 0xFFFFFFFF or StringInStr($OBject[$i][2],"GoldCoins") Then 
			InteractGUID($OBject[$i][1],0x7545)
			ConsoleWrite("GO")
			$foundobject = 1
			ExitLoop
		EndIf
	Next
	if $foundobject = 0 then ExitLoop
wend

;//The following will move your toon from where ever you are towards the priest.
;//This part will only work in tristram, if you are at the inn. 
;//This won't work if you have not moved in this session (do a click anywhere in the world to fix)
MoveToPos(2945,2809,24.04)
MoveToPos(2904,2803,24.04)

;//The following part will make you interact with the priest
;//Note that you can only interact with NPC's while the game window is active. (unless you spam the interact function once you are at the NPC)
$OBject = IterateObjectList(0)
$PriestIndex = _ArraySearch($OBject,"Priest_Male", 0 , 0 , 0 , 1 , 1 , 2)
InteractGUID($OBject[$PriestIndex][1],0x7546)
sleep(1000)
InteractGUID($OBject[$PriestIndex][1],0x7546)
Exit


;;================================================================================
;; FUNCTIONS
;;================================================================================
;;--------------------------------------------------------------------------------
;;	LocateMyToon()
;;--------------------------------------------------------------------------------
func LocateMyToon()
	if $_debug then ConsoleWrite("-----Looking for local player------" &@crlf)
	$_CurOffset = $_itrObjectManagerD
	$_Count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	for $i = 0 to $_Count step +1 
		$_GUID = _MemoryRead($_CurOffset+0x4, $d3, 'ptr')
		$_NAME = _MemoryRead($_CurOffset+0x8, $d3, 'char[64]')
		if $_GUID = 0x77BC0000 Then
			global $_Myoffset = $_CurOffset
			if $_debug then ConsoleWrite("My toon located at: " &$_Myoffset & ", GUID: " & $_GUID & ", NAME: " & $_NAME &@CRLF)
			ExitLoop
		EndIf
		$_CurOffset = $_CurOffset + $_ObjmanagerStrucSize
	Next
EndFunc	

;;--------------------------------------------------------------------------------
;;	OffsetList()
;;--------------------------------------------------------------------------------
func offsetlist()
   global $ofs_ObjectManager = 					0x01580A2C
   global $ofs__ObjmanagerActorOffsetA = 		0x8b0
   global $ofs__ObjmanagerActorCount = 			0x108
   global $ofs__ObjmanagerActorOffsetB = 		0x148
   global $ofs__ObjmanagerActorLinkToCTM = 		0x380
   global $_ObjmanagerStrucSize = 				0x428	

   global $_itrObjectManagerA  		= _MemoryRead($ofs_ObjectManager, $d3, 'ptr')		
   global $_itrObjectManagerB  		= _MemoryRead($_itrObjectManagerA+$ofs__ObjmanagerActorOffsetA, $d3, 'ptr')	
   global $_itrObjectManagerCount	= $_itrObjectManagerB+$ofs__ObjmanagerActorCount
   global $_itrObjectManagerC  		= _MemoryRead($_itrObjectManagerB+$ofs__ObjmanagerActorOffsetB, $d3, 'ptr')	
   global $_itrObjectManagerD  		= _MemoryRead($_itrObjectManagerC, $d3, 'ptr')	
   global $_itrObjectManagerE  		= _MemoryRead($_itrObjectManagerD, $d3, 'ptr')	



   global $ofs_Interact = 					0x01580A14
   global $ofs__InteractOffsetA = 			0xA8
   global $ofs__InteractOffsetB = 			0x58
   global $ofs__InteractOffsetUNK1 = 		0x7F20 ;Set to 777c
   global $ofs__InteractOffsetUNK2 = 		0x7F44 ;Set to 1 for NPC interaction
   global $ofs__InteractOffsetUNK3 = 		0x7F7C ;Set to 7546 for NPC interaction, 7545 for loot interaction
   global $ofs__InteractOffsetUNK4 = 		0x7F80 ;Set to 7546 for NPC interaction, 7545 for loot interaction
   global $ofs__InteractOffsetMousestate = 	0x7F84 ;Mouse state 1 = clicked, 2 = mouse down
   global $ofs__InteractOffsetGUID = 		0x7F88 ;Set to the GUID of the actor you want to interact with


   global $_itrInteractA  = _MemoryRead($ofs_Interact, $d3, 'ptr')	
   global $_itrInteractB  = _MemoryRead($_itrInteractA, $d3, 'ptr')	
   global $_itrInteractC  = _MemoryRead($_itrInteractB, $d3, 'ptr')	
   global $_itrInteractD  = _MemoryRead($_itrInteractC+$ofs__InteractOffsetA, $d3, 'ptr')	
   global $_itrInteractE  = $_itrInteractD+$ofs__InteractOffsetB

   $FixSpeed = 0x20 ;69736
   $ToggleMove = 0x34
   $MoveToXoffset = 0x3c
   $MoveToYoffset = 0x40
   $MoveToZoffset = 0x44
   $CurrentX = 0xA4
   $CurrentY = 0xA8
   $CurrentZ = 0xAc
   $RotationOffset = 0x170

   LocateMyToon()
   #cs
   global $ClickToMoveMain = _MemoryRead($_Myoffset + $ofs__ObjmanagerActorLinkToCTM, $d3, 'ptr')
   global $ClickToMoveRotation = $ClickToMoveMain + $RotationOffset
   global $ClickToMoveCurX = $ClickToMoveMain + $CurrentX
   global $ClickToMoveCurY = $ClickToMoveMain + $CurrentY
   global $ClickToMoveCurZ = $ClickToMoveMain + $CurrentZ
   global $ClickToMoveToX = $ClickToMoveMain + $MoveToXoffset
   global $ClickToMoveToY = $ClickToMoveMain + $MoveToYoffset
   global $ClickToMoveToZ = $ClickToMoveMain + $MoveToZoffset
   global $ClickToMoveToggle = $ClickToMoveMain + $ToggleMove
   global $ClickToMoveFix= $ClickToMoveMain + $FixSpeed
   #ce	
	
EndFunc

;;--------------------------------------------------------------------------------
;;	GetCurrentPos()
;;--------------------------------------------------------------------------------
Func GetCurrentPos()
	dim $return[3]
	$return[0] = _MemoryRead($ClickToMoveCurX, $d3, 'float')
	$return[1] = _MemoryRead($ClickToMoveCurY, $d3, 'float')
	$return[2] = _MemoryRead($ClickToMoveCurZ, $d3, 'float')
	return $return
EndFunc

;;--------------------------------------------------------------------------------
;;	MoveToPos()
;;--------------------------------------------------------------------------------
func MoveToPos($_x,$_y,$_z)
	_MemoryWrite($ClickToMoveToX , $d3,$_x, 'float')
	_MemoryWrite($ClickToMoveToY , $d3,$_y, 'float')
	_MemoryWrite($ClickToMoveToZ , $d3,$_z, 'float')
	_MemoryWrite($ClickToMoveToggle , $d3,1, 'int')
	_MemoryWrite($ClickToMoveFix , $d3,69736, 'int')

	while 1
		$CurrentLoc = GetCurrentPos()
		$xd = $_x-$CurrentLoc[0]
		$yd = $_y-$CurrentLoc[1]
		$zd = $_z-$CurrentLoc[2]
		$Distance = Sqrt($xd*$xd + $yd*$yd + $zd*$zd)	
		if $Distance < 2 then ExitLoop
		if _MemoryRead($ClickToMoveToggle, $d3, 'float') = 0 then ExitLoop
		sleep(10)
	WEnd
EndFunc						
		
;;--------------------------------------------------------------------------------
;;	InteractGUID()
;;--------------------------------------------------------------------------------
func InteractGUID($_guid,$_snoPower)
	$FixSpeed = 0x20 ;69736
	$ToggleMove = 0x34
	$MoveToXoffset = 0x3c
	$MoveToYoffset = 0x40
	$MoveToZoffset = 0x44
	$CurrentX = 0xA4
	$CurrentY = 0xA8
	$CurrentZ = 0xAc
	$RotationOffset = 0x170
	global $ClickToMoveRotation = $ClickToMoveMain + $RotationOffset
	global $ClickToMoveCurX = $ClickToMoveMain + $CurrentX
	global $ClickToMoveCurY = $ClickToMoveMain + $CurrentY
	global $ClickToMoveCurZ = $ClickToMoveMain + $CurrentZ
	global $ClickToMoveToX = $ClickToMoveMain + $MoveToXoffset
	global $ClickToMoveToY = $ClickToMoveMain + $MoveToYoffset
	global $ClickToMoveToZ = $ClickToMoveMain + $MoveToZoffset
	global $ClickToMoveToggle = $ClickToMoveMain + $ToggleMove
	global $ClickToMoveFix= $ClickToMoveMain + $FixSpeed	
		$CurrentLocX = _MemoryRead($ClickToMoveCurX, $d3, 'float')
		$CurrentLocY = _MemoryRead($ClickToMoveCurY, $d3, 'float')
		$CurrentLocZ = _MemoryRead($ClickToMoveCurZ, $d3, 'float')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK1 , $d3, 0x777C, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK2 , $d3, 0x1, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK3 , $d3, $_snoPower, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetUNK4 , $d3, $_snoPower, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetMousestate , $d3, 0x1, 'ptr')
	_MemoryWrite($_itrInteractE+$ofs__InteractOffsetGUID , $d3, $_guid, 'ptr')	
		_MemoryWrite($ClickToMoveToX , $d3,$CurrentLocX+1, 'float')
		_MemoryWrite($ClickToMoveToY , $d3,$CurrentLocY, 'float')
		_MemoryWrite($ClickToMoveToZ , $d3,$CurrentLocZ, 'float')
		_MemoryWrite($ClickToMoveToggle , $d3,1, 'int')
		_MemoryWrite($ClickToMoveFix , $d3,69736, 'int')	

	$tempvalue = _MemoryRead($_itrInteractE+$ofs__InteractOffsetUNK2, $d3, 'int')
	while $tempvalue = 1
		$tempvalue = _MemoryRead($_itrInteractE+$ofs__InteractOffsetUNK2, $d3, 'int')
		sleep(10)
	WEnd
EndFunc
	
;;--------------------------------------------------------------------------------
;;	IterateObjectList()
;;--------------------------------------------------------------------------------
func IterateObjectList($_displayINFO)
	if $_displayINFO = 1 then ConsoleWrite("-----Iterating through Actors------" &@crlf)
	if $_displayINFO = 1 then ConsoleWrite("First Actor located at: "&$_itrObjectManagerD &@crlf)
	$_CurOffset = $_itrObjectManagerD
	$_Count = _MemoryRead($_itrObjectManagerCount, $d3, 'int')
	dim $OBJ[$_Count+1][9]
	if $_displayINFO = 1 then ConsoleWrite("Number of Actors : " & $_Count &@crlf)
	for $i = 0 to $_Count step +1 
		$_GUID = _MemoryRead($_CurOffset+0x4, $d3, 'ptr')
		$_NAME = _MemoryRead($_CurOffset+0x8, $d3, 'char[64]')
		$_POS_X = _MemoryRead($_CurOffset+0xB0, $d3, 'float')	
		$_POS_Y = _MemoryRead($_CurOffset+0xB4, $d3, 'float')	
		$_POS_Z = _MemoryRead($_CurOffset+0xB8, $d3, 'float')	
		$_DATA = _MemoryRead($_CurOffset+0x1FC, $d3, 'int')
		$_DATA2 = _MemoryRead($_CurOffset+0x1Cc, $d3, 'int')		
		$_DATA3 = _MemoryRead($_CurOffset+0x1C0, $d3, 'int')		
		
		$CurrentLoc = GetCurrentPos()
		$xd = $_POS_X-$CurrentLoc[0]
		$yd = $_POS_Y-$CurrentLoc[1]
		$zd = $_POS_Z-$CurrentLoc[2]
		$Distance = Sqrt($xd*$xd + $yd*$yd + $zd*$zd)
			$OBJ[$i][0] = $i
			$OBJ[$i][1] = $_GUID
			$OBJ[$i][2] = $_NAME
			$OBJ[$i][3] = $_POS_X
			$OBJ[$i][4] = $_POS_Y
			$OBJ[$i][5] = $_POS_Z
			$OBJ[$i][6] = $_DATA
			$OBJ[$i][7] = $_DATA2
			$OBJ[$i][8] = $Distance
		
		if $_displayINFO = 1 then ConsoleWrite($i & @TAB&" : " & $_CurOffset & " " & $_GUID & " : " & $_DATA & " "& $_DATA2 & " " & @TAB& $_POS_X &" "& $_POS_Y&" "& $_POS_Z & @TAB& $_NAME &@crlf)
		$_CurOffset = $_CurOffset + $_ObjmanagerStrucSize
	Next
	return $OBJ
EndFunc