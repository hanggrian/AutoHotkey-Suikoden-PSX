; Kill highlands spawned by Rowd and repeatedly refuse to jump. After 108 iterations, a fabled
; colored intro should appear.
;
; Game settings `Message Speed` must be set to `Fast`. When the health of Riou & Jowy are critical,
; pause the script to use Medicine. The counter will not be reset when the script is continued.
;
; Game     : S2
; Location : Highland Camp prologue

#include lib/core.ahk

setIcon("icon_s2_off")
MsgBox,, % "View Colored Intro (S2)"
  , % "This script will stops after 108th iteration.`n`n"
    . "Controls:`n"
    . "Backspace`tToggle on/off."

global counter := 0

Backspace::
  toggle := !toggle
  if (toggle) {
    setIcon("icon_s2_on")
    initializeS2()
  }
  loop {
    if (not toggle) {
      setIcon("icon_s2_off")
      break
    } else if (counter > 108) {
      msgBox Finished.
      setIcon("icon_s2_off")
      break
    }

    while (not isFinishState() && toggle) {
      if (isFightState()) {
        doFight()
      } else {
        ; eepeatedly press back to avoid clogging
        sleep 400
        send {%triangle% down}
        send {%triangle% up}
      }
    }

    ; finish fight and conversation
    doFinishS2()
    loop 5 {
      sleep 400
      send {%triangle% down}
      send {%triangle% up}
    }

    ; select 1st option 3 consecutive times
    loop 3 {
      sleep 400
      send {%cross% down}
      send {%cross% up}
      sleep 600
      send {%triangle% down}
      send {%triangle% up}
    }

    ; select 2nd option
    sleep 400
    send {%ddown% down}
    send {%ddown% up}
    send {%cross% down}
    send {%cross% up}
    sleep 600
    send {%triangle% down}
    send {%triangle% up}

    counter++
  }
  return
