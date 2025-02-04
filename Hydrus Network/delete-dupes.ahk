#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"

;Show Pairs
Numpad9::
{
	Click 990, 550
	Sleep 100
	Click 990, 560
}

Numpad8::
{
	Click 890, 550
}