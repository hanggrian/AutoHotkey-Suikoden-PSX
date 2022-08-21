; Roll the dice and fight scripted enemies.
; When the counter reaches 5, turn back to original point (in case of reaching Kirinji).
;
; Game     : S1
; Location : Big Wheel in Kouan
; Speed    : >300 FPS

msgBox % "Backspace`tToggle on/off."

#noEnv
#include libs/core.ahk
#maxThreadsPerHotkey 2
#singleInstance force

Backspace::
  toggle := !toggle
  if (toggle) {
    prepareScanStateS1()
    counter := 0
  }
  loop {
    if (not toggle) {
      break
    }

    if (isFightState()) {
      doFight()
    } else if (isFinishState()) {
      doFinishS1()
    } else if (isFallbackState()) {
      doFallbackS1()
    } else {
      if (counter < 5) {
        counter++
        doMove(dup, 100)
      } else {
        counter := 0
        doMove(ddown, 200)
      }
    }
  }
  return

doMove(direction, duration) {
  send {%circle% down}

  send {%direction% down}
  sleep duration
  send {%direction% up}

  send {%circle% up}
}
