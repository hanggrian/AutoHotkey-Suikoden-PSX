#noEnv
#include libs/core.ahk

global currentS2 := getPreference("General", "S2")

; Call this once before calling any other scan functions
prepareScanState() {
  currentS2 := getPreference("General", "S2")
  if (not currentS2) {
    prepareScanStateS1()
  } else {
    prepareScanStateS2()
  }
}

doFinish() {
  if (not currentS2) {
    doFinishS1()
  } else {
    doFinishS2()
  }
}

doFallback() {
  if (not currentS2) {
    doFallbackS1()
  } else {
    doFallbackS2()
  }
}

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  return
