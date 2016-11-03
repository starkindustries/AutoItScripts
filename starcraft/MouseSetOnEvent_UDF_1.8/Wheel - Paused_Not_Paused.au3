#include "MouseOnEvent.au3"

$iPaused = False

_MouseSetOnEvent($MOUSE_WHEELDOWN_EVENT, "PausePlay")

Sleep(5000)

_MouseSetOnEvent($MOUSE_WHEELDOWN_EVENT)

Func PausePlay()
	$iPaused = Not $iPaused
	
	ConsoleWrite("Paused: " & $iPaused & @CRLF)
EndFunc
