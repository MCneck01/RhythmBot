#NoEnv
#SingleInstance Force
#MaxHotkeysPerInterval 99000000
#HotkeyInterval 99000000
#KeyHistory 0
SetBatchLines, -1
Process, Priority, , High
ListLines, Off
SendMode Input
SetTitleMatchMode 2
SetKeyDelay, -1, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen

; --- UI Setup ---
; ลบ E0x08000000 ออก เพื่อให้คลิกแล้วเลือกหน้าต่างได้
Gui, +AlwaysOnTop -Caption +Border +LastFound
Gui, Color, 050505
Gui, Font, s12 w700 c00FFFF, Segoe UI

; เก็บ ID ของหน้าต่างบอทไว้ เพื่อสั่งลากตัวมันเองโดยเฉพาะ
WinGet, hGui, ID

; แถบหัวข้อสำหรับลาก (Drag Bar)
Gui, Add, Text, x0 y0 w360 h40 Center gDragBackground +0x200 Background000000, RHYTHM PRO v1.4 (beta by.sasaya)

Gui, Font, s10 w400 cWhite
Gui, Add, Text, x20 y50 gDragBackground, [F2] START / STOP
Gui, Add, Text, x20 y80 gDragBackground, [F3] RELOAD
Gui, Add, Text, x20 y110 gDragBackground, [F4] CLOSE

Gui, Add, GroupBox, x160 y45 w180 h85 c00FFFF, Status
Gui, Font, s14 w700
Gui, Add, Text, x170 y75 w160 Center vStatus cRed gDragBackground, OFFLINE

Gui, Show, w360 h150, RhythmBotPro

; --- ระบบลากหน้าจอแบบระบุตัวตน (Targeted Drag) ---
OnMessage(0x0201, "WM_LBUTTONDOWN")
return

DragBackground:
    PostMessage, 0xA1, 2,,, ahk_id %hGui%
return

WM_LBUTTONDOWN() {
    global hGui
    PostMessage, 0xA1, 2,,, ahk_id %hGui%
}

; --- ปุ่มควบคุม ---
F4:: ExitApp 
F3:: Reload

global BotRunning := false

F2::
    BotRunning := !BotRunning
    
    if (BotRunning) {
        GuiControl, +c00FF00, Status
        GuiControl,, Status, ONLINE
        SetTimer, RunBotLogic, 0 ; ใช้ Timer แทน Loop เพื่อไม่ให้ UI ค้าง
    } else {
        GuiControl, +cRed, Status
        GuiControl,, Status, OFFLINE
        SetTimer, RunBotLogic, Off
    }
return

; --- ลอจิกบอท ---
RunBotLogic:
    ; *** ใส่ค่าพิกัดที่คุณหามาได้ ตรงนี้ ***
    HandleKey("a", 780, 848, 802, 852, 0x9800FE)
    HandleKey("s", 866, 848, 888, 852, 0xE9008C)
    HandleKey("d", 948, 848, 970, 852, 0x0091F2)
    HandleKey("f", 1032, 848, 1054, 852, 0x00F694)
    HandleKey("g", 1117, 848, 1139, 852, 0xF69400)
return

HandleKey(keyName, x1, y1, x2, y2, color) {
    PixelSearch, Px, Py, x1, y1, x2, y2, color, 65, Fast RGB
    isPressed := GetKeyState(keyName)

    if (ErrorLevel = 0) {
        if (!isPressed) {
            Send {Blind}{%keyName% down}
        }
    } else {
        if (isPressed) {
            Send {Blind}{%keyName% up}
        }
    }
}
