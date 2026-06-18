# Mobile Viewer Translation

Modern viewers will often open the artifact on a smartphone. Do not treat this as a compromise.

## Core principle

```text
Translate Flash-era interaction memory into touch-native form.
Do not copy PC-era input devices literally.
```

## What to preserve

Preserve:

- launched-object feeling;
- small closed world;
- short entry ritual;
- tactile response;
- sound-after-action;
- short rules;
- quick failure/result;
- retry loop;
- plain placement wrapper;
- “あったなー、こういうの” smallness.

Do not insist on preserving:

- hover as a required input;
- keyboard shortcuts as primary input;
- desktop-only Stage proportions;
- tiny PC-era controls;
- long loading waits.

## Translation table

| PC-era Flash memory | Mobile translation |
|---|---|
| hover | immediate press feedback |
| click | tap |
| mouse down/up | long press/release |
| keyboard Z/X/R | large on-screen or whole-stage actions |
| small button | thumb-sized target |
| cursor touching object | finger/tap causing object response |
| 640×480 desktop box | contained mobile Stage, often vertical |
| sound surprise | sound after START/TAP |
| plugin island | Ruffle-hosted SWF box |

## Stage sizing

If mobile is primary, do not simply shrink 640×480.

Consider contained vertical stages such as:

```text
360×560
375×600
390×640
```

The exact size depends on artifact, but the important thing is that the SWF remains a contained object, not a fluid responsive app.

Desktop can still view it centered in the wrapper.

## Input rules

Prefer:

```text
tap
long press
release
simple swipe only if truly needed
whole-stage press areas
```

Avoid:

```text
small required controls
hover-only feedback
keyboard-only play
multi-touch complexity
modern gesture-heavy app design
```

## Text and AA

For mobile:

- use short AA tokens;
- avoid large multi-line AA art as core UI;
- use large enough text;
- keep labels brief;
- test that finger contact does not hide essential information.

Good AA tokens:

```text
('A`)
orz
＼(^o^)／
■■■
＜●＞
```

## Sound

Mobile sound should be opt-in through the first action.

Pattern:

```text
TAP TO START
```

The first tap can initialize interaction and sound permission. Use `SOUND ON/OFF` only if the artifact benefits from the old UI detail.

## Wrapper

Mobile wrapper should be simple:

```text
title
contained SWF
short instruction
AS2 / Ruffle / last update
```

Do not add modern share buttons, app-store-like cards, or marketing sections.

## Review checklist

```text
□ Mobile viewing is treated as primary when social spread is expected.
□ Interaction works with tap / long press / release.
□ Hover is not required.
□ Finger occlusion does not block play.
□ Text and AA are readable.
□ START / RETRY targets are large enough.
□ One play loop is short.
□ The SWF remains a contained object.
□ The UI does not become a modern app shell.
□ Desktop behavior remains acceptable but secondary.
```
