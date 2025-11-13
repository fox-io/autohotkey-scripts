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

HYDRUS_WINDOW := "ahk_exe hydrus_client.exe"
DEFAULT_MODAL_TIMEOUT := 2000
DEFAULT_REFRESH_TIMEOUT := 5000

ShowRandomPairs() {
	Click 214, 530
}

RefreshAndShowNextPairs() {
	Click 370, 450
	WaitForHydrusIdle()
	ShowRandomPairs()
}

ConfirmDeletionAndContinue() {
	AcceptHydrusModal()
	RefreshAndShowNextPairs()
}

WaitForHydrusEnabled(desired := true, timeout := DEFAULT_MODAL_TIMEOUT) {
	global HYDRUS_WINDOW
	start := A_TickCount
	while (A_TickCount - start) <= timeout {
		try
		{
			isEnabled := WinGetEnabled(HYDRUS_WINDOW)
		}
		catch
		{
			return false
		}
		if (!!isEnabled = desired)
			return true
		Sleep 25
	}
	return false
}

WaitForHydrusModalOpen(timeout := DEFAULT_MODAL_TIMEOUT) {
	global HYDRUS_WINDOW
	if !WaitForHydrusEnabled(false, timeout)
		return ""
	dialogId := WinExist("A")
	mainId := WinExist(HYDRUS_WINDOW)
	return (dialogId && dialogId != mainId) ? dialogId : ""
}

AcceptHydrusModal(timeout := DEFAULT_MODAL_TIMEOUT) {
	if !(dialogId := WaitForHydrusModalOpen(timeout))
		return false
	dialogRef := "ahk_id " dialogId
	ControlSend "{Enter}", , dialogRef
	WinWaitClose dialogRef, , timeout / 1000
	WaitForHydrusEnabled(true, timeout)
	return true
}

IsBusyCursor() {
	static busy := Map("Wait", true, "AppStarting", true)
	return busy.Has(A_Cursor)
}

WaitForHydrusIdle(timeout := DEFAULT_REFRESH_TIMEOUT) {
	start := A_TickCount
	while (A_TickCount - start) <= timeout {
		if !IsBusyCursor()
			return true
		Sleep 50
	}
	return false
}

WaitForContextMenu(expectedCount := 1, timeout := 700) {
	start := A_TickCount
	while (A_TickCount - start) <= timeout {
		try
		{
			menuHandles := WinGetList("ahk_class #32768")
		}
		catch
		{
			menuHandles := []
		}
		if menuHandles.Length >= expectedCount
			return true
		Sleep 20
	}
	return false
}

#HotIf WinActive(HYDRUS_WINDOW)

;Show Pairs
Numpad5::
{
	ShowRandomPairs()
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
	AcceptHydrusModal()
}

;= False Positives
Numpad0::
{
	Click 214, 546
	AcceptHydrusModal()
}

;= Delete ALL
NumpadDot::
{
	Click 444, 83
	Send "^{a}{Delete}"
	ConfirmDeletionAndContinue()
}

;= Delete SELECTED
Numpad3::
{
	Send "{Delete}"
	ConfirmDeletionAndContinue()
}

; Mark SELECTED as COMICS
Numpad9::
{
	; Open Right Click Menu
	Click(447, 72, "Right")
	if !WaitForContextMenu()
		return
	; Move cursor to "Manage" and wait for submenu
	MouseMove 547, 250
	WaitForContextMenu(2)
	; Click "Tags"
	Click 622, 252
	if !(tagsDialog := WaitForHydrusModalOpen())
		return
	tagsDialogRef := "ahk_id " tagsDialog
	WinActivate tagsDialogRef
	; Click tag entry box
	Click 419, 717
	; Type "meta:comic"
	Send "meta:comic"
	Send "{Enter}"
	; Click "Accept"
	Click 605, 983
	WinWaitClose tagsDialogRef, , DEFAULT_MODAL_TIMEOUT / 1000
	WaitForHydrusEnabled(true)
}

#HotIf
