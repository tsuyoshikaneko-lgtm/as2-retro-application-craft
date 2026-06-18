# Publish and Verify

Use this reference when the user wants a previewable artifact, handoff package, or wrapper for a real SWF.

## Boundary

This skill can generate:

```text
spec
Flash IDE setup
AS2 frame scripts
MTASC class targets
symbol/linkage/instance maps
wrapper HTML
review checklists
prompts for other agents
```

It does not create a valid `.swf` unless one of these is available and used:

```text
Flash/Animate authoring and publishing environment
MTASC-compatible AS2 source plus local MTASC toolchain
```

## Flash IDE publish checklist

```text
□ Document type is ActionScript 2.0.
□ Stage size and fps match the spec.
□ Timeline labels exist and each state frame has stop().
□ Frame-specific setup scripts are on the frames where their instances exist.
□ Library symbols have the documented linkage IDs.
□ Stage instances have the documented instance names.
□ Dynamic linkage assets are exported for ActionScript.
□ Sound linkage IDs match attachSound() calls.
□ SharedObject name is artifact-specific.
□ Publish target is conservative, usually Flash Player 8-era.
□ Output SWF filename matches the wrapper.
```

## MTASC / Ruffle CLI pipeline

Use this only when the artifact can be generated from code at runtime. It is a weaker creator-memory match than Flash IDE authoring, but a stronger reproducible build path.

For concrete MTASC publishing, isolated builder setup, generated SWF inspection, Ruffle font-source SWFs, cache busting, and debug handoff, use the companion operational skill:

```text
../../operations/as2-swf-debug-pipeline/
../../operations/as2-swf-debug-pipeline/references/01_mtasc_publish_howto.md
```

Good fit:

```text
TextField-heavy AA games
code-drawn shapes
simple MovieClip buttons
SharedObject persistence
mouse/touch-like whole-stage controls
```

Poor fit:

```text
Timeline animation as content
hand-authored masks
Library-heavy symbol art
sound panels with linked assets
complex imported fonts or bitmaps
```

Minimum source shape:

```text
class AppName {
  static function main():Void {
    // create root objects at runtime
  }
}
```

Minimum command shape:

```sh
mtasc -cp src -main -swf app.swf -header 390:640:30:ffffff -version 8 src/AppName.as
```

Use `swfmill` only when the build needs imported assets, linked sounds, fonts, or a generated library SWF. Do not add it to a text-only project just to make the pipeline look more Flash-like.

## Ruffle wrapper smoke-check

Open the wrapper through the intended local or deployed path and check:

```text
□ Ruffle script path loads.
□ Ruffle config is declared before `ruffle.js` when custom fonts, scaling, or debug logs are needed.
□ SWF path loads.
□ Ruffle `.wasm` loads with the correct MIME type in deployed environments.
□ SWF/font/Ruffle assets are same-origin or CORS-enabled.
□ Cache-busted app/font SWF paths point at the current generated files.
□ SWF appears with the expected Stage aspect ratio.
□ START / TAP target responds.
□ Press/release state resets after release outside.
□ Main loop or primary interaction runs.
□ Retry or reset does not duplicate Key listeners or dynamic clips.
□ Sound starts only after a user action.
□ TextFields are readable on mobile.
□ Touch target size and finger occlusion are acceptable.
□ Wrapper remains plain and placement-like.
```

For random, data-driven, or generated visual states, add a SWF-owned fixture path when possible:

```text
wrapper query parameter -> FlashVars -> AS2 fixture branch
```

Do not maintain a parallel JavaScript gameplay preview as the verification source for a SWF artifact. It can be useful as an early sketch, but it must not replace Ruffle-loaded SWF smoke checks.

## Handoff note

If you cannot publish or run the SWF in the current environment, say that plainly and provide the exact checklist above as the handoff artifact. Do not imply that uncompiled frame scripts or unbuilt MTASC sources are already a working SWF.
