; Commons library is used for when a script supports both S1 and S2.

#include lib/core.ahk

global isS2

; Load scan properties of any.
initialize() {
  isS2 := getPreference("General", "S2")
  if (not isS2) {
    initializeS1()
  } else {
    initializeS2()
  }
}

; In any finish state, close all dialogs.
doFinish() {
  if (not isS2) {
    doFinishS1()
  } else {
    doFinishS2()
  }
}

; In any stagnated state, press enter and back.
doFallback() {
  if (not isS2) {
    doFallbackS1()
  } else {
    doFallbackS2()
  }
}

; Change icon in notification area to `off`.
setIconOff() {
  isS2 := getPreference("General", "S2")
  if (isS2) {
    setIcon("icon_s2_off")
  } else {
    setIcon("icon_s1_off")
  }
}

; Change icon in notification area to `on`.
setIconOn() {
  isS2 := getPreference("General", "S2")
  if (isS2) {
    setIcon("icon_s2_on")
  } else {
    setIcon("icon_s1_on")
  }
}
