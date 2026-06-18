---
name: as2-swf-debug-pipeline
description: >
  Use for compiling, publishing, inspecting, and debugging ActionScript 2.0 / Flash 8 SWF artifacts, especially MTASC-built code-only SWFs played through Ruffle. Focus on deterministic local builds, isolated legacy toolchains, SWF artifact inspection, Ruffle wrapper checks, font-source SWFs for Japanese/AA TextFields, browser smoke tests, cache-busting, and root-cause isolation. Do not use for designing the retro application concept itself; use this after an AS2/SWF artifact exists or when build/publish/debug behavior is the task.
---

# AS2 SWF Debug Pipeline

## Purpose

Use this skill when the task is operational:

```text
Can it compile?
Did the expected SWF bytes change?
Can Ruffle load the current SWF?
Is the wrapper publishing the right files?
Do the representative visual states render correctly?
Can a human play the current build without stale cache or hidden runtime faults?
```

For application concept, Flash-era authenticity, or mobile interaction design, use the companion creative skill first:

```text
../../creative/as2-retro-application-craft/
```

## Core Rule

Never debug a published SWF as one blurry problem.

Walk the pipeline in order:

```text
source
  -> compiler/toolchain
  -> generated SWF bytes
  -> wrapper HTML
  -> Ruffle runtime
  -> browser cache/network
  -> interaction smoke test
```

At each layer, collect one concrete signal before moving to the next layer.

## Reference Selection

Read `references/01_mtasc_publish_howto.md` when the task involves any of:

```text
MTASC publish
make swf
isolated builder setup
Ruffle wrapper config
Japanese AA font-source SWF
SWF byte/structure inspection
publish checklist
common MTASC/Ruffle failures
```

Keep `SKILL.md` for routing and debug order. Keep concrete commands, Dockerfile shape, wrapper snippets, font XML, and failure recipes in the reference.

## Debug Ladder

### 1. Identify The Build Lane

Classify the artifact:

```text
Flash IDE / Animate publish
MTASC code-only class target
MTASC update-into-existing-SWF target
hybrid swfmill library/font SWF + MTASC app SWF
```

Record:

```text
source entry file
output SWF path
stage width/height/fps
wrapper path or URL
Ruffle path or CDN
sidecar SWFs/assets beside the wrapper
```

Do not assume that editing `.as` changed the SWF the browser is loading.

### 2. Make The Toolchain Deterministic

Prefer a repository-contained build path:

```text
make swf
operations/mtasc-builder/
```

Pin old packages by URL and SHA256. Avoid installing old Flash-era compilers directly onto the host unless the user explicitly asks for that.

If the user has a source archive such as `mtasc-master.zip`, do not treat it as the executable. It must be built or replaced by a known binary in an isolated builder.

### 3. Prove The SWF Bytes

After building, prove that the output exists and is the expected kind of file:

```sh
ls -lh <out.swf>
file <out.swf>
```

Expected signal for this package:

```text
Macromedia Flash data (compressed), version 8
```

When behavior is ambiguous, inspect structure or markers with decompression / `swfmill swf2xml`. Use the reference for concrete commands.

### 4. Check The Wrapper Surface

A valid SWF can still fail because the wrapper points at the wrong file.

Check:

```text
object data / param movie path
cache-busting query string
Ruffle script path
fontSources/defaultFonts path
CSS aspect ratio and object width/height
Ruffle config before ruffle.js
CDN preview vs self-hosted archive path
.wasm MIME type
CORS when files are cross-origin
CSP when the host is locked down
```

Do not trust a browser refresh if the wrapper lacks cache-busted SWF and font-source paths.

### 5. Separate Ruffle Load From Game Behavior

First prove Ruffle loaded the SWF:

```text
title/loading screen appears
no 404 for app SWF or font SWF
no missing ruffle.js / .wasm error
Ruffle replaces the object/embed
```

Then test behavior:

```text
start/retry button
first 1-2 seconds after start
input hold/release
collision/game-over
score/state update
SharedObject/high score
```

Console silence is not enough. A page can have no console errors and still have stale SWF bytes, missing glyphs, bad physics, or wrong hit boxes.

### 6. Verify Representative Display States

Build success is not display correctness.

For artifacts with random, generated, or data-driven visuals, add a fixture pathway that can force representative states during inspection. Prefer a SWF-owned fixture path such as FlashVars copied from the wrapper query string. Do not rely on a parallel JavaScript gameplay preview as the source of truth.

Useful fixture groups:

```text
small / medium / maximum text
short / long / multiline TextFields
minimum / maximum MovieClip sizes
all glyph families used by the artifact
empty / loading / active / result states
first-frame and first-interaction states
```

Check shape, not just presence:

```text
TextField width/height and wordWrap/multiline behavior
font size and line height
Stage bounds and cropping
hit rectangle vs visible art when behavior depends on it
Ruffle object/embed replacement
font-source SWF glyph coverage when Japanese/AA text is used
```

### 7. Treat Japanese AA As A Publish Issue

For Japanese AA/TextFields, do not keep changing only `TextFormat`.

Use a Ruffle font-source SWF generated with `swfmill`, and use redistributable fonts only. Verify that the font SWF exists and that the wrapper lists it in `fontSources`.

### 8. Patch The Owner Layer

Classify before editing:

```text
state bug        title/main/result transition wrong
input bug        press/release/releaseOutside order wrong
physics bug      gravity, velocity, spawn timing, or bounds too harsh
hit bug          hit rectangles do not match visual AA
cleanup bug      old TextFields/MovieClips remain after transition
font bug         glyphs missing or font source not loaded
cache bug        old SWF or font SWF still served
wrapper bug      wrong path, scale, Ruffle setting, or deploy shape
toolchain bug    compiler or generated bytes not current
```

Patch the smallest layer that owns the bug. Do not rewrite gameplay to fix a wrapper path, and do not rewrite wrapper HTML to fix gravity.

## Fix Loop

Use this loop for every issue:

```text
1. Capture the exact visible symptom.
2. Name the suspected layer.
3. Add one observable marker if needed.
4. Build with the deterministic command.
5. Verify SWF bytes before browser work.
6. Reload a cache-busted wrapper.
7. Run the shortest useful smoke test.
8. Record remaining unverified risk.
```

## Output Expectations

Report:

```text
build lane
commands run
generated files
artifact inspection result
wrapper/Ruffle checks
representative display-state checks
bug classification
patch summary
verification status
remaining risk if browser verification was blocked
```

Do not claim full playable verification unless the current SWF was actually opened and smoke-tested in Ruffle.

## Done

The task is done when:

- the build command is reproducible;
- generated SWF paths are known;
- stale-cache risk is handled;
- Ruffle wrapper dependencies are explicit;
- representative dynamic/display states have been inspected or the gap is named;
- the bug is assigned to a concrete layer;
- the patch is scoped to that layer;
- verification evidence is recorded;
- any unverified browser/manual step is named plainly.
