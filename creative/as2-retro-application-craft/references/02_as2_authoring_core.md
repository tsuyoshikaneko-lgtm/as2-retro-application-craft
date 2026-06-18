# AS2 Authoring Core

AS2-era applications were not primarily conceived as modern component trees. They were built from a concrete authoring model:

```text
Stage + Timeline + Library + Symbols + frame scripts
```

## Stage

The Stage is a fixed coordinate world.

Typical historical sizes include:

```text
550×400
640×480
800×600
```

For modern mobile-first viewing, the Stage may be vertical or smaller, but it should still feel like a contained SWF object rather than a fluid web page.

Use:

```actionscript
Stage.scaleMode = "noScale";
Stage.align = "TL";
```

## Timeline

Use Timeline labels for coarse application states.

Typical labels:

```text
loading
title
main
result
gameover
about
```

Use:

```actionscript
stop();
gotoAndStop("main");
```

Avoid turning AS2 into a modern state-machine library unless the task explicitly needs it.

## Library

The Library contains reusable symbols:

```text
Graphic symbols    timeline art or static material
Button symbols     up / over / down / hit states
MovieClip symbols  independent timelines and script targets
Sound symbols      linked sounds for attachSound()
```

The Library is also where linkage IDs are assigned.

## Linkage ID vs Instance name

Do not confuse them.

```text
Linkage ID      Library export name used by attachMovie() / attachSound()
Instance name   Stage object name used by ActionScript references
```

Example:

```text
Library MovieClip linkage ID: mc_obstacle
Stage instance name: mc_player
TextField instance name: tf_status
Button instance name: btn_start
```

## MovieClip

MovieClip is the main unit of AS2 application craft.

It can be:

- a visual object;
- a behavior container;
- an independent timeline;
- a dynamic object created by `attachMovie()`;
- a button-like object using `onPress` / `onRelease`;
- a holder for child clips.

## Depth

Depth controls visual order and lifecycle.

When dynamically creating clips:

```actionscript
var depth:Number = holder.getNextHighestDepth();
var mc:MovieClip = holder.attachMovie("mc_obstacle", "ob" + depth, depth);
```

Always plan cleanup:

```actionscript
mc.removeMovieClip();
```

## TextField

TextField is fragile and very AS2-feeling.

For device-font/status UI:

```actionscript
tf_status.selectable = false;
tf_status.embedFonts = false;
tf_status.text = "SCORE 000012";
```

For AA/text applications, keep text short and large enough for mobile viewing.

## Button

Button is not just a clickable div.

The old mental model is:

```text
up / over / down / hit
```

For MovieClip-buttons, include:

```actionscript
onRollOver
onRollOut
onPress
onRelease
onReleaseOutside
```

`onReleaseOutside` matters because otherwise pressed buttons may visually remain down.

## Local memory

Use `SharedObject` for tiny persistence:

```actionscript
var so:SharedObject = SharedObject.getLocal("my_app");
so.data.hi = 12;
so.flush();
```

Do not overuse it. A high score, preference, visited flag, or sound setting is enough.
