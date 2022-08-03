; Script for leveling and looting regular enemies.
; Written to work on all resolutions, but only tested with 640x480 window.
; Location	: Any enemy spawn area with wide horizontal area
; Speed		: >300 FPS

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
        ; Let go.
        send {%DDOWN% down}
        send {%DDOWN% up}
        loop 3 {
          send {%CROSS% down}
          send {%CROSS% up}
        }
      }
    } else if (scanFinish()) {
      if (s2) {
        ; Party members lv 1> exp gained 2> money gained 3> item gained
        ; 4> give up on item (if full) 5> close 6> just to be sure.
        loop 6 {
          finish()
        }
      } else {
        ; In S1, money and item gained box is the same, so no need for looping.
        finish()
      }
    } else {
      moveTwice(DLEFT, DRIGHT, 100)
    }
  }
  return

isEnemyFound(colorX, colorY) {
  PixelGetColor, color, colorX, colorY
  return color = 0xFEFEFE
}
