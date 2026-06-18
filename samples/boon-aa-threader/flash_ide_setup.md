# Flash IDE Setup: boon-threader.swf

## Document

```text
Document type: ActionScript 2.0
Target: Flash Player 8-era
Stage: 390 x 640
fps: 30
Background: #ffffff
```

## Timeline

Create four labeled keyframes on the `actions` layer:

```text
frame 1: loading
frame 2: title
frame 3: main
frame 4: result
```

Every labeled frame should stop. The provided `frame_scripts.as` is split by frame label. Do not paste the whole file into one frame. Copy each labeled section to the matching Timeline frame; each section already ends with its own setup call.

## Layers

Top to bottom:

```text
actions
ui
player
objects
background
```

## Library Symbols

Create these symbols:

| Symbol | Type | Linkage | Registration | Notes |
|---|---|---|---|---|
| PlayerAA | MovieClip | none | center | Empty clip is fine; AS2 offsets the AA art so the clip origin (0,0) sits at the AA's visual center, then samples collision points around that origin. |
| ObstacleAA | MovieClip | `mc_aa_obstacle` | top-left | Empty clip; export for ActionScript. |
| Holder | MovieClip | none | top-left | Empty holder placed on main frame. |
| BackgroundAA | MovieClip | none | top-left | Empty holder placed on main frame. |
| StartButton | MovieClip | none | top-left | Draw a simple border/label or leave text to stage. |
| RetryButton | MovieClip | none | top-left | Draw a simple border/label or leave text to stage. |
| click.wav | Sound | `se_click` | n/a | Export for ActionScript. |
| pass.wav | Sound | `se_pass` | n/a | Export for ActionScript. |
| hit.wav | Sound | `se_hit` | n/a | Export for ActionScript. |

Small sounds are enough: click, short pass beep, dull hit.

## Stage Instances

Place and name these instances.

### loading frame

| Instance | Type | Suggested position |
|---|---|---|
| `tf_loading` | TextField | x 40, y 290, w 310, h 40 |

### title frame

| Instance | Type | Suggested position |
|---|---|---|
| `tf_title` | TextField | x 28, y 150, w 334, h 180 |
| `btn_start` | StartButton MovieClip | x 55, y 405, w 280, h 58 |

### main frame

| Instance | Type | Suggested position |
|---|---|---|
| `mc_bg` | BackgroundAA MovieClip | x 0, y 0 |
| `mc_holder` | Holder MovieClip | x 0, y 0 |
| `mc_player` | PlayerAA MovieClip | x 104, y 320 |
| `tf_score` | TextField | x 12, y 12, w 180, h 24 |
| `tf_hi` | TextField | x 215, y 12, w 160, h 24 |
| `tf_status` | TextField | x 12, y 604, w 360, h 24 |

### result frame

| Instance | Type | Suggested position |
|---|---|---|
| `tf_result` | TextField | x 28, y 190, w 334, h 150 |
| `tf_status` | TextField | x 28, y 355, w 334, h 30 |
| `btn_retry` | RetryButton MovieClip | x 55, y 425, w 280, h 58 |

## Text Settings

Use device fonts:

```text
font: MS Gothic / Osaka / _等幅
selectable: false
embed fonts: false
```

AA should stay readable on mobile, but obstacle art may be multi-line. Keep the actual hit clip smaller than the visible AA so the game stays forgiving.

## Publish

Publish to:

```text
samples/boon-aa-threader/boon-threader.swf
```

Then open:

```text
samples/boon-aa-threader/wrapper.html
```

The wrapper assumes Ruffle at:

```text
./ruffle/ruffle.js
```

Change that path if your deployment uses a different Ruffle location.
