; Run around to fight encountered enemies.
;
; When targeted mode is enabled, the script will only fight enemies with registered coordinates,
; which is helpful when looting certain items.
;
; Game     : S1 & S2
; Location : Any enemy-spawn area, preferably with wide horizontal area

#include lib/commons.ahk

setIconOff()
MsgBox,, % "Fight (S1 & S2)"
  , % "Controls:`n"
    . "```t`tToggle Suikoden 1 or 2.`n"
    . "-`t`tToggle fight all or targeted enemies.`n"
    . "=`t`tChange enemy coordinates for targeted enemies.`n"
    . "+`t`tTest enemy coordinates.`n"
    . "Backspace`tToggle on/off."

global toggle

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  setIconOff()
  toggle := false
  return

-::
  toggleModePreference("Fight", "Targeted", "Targeted enemies.", "All enemies.")
  toggle := false
  return

=::
  enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
  InputBox, input, Enter Enemy Coordinates, Coordinates are comma-separated. (x`,y)`nSupports multiple coordinates by separating them with space. (x1`,y1 x2`,y2),,,,,,,, %enemyCoordinates%
  if (not errorLevel) {
    setPreference("Fight", "EnemyCoordinates", input)
  }
  return

+::
  enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
  StringSplit, coordinates, enemyCoordinates, %A_Space%
  message := "Enemy colors:`n"
  loop %coordinates0% {
    StringSplit, coordinate, coordinates%A_Index%, `,
    if (isEnemyFound(coordinate1, coordinate2)) {
      found := "found.`n"
    } else {
      found := "not found.`n"
    }
    message = %message%%coordinate1%`,%coordinate2% is %found%
  }
  msgBox %message%
  return

Backspace::
  toggle := !toggle
  if (toggle) {
    setIconOn()
    initialize()
    targeted := getPreference("Fight", "Targeted")
    if (targeted) {
      enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
      StringSplit, coordinates, enemyCoordinates, %A_Space%
    }
  }
  loop {
    if (not toggle) {
      setIconOff()
      break
    }

    if (isFightState()) {
      if (not targeted) {
        doFight()
      } else {
        loop %coordinates0% {
          StringSplit, coordinate, coordinates%A_Index%, `,
          if (isEnemyFound(coordinate1, coordinate2)) {
            doFight()
            break
          }
        }
        ; if not found, escape fight
        send {%ddown% down}
        send {%ddown% up}
        send {%cross% down}
        send {%cross% up}
        ; wait for dialog animation and close
        sleep 100
        send {%cross% down}
        send {%cross% up}
      }
    } else if (isFinishState()) {
      doFinish()
    } else if (isFallbackState()) {
      doFallback()
    } else {
      doMoveAround(100)
    }
  }
  return

isEnemyFound(colorX, colorY) {
  PixelGetColor, color, colorX, colorY
  return color = scanEnemyColor
}
