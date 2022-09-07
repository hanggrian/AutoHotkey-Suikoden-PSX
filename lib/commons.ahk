; Commons library is used for when a script supports both S1 and S2.

#noEnv
#include lib/core.ahk

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  return

global currentS2 := getPreference("General", "S2")

initialize() {
  currentS2 := getPreference("General", "S2")
  if (not currentS2) {
    initializeS1()
  } else {
    initializeS2()
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
