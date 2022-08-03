; Script to abuse stat stone glitch, party characters must all have 3 balloons.
; For a character that has fixed equipment, put him/her on 4th position and change mode using NumpadDot.
; Location	: Soniere Prison save point
; Speed		: >300 FPS

#include libs/core.ahk

msgBox % "```tToggle Suikoden 1 or 2.`n"
  . "-`tToggle use to self or 4th character.`n"
  . "1`tUse 1 rune piece.`n"
  . "2`tUse 2 rune pieces.`n"
  . "3`tUse 3 rune pieces.`n"
  . "4`tUse 4 rune pieces.`n"
  . "5`tUse 5 rune pieces.`n"
  . "6`tUse 6 rune pieces.`n"
  . "7`tUse 7 rune pieces.`n"
  . "8`tUse 8 rune pieces.`n"
  . "9`tUse 9 rune pieces.`n"
  . "0`tFallback function if 1-9 fails to encounter enemies."

; Change mode, either use to self or 4th character.
`::
  toggleModePreference("UseRunePieces", "ToSelf", "1st character items to self.", "1st character items to 4th character.")
  return

1::
  useStatStones(1)
  return
2::
  useStatStones(2)
  return
3::
  useStatStones(3)
  return
4::
  useStatStones(4)
  return
5::
  useStatStones(5)
  return
6::
  useStatStones(6)
  return
7::
  useStatStones(7)
  return
8::
  useStatStones(8)
  return
9::
  useStatStones(9)
  return

; Fallback function if haven't encountered enemies.
0::
  loop 3 {
    send {%CIRCLE% down}
    send {%CIRCLE% up}
  }

  moveTwice(DLEFT, DRIGHT, 150)
  moveTwice(DRIGHT, DLEFT, 150)

  resetToCheckpoint()
  return

; Use n-items from 1st character to self or 4th character, depending on mode.
useStatStones(itemCount) {
  ; Open menu.
  send {%SQUARE% down}
  send {%SQUARE% up}

  toSelf := getPreference("UseRunePieces", "ToSelf")
  loop %itemCount% {
    ; Menu 1> items 2> characters 3> item 4> use.
    loop 4 {
      send {%CROSS% down}
      send {%CROSS% up}
    }
    ; To 1st or 4th character.
    if (not toSelf) {
      send {%DDOWN% down}
      send {%DDOWN% up}
    }
    ; Character 1> confirm 2> close.
    loop 2 {
      send {%CROSS% down}
      send {%CROSS% up}
    }
  }

  ; Exit menu.
  send {%SQUARE% down}
  send {%SQUARE% up}

  moveTwice(DLEFT, DRIGHT, 150)
  moveTwice(DRIGHT, DLEFT, 150)

  resetToCheckpoint()
}

resetToCheckpoint() {
  loop 2 {
    send {%CROSS% down}
    send {%CROSS% up}
  }
  sleep 500 ; defeat animation
  send {%CROSS% down}
  send {%CROSS% up}
}
