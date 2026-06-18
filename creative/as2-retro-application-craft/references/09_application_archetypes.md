# Application Archetypes

This skill is not tied to one recipe. Use these archetypes as starting shapes.

## One-button game

Input:

```text
press / release
```

AS2 primitives:

```text
onMouseDown / onMouseUp
onEnterFrame
hitTest
SCORE / GAME OVER / RETRY
```

Mobile translation: whole-stage long press.

Use `assets/one_button_game_loop_snippet.as` only for this archetype or close variants. Do not let score, gravity, or collision logic leak into diagnostics, galleries, pseudo-tools, or sound panels.

## Click toy

Input:

```text
tap/click object
```

AS2 primitives:

```text
MovieClip onPress/onRelease
attachMovie small effects
attachSound click
```

Good for: objects that bounce, flee, change, disappear, say one word.

## Pseudo-tool

Input:

```text
press buttons, drag simple sliders, choose options
```

AS2 primitives:

```text
TextFields
Button states
SharedObject for tiny memory
frame labels for result screens
```

Tone: useful-looking but slightly useless. Do not over-explain.

Avoid game-state defaults unless the pseudo-tool genuinely measures time, score, or failure.

## Diagnostic / measuring app

Input:

```text
choose / tap / short sequence
```

AS2 primitives:

```text
Timeline states
TextField panels
simple score/result logic
SharedObject optional
```

Keep result copy short. Avoid self-important meaning.

Prefer `TextField`, Button states, tiny `SharedObject` memory, and frame labels over game-loop scaffolding.

## Gallery / viewer

Input:

```text
next / previous / choose thumbnail
```

AS2 primitives:

```text
gotoAndStop frames
loadMovie optional
Button states
simple transitions
```

Mobile translation: large next/previous areas.

## Sound panel

Input:

```text
tap buttons to trigger sounds
```

AS2 primitives:

```text
attachSound
SOUND ON/OFF
Button down state
```

This is a good place for tactile Flash memory.

## Text / AA interaction

Input:

```text
tap text / avoid text / arrange text / erase text
```

AS2 primitives:

```text
TextFields
MovieClip text holders
attachMovie tokens
simple hitTest
```

Mobile note: short AA only.

## Interactive movie

Input:

```text
small branch, skip, replay, click to trigger moment
```

AS2 primitives:

```text
Timeline
labels
gotoAndPlay
Button states
Sound
```

Do not make it a passive video unless interaction matters.

## Kiosk-like app

Input:

```text
large buttons, simple menu, one result panel
```

AS2 primitives:

```text
fixed Stage
big MovieClip buttons
frame labels
TextFields
```

Good for mobile because large buttons map well to touch.
