#Requires AutoHotkey v2.0

CoordMode "Mouse", "Screen"

;Show Pairs
Numpad5::
{
	Click 214, 530
}

;= Duplicates of SAME quality
Numpad6::
{
	Click 214, 496
}

;= Related alts
Numpad2::
{
	Click 214, 526
	Sleep 450
	Send "{Enter}"
}

;= False Positives
Numpad0::
{
	Click 214, 546
	Sleep 450
	Send "{Enter}"
}

;= Delete ALL
NumpadDot::
{
	Click 444, 83
	Send "^{a}{Delete}"
	Sleep 450
	Send "{Enter}"
	Click 370, 450
	Sleep 450
	Send "{Numpad5}"
}

;= Delete SELECTED
Numpad3::
{
	Send "{Delete}"
	Sleep 450
	Send "{Enter}"
	Send "{Numpad5}"
}

; Mark SELECTED as COMICS
Numpad9::
{
	; Open Right Click Menu
	Click(447, 72, "Right")
	Sleep 100
	; Move cursor to "Manage" and wait for submenu
	MouseMove 547, 250
	Sleep 300
	; Click "Tags"
	Click 622, 252
	Sleep 200
	; Click tag entry box
	Click 419, 717
	Sleep 100
	; Type "comic"
	Send "comic"
	Sleep 100
	Send "{Enter}"
	Sleep 100
	; Click "Accept"
	Click 605, 983
}