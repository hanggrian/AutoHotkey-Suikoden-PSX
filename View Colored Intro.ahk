/*
Kill highlands spawned by Rowd and repeatedly refuse to jump. After 108 iterations, a fabled
colored intro should appear.

Game settings `Message Speed` must be set to `Fast`. When the health of Riou & Jowy are critical,
pause the script to use Medicine. The counter will not be reset when the script is continued.

Game     : S2
Location : Highland Camp prologue
*/

#Include, lib/core.ahk

setIcon("icon_s2_off")
MsgBox,, % "View Colored Intro (S2)"
    , % "This script will stops after 108th iteration.`n`n"
        . "Controls:`n"
        . "BackSpace`tToggle on/off."

global counter := 0

BackSpace::
    toggle := !toggle
    If (toggle) {
        setIcon("icon_s2_on")
        initializeS2()
    }
    Loop {
        If (Not toggle) {
            setIcon("icon_s2_off")
            Break
        } Else If (counter > 108) {
            MsgBox, % "Finished."
            setIcon("icon_s2_off")
            Break
        }

        While (Not isFinishState() And toggle) {
            If (isFightState()) {
                doFight()
            } Else {
                ; eepeatedly press back to avoid clogging
                Sleep, 400
                Send, {%triangle% Down}
                Send, {%triangle% Up}
            }
        }

        ; finish fight and conversation
        doFinishS2()
        Loop, 5 {
            Sleep, 400
            Send, {%triangle% Down}
            Send, {%triangle% Up}
        }

        ; select 1st option 3 consecutive times
        Loop, 3 {
            Sleep, 400
            Send, {%cross% Down}
            Send, {%cross% Up}
            Sleep, 600
            Send, {%triangle% Down}
            Send, {%triangle% Up}
        }

        ; select 2nd option
        Sleep, 400
        Send, {%ddown% Down}
        Send, {%ddown% Up}
        Send, {%cross% Down}
        Send, {%cross% Up}
        Sleep, 600
        Send, {%triangle% Down}
        Send, {%triangle% Up}

        counter++
    }
    Return
