; Script to farm Fortune Rune Piece.
; Location : Big Wheel in Kouan
; Speed    : >300 FPS

#include libs/core.ahk
#maxThreadsPerHotkey 2

msgBox % "Backspace`tToggle on/off."

; Roll the dice 5 times and rollback if reached Kirinji.
Backspace::
  toggle := !toggle
  if (toggle) {
    prepareScan()
    counter := 0
  }
  loop {
    if (not toggle) {
      break
    }
    if (scanFight()) {
      fight()
    } else if (scanFinish()) {
      finish()
    } else {
      if (counter < 5) {
        counter++
        move(dup, 100)
      } else {
        counter := 0
        move(ddown, 200)
      }
    }
  }
  return

move(direction, duration) {
  send {%circle% down}

  send {%direction% down}
  sleep duration
  send {%direction% up}

  send {%circle% up}
}
