/*
Run around to fight encountered enemies.

When targeted mode is enabled, the script will only fight enemies with registered coordinates,
which is helpful when looting certain items.

Game     : S1 & S2
Location : Any enemy-spawn area, preferably with wide horizontal area
*/

#Include, lib/commons.ahk

setIconOff()
MsgBox,, % "Fight (S1 & S2)"
    , % "Controls:`n"
        . "```t`tToggle Suikoden 1 or 2.`n"
        . "-`t`tToggle fight all or targeted enemies.`n"
        . "=`t`tChange enemy coordinates for targeted enemies.`n"
        . "+`t`tTest enemy coordinates.`n"
        . "BackSpace`tToggle on/off."

global toggle

`::
    toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
    setIconOff()
    toggle := False
    Return

-::
    toggleModePreference("Fight", "Targeted", "Targeted enemies.", "All enemies.")
    toggle := False
    Return

=::
    enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
    InputBox, input, % "Enter Enemy Coordinates"
        , % "Coordinates are comma-separated. (x,y)`n"
            . "Supports multiple coordinates by separating them with space. (x1,y1 x2,y2)"
        ,,,,,,,, %enemyCoordinates%
    If (Not ErrorLevel) {
        setPreference("Fight", "EnemyCoordinates", input)
    }
    Return

+::
    initialize()
    enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
    StringSplit, coordinates, enemyCoordinates, %A_Space%
    message := "Enemy colors:`n"
    Loop, %coordinates0% {
        StringSplit, coordinate, coordinates%A_Index%, `,
        If (isEnemyFound(coordinate1, coordinate2)) {
            found := "found.`n"
        } Else {
            found := "not found.`n"
        }
        message = %message%%coordinate1%`,%coordinate2% is %found%
    }
    MsgBox, %message%
    Return

BackSpace::
    toggle := !toggle
    If (toggle) {
        setIconOn()
        initialize()
        targeted := getPreference("Fight", "Targeted")
        If (targeted) {
            enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
            StringSplit, coordinates, enemyCoordinates, %A_Space%
        }
    }
    Loop {
        If (Not toggle) {
            setIconOff()
            Break
        }

        If (isFightState()) {
            If (not targeted) {
                doFight()
            } Else {
                Loop, %coordinates0% {
                    StringSplit, coordinate, coordinates%A_Index%, `,
                    If (isEnemyFound(coordinate1, coordinate2)) {
                        doFight()
                        Break
                    }
                }
                ; if not found, escape fight
                Send, {%ddown% Down}
                Send, {%ddown% Up}
                Send, {%cross% Down}
                Send, {%cross% Up}
                ; wait for dialog animation and close
                Sleep, 100
                Send, {%cross% Down}
                Send, {%cross% Up}
            }
        } Else If (isFinishState()) {
            doFinish()
        } Else If (isFallbackState()) {
            doFallback()
        } Else {
            doMoveAround(100)
        }
    }
    Return

isEnemyFound(colorX, colorY) {
    PixelGetColor, color, colorX, colorY
    Return color = scanEnemyColor
}
