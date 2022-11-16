; Use 9 items to 1st or 2nd character, depending on mode. Then run around to encounter enemies and
; deliberately lose the fight, returning to last checkpoint and repeat the processs.
;
; In S1, items are held by 1st character. Party characters must all have 3 balloons. Change mode to
; 2th for characters that has fixed equipment.
;
; In S2, items are held by party inventory. Party characters must all have 1 HP and Fire Lizard Rune
; attached to their weapons. It's best to detach all non-weapon runes as certain runes (Double Beat,
; Draining, etc.) may prolong the process. Change mode to 2th for non-human characters.
;
; Game     : S1 & S2
; Location : Any enemy-spawn area with save point (e.g., Soniere Prison in S1, Banner Pass in S2)

#include lib/commons.ahk

setIconOff()
MsgBox,, % "Abuse Stat Stones Glitch (S1 & S2)"
  , % "Controls:`n"
    . "```t`tToggle Suikoden 1 or 2.`n"
    . "-`t`tToggle use to 1st or 2nd character.`n"
    . "Backspace`tToggle on/off."

global toggle

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  setIconOff()
  toggle := false
  return

-::
  toggleModePreference("AbuseStatStonesGlitch", "ToSecond", "To 2nd character.", "To 1st character.")
  toggle := false
  return

Backspace::
  toggle := !toggle
  if (toggle) {
    setIconOn()
    initialize()
    toSecond := getPreference("AbuseStatStonesGlitch", "ToSecond")
  }
  loop {
    if (not toggle) {
      setIconOff()
      break
    }

    ; open menu
    send {%square% down}
    send {%square% up}

    if (isS2) {
      ; in S2, menu stays in party inventory whenever stone is used
      ; menu 1> items 2> party's
      loop 2 {
        send {%cross% down}
        send {%cross% up}
      }
      loop 9 {
        ; item 1> use 2> character
        loop 2 {
          send {%cross% down}
          send {%cross% up}
        }
        ; to 1st or 4th character
        if (toSecond) {
          send {%ddown% down}
          send {%ddown% up}
        }
        ; character 1> confirm
        send {%cross% down}
        send {%cross% up}
        ; stats raised information
        sleep 100
      }
      ; close menu of any depth
      loop 4 {
        send {%triangle% down}
        send {%triangle% up}
      }
    } else {
      ; in S1, menu goes back to root whenever stone is used
      loop 9 {
        ; menu 1> items 2> characters 3> item 4> use
        loop 4 {
          send {%cross% down}
          send {%cross% up}
        }
        ; to 1st or 4th character
        if (toSecond) {
          send {%dright% down}
          send {%dright% up}
        }
        ; character 1> confirm 2> close
        loop 2 {
          send {%cross% down}
          send {%cross% up}
        }
      }
      ; close menu of any depth
      loop 4 {
        send {%circle% down}
        send {%circle% up}
      }
    }

    ; purposely lose fight until game over
    doMoveAndLose(toggle)
    while (isFinishState() && toggle) {
      doFinish()
      doMoveAndLose(toggle)
    }

    ; choose try again and wait for revive delay
    send {%cross% down}
    send {%cross% up}
    sleep 1000
  }
  return

doMoveAndLose(toggle) {
  ; move around until enemies encounter
  while (not isFightState() && toggle) {
    doMoveAround(200)
  }

  if (isS2) {
    ; with Fire Lizard rune, there's a chance of winning the fight if all enemies die at the end of
    ; the turn
    send {%dup% down}
    send {%dup% up}
    loop 4 {
      send {%cross% down}
      send {%cross% up}
    }
    sleep 700
  } else {
    ; with baloon glitch, any fight is always lost
    loop 2 {
      send {%cross% down}
      send {%cross% up}
    }
    sleep 500
  }
}
