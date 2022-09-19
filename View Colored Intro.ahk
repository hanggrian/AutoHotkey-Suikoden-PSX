; Kill highlands spawned by Rowd and repeatedly refuse to jump.
; After 108 iterations, a fabled colored intro should appear.
; There is a risk of dying if Riou and Jowy are not at least level 3 at the start of the script.
;
; Game     : S2
; Location : Highland Camp prologue
; Speed    : >300 FPS

Menu, Tray, Icon, res/icon_s2_off.ico
MsgBox,, % "View Colored Intro (S2)"
  , % "This script will stops after 108th iteration.`n`n"
    . "Controls:`n"
    . "Backspace`tToggle on/off."

#noEnv
#include lib/core.ahk
#maxThreadsPerHotkey 2
#singleInstance force

Backspace::
  toggle := !toggle
  if (toggle) {
    Menu, Tray, Icon, res/icon_s2_on.ico
    initializeS2()
    counter := 0
  }
  loop {
    if (not toggle) {
      Menu, Tray, Icon, res/icon_s2_off.ico
      break
    } else if (counter > 108) {
      msgBox Finished.
      Menu, Tray, Icon, res/icon_s2_off.ico
      break
    }

    while (not isFinishState() && toggle) {
      if (isFightState()) {
        doFight()
      } else {
        ; Repeatedly press back to avoid clogging.
        sleep 200
        send {%triangle% down}
        send {%triangle% up}
      }
    }

    ; Finish fight and conversation.
    doFinishS2()
    loop 5 {
      sleep 200
      send {%triangle% down}
      send {%triangle% up}
    }

    ; Select 1st option 3 consecutive times.
    loop 3 {
      sleep 200
      send {%cross% down}
      send {%cross% up}
      sleep 600
      send {%triangle% down}
      send {%triangle% up}
    }

    ; Select 2nd option.
    sleep 200
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
