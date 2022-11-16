# AutoHotkey Suikoden PSX

![Fight.ahk preview on Suikoden 2.](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/preview.gif)

AutoHotkey scripts for Suikoden 1 and 2. For when you want to maximize all characters' level and
stats without GameShark.

## Install

Configure 2 sections of `preferences.ini`.

### Controls

Enter gamepad key bindings in this section. Avoid using uppercase letters, as the Shift key will
also be triggered by AutoHotkey.

```
[Controls]
DUp=w
DLeft=a
DDown=s
DRight=d
Triangle=i
Circle=l
Cross=k
Square=j
```

### Scans

Use `Window Spy` to find a coordinate and color for scanning fight and finish state. Here's an
example of preferences for `ePSXe` running at 640x480 with `Pete's OpenGL2 Driver 2.9`.

```
[Scans]
EnemyColor=0xfefefe
S1FightPoint=10,388,0x31e5fd
S1FinishPoint=70,238,0x31e5fd
S2FightPoint=12,400,0x398acc
S2FinishPoint=30,246,0xfefefe
```

A point in this INI file is 3 comma-separated values of X-coordinate, Y-coordinate, and color.

| INI Key | Screenshot | Note |
| --- | --- | --- |
| S1FightPoint | ![Fight state scan target of Suikoden 1.](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s1_fight.png) | Any border of the boxes showing party members, enemies, or moves. |
| S1FinishPoint | ![Finish state scan target of Suikoden 1.](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s1_finish.png) | Any border of center box showing money and item gained. |
| S2FightPoint | ![Fight state scan target of Suikoden 2.](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s2_fight.png) | Any border of the boxes showing party members, enemies, or moves. |
| S2FinishPoint | ![Finish state scan target of Suikoden 2.](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s2_finish.png) | First `Lv` text of top-left box showing character exp gained. |

# Usage

All of the runnable scripts are semi-automatic triggered by keystroke (mostly `Backspace`). Run the
script and read the instruction in the initial message box.

The only tested speed of these scripts are above 300 FPS.
