; Roll the dice and fight scripted enemies.
; After 5 iterations, return back to original point (in case of reaching Kirinji).
;
; Game     : S1
; Location : Big Wheel in Kouan
; Speed    : >300 FPS

Menu, Tray, Icon, res/icon_s1_off.ico
MsgBox,, % "Farm Fortune Rune Piece (S1)"
  , % "Controls:`n"
    . "Backspace`tToggle on/off."

#noEnv
#include lib/core.ahk
#maxThreadsPerHotkey 2
#singleInstance force

Backspace::
  toggle := !toggle
  if (toggle) {
    Menu, Tray, Icon, res/icon_s1_on.ico
    initializeS1()
    counter := 0
  }
  loop {
    if (not toggle) {
      Menu, Tray, Icon, res/icon_s1_off.ico
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
