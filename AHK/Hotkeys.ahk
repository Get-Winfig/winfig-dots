#Requires AutoHotkey v2.0

; Alt+O: Restart whkd (PowerShell syntax)
!o:: {
    Run 'powershell -NoProfile -Command "taskkill /f /im whkd.exe; Start-Process whkd -WindowStyle hidden"', , 'Hide'
    MsgBox "whkd restarted.", "Info", 1
}

; Alt+Shift+O: Reload komorebic configuration
!+o:: {
    Run 'komorebic reload-configuration', , 'Hide'
    MsgBox "Komorebic configuration reloaded.", "Info", 1
}

; Alt+Ctrl+O: Reload yasbc
!^o:: {
    Run 'yasbc reload', , 'Hide'
    MsgBox "YASBC reloaded.", "Info", 1
}

; Windows+F2: Toggle komorebic shortcuts
#F2:: {
    Run 'komorebic toggle-shortcuts', , 'Hide'
}

; Alt+W Close active/focused window,app
!w:: {
    WinClose(A_ScriptHwnd)
}

; Windows+T Open Windows Terminal
#t:: {
    Run 'wt', , 'Max'
}

; Windows+K: Open Windows Terminal with WSL
#k:: {
    Run 'wt.exe wsl.exe', , 'Max'
}

; Alt+M: Minimize all expect active window
!m:: {
    WinMinimizeAll()
    WinActivate("A")
}
WinMinimizeAll() {
    windows := WinGetList()
    for win in windows
        WinMinimize(win)
}
