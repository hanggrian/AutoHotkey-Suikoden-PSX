; Roll the dice and fight scripted enemies.
;
; In case of reaching Kirinji, the game becomes stagnated.
; But in this case, the fallback trigger is return to original point.
;
; Game     : S1
; Location : Just below entrance of Big Wheel in Kouan

#include lib/core.ahk

setIcon("icon_s1_off")
MsgBox,, % "Farm Fortune Rune Piece (S1)"
  , % "Controls:`n"
    . "Backspace`tToggle on/off."

Backspace::
  toggle := !toggle
  if (toggle) {
    setIcon("icon_s1_on")
    initializeS1()
    counter := 0
  }
  loop {
    if (not toggle) {
      setIcon("icon_s1_off")
      break
    }

    if (isFightState()) {
      doFight()
    } else if (isFinishState()) {
      doFinishS1()
    } else if (isFallbackState()) {
      doFallbackS1()
      doMove(ddown, 200)
    } else {
      doMove(dup, 100)
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
