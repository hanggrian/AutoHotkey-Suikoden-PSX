; Leave just 1 or 2 enemies left (preferably the ones with weapon range L so they may not be
; countered), then select which character to attack while the rest is defending.
;
; In an attempt to get a different loot, a different scenario must occur. Within the emulator
; environment, repeatedly try to finish the enemy with different character. If no desired loot is
; available, press `BackSpace` to make the entire party skip moves to try again.
;
; This script is particularly useful when trying to obtain loots from enemies that cannot be
; encountered using conventional `Fight.ahk` script, e.g.:
; - Any loot from bosses.
; - In S1, Iron Boots from Highlands at Greenhill Forest #2.
;
; Game     : S1 & S2
; Location : Any enemy-spawn area, preferably with wide horizontal area

#Include, libs/commons.ahk

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
        . "BackSpace`tSkip all moves."

global partySize := getPreference("Loot", "PartySize")
global running := False ; prevent while loop to be executed after moves are finished

initialize()

`::
    toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
    initialize()
    Return

-::
    partySize := getPreference("Loot", "PartySize")
    InputBox, input, % "Enter Party Size", % "Currently party size is " . partySize . "."
        ,,,,,,,, %partySize%
    If (Not ErrorLevel) {
        setPreference("Loot", "PartySize", input)
    }
    Return

1::
    start()
    attack()
    times := getLastDefendTimes(1)
    Loop, %times% {
        defend()
    }
    finish()
    Return

2::
    start()
    defend()
    attack()
    times := getLastDefendTimes(2)
    Loop, %times% {
        defend()
    }
    finish()
    Return

3::
    start()
    Loop, 2 {
        defend()
    }
    attack()
    times := getLastDefendTimes(3)
    Loop, %times% {
        defend()
    }
    finish()
    Return

4::
    start()
    Loop, 3 {
        defend()
    }
    attack()
    times := getLastDefendTimes(4)
    Loop, %times% {
        defend()
    }
    finish()
    Return

5::
    start()
    Loop, 4 {
        defend()
    }
    attack()
    times := getLastDefendTimes(5)
    Loop, %times% {
        defend()
    }
    finish()
    Return

6::
    start()
    Loop, 5 {
        defend()
    }
    attack()
    finish()
    Return

BackSpace::
    start()
    times := getLastDefendTimes(0)
    Loop, %times% {
        defend()
    }
    finish()
    Return

start() {
    running := False

    Send, {%cross% Down}
    Send, {%cross% Up}
    Sleep, 100
}

defend() {
    Send, {%ddown% Down}
    Send, {%ddown% Up}
    Send, {%cross% Down}
    Send, {%cross% Up}
}

attack() {
    Send, {%cross% Down}
    Send, {%cross% Up}
    Sleep, 100
    Send, {%cross% Down}
    Send, {%cross% Up}
    Sleep, 100
}

finish() {
    Sleep, 100
    Send, {%cross% Down}
    Send, {%cross% Up}

    running := True
    waitCount := 0 ; in case the fight never ends, stop waiting after certain times
    While (Not isFinishState() And running And waitCount < 5) {
        waitCount++
        Sleep, 500
    }

    If (running) {
        running := False

        ; doFinish() will close all windows
        ; instead, skip to parts where item is gained
        Loop, 2 {
            Send, {%cross% Down}
            Send, {%cross% Up}
        }
        Sleep, 100
        Send, {%cross% Down}
        Send, {%cross% Up}
    }
}

getLastDefendTimes(attackIndex) {
    times := partySize - attackIndex
    If (times < 0) {
        Return 0
    }
    Return times
}
