; Leave just 1 or 2 enemies left (preferably the ones with weapon range L so they may not be
; countered), then select which character to attack while the rest is defending.
;
; In an attempt to get a different loot, a different scenario must occur. Within the emulator
; environment, repeatedly try to finish the enemy with different character. If no desired loot is
; available, press `Backspace` to make the entire party skip moves to try again.
;
; This script is particularly useful when trying to obtain loots from enemies that cannot be
; encountered using conventional `Fight.ahk` script, e.g.:
; - Any loot from bosses.
; - In S1, Iron Boots from Highlands at Greenhill Forest #2.
;
; Game     : S1 & S2
; Location : Any enemy-spawn area, preferably with wide horizontal area

#include lib/commons.ahk

setIconOff()
MsgBox,, % "Loot (S1 & S2)"
  , % "Controls:`n"
    . "```t`tToggle Suikoden 1 or 2.`n"
    . "-`t`tChange party size.`n"
    . "1`t`tSelect 1st character to attack.`n"
    . "2`t`tSelect 2nd character to attack.`n"
    . "3`t`tSelect 3rd character to attack.`n"
    . "4`t`tSelect 4th character to attack.`n"
    . "5`t`tSelect 5th character to attack.`n"
    . "6`t`tSelect 6th character to attack.`n"
    . "Backspace`tSkip all moves."

global partySize := getPreference("Loot", "PartySize")
global running := false ; prevent while loop to be executed after moves are finished

initialize()

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  initialize()
  return

-::
  partySize := getPreference("Loot", "PartySize")
  InputBox, input, Enter Party Size, Currently party size is %partySize%.
  if (not errorLevel) {
    setPreference("Loot", "PartySize", input)
  }
  return

1::
  start()
  attack()
  times := getLastDefendTimes(1)
  loop %times% {
    defend()
  }
  finish()
  return

2::
  start()
  defend()
  attack()
  times := getLastDefendTimes(2)
  loop %times% {
    defend()
  }
  finish()
  return

3::
  start()
  loop 2 {
    defend()
  }
  attack()
  times := getLastDefendTimes(3)
  loop %times% {
    defend()
  }
  finish()
  return

4::
  start()
  loop 3 {
    defend()
  }
  attack()
  times := getLastDefendTimes(4)
  loop %times% {
    defend()
  }
  finish()
  return

5::
  start()
  loop 4 {
    defend()
  }
  attack()
  times := getLastDefendTimes(5)
  loop %times% {
    defend()
  }
  finish()
  return

6::
  start()
  loop 5 {
    defend()
  }
  attack()
  finish()
  return

Backspace::
  start()
  times := getLastDefendTimes(0)
  loop %times% {
    defend()
  }
  finish()
  return

start() {
  running := false

  send {%cross% down}
  send {%cross% up}
  sleep 100
}

defend() {
  send {%ddown% down}
  send {%ddown% up}
  send {%cross% down}
  send {%cross% up}
}

attack() {
  send {%cross% down}
  send {%cross% up}
  sleep 100
  send {%cross% down}
  send {%cross% up}
  sleep 100
}

finish() {
  sleep 100
  send {%cross% down}
  send {%cross% up}

  running := true
  waitCount := 0 ; in case the fight never ends, stop waiting after certain times
  while (not isFinishState() && running && waitCount < 5) {
    waitCount++
    sleep 500
  }

  if (running) {
    running := false

    ; doFinish() will close all windows
    ; instead, skip to parts where item is gained
    loop 2 {
      send {%cross% down}
      send {%cross% up}
    }
    sleep 100
    send {%cross% down}
    send {%cross% up}
  }
}

getLastDefendTimes(attackIndex) {
  times := partySize - attackIndex
  if (times < 0) {
    return 0
  }
  return times
}
