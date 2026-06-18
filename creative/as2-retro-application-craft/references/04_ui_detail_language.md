# UI Detail Language

AS2 retro application UI should not be generic old-web styling. It should use Flash/SWF-specific interface details that support the artifact.

## Core details

Use a few of these, not all:

```text
Now Loading...
ENTER
START
CLICK TO START
TAP TO START
SKIP INTRO
SOUND ON / OFF
SCORE 000000
HI 000000
GAME OVER
RETRY
REPLAY
ver.1.00
last update
AS2 / Ruffle
```

## Principle

```text
Use details because the application needs them,
not because they look retro.
```

If the detail does not contribute to launch, input, feedback, state, or placement, omit it.

## Avoid old homepage parody

Do not automatically add:

```text
キリ番
工事中
blinking text everywhere
MIDI nostalgia
busy tiled backgrounds
visitor counter overload
under construction GIF energy
```

Those belong to broader old-web parody. This skill is about small SWF application craft.

## Loading

Modern networks remove natural waiting. Treat `Now Loading...` as a short ritual, not a real delay unless assets require loading.

Recommended:

```text
0.6〜1.5 seconds
simple bar or percentage
then START / ENTER / TAP TO START
```

Do not force long waits.

## Entry

Entry creates launched-object feeling.

Desktop copy:

```text
[ ENTER ]
[ START ]
CLICK TO START
```

Mobile copy:

```text
TAP TO START
おしてはじめる
```

## Button behavior

Desktop:

- hover reversal or alpha change;
- pressed state sinks 1–2 px;
- sound on release.

Mobile:

- no hover dependency;
- press/down feedback must be immediate;
- release/cancel restores state;
- touch target must be large.

## Status panels

Use short, device-font status text:

```text
SCORE 000012
HI    000034
SOUND ON
ver.1.00
```

Zero padding is useful. It feels like small Flash/game UI without requiring explanation.

## Result screens

Keep copy sparse.

```text
GAME OVER
[ RETRY ]
```

or:

```text
できました
[ もう一回 ]
```

Avoid meaning-heavy endings unless the artifact explicitly needs them.

## Wrapper UI

Wrapper pages should be quiet:

```text
title
SWF object
short explanation
ver / last update / AS2 / Ruffle
```

No modern social share blocks. Sharing should happen from the social post, not inside the tiny SWF placement page.
