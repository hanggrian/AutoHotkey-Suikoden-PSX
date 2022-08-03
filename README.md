# AutoHotkey Suikoden PSX

AutoHotkey scripts for Suikoden 1 and 2.

## Install

Configure `preferences.ini`, specifically section `Controls` and `Scans`.

### Controls

Only D-pad and geometric shape buttons are relevant.

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

Use `Window Spy` to find a coordinate and color for scanning fight and finish state.
Here's an example of preferences for ePSXe running at 640x480 with `Pete's OpenGL2 Driver 2.9`.

```
[Scans]
S1FightColor=0x31e5fd
S1FightX=10
S1FightY=388
S1FinishColor=0x31e5fd
S1FinishX=70
S1FinishY=238
S2FightColor=0x398acc
S2FightX=12
S2FightY=400
S2FinishColor=0xfefefe
S2FinishX=30
S2FinishY=246
```

#### Suikoden 1 Fight

![Suikoden 1 Fight](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s1_fight.png)

Any border of the boxes showing party members, enemies, or moves.

#### Suikoden 1 Finish

Any border of center box showing money and item gained.

![Suikoden 1 Finish](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s1_finish.png)

#### Suikoden 2 Fight

![Suikoden 2 Fight](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s2_fight.png)

Any border of the boxes showing party members, enemies, or moves.

#### Suikoden 2 Finish

![Suikoden 2 Finish](https://github.com/hendraanggrian/AutoHotkey-Suikoden-PSX/raw/assets/s2_finish.png)

First `Lv` text of top-left box showing character exp gained.
