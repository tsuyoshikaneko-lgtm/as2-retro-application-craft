# AS2 Retro Application Spec Template

## 1. Artifact name

```text
[name].swf
```

## 2. Artifact type

Choose one:

```text
one-button game
click toy
pseudo-tool
diagnostic
gallery
sound panel
AA/text interaction
kiosk widget
interactive movie
small simulation
other
```

## 3. Viewing assumption

```text
Primary: mobile / desktop / mixed
Distribution: X/social / direct link / archive / installation
```

If social/mobile is likely, treat mobile as primary.

## 4. Interaction memory to preserve

What should the viewer feel?

```text
launching
waiting briefly
entering
touching
hearing feedback
failing
retrying
arranging
erasing
measuring
triggering sound
```

## 5. Mobile translation

```text
Primary input:
- tap
- long press
- release
- simple swipe
- whole-stage press

Hover dependency: none / optional desktop-only
Touch target plan:
Text/AA readability:
Finger occlusion concerns:
```

## 6. Implementation boundary

```text
Output type:
- spec only
- Flash IDE frame script
- external .as include
- wrapper HTML
- review
- publish handoff

Can publish SWF in current environment: yes / no / unknown
If no, hand off publish checklist explicitly.
```

## 7. Stage

```text
Stage size:
fps: 24 / 30
Scale mode: noScale
Alignment: TL
```

## 8. Timeline labels

```text
loading
title
main
result
gameover
about
```

## 9. Frame-script placement

```text
frame 1 / common actions:
- Stage.scaleMode / align
- shared state
- helper functions
- navigation functions

frame "title" actions:
- stop()
- setup title TextFields and buttons after instances exist

frame "main" actions:
- stop()
- setup main TextFields, input, and archetype-specific loop after instances exist

frame "result" actions:
- stop()
- setup retry/result UI after instances exist
```

## 10. Library symbols

| Symbol | Type | Linkage ID | Registration point | Purpose |
|---|---|---|---|---|
|  | MovieClip / Button / Graphic / Sound |  | center / top-left / custom |  |

## 11. Stage instances

| Instance name | Symbol | Frame | Purpose |
|---|---|---|---|
| mc_player |  | main |  |
| tf_status |  | main |  |
| btn_start |  | title |  |

## 12. Layers

```text
actions
ui
hit
objects
background
```

## 13. Input behavior

```text
onPress:
onRelease:
onReleaseOutside:
onEnterFrame:
Key listener, if any:
```

## 14. TextFields

```text
selectable=false
embedFonts=false
font/device-font assumption:
copy:
```

## 15. Sound

```text
Sound assets:
Linkage IDs:
When sound is initialized:
SOUND ON/OFF behavior:
```

## 16. Dynamic clips

```text
attachMovie IDs:
depth strategy:
cleanup rules:
```

## 17. Local memory

```text
SharedObject name: [artifact_slug]
data saved:
flush timing:
```

## 18. Wrapper

```text
SWF filename:
Stage width / height:
Ruffle path:
Mobile wrapper behavior:
Plain page copy:
last update:
AS2 / Ruffle disclosure:
```

## 19. Publish / Ruffle smoke-check

```text
Publish target:
Published SWF path:
Wrapper path:
Checks:
- Ruffle script loads
- SWF path loads
- Stage aspect ratio matches
- START/TAP responds
- release outside resets button state
- retry/reset does not duplicate listeners or clips
- sound starts after user action
- mobile text and touch targets are readable
```

## 20. Review notes

```text
Former Flash creator lens:
Former viewer lens:
Mobile translation notes under viewer lens:
Agent Skill distribution lens:
```
