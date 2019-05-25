HotKeySet("{f9}","exitProgram")
HotKeySet("{f1}","toggleSpamSpacebar")
HotKeySet("{e}","toggleSpamSpacebar")

global $shouldSpamSpacebar = False

While True
	if ($shouldSpamSpacebar) Then
		Send("{SPACE}")
		Sleep(50)
	EndIf
WEnd

Func toggleSpamSpacebar()
	$shouldSpamSpacebar = Not $shouldSpamSpacebar
EndFunc

Func exitProgram()
	Exit
EndFunc