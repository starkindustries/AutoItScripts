Global $Paused 
Global $DebugOn = True
Global $runCount = 0
;0,8130952380952381 , 0,7314285714285714
 HotKeySet("=","Leave")
 HotKeySet("-", "Pause")
 HotKeySet("x", "Stop")

 $default_resolutionX = 1680
 $default_resolutionY = 1050
 $x_ratio = @Desktopwidth / $default_resolutionX
 $y_ratio = @Desktopheight / $default_resolutionY
 
 

$Ruby = 0xB01D2D
$Emerald = 0x58EE33
$Amethyst = 0xA56DF1
$Topaz = 0xFFF02F

$Yellow = 0xFFFF00 ;rare color code
$Blue = 0x6969FF ;blue color code 
$Orange = 0xBF642F ;legendary color code
$Green = 0x00FF00 ;SET color

$Left = 64
$Top = 42
$Right = 720
$Bottom = 519

$timeBetweenGames = 20000 ; + Random(10000, 20000) 

; item levels and variables of manipulation items on stash or vendor
$YellowItem = 0
$OrangeItem = 0 
$GreenItem = 0
$BlueItem = 0
;gem levels and variables of manipulation on stash drop
$EmeraldGem = 0
$TopazGem = 0
$RubyGem = 0
$AmethystGem = 0

$go = True
$Leave = False



 
While $go
	
	
	 if($Leave) Then
		$Pixel1 = PixelSearch((1482 * $x_ratio),(20 * $y_ratio),(1535 * $x_ratio),(95 * $y_ratio),0xFFF000) ;searches top right screen for yellow of broken armor
		 If Not @error Then
			 Send("t")
			 Sleep(8000)
			 MouseClick("left", Round(1480 * $x_ratio),Round(281 * $y_ratio));begin movement towards merchant
			 Sleep(1500)
			 MouseClick("left", Round(1316 * $x_ratio),Round(206 * $y_ratio)) ;moves to get merchant in screen
			 Sleep(1500)
			 MouseClick("left", Round(845 * $x_ratio),Round(225 * $y_ratio)) ;NPC Merchant to the right of cain's home
			 Sleep(1500)
			 MouseClick("left", Round(521 * $x_ratio),Round(506 * $y_ratio)) ;button to open up repair menu
			 Sleep(1500)
			 MouseClick("left", Round(260 * $x_ratio),Round(595 * $y_ratio)) ;button to pay for repairs 
			 Sleep(2500)
			 Send("{ESCAPE}") ;opens menu
			 Sleep(1000)
			 MouseClick("left", Round(841 * $x_ratio),Round(579 * $y_ratio)) ;button to leave game
			 Sleep(5500)
			 MouseClick("left", Round(875 * $x_ratio),Round(612 * $y_ratio)) ; dissmiss message
			 SLeep(500)
			 MouseClick("left", Round(1442 * $x_ratio),Round(112 * $y_ratio)) ;
			 Sleep(1500)
			 
			 Sleep(500)
			 Sleep($timeBetweenGames)
			 MouseClick("left", Round(230 * $x_ratio),Round(416 * $y_ratio)) ;button to resume game from main menu
			 Sleep(500)
			 
			 Sleep(4500)
			 
		 Else
			 MouseClick("right")
			 
			 Sleep(800)
			 
			 
			 MouseClick("middle", Round(498 * $x_ratio),Round(234 * $y_ratio)) ;starts the main run -- i'm used MIDDLE MOUSE CLICK for not to attack enemys
			 Sleep(2000)
			 MouseClick("middle", Round(128 * $x_ratio),Round(245 * $y_ratio)) ;-- i'm used MIDDLE MOUSE CLICK for not to attack enemys
			 Sleep(2700)
			 MouseClick("middle", Round(21 * $x_ratio),Round(508 * $y_ratio)) ;--  i'm used MIDDLE MOUSE CLICK for not to attack enemys
			 Sleep(2500)
			 MouseMove(Round(124 * $x_ratio),Round(223 * $y_ratio),1) ;moves cursor over to the CELLAR so the proper blue pixel becomes
			 
			 Sleep(1000)
			 $Pixel2 = PixelSearch(10,150,(200 * $x_ratio),(288 * $y_ratio),0x3B62E3,5) ;searches for the specific blue pixel that only occurs when mouse hovers over open CELLAR
			  If Not @error Then
				 
				 MouseClick("left",Round(124 *$x_ratio),Round(223 * $y_ratio)) ;CLICKED TO enter the CELLAR
				 
				 Sleep(5000)
				 MouseClick("middle",Round(60 *$x_ratio),Round(962 * $y_ratio)) ;Entrance to CELLAR -- i'm used MIDDLE MOUSE CLICK for not to interact with enemys
				 Sleep(1400)
				 
				 Send("w")
				 Sleep(900)
				 MouseClick("middle",Round(441 *$x_ratio),Round(185 * $y_ratio)) ; -- i'm used MIDDLE MOUSE CLICK for not to attack enemys
				 Sleep(1800)
				 
				 MouseClick("right")
				 Send("q")
				 Send("e")
				 Send("{SHIFTDOWN}")
				 MouseClick("left",Round(741 *$x_ratio),Round(448 * $y_ratio)) ; USE seven-sided strike (monk skill)
				 Sleep(20)
				 Send("{SHIFTUP}")
				 Send("r")
				 Send("e")
				 Sleep(6200)
				 
				 MouseClick("left",Round(496 *$x_ratio),Round(586 * $y_ratio)) ;moves left down
				 Sleep(2000)
				 MouseClick("left",Round(1282 *$x_ratio),Round (179 * $y_ratio)) ;moves left up
				 Sleep(1500)
				 Send("e")
				 MouseClick("right")
				 Sleep(1500)
				 MouseClick("middle",Round(696 *$x_ratio),Round (940 * $y_ratio)) ;moves right up
				 Sleep(2200)
				 MouseClick("middle",Round(507 *$x_ratio),Round (877 * $y_ratio)) ;moves right up
				 Sleep(1600)
				 MouseClick("middle",Round(1387 *$x_ratio),Round (127 * $y_ratio)) ;moves right up
				 Sleep(2600)
				 MouseClick("left",Round(351 *$x_ratio),Round (664 * $y_ratio)) ;moves right up
				 Sleep(1600)
				 
				 MouseClick("right")
				 FindItemSlow()
				 
				 Send("z")
				 Finditemfast()
				 Send("z")
				 Send("q")
				 Send("w")
				 Send("r")
				 
				 Send("t")
				 Sleep(8500)
				 
				 if $runCount > 11 then
				 Town()
				 Send("{SPACE}") ;close all windows
				 $runCount = 0
					else
				 endif
				 
				 
				 
				 Send("{Escape}") ;menu
				 Sleep(200)
				 MouseClick("left",Round(841 * $x_ratio),Round(566 * $y_ratio)) ;button to leave game
				 Sleep(2700)
				 
				 MouseClick("left", Round(875 * $x_ratio),Round(612 * $y_ratio)) ; dissmis message
				 SLeep(4500)
				 Send("{F8}")
				 SLeep(500)
				 MouseClick("left", Round(1442 * $x_ratio),Round(112 * $y_ratio)) ;

				 Sleep($timeBetweenGames)
				 MouseClick("left",Round(230 * $x_ratio),Round(416 * $y_ratio)) ;button to resume game from main menu
				 Sleep(500)
			     
				 Sleep(7000)
				 $runCount = $runCount +1
			 Else
				 MouseClick("left",Round(900 * $x_ratio),Round(900 * $y_ratio)) ;moves down screen away from CELLAR in attempt for safety before teleporting back to town
				  Send("e")
				 Sleep(1200)
				 Send("w")
				 Send("e")
				 Send("q")
				 Send("r")
				 Sleep(200)
				 Send("{ESCAPE}") ;menu
				 MouseClick("left",Round(841 * $x_ratio),Round(579 * $y_ratio)) ;button to leave game
				 Sleep(14500)
				 MouseClick("left", Round(875 * $x_ratio),Round(612 * $y_ratio)) ; dissmis message
				 Sleep(400)
				 MouseClick("left", Round(1442 * $x_ratio),Round(112 * $y_ratio)) ; 
				 Sleep($timeBetweenGames)
				 MouseClick("left",Round(230 * $x_ratio),Round(416 * $y_ratio)) ;button to resume game from main menu
				 
				 
				 Sleep(7000)
				 
			 EndIf
		 EndIf
	 EndIf
		$YellowItem = 0
		$OrangeItem = 0 
		$GreenItem = 0
		$BlueItem = 0
		
		$EmeraldGem = 0
		$TopazGem = 0
		$RubyGem = 0
		$AmethystGem = 0
 WEnd

 Func Pause()
 $Leave = False	
   
EndFunc   ;==>Pause


Func Town()

   MouseClick("left",Round(1247 * $x_ratio),Round(105 * $y_ratio))		;go to vendor nearly Decard Cain
   Sleep(2800)
   MouseClick("left",Round(1137 * $x_ratio),Round(130 * $y_ratio))		;go to vendor nearly Decard Cain
   Sleep(2300)
   
   SellItemPixelMap()
   Sleep(200)
   
   MouseClick("left",Round(601 * $x_ratio),Round(852 * $y_ratio))		;go to vendor nearly Decard Cain
   Sleep(2000)
   
   MouseClick("left",Round(93 * $x_ratio),Round(920 * $y_ratio))		;go to vendor nearly Decard Cain
   Sleep(2800)
   
   DepositRarePixelMap()
   	
EndFunc








Func SellBlue()
   
   ; selling blue items to vendor
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x141E3A )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; more blue color
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x223E5D )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; more blue color
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x101421 )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; more blue color
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x18223D )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; more blue color
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x0E16C3 )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; more blue color
   $Searching = True
   while $Searching
	  $BlueItemVendor = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x04047E )			
	  if Not @error Then
		 MouseClick("right", $BlueItemVendor[0], $BlueItemVendor[1])
		 Sleep(500)
	  Else
		 $Searching = False
	  EndIf
  WEnd
EndFunc


Func SellItemPixelMap()
   ;$LogItemGet = FileOpen("C:\Users\ArthurMelo\Desktop\d3ItemGetLog.txt", 1)
  
   
   ;$line = [1208	1257	1303	1351	1398	1445	1491	1538	1586	1632]
   ;$collum = [594 639 686 732 779 827 ]
  ; $matrizInventory = $line*$collum
   

  ; For $count = 1 to 60
;		Sleep(50)
;		MouseClick("right", (StringLeft($matrizInventory[$count] , 4) * $x_ratio),(StringRight($matrizInventory[$count] , 3) * $y_ratio))
;		Sleep(50)
;		FileWrite($LogItemGet, StringLeft($matrizInventory[$count] , 4) & "," (StringRight($matrizInventory[$count] , 3)))
;	next
   
   
   
    ; selling blue and white items 
   ;slot 1
MouseClick("right", (1208 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 2 
MouseClick("right", (1257 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 3
MouseClick("right", (1303 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 4
MouseClick("right", (1351 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 5
MouseClick("right", (1398 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 6
MouseClick("right", (1445 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 7
MouseClick("right", (1491 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 8
MouseClick("right", (1538 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 9
MouseClick("right", (1586 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 10
MouseClick("right", (1632 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 11
MouseClick("right", (1208 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 12
MouseClick("right", (1257 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 13
MouseClick("right", (1303 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 14
MouseClick("right", (1351 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 15
MouseClick("right", (1398 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 16
MouseClick("right", (1445 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 17
MouseClick("right", (1491 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 18
MouseClick("right", (1538 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 19
MouseClick("right", (1586 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 20
MouseClick("right", (1632 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 21
MouseClick("right", (1208 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 22
MouseClick("right", (1257 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 23
MouseClick("right", (1303 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 24
MouseClick("right", (1351 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 25
MouseClick("right", (1398 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 26
MouseClick("right", (1445 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 27
MouseClick("right", (1491 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 28
MouseClick("right", (1538 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 29
MouseClick("right", (1586 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 30
MouseClick("right", (1632 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 31
 ;TOME OF SECRETS
;slot 32
MouseClick("right", (1257 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 33
MouseClick("right", (1303 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 34
MouseClick("right", (1351 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 35
MouseClick("right", (1398 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 36
MouseClick("right", (1445 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 37
MouseClick("right", (1491 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 38
MouseClick("right", (1538 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 39
MouseClick("right", (1586 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 40
MouseClick("right", (1632 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 41

;RUBY

;slot 42

;AMETYST

;slot 43

;EMERALD

;slot 44

;TOPAZ

;slot 45

MouseClick("right", (1398 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 46
MouseClick("right", (1445 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 47
MouseClick("right", (1491 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 48
MouseClick("right", (1538 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 49
MouseClick("right", (1586 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 50
MouseClick("right", (1632 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 51

;RUBY

;slot 52

;AMETYST

;slot 53

;EMERALD

;slot 54

;TOPAZ

;slot 55
MouseClick("right", (1398 * $x_ratio),(827 *  $y_ratio))
	   Sleep(80)
;slot 56
MouseClick("right", (1445 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 57
MouseClick("right", (1491 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 58
MouseClick("right", (1538 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 59
MouseClick("right", (1586 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 60
MouseClick("right", (1632 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)

	   
	   
   MouseClick("left",Round(506 * $x_ratio),Round(483 * $y_ratio))		;click repair tab
   Sleep(200)
   MouseClick("left",Round(242 * $x_ratio),Round(528 * $y_ratio))		;click repair
   Sleep(200)
   Send("{SPACE}") ;close windows
   
   
	   
EndFunc



Func DepositRarePixelMap()

MouseClick("right", (1208 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 2 
MouseClick("right", (1257 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 3
MouseClick("right", (1303 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 4
MouseClick("right", (1351 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 5
MouseClick("right", (1398 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 6
MouseClick("right", (1445 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 7
MouseClick("right", (1491 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 8
MouseClick("right", (1538 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 9
MouseClick("right", (1586 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 10
MouseClick("right", (1632 * $x_ratio),(594 * $y_ratio))
	   Sleep(80)
;slot 11
MouseClick("right", (1208 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 12
MouseClick("right", (1257 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 13
MouseClick("right", (1303 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 14
MouseClick("right", (1351 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 15
MouseClick("right", (1398 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 16
MouseClick("right", (1445 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 17
MouseClick("right", (1491 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 18
MouseClick("right", (1538 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 19
MouseClick("right", (1586 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 20
MouseClick("right", (1632 * $x_ratio),(639 * $y_ratio))
	   Sleep(80)
;slot 21
MouseClick("right", (1208 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 22
MouseClick("right", (1257 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 23
MouseClick("right", (1303 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 24
MouseClick("right", (1351 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 25
MouseClick("right", (1398 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 26
MouseClick("right", (1445 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 27
MouseClick("right", (1491 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 28
MouseClick("right", (1538 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 29
MouseClick("right", (1586 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 30
MouseClick("right", (1632 * $x_ratio),(686 * $y_ratio))
	   Sleep(80)
;slot 31
 ;TOME OF SECRETS
;slot 32
MouseClick("right", (1257 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 33
MouseClick("right", (1303 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 34
MouseClick("right", (1351 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 35
MouseClick("right", (1398 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 36
MouseClick("right", (1445 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 37
MouseClick("right", (1491 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 38
MouseClick("right", (1538 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 39
MouseClick("right", (1586 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 40
MouseClick("right", (1632 * $x_ratio),(732 * $y_ratio))
	   Sleep(80)
;slot 41

;RUBY

;slot 42

;AMETYST

;slot 43

;EMERALD

;slot 44

;TOPAZ

;slot 45

MouseClick("right", (1398 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 46
MouseClick("right", (1445 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 47
MouseClick("right", (1491 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 48
MouseClick("right", (1538 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 49
MouseClick("right", (1586 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 50
MouseClick("right", (1632 * $x_ratio),(779 * $y_ratio))
	   Sleep(80)
;slot 51

;RUBY

;slot 52

;AMETYST

;slot 53

;EMERALD

;slot 54

;TOPAZ

;slot 55
MouseClick("right", (1398 * $x_ratio),(827 *  $y_ratio))
	   Sleep(80)
;slot 56
MouseClick("right", (1445 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 57
MouseClick("right", (1491 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 58
MouseClick("right", (1538 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 59
MouseClick("right", (1586 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
;slot 60
MouseClick("right", (1632 * $x_ratio),(827 * $y_ratio))
	   Sleep(80)
   Send("{SPACE}") ;close windows
EndFunc


Func DepositRare()
   $LogItemGet = FileOpen("C:\Users\ArthurMelo\Desktop\d3ItemGetLog.txt", 1)
   ;search for yellow itens on inventory
   $Searching = True
   while $Searching
   
	  $YellowInInventory = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x4B3B08)	
	  if Not @error Then
		 MouseClick("right", $YellowInInventory[0], $YellowInInventory[1])
		 
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
   
   ; yellow color 2
   $Searching = True
   while $Searching
	  $YellowInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x5B4B10 )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory2[0], $YellowInInventory2[1])
		 
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
WEnd

   ; yellow color 3
   $Searching = True
   while $Searching
	  $YellowInInventory3 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x45360B )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory3[0], $YellowInInventory3[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; yellow color 4
   $Searching = True
   while $Searching
	  $YellowInInventory4 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x433509 )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory4[0], $YellowInInventory4[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; yellow color 5
   $Searching = True
   while $Searching
	  $YellowInInventory5 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x78700B )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory5[0], $YellowInInventory5[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; yellow color 6
   $Searching = True
   while $Searching
	  $YellowInInventory6 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x645812 )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory6[0], $YellowInInventory6[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  ; yellow color 7
   $Searching = True
   while $Searching
	  $YellowInInventory7 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x4D3F0E )			
	  if Not @error Then
		 MouseClick("right", $YellowInInventory7[0], $YellowInInventory7[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "YELLOW ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ;orange  color 1
   $Searching = True
   while $Searching
	  $OrangeInInventory = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xFF7F00 )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory[0], $OrangeInInventory[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; orange  color 2
   $Searching = True
   while $Searching
	  $OrangeInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x4C280D )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory2[0], $OrangeInInventory2[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; orange  color 3
   $Searching = True
   while $Searching
	  $OrangeInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xA85604 )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory2[0], $OrangeInInventory2[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; orange  color 4
   $Searching = True
   while $Searching
	  $OrangeInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x261407 )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory2[0], $OrangeInInventory2[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ; orange  color 5
   $Searching = True
   while $Searching
	  $OrangeInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x4F2D0F )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory2[0], $OrangeInInventory2[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  ;orange  color 6
   $Searching = True
   while $Searching
	  $OrangeInInventory2 = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x8E5112 )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory2[0], $OrangeInInventory2[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "ORANGE ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  
  
  ;green color 1
   $Searching = True
   while $Searching
	  $OrangeInInventory = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x00FF00,3 )			
	  if Not @error Then
		 MouseClick("right", $OrangeInInventory[0], $OrangeInInventory[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "GREEN ITEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  FileWrite($LogItemGet, "====================================================== " &@LF &@LF)
  FileClose($LogItemGet)
   
  EndFunc




Func DropInChestMyCheeeeepedDjemssss()
$LogItemGet = FileOpen("C:\Users\ArthurMelo\Desktop\d3ItemGetLog.txt", 1)

   ; Tome of secret
   $Searching = True
   while $Searching
   
	  $PixelTomeSecrets = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x56110F )			
	  if Not @error Then
		 MouseClick("right", $PixelTomeSecrets[0], $PixelTomeSecrets[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "TOME OF SECRETS ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  
   ; Yellow gems
   $Searching = True
   while $Searching
	  $PixelYellowGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xce8200 )			
	  if Not @error Then
		 MouseClick("right", $PixelYellowGem[0], $PixelYellowGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "TOPAZ GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; Yellow gems
   $Searching = True
   while $Searching
	  $PixelYellowGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xc17900 )			
	  if Not @error Then
		 MouseClick("right", $PixelYellowGem[0], $PixelYellowGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "TOPAZ GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  
   ; Green gems
   $Searching = True
   while $Searching
	  $PixelGreenGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x319e31 )			
	  if Not @error Then
		 MouseClick("right", $PixelGreenGem[0], $PixelGreenGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "EMERALD GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; Green gems
   $Searching = True
   while $Searching
	  $PixelGreenGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x3db835 )			
	  if Not @error Then
		 MouseClick("right", $PixelGreenGem[0], $PixelGreenGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "EMERALD GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  
   ; Red gems
   $Searching = True
   while $Searching
	  $PixelRedGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xf01d1f)			
	  if Not @error Then
		 MouseClick("right", $PixelRedGem[0], $PixelRedGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "RUBY GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; Red gems
   $Searching = True
   while $Searching
	  $PixelRedGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xe90b0b)			
	  if Not @error Then
		 MouseClick("right", $PixelRedGem[0], $PixelRedGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "RUBY GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
  
   ; Purple gems
   $Searching = True
   while $Searching
	  $PixelPurpledGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0x9905db )			
	  if Not @error Then
		 MouseClick("right", $PixelPurpledGem[0], $PixelPurpledGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "AMETYST GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
  
   ; Purple gems
   $Searching = True
   while $Searching
	  $PixelPurpledGem = PixelSearch((1183 * $x_ratio),(566 * $y_ratio),(1664 * $x_ratio),(852 * $y_ratio),0xb110f7 )			
	  if Not @error Then
		 MouseClick("right", $PixelPurpledGem[0], $PixelPurpledGem[1])
		 Sleep(500)
		 FileWrite($LogItemGet, "AMETYST GEM FOUND ---- " & @MDAY &"/"& @MON&"/"&@YEAR&" - "& @HOUR & ":" & @MIN  & @LF )
	  Else
		 $Searching = False
	  EndIf
  WEnd
   
   FileWrite($LogItemGet, "====================================================== "&@LF&@LF)
    FileClose($LogItemGet)
EndFunc




Func FindItemSlow()
 ;itemlog for drops and salvage items and gem drops ....
	Sleep(500)
	Send("{ALTDOWN}")
	Send("{ALTUP}")
	$work = 1
	$checkCount = 0
	$x1 = 362
	$y1 = 146
	$x2 = 1566
	$y2 = 869
	
	$sleepTimeBetweenCollectDrops = 1800
	
   While $work == 1  And $checkCount <10
     
     $work = 0
	 
     $PixelBlue = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Blue,3) ;searches for BLUE itens on the flor
     If Not @error Then
       MouseClick("left", $PixelBlue[0], $PixelBlue[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
	
	   $BlueItem = $BlueItem + 1
	   $checkCount = $checkCount +1
     EndIf
		Send("{ALTDOWN}")
		Send("{ALTUP}")
		$PixelYellow = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Yellow,3) ;searches for YELLOW itens on the flor
     If Not @error Then 
       MouseClick("left", $PixelYellow[0], $PixelYellow[1], 1, 10) ;clicks magic
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $YellowItem = $YellowItem +1
	   $checkCount = $checkCount +1
     EndIf
		Send("{ALTDOWN}")
		Send("{ALTUP}")
		$PixelOrange = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Orange,3) ;searches for ORANGE itens on the flor OH YEAH!
     If Not @error Then
       MouseClick("left", $PixelOrange[0], $PixelOrange[1], 1, 10) ;clicks legendary
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $OrangeItem = $OrangeItem +1
	   $checkCount = $checkCount +1
     EndIf 
		 Send("{ALTDOWN}")
		 Send("{ALTUP}")
		 $PixelGreen = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Green,3) ;searches for GREEN itens on the flor OH YEAH 2 !!!
     If Not @error Then
       MouseClick("left", $PixelGreen[0], $PixelGreen[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $GreenItem = $GreenItem +1
	   $checkCount = $checkCount +1
     EndIf
     ; search for gems

     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Amethyst,9) ;searches for AMETHYST GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $AmethystGem = $AmethystGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio), $Ruby,6) ;searches for RUBY GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $RubyGem = $RubyGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Topaz,11) ;searches for TOPAZ GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $TopazGem = $TopazGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Emerald,11) ;searches for EMERALD GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $EmeraldGem = $EmeraldGem +1
	   $checkCount = $checkCount +1
     EndIf
   WEnd  
   DEBUG("Finish Item Searching")
EndFunc



Func FindItemFast()
 
	Send("{ALTDOWN}")
	Send("{ALTUP}")
	$work = 1
	$checkCount = 0
	$sleepTimeBetweenCollectDrops = 1200
	
	$x1 = 14
	$y1 = 342
	$x2 = 1586
	$y2 = 866
	
	
   While $work == 1  And $checkCount <6
     
     $work = 0
	 
     $PixelBlue = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Blue,3) ;searches for BLUE itens on the flor
     If Not @error Then
       MouseClick("left", $PixelBlue[0], $PixelBlue[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
	
	   $BlueItem = $BlueItem + 1
	   $checkCount = $checkCount +1
     EndIf
		Send("{ALTDOWN}")
		Send("{ALTUP}")
		$PixelYellow = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Yellow,3) ;searches for YELLOW itens on the flor
     If Not @error Then 
       MouseClick("left", $PixelYellow[0], $PixelYellow[1], 1, 10) ;clicks magic
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $YellowItem = $YellowItem +1
	   $checkCount = $checkCount +1
     EndIf
		Send("{ALTDOWN}")
		Send("{ALTUP}")
		$PixelOrange = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Orange,1) ;searches for ORANGE itens on the flor OH YEAH!
     If Not @error Then
       MouseClick("left", $PixelOrange[0], $PixelOrange[1], 1, 10) ;clicks legendary
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $OrangeItem = $OrangeItem +1
	   $checkCount = $checkCount +1
     EndIf 
		 Send("{ALTDOWN}")
		 Send("{ALTUP}")
		 $PixelGreen = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Green,3) ;searches for GREEN itens on the flor OH YEAH 2 !!!
     If Not @error Then
       MouseClick("left", $PixelGreen[0], $PixelGreen[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $GreenItem = $GreenItem +1
	   $checkCount = $checkCount +1
     EndIf
     ; search for gems

     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Amethyst,9) ;searches for AMETHYST GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $AmethystGem = $AmethystGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Ruby,6) ;searches for RUBY GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $RubyGem = $RubyGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Topaz,5) ;searches for TOPAZ GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $TopazGem = $TopazGem +1
	   $checkCount = $checkCount +1
     EndIf
     $SearchResult = PixelSearch(($x1 * $x_ratio),($y1 * $y_ratio),($x2 * $x_ratio),($y2 * $y_ratio),$Emerald,9) ;searches for EMERALD GEM
     If Not @error Then
       MouseClick("left", $SearchResult[0], $SearchResult[1], 1, 10) ;IF ITS THERE IT CLICKS IT.
       Sleep($sleepTimeBetweenCollectDrops)
       $work = 1
	   
       $EmeraldGem = $EmeraldGem +1
	   $checkCount = $checkCount +1
     EndIf
   WEnd  
   DEBUG("Finish Item Searching")
   
EndFunc




Func CheckDeath()

	  $PixelDeath = PixelSearch((670 * $x_ratio),(812 * $y_ratio),(1293 * $x_ratio),(881 * $y_ratio))	
	  if Not @error Then
		 ; dead
	  EndIf
   EndFunc
   

 Func Stop() ;to allow the script to stop
 Exit
 EndFunc

 Func Leave()
 $Leave = True
 EndFunc
 
 Func DEBUG($MESSAGE)
   If $DebugOn Then
      
   EndIf
EndFunc      ;==>Debug Info


Func SelectOneTabChest()
	Sleep(200)
	MouseClick("left",Round(496 * $x_ratio),Round(225 * $y_ratio))		; 1st tab
EndFunc

Func SelectTwoTabChest()
	Sleep(200)
	MouseClick("left",Round(503 * $x_ratio),Round(352 * $y_ratio))		; 1st tab
EndFunc

Func SelectThreeTabChest()
	Sleep(200)
	MouseClick("left",Round(498 * $x_ratio),Round(473 * $y_ratio))		; 1st tab
EndFunc