# Flash IDE Materiality

Former Flash makers remember more than AS2 syntax. They remember the physical work of authoring inside Flash IDE.

This reference captures that work-memory.

## Registration point

Every symbol has a registration point. It affects:

- `_x` / `_y` positioning;
- rotation;
- scaling;
- hit tests;
- visual alignment;
- whether movement feels centered or offset.

Call it out in setup instructions:

```text
mc_player: MovieClip, registration center
mc_panel: MovieClip, registration top-left
mc_obstacle: MovieClip, registration center-left
```

This is a strong former-creator detail.

## Symbol types

Use the right symbol type.

```text
Graphic    static or timeline-synced visual material; not ideal for script behavior
Button     built-in up/over/down/hit states
MovieClip  independent timeline and scriptable behavior; preferred for dynamic AS2 apps
Sound      library sound with linkage ID for attachSound()
```

When in doubt, small AS2 applications usually lean on MovieClip symbols.

## Layers

Layering is part of Flash authoring.

Typical stage layers:

```text
actions
ui
player
objects
hit
background
```

Keep `actions` as a top layer with frame scripts. A dedicated invisible `hit` layer or hit MovieClip is historically plausible.

## Hit area layer

Buttons and interactive objects often need larger hit areas than their visible art.

For Button symbols:

```text
up    visible normal state
over  hover state
down  pressed state
hit   invisible larger clickable region
```

For MovieClip-buttons, create a transparent rectangle child or separate hit clip if needed.

## Linkage and export

For `attachMovie()` and `attachSound()`, set Library linkage.

Watch the old trap:

```text
Export in first frame
```

If many linked assets export on frame 1, a preloader may appear only after heavy assets already loaded. Mention this when building real preloaders.

## Instance-name trap

Stage references need instance names.

A common failure:

```text
The symbol exists on stage, but no instance name was set.
AS2 code says mc_player._x, but mc_player is undefined.
```

Always distinguish:

```text
Library symbol name
Linkage ID
Stage instance name
```

## Frame labels and stop()

A common beginner error was forgetting `stop();`, causing the timeline to run through screens.

Every screen/state frame should normally have:

```actionscript
stop();
```

## MovieClip internal timeline

A MovieClip can have its own small timeline:

- idle two-frame blink;
- Button hover animation;
- impact flicker;
- loading bar fill;
- tiny looped object.

Do not over-modernize everything into code. Some hand-placed timeline behavior is authentic.

## Sound materiality

Sound was usually a Library asset with linkage.

Example:

```actionscript
var se:Sound = new Sound();
se.attachSound("se_click");
se.start();
```

Keep sounds short and tactile:

- click;
- start;
- impact;
- retry;
- small success.

Avoid overproduced audio unless the artifact is a sound panel.

## Masks and simple visual tricks

Mask layers, alpha fades, simple frame tweens, and shape/position changes are historically plausible.

Use sparingly. The goal is not an effects demo.

## Publish and wrapper memory

Former creators remember publishing:

- `.fla` source;
- `.swf` output;
- generated `.html`;
- Flash Player version target;
- quality setting;
- scale mode;
- wmode quirks.

The final wrapper today may use Ruffle, but preserve the sense that a SWF is being placed, not that a modern app is being mounted.
