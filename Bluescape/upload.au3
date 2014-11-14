;Wait 5 sec to upload window to appear
Local $hWnd = WinWait ("[CLASS:#32770]", "", "5")

; Set input focus to the search field
ControlFocus ($hWnd, "", "Edit1")

; Set filename
Sleep(2000)
ControlSetText ("Open", "", "Edit1", "0.png")

; Click on "Open" button
Sleep(2000)
ControlClick("Open", "", "Button1")