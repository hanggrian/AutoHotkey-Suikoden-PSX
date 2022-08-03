global DUP := getPreference("Controls", "DUp")
global DLEFT := getPreference("Controls", "DLeft")
global DDOWN := getPreference("Controls", "DDown")
global DRIGHT := getPreference("Controls", "DRight")
global TRIANGLE := getPreference("Controls", "Triangle")
global CIRCLE := getPreference("Controls", "Circle")
global CROSS := getPreference("Controls", "Cross")
global SQUARE := getPreference("Controls", "Square")

; Moves selection 1> auto 2> confirm.
global S1_FIGHT_LOOP=2
; S2 runs on slower fps, so add 2 extra times to ensure the script does not stop in confirmation
global S2_FIGHT_LOOP=4

global CURRENT_FIGHT_COLOR
global CURRENT_FIGHT_X
global CURRENT_FIGHT_Y
global CURRENT_FIGHT_LOOP
global CURRENT_FINISH_COLOR
global CURRENT_FINISH_X
global CURRENT_FINISH_Y

; Call this once before calling any other scan functions.
prepareScan() {
  s2 := getPreference("General", "S2")
  if (s2) {
    CURRENT_FIGHT_COLOR := getPreference("Scans", "S2FightColor")
    CURRENT_FIGHT_X := getPreference("Scans", "S2FightX")
    CURRENT_FIGHT_Y := getPreference("Scans", "S2FightY")
    CURRENT_FIGHT_LOOP := S2_FIGHT_LOOP
    CURRENT_FINISH_COLOR := getPreference("Scans", "S2FinishColor")
    CURRENT_FINISH_X := getPreference("Scans", "S2FinishX")
    CURRENT_FINISH_Y := getPreference("Scans", "S2FinishY")
  } else {
    CURRENT_FIGHT_COLOR := getPreference("Scans", "S1FightColor")
    CURRENT_FIGHT_X := getPreference("Scans", "S1FightX")
    CURRENT_FIGHT_Y := getPreference("Scans", "S1FightY")
    CURRENT_FIGHT_LOOP := S1_FIGHT_LOOP
    CURRENT_FINISH_COLOR := getPreference("Scans", "S1FinishColor")
    CURRENT_FINISH_X := getPreference("Scans", "S1FinishX")
    CURRENT_FINISH_Y := getPreference("Scans", "S1FinishY")
  }
}

scanFight() {
  PixelGetColor, color, CURRENT_FIGHT_X, CURRENT_FIGHT_Y
  return color = CURRENT_FIGHT_COLOR
}

scanFinish() {
  PixelGetColor, color, CURRENT_FINISH_X, CURRENT_FINISH_Y
  return color = CURRENT_FINISH_COLOR
}

fight() {
  send {%DUP% down}
  send {%DUP% up}
  loop %CURRENT_FIGHT_LOOP% {
    send {%CROSS% down}
    send {%CROSS% up}
  }
}

finish() {
  send {%CROSS% down}
  send {%CROSS% up}
}

moveTwice(direction1, direction2, duration) {
  send {%CIRCLE% down}

  send {%direction1% down}
  sleep duration
  send {%direction1% up}

  send {%direction2% down}
  sleep duration
  send {%direction2% up}

  send {%CIRCLE% up}
}

getPreference(section, key) {
  IniRead, value, preferences.ini, %section%, %key%
  return value
}

setPreference(section, key, value) {
  IniWrite, %value%, preferences.ini, %section%, %key%
}

toggleModePreference(section, key, modeOnDesc, modeOffDesc) {
  value := getPreference(section, key)
  setPreference(section, key, !value)
  if (!value) {
    msgBox Mode changed:`n%modeOnDesc%
  } else {
    msgBox Mode changed:`n%modeOffDesc%
  }
}
