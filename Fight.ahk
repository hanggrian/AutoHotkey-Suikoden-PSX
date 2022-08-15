; Run around to encounter enemies and fight.
; When targeted mode is enabled, the script will only fight enemies with registered coordinates,
; which is helpful when looting certain items.
;
; Game     : S1 & S2
; Location : Any enemy spawn area with wide horizontal area
; Speed    : >300 FPS

#include libs/core.ahk
#maxThreadsPerHotkey 2

msgBox % "```t`tToggle Suikoden 1 or 2.`n"
  . "-`t`tToggle fight all or targeted enemies.`n"
  . "=`t`tChange enemy coordinates for targeted enemies.`n"
  . "+`t`tTest enemy coordinates.`n"
  . "Backspace`tToggle fight."

`::
  toggleModePreference("General", "S2", "Suikoden 2.", "Suikoden 1.")
  return

-::
  toggleModePreference("Fight", "Targeted", "Targeted enemies.", "All enemies.")
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
    prepareScan()
  }
  s2 := getPreference("General", "S2")
  targeted := getPreference("Fight", "Targeted")
  if (targeted) {
    enemyCoordinates := getPreference("Fight", "EnemyCoordinates")
    StringSplit, coordinates, enemyCoordinates, %A_Space%
  }
  loop {
    if (not toggle) {
      break
    }
    if (scanFight()) {
      if (not targeted) {
        fight()
      } else {
        loop %coordinates0% {
          StringSplit, coordinate, coordinates%A_Index%, `,
          if (isEnemyFound(coordinate1, coordinate2)) {
            fight()
            break
          }
        }
        ; Select Let Go.
        send {%ddown% down}
        send {%ddown% up}
        send {%cross% down}
        send {%cross% up}
        ; Wait for dialog animation and close, extra loop to avoid hanging.
        loop 2 {
          sleep 100
          send {%cross% down}
          send {%cross% up}
        }
      }
    } else if (scanFinish()) {
      if (s2) {
        ; Party members lv 1> exp gained 2> money gained.
        loop 2 {
          finish()
        }
        ; Money gained 1> item gained 2> give up on item (if full) 3> close.
        loop 3 {
          sleep 100
          finish()
        }
        ; Hanging item gained hotfix.
        send {%triangle% down}
        send {%triangle% up}
      } else {
        ; No need for looping in S1 because money and item gained box is the same.
        finish()
      }
    } else {
      moveTwice(dleft, dright, 100)
    }
  }
  return

isEnemyFound(colorX, colorY) {
  PixelGetColor, color, colorX, colorY
  return color = currentEnemyColor
}
