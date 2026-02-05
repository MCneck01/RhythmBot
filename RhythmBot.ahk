#NoEnv
#SingleInstance Force
SetBatchLines, -1
CoordMode, Pixel, Screen
CoordMode, Mouse, Screen
SetKeyDelay, -1, -1

; --- UI (ลากได้ / Always on Top / ปิดสนิท) ---
Gui, +AlwaysOnTop -Caption +Border
Gui, Color, 050505
Gui, Font, s12 w700 c00FFFF, Segoe UI
Gui, Add, Text, x10 y10 w330 Center, RHYTHM v1.3 (beta by.sasaya)

; --- ส่วนควบคุมด้านซ้าย ---
Gui, Font, s10 w400 cWhite
Gui, Add, Text, x20 y50, [F2] START BOT
Gui, Add, Text, x20 y80, [F3] RELOAD / STOP
Gui, Add, Text, x20 y110, [F4] CLOSE APP

; --- GroupBox สถานะ ---
Gui, Add, GroupBox, x160 y45 w180 h85 c00FFFF, Status ; *ขยายความสูงเล็กน้อย*

; ข้อความ ONLINE/OFFLINE
Gui, Font, s14 w700
Gui, Add, Text, x170 y65 w160 Center vStatus cRed, OFFLINE

; --- ไฟสถานะ (LEDs) ---
; ใช้ Progress bar เต็มหลอด (100) เพื่อจำลองเป็นไฟ
; ตั้งชื่อตัวแปรเป็น LightA, LightS... เพื่อเรียกใช้ในฟังก์ชัน
Gui, Add, Progress, x170 y95 w28 h10 vLightA c333333 Background101010, 100
Gui, Add, Progress, x+5 yp w28 h10 vLightS c333333 Background101010, 100
Gui, Add, Progress, x+5 yp w28 h10 vLightD c333333 Background101010, 100
Gui, Add, Progress, x+5 yp w28 h10 vLightF c333333 Background101010, 100
Gui, Add, Progress, x+5 yp w28 h10 vLightG c333333 Background101010, 100

Gui, Show, w360 h160, RhythmBotPro

OnMessage(0x0201, "WM_LBUTTONDOWN")
return

WM_LBUTTONDOWN() {
    PostMessage, 0xA1, 2,,, A
}

; --- ปุ่มควบคุม ---
F4:: ExitApp 
F3:: Reload

F2::
GuiControl, +c00FF00, Status
GuiControl,, Status, ONLINE
Loop {
    ; ส่ง KeyName และ Color ไปด้วย เพื่อเอาไปเปลี่ยนสีไฟ
    HandleKey("a", 780, 820, 802, 865, 0x9800FE) ; เลน A (ม่วง)
    HandleKey("s", 866, 820, 888, 865, 0xE9008C) ; เลน S (ชมพู)
    HandleKey("d", 948, 820, 970, 865, 0x0091F2) ; เลน D (ฟ้า)
    HandleKey("f", 1032, 820, 1054, 865, 0x00F694) ; เลน F (เขียว)
    HandleKey("g", 1117, 820, 1139, 865, 0xF69400) ; เลน G (ส้ม)
    
    if GetKeyState("F3")
        break
}
return

; --- ฟังก์ชันประมวลผล (เพิ่มการเปลี่ยนสีไฟ UI) ---
HandleKey(keyName, x1, y1, x2, y2, color) {
    ; Variation 75
    PixelSearch, Px, Py, x1, y1, x2, y2, color, 75, Fast RGB
    
    if (ErrorLevel = 0) {
        if !GetKeyState(keyName) {
            Send {%keyName% down}
            ; [UI] เปิดไฟ: เปลี่ยนสี Progress bar เป็นสีเดียวกับโน้ต
            ; ตัด 0x ออกจากสีเพื่อให้ GuiControl อ่านค่าได้ถูกต้อง (แม้ AHK จะฉลาดพอ แต่ทำเพื่อความชัวร์)
            cleanColor := RegExReplace(color, "^0x", "")
            GuiControl, +c%cleanColor%, Light%keyName%
        }
    } else {
        if GetKeyState(keyName) {
            Sleep, 25
            PixelSearch, Px, Py, x1, y1, x2, y2, color, 75, Fast RGB
            if (ErrorLevel != 0) {
                Send {%keyName% up}
                ; [UI] ปิดไฟ: เปลี่ยนกลับเป็นสีเทาเข้ม
                GuiControl, +c333333, Light%keyName%
            }
        }
    }
}