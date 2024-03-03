/*
Roll the dice and fight scripted enemies.

In case of reaching Kirinji, the game becomes stagnated. But in this case, the fallback trigger is
return to original point.

Game     : S1
Location : Just below entrance of Big Wheel in Kouan
*/

#Include, lib/core.ahk

setIcon("icon_s1_off")
MsgBox,, % "Farm Fortune Rune Piece (S1)"
    , % "Controls:`n"
        . "BackSpace`tToggle on/off."

BackSpace::
    toggle := !toggle
    If (toggle) {
        setIcon("icon_s1_on")
        initializeS1()
        counter := 0
    }
    Loop {
        If (Not toggle) {
            setIcon("icon_s1_off")
            Break
        }

        If (isFightState()) {
            doFight()
        } Else If (isFinishState()) {
            doFinishS1()
        } Else If (isFallbackState()) {
            doFallbackS1()
            doMove(ddown, 200)
        } Else {
            doMove(dup, 100)
        }
    }
    Return

doMove(direction, duration) {
    Send, {%circle% Down}

    Send, {%direction% Down}
    Sleep, duration
    Send, {%direction% Up}

    Send, {%circle% Up}
}
