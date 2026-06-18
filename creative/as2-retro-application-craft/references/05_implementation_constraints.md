# Implementation Constraints and Tradeoffs

AS2-era constraints shape the application. Do not hide them; use them carefully.

## Frame-script structure

Small AS2 apps often use frame scripts rather than class-based architecture.

Good:

```actionscript
stop();
gotoAndStop("main");
_root.onEnterFrame = function():Void { ... };
```

Avoid AS3-style packages/classes unless explicitly asked for a migration discussion.

## Frame setup and instance timing

Flash IDE stage instances exist on the frames where they are placed. Do not initialize a frame-specific instance before the playhead reaches that frame.

Good pattern:

```text
frame 1 / actions:
  common state, helper functions, navigation functions

frame "title" / actions:
  stop();
  setupText(tf_status);
  setupButton(btn_start, goMain);

frame "main" / actions:
  stop();
  setupText(tf_score);
  setupMainFrame();

frame "result" / actions:
  stop();
  setupButton(btn_retry, goMain);
```

Navigation functions should normally set state and move the playhead:

```actionscript
function goMain():Void {
    cleanupDynamic();
    _root.mode = "main";
    gotoAndStop("main");
}
```

The target frame then runs setup after `btn_start`, `tf_score`, `mc_player`, or other frame-specific instances exist. This avoids stale text, undefined instance errors, and duplicated listener setup.

If a helper is meant for an external `.as` include, say so explicitly. If it assumes Flash IDE stage instances, do not present it as a standalone AS2 app.

## onEnterFrame

`onEnterFrame` creates the characteristic every-frame body.

Use for:

- simple physics;
- cursor/touch following;
- collision checks;
- polling mode state;
- tiny loops.

Avoid making it too smooth or modern. 24fps or 30fps often feels more appropriate than a 60fps mental model.

## Input

AS2 commonly uses:

```actionscript
_root.onMouseDown
_root.onMouseUp
Key.addListener
MovieClip.onPress
MovieClip.onRelease
```

For modern mobile viewing, browser/Ruffle touch may map to mouse-like events. Design whole-stage or large-area interactions instead of tiny controls.

## Key listener trap

Avoid repeated `Key.addListener()` registration on every retry.

Register once, or explicitly remove:

```actionscript
Key.removeListener(keyListener);
```

## Button outside release

If a button sinks on `onPress`, restore it in:

```actionscript
onRelease
onReleaseOutside
onRollOut
```

Otherwise it can remain visually pressed.

## attachMovie lifecycle

Dynamic clips should be tracked and cleaned.

```actionscript
var mc:MovieClip = holder.attachMovie("mc_obstacle", "ob" + depth, depth);
dynamicClips.push(mc);
```

Cleanup:

```actionscript
for (...) dynamicClips[i].removeMovieClip();
dynamicClips = [];
```

This prevents old objects from bleeding into other screens.

## Depth

Depth bugs are historically authentic but should not break the artifact.

Plan ranges:

```text
background: 0-99
objects: 100-999
ui: 1000+
```

Use `getNextHighestDepth()` for small artifacts, but still know where things live.

## hitTest

Use simple collision. Former creators recognize `hitTest`.

For games/toys, slightly generous or slightly boxy collision is acceptable. Do not overengineer physics unless the app requires it.

## SharedObject

Use for tiny local memory:

- high score;
- sound setting;
- visited flag;
- last selected mode.

Keep it small. This is not a database.

## TextField

Common AS2 TextField practices:

```actionscript
tf.selectable = false;
tf.embedFonts = false;
tf.text = "SCORE 000012";
```

For AA/text content, ensure the font is device-font/monospace-like. On modern mobile devices, long AA may fail; use short AA tokens.

## Sound

For library-linked sound:

```actionscript
var snd:Sound = new Sound();
snd.attachSound("se_click");
snd.start();
```

Modern browsers often require user action before sound. Put sound activation behind Start/Tap.

## FlashVars

If the wrapper passes small configuration values, AS2 can read them from `_root`:

```actionscript
var mode:String = String(_root.mode);
```

Use sparingly. Too much wrapper-driven configuration makes the SWF feel like a modern embedded app.

## Loading and Export in first frame

`Export in first frame` can make linked assets load before the preloader appears. This matters when building real preloaders.

For small artifacts, a fake loading ritual may be enough. For heavier artifacts, mention the tradeoff.

## Ruffle

Ruffle is a modern translation layer, not the original Flash Player.

Do not assume every Flash behavior is identical. For generated artifacts, keep features conservative:

- simple timeline;
- simple TextFields;
- simple Sound;
- simple input;
- no exotic filters or obscure APIs unless needed.

## Publish boundary

Generated AS2 is usually a frame script or include, not a finished `.swf`. A working artifact still needs:

- Flash IDE / Animate document set to ActionScript 2.0;
- Timeline labels and frame scripts placed on an `actions` layer;
- Library symbols with linkage IDs for `attachMovie()` / `attachSound()`;
- Stage instances with instance names where the code references them;
- publish settings targeting a conservative Flash Player version;
- wrapper HTML configured to the published SWF name and Stage dimensions.

When the user asks to ship, preview, or hand off an artifact, include a short publish and Ruffle smoke-check rather than stopping at code.
