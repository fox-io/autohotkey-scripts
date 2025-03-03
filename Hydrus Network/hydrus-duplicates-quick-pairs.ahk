#Requires AutoHotkey v2.0

; This script is used to enable Numpad to be used in Hyrus Network in conjunction with
; the Filtering tab of the Duplicates Processing page. This enables you do do Quick and
; Dirty Processing using only the Numpad, rather than various keys and mouse input, 
; speeding up the process.
;
; The coordinates provided are relative to a default, unmodified layout, maximized
; window, using 1920x1080 resolution resolution in Windows 11.
;
; Created using Hydrus Client v605.
; 
; Numpad 5 - "Show Some Random Potential Pairs"
; Numpad 6 - "Set Current Media as Duplicates of the Same Quality"
; Numpad 2 - "Set Current Media as Related Alternatives"
; Numpad 0 - "Set Current Media as Not Related/False Positives"
; Numpad . - Selects ALL current media and deletes them. Clicks refresh to update
;            potential duplicate count. Clicks Numpad 5 to show next potential pairs.
; Numpad 3 - Deletes SELECTED media, leaving the rest untouched. Clicks refresh to
;            updates potential duplicate count. Clicks Numpad 5 to show next potential
;            pairs.
; Numpad 9 - Tags SELECTED media with "meta:comic" tag. Nothing is deleted or refreshed.

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
	Sleep 1500
	Send "{Numpad5}"
}

;= Delete SELECTED
Numpad3::
{
	Send "{Delete}"
	Sleep 450
	Send "{Enter}"
	Click 370, 450
	Sleep 1500
	Send "{Numpad5}"
}

; Mark SELECTED as COMICS
Numpad9::
{
	; Open Right Click Menu
	Click(447, 72, "Right")
	Sleep 450
	; Move cursor to "Manage" and wait for submenu
	MouseMove 547, 250
	Sleep 450
	; Click "Tags"
	Click 622, 252
	Sleep 450
	; Click tag entry box
	Click 419, 717
	Sleep 450
	; Type "meta:comic"
	Send "meta:comic"
	Sleep 450
	Send "{Enter}"
	Sleep 450
	; Click "Accept"
	Click 605, 983
}