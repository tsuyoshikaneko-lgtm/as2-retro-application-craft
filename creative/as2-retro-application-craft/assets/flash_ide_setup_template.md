# Flash IDE Setup Template

Use this when explaining how to build the artifact in Flash 8 / CS3 / Animate using an AS2 document.

## Document

```text
Document type: ActionScript 2.0
Target: Flash Player 8-era unless otherwise required
Stage size:
fps: 24 or 30
Background: usually white or plain
```

Recommended Stage settings in frame script:

```actionscript
Stage.scaleMode = "noScale";
Stage.align = "TL";
stop();
```

## Timeline labels

Create labeled frames:

```text
frame 1: loading
frame 2: title
frame 3: main
frame 4: result / gameover
```

Put an `actions` layer on top.

Each state frame should usually include:

```actionscript
stop();
```

## Frame-script placement

Use one common actions frame for shared helpers, then place frame-specific setup on the frames where the instances exist.

```text
frame 1 / common actions:
  Stage.scaleMode / Stage.align
  shared state
  helper functions
  goTitle / goMain / goResult

frame "title" / actions:
  stop()
  setupText(tf_status)
  setupButton(btn_start, goMain)

frame "main" / actions:
  stop()
  setupText(tf_status or tf_score)
  setupWholeStagePress(), if needed
  archetype-specific loop, if needed

frame "result" / actions:
  stop()
  setupButton(btn_retry, goMain)
```

Do not run setup for `tf_score`, `mc_player`, `btn_retry`, or similar instances before the playhead reaches the frame where they exist.

## Layers

Suggested layers:

```text
actions
ui
hit
objects
background
```

## Library symbols

Create symbols deliberately.

| Symbol | Type | Linkage | Registration | Notes |
|---|---|---|---|---|
| main visual object | MovieClip | optional | center/top-left | scriptable if needed |
| Button | Button or MovieClip | optional | top-left | up/over/down/hit states |
| dynamic object | MovieClip | required for attachMovie | usually center | export for AS |
| sound effect | Sound | required for attachSound | n/a | export for AS |

## Linkage ID vs instance name

State this explicitly to avoid confusion:

```text
Linkage ID: library export name for attachMovie / attachSound
Instance name: stage object reference name used by code
```

Example:

```text
Library symbol: Obstacle
Linkage ID: mc_obstacle
Stage instance: not needed if dynamically attached
```

```text
Library symbol: StartButton
Stage instance name: btn_start
```

## Registration points

Document the registration point for symbols whose motion/hit behavior matters.

Examples:

```text
mc_player: center registration
mc_panel: top-left registration
mc_obstacle: center-left registration
```

## Button setup

If using Button symbols:

```text
up
over
down
hit
```

If using MovieClip buttons, implement:

```actionscript
onRollOver
onRollOut
onPress
onRelease
onReleaseOutside
```

## Sound setup

For a linked click sound:

```text
Library sound symbol: click.wav
Linkage ID: se_click
Export for ActionScript: yes
```

AS2 usage:

```actionscript
var s:Sound = new Sound();
s.attachSound("se_click");
s.start();
```

## Export in first frame trap

If using many exported linkage assets, note:

```text
Export in first frame can make assets load before the preloader appears.
```

For small artifacts, this may not matter. For heavier ones, consider a real loading strategy or keep the fake loading ritual short.

## SharedObject setup

Use an artifact-specific local object name:

```actionscript
_root.appId = "my_artifact_slug";
_root.localStore = SharedObject.getLocal(String(_root.appId));
```

Do not leave multiple artifacts sharing a generic name such as `as2_retro_app`.

## TextFields

For status text:

```text
Instance name: tf_status / tf_score / tf_hi
Selectable: false
Font: device font / monospace-like
```

Frame script should set:

```actionscript
tf_status.selectable = false;
```

## Mobile-oriented Flash setup

If mobile viewing is primary:

```text
Use larger text and AA.
Use whole-stage or large target input.
Do not rely on hover.
Prefer vertical or contained mobile Stage sizes when appropriate.
Keep desktop affordances secondary.
```

## Publish and smoke-check

Before handing off:

```text
□ Publish as an AS2 SWF.
□ Confirm the SWF filename matches the wrapper.
□ Confirm the wrapper width/height match the Stage.
□ Open the wrapper through the intended path.
□ Confirm Ruffle loads.
□ Confirm START/TAP responds.
□ Confirm retry/reset does not duplicate listeners or old dynamic clips.
□ Confirm sound starts only after user action.
□ Confirm mobile text and touch targets are readable.
```
