/*
Use 9 items to 1st or 2nd character, depending on mode. Then run around to encounter enemies and
deliberately lose the fight, returning to last checkpoint and repeat the processs.

In S1, items are held by 1st character. Party characters must all have 3 balloons. Change mode to
2th for characters that has fixed equipment.

In S2, items are held by party inventory. Party characters must all have 1 HP and Fire Lizard Rune
attached to their weapons. It's best to detach all non-weapon runes as certain runes (Double Beat,
Draining, etc.) may prolong the process. Change mode to 2th for non-human characters.

Game     : S1 & S2
Location : Any enemy-spawn area with save point (e.g., Soniere Prison in S1, Banner Pass in S2)
*/

#Include, lib/commons.ahk

setIconOff()
MsgBox,, % "Abuse Stat Stones Glitch (S1 & S2)"
    , % "Controls:`n"
        . "```t`tToggle Suikoden 1 or 2.`n"
        . "-`t`tToggle use to 1st or 2nd character.`n"
        . "BackSpace`tToggle on/off."

global toggle

`::
    toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
    setIconOff()
    toggle := False
    Return

-::
    toggleModePreference("AbuseStatStonesGlitch"
        , "ToSecond", "To 2nd character.", "To 1st character.")
    toggle := False
    Return

BackSpace::
    toggle := !toggle
    If (toggle) {
        setIconOn()
        initialize()
        toSecond := getPreference("AbuseStatStonesGlitch", "ToSecond")
    }
    Loop {
        If (not toggle) {
            setIconOff()
            Break
        }

        ; open menu
        Send, {%square% Down}
        Send, {%square% Up}

        If (isS2) {
            ; in S2, menu stays in party inventory whenever stone is used
            ; menu 1> items 2> party's
            Loop, 2 {
                Send, {%cross% Down}
                Send, {%cross% Up}
            }
            Loop, 9 {
                ; item 1> use 2> character
                Loop, 2 {
                    Send, {%cross% Down}
                    Send, {%cross% Up}
                }
                ; to 1st or 4th character
                If (toSecond) {
                    Send, {%ddown% Down}
                    Send, {%ddown% Up}
                }
                ; character 1> confirm
                Send, {%cross% Down}
                Send, {%cross% Up}
                ; stats raised information
                Sleep, 100
            }
            ; close menu of any depth
            Loop, 4 {
                Send, {%triangle% Down}
                Send, {%triangle% Up}
            }
        } Else {
            ; in S1, menu goes back to root whenever stone is used
            Loop, 9 {
                ; menu 1> items 2> characters 3> item 4> use
                Loop, 4 {
                    Send, {%cross% Down}
                    Send, {%cross% Up}
                }
                ; to 1st or 4th character
                If (toSecond) {
                    Send, {%dright% Down}
                    Send, {%dright% Up}
                }
                ; character 1> confirm 2> close
                Loop, 2 {
                    Send, {%cross% Down}
                    Send, {%cross% Up}
                }
            }
            ; close menu of any depth
            Loop, 4 {
                Send, {%circle% Down}
                Send, {%circle% Up}
            }
        }

        ; purposely lose fight until game over
        doMoveAndLose(toggle)
        While (isFinishState() And toggle) {
            doFinish()
            doMoveAndLose(toggle)
        }

        ; choose try again and wait for revive delay
        Send, {%cross% Down}
        Send, {%cross% Up}
        Sleep, 2000
    }
    Return

doMoveAndLose(toggle) {
    ; move around until enemies encounter
    While (Not isFightState() And toggle) {
        doMoveAround(200)
    }

    If (isS2) {
        ; with Fire Lizard rune, there's a chance of winning the fight if all enemies die at the end
        ; of the turn
        Send, {%dup% Down}
        Send, {%dup% Up}
        Loop, 4 {
            Send, {%cross% Down}
            Send, {%cross% Up}
        }
        Sleep, 700
    } Else {
        ; with baloon glitch, any fight is always lost
        Loop, 2 {
            Send, {%cross% Down}
            Send, {%cross% Up}
        }
        Sleep, 500
    }
}
