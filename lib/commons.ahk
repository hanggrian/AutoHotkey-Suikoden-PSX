/*
Commons library is used for when a script supports both S1 and S2.
*/

#Include, lib/core.ahk

global isS2

/*
Load scan properties of any.
*/
initialize() {
    isS2 := getPreference("General", "S2")
    If (Not isS2) {
        initializeS1()
    } Else {
        initializeS2()
    }
}

/*
In any finish state, close all dialogs.
*/
doFinish() {
    If (Not isS2) {
        doFinishS1()
    } Else {
        doFinishS2()
    }
}

/*
In any stagnated state, press enter and back.
*/
doFallback() {
    If (Not isS2) {
        doFallbackS1()
    } Else {
        doFallbackS2()
    }
}

/*
Change icon in notification area to `off`.
*/
setIconOff() {
    isS2 := getPreference("General", "S2")
    If (isS2) {
        setIcon("icon_s2_off")
    } Else {
        setIcon("icon_s1_off")
    }
}

/*
Change icon in notification area to `on`.
*/
setIconOn() {
    isS2 := getPreference("General", "S2")
    If (isS2) {
        setIcon("icon_s2_on")
    } Else {
        setIcon("icon_s1_on")
    }
}
