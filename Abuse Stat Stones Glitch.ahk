; Use N number of items to 1st or 2nd character, depending on mode.
; Then run around to encounter enemies and deliberately lose the fight,
; returning to last checkpoint and repeat the processs.
;
; In S1, items are held by 1st character.
; Party characters must all have 3 balloons.
; For a character that has fixed equipment, put him/her on 4th position and change mode using NumpadDot.
;
; In S2, items are held by party inventory.
; Party characters must all have 1 HP and Fire Lizard Rune attached to their weapons.
;
; Game     : S1 & S2
; Location : Soniere Prison save point
; Speed    : >300 FPS

#include libs/core.ahk

msgBox % "```tToggle Suikoden 1 or 2.`n"
  . "-`tToggle use to 1st or 4th character.`n"
  . "1`tUse 1 stat stone.`n"
  . "2`tUse 2 stat stones.`n"
  . "3`tUse 3 stat stones.`n"
  . "4`tUse 4 stat stones.`n"
  . "5`tUse 5 stat stones.`n"
  . "6`tUse 6 stat stones.`n"
  . "7`tUse 7 stat stones.`n"
  . "8`tUse 8 stat stones.`n"
  . "9`tUse 9 stat stones.`n"
  . "0`tFallback function if 1-9 fails to encounter enemies."

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  return

-::
  toggleModePreference("AbuseStatStonesGlitch", "ToSecond", "To 2nd character.", "To 1st character.")
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

0::
  s2 := getPreference("General", "S2")

  ; Close menu of any depth.
  loop 3 {
    if (s2) {
      send {%triangle% down}
      send {%triangle% up}
    } else {
      send {%circle% down}
      send {%circle% up}
    }
  }

  resetToCheckpoint(s2)
  return

useStatStones(itemCount) {
  s2 := getPreference("General", "S2")
  toSecond := getPreference("AbuseStatStonesGlitch", "ToSecond")

  ; Open menu.
  send {%square% down}
  send {%square% up}

  if (s2) {
    ; In S2, menu stays in party inventory whenever stone is used.
    ; Menu 1> items 2> party's.
    loop 2 {
      send {%cross% down}
      send {%cross% up}
    }
    loop %itemCount% {
      ; Item 1> use 2> character.
      loop 2 {
        send {%cross% down}
        send {%cross% up}
      }
      ; To 1st or 4th character.
      if (toSecond) {
        send {%ddown% down}
        send {%ddown% up}
      }
      ; Character 1> confirm.
      send {%cross% down}
      send {%cross% up}
      ; Stats raised information.
      sleep 100
    }
  } else {
    ; In S1, menu goes back to root whenever stone is used.
    loop %itemCount% {
      ; Menu 1> items 2> characters 3> item 4> use.
      loop 4 {
        send {%cross% down}
        send {%cross% up}
      }
      ; To 1st or 4th character.
      if (toSecond) {
        send {%dright% down}
        send {%dright% up}
      }
      ; Character 1> confirm 2> close.
      loop 2 {
        send {%cross% down}
        send {%cross% up}
      }
    }
  }

  ; Exit menu.
  send {%square% down}
  send {%square% up}

  resetToCheckpoint(s2)
}

resetToCheckpoint(s2) {
  moveTwice(dleft, dright, 200)
  moveTwice(dright, dleft, 200)

  if (s2) {
    ; With Fire Lizard rune, there's a chance of winning the fight
    ; if all enemies die at the end of the turn.
    send {%dup% down}
    send {%dup% up}
    loop 4 {
      send {%cross% down}
      send {%cross% up}
    }
    ; Attack and wait defeat animation to revive, or close winning overview.
    sleep 800
    loop 3 {
      send {%cross% down}
      send {%cross% up}
    }
  } else {
    ; With baloon glitch, any fight is always lost.
    loop 2 {
      send {%cross% down}
      send {%cross% up}
    }
    ; Wait defeat animation to revive.
    sleep 500
    send {%cross% down}
    send {%cross% up}
  }
}
