; Core library is the base of all scripts.

#noEnv ; generally better performance
#singleInstance force ; faster testing
#maxThreadsPerHotkey 2 ; required for toggle support

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

; Load scan properties of Suikoden 1.
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

; Load scan properties of Suikoden 2.
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

; Check if fight point is valid.
isFightState() {
  PixelGetColor, color, scanFightX, scanFightY
  return color = scanFightColor
}

; Check if finish point is valid.
isFinishState() {
  PixelGetColor, color, scanFinishX, scanFinishY
  return color = scanFinishColor
}

; Check if the game has become stagnated, which usually happens in sudden FPS drop.
; This is done by picking a color of any coordinate,
; then later check if the color is still in that coordinate.
isFallbackState() {
  PixelGetColor, color, scanFightX, scanFightY
  if (color = lastFallbackColor) {
    lastFallbackColor := ""
    return true
  }
  lastFallbackColor := color
  return false
}

; In any fight state, select Free Will.
doFight() {
  send {%dup% down}
  send {%dup% up}
  send {%cross% down}
  send {%cross% up}

  sleep 100 ; confirmation dialog animation
  send {%cross% down}
  send {%cross% up}
}

; In Suikoden 1 finish state, close all dialogs.
doFinishS1() {
  ; no need for looping in S1 because money and item gained box is the same
  sleep 100 ; money/item dialog animation
  send {%cross% down}
  send {%cross% up}
}

; In Suikoden 2 finish state, close all dialogs.
doFinishS2() {
  ; party members lv 1> exp gained 2> money gained
  loop 2 {
    send {%cross% down}
    send {%cross% up}
  }
  ; money gained 1> item gained 2> give up on item (if full) 3> close
  loop 3 {
    sleep 100 ; money/item dialog animation
    send {%cross% down}
    send {%cross% up}
  }
}

; In Suikoden 1 stagnated state, press enter and back.
; Enter is neccessary because escape/bribe confirmation dialog cannot be dismissed with back button.
doFallbackS1() {
  send {%cross% down}
  send {%cross% up}
  send {%circle% down}
  send {%circle% up}
}

; In Suikoden 2 stagnated state, press enter and back.
; Enter is neccessary because escape/bribe confirmation dialog cannot be dismissed with back button.
doFallbackS2() {
  send {%cross% down}
  send {%cross% up}
  send {%triangle% down}
  send {%triangle% up}
}

; Run horizontally to encounter enemies.
doMoveAround(duration) {
  send {%circle% down}
  send {%dleft% down}
  sleep duration
  send {%dleft% up}

  send {%dright% down}
  sleep duration
  send {%dright% up}
  send {%circle% up}
}

; Get value from an INI file.
getPreference(section, key) {
  IniRead, value, preferences.ini, %section%, %key%
  return value
}

; Set value to an INI file.
setPreference(section, key, value) {
  IniWrite, %value%, preferences.ini, %section%, %key%
}

; Toggle a boolean preference, also display an alert about current state.
toggleModePreference(section, key, modeOnDesc, modeOffDesc) {
  value := getPreference(section, key)
  setPreference(section, key, !value)
  if (!value) {
    msgBox Mode changed:`n%modeOnDesc%
  } else {
    msgBox Mode changed:`n%modeOffDesc%
  }
}

; Change icon in notification area.
setIcon(file) {
  path := format("res/{1}.ico", file)
  Menu, Tray, Icon, %path%
}
