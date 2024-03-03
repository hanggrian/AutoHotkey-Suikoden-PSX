/*
Core library is the base of all scripts.
*/

#NoEnv ; generally better performance
#SingleInstance, Force ; faster testing
#MaxThreadsPerHotkey, 2 ; required for toggle support

global dup := getPreference("Controls", "DUp")
global dleft := getPreference("Controls", "DLeft")
global ddown := getPreference("Controls", "DDown")
global dright := getPreference("Controls", "DRight")
global triangle := getPreference("Controls", "Triangle")
global circle := getPreference("Controls", "Circle")
global cross := getPreference("Controls", "Cross")
global square := getPreference("Controls", "Square")

global scanEnemyColor
global scanFightX
global scanFightY
global scanFightColor
global scanFinishX
global scanFinishY
global scanFinishColor

global lastFallbackColor

/*
Load scan properties of Suikoden 1.
*/
initializeS1() {
    scanEnemyColor := getPreference("Scans", "EnemyColor")
    scanFightPoint := getPreference("Scans", "S1FightPoint")
    scanFinishPoint := getPreference("Scans", "S1FinishPoint")
    StringSplit, coordinate, scanFightPoint, `,
    scanFightX := coordinate1
    scanFightY := coordinate2
    scanFightColor := coordinate3
    StringSplit, coordinate, scanFinishPoint, `,
    scanFinishX := coordinate1
    scanFinishY := coordinate2
    scanFinishColor := coordinate3
}

/*
Load scan properties of Suikoden 2.
*/
initializeS2() {
    scanEnemyColor := getPreference("Scans", "EnemyColor")
    scanFightPoint := getPreference("Scans", "S2FightPoint")
    scanFinishPoint := getPreference("Scans", "S2FinishPoint")
    StringSplit, coordinate, scanFightPoint, `,
    scanFightX := coordinate1
    scanFightY := coordinate2
    scanFightColor := coordinate3
    StringSplit, coordinate, scanFinishPoint, `,
    scanFinishX := coordinate1
    scanFinishY := coordinate2
    scanFinishColor := coordinate3
}

/*
Check if fight point is valid.
*/
isFightState() {
    PixelGetColor, color, scanFightX, scanFightY
    Return color = scanFightColor
}

/*
Check if finish point is valid.
*/
isFinishState() {
    PixelGetColor, color, scanFinishX, scanFinishY
    Return color = scanFinishColor
}

/*
Check if the game has become stagnated, which usually happens in sudden FPS drop. This is done by
picking a color of any coordinate, then later check if the color is still in that coordinate.
*/
isFallbackState() {
    PixelGetColor, color, scanFightX, scanFightY
    If (color = lastFallbackColor) {
        lastFallbackColor := ""
        Return True
    }
    lastFallbackColor := color
    Return False
}

/*
In any fight state, select Free Will.
*/
doFight() {
    Send, {%dup% Down}
    Send, {%dup% Up}
    Send, {%cross% Down}
    Send, {%cross% Up}

    Sleep, 100 ; confirmation dialog animation
    Send, {%cross% Down}
    Send, {%cross% Up}
}

/*
In Suikoden 1 finish state, close all dialogs.
*/
doFinishS1() {
    ; no need for looping in S1 because money and item gained box is the same
    Sleep, 100 ; money/item dialog animation
    Send, {%cross% Down}
    Send, {%cross% Up}
}

/*
In Suikoden 2 finish state, close all dialogs.
*/
doFinishS2() {
    ; party members lv 1> exp gained 2> money gained
    Loop, 2 {
        Send, {%cross% Down}
        Send, {%cross% Up}
    }
    ; money gained 1> item gained 2> give up on item (if full) 3> close
    Loop, 3 {
        Sleep, 100 ; money/item dialog animation
        Send, {%cross% Down}
        Send, {%cross% Up}
    }
}

/*
In Suikoden 1 stagnated state, press enter and back. Enter is neccessary because escape/bribe
confirmation dialog cannot be dismissed with back button.
*/
doFallbackS1() {
    Send, {%cross% Down}
    Send, {%cross% Up}
    Send, {%circle% Down}
    Send, {%circle% Up}
}

/*
In Suikoden 2 stagnated state, press enter and back. Enter is neccessary because escape/bribe
confirmation dialog cannot be dismissed with back button.
*/
doFallbackS2() {
    Send, {%cross% Down}
    Send, {%cross% Up}
    Send, {%triangle% Down}
    Send, {%triangle% Up}
}

/*
Run horizontally to encounter enemies.
*/
doMoveAround(duration) {
    Send, {%circle% Down}
    Send, {%dleft% Down}
    Sleep, duration
    Send, {%dleft% Up}

    Send, {%dright% Down}
    Sleep, duration
    Send, {%dright% Up}
    Send, {%circle% Up}
}

/*
Get value from an INI file.
*/
getPreference(section, key) {
    IniRead, value, preferences.ini, %section%, %key%
    Return value
}

/*
Set value to an INI file.
*/
setPreference(section, key, value) {
    IniWrite, %value%, preferences.ini, %section%, %key%
}

/*
Toggle a boolean preference, also display an alert about current state.
*/
toggleModePreference(section, key, modeOnDesc, modeOffDesc) {
    value := getPreference(section, key)
    setPreference(section, key, !value)
    If (!value) {
        MsgBox, % "Mode changed:`n" . modeOnDesc
    } Else {
        MsgBox, % "Mode changed:`n" . modeOffDesc
    }
}

/*
Change icon in notification area.
*/
setIcon(file) {
    path := Format("res/{1}.ico", file)
    Menu, Tray, Icon, %path%
}
