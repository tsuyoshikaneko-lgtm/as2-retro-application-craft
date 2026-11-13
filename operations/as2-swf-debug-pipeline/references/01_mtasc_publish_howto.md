# MTASC Publish How-To

This reference is the operational path for publishing an AS2 / Flash 8 SWF through MTASC and Ruffle.

Use it when the user asks:

```text
mtascしたい
SWF化したい
Ruffleで公開したい
make swfでビルドしたい
MTASCを使った配布パイプラインを作りたい
```

## Contents

- [0. Decide Whether MTASC Is The Right Lane](#0-decide-whether-mtasc-is-the-right-lane)
- [1. Recommended Repository Shape](#1-recommended-repository-shape)
- [2. Isolated MTASC Builder](#2-isolated-mtasc-builder)
- [3. Direct MTASC Command](#3-direct-mtasc-command)
- [4. MTASC-Friendly AS2 Rules](#4-mtasc-friendly-as2-rules)
- [5. Ruffle Wrapper](#5-ruffle-wrapper)
- [6. Japanese AA / Font Source SWF](#6-japanese-aa--font-source-swf)
- [7. Display Verification / Fixture States](#7-display-verification--fixture-states)
- [8. Publish Checklist](#8-publish-checklist)
- [9. Common MTASC Compile Errors](#9-common-mtasc-compile-errors)
  - [Class not found](#class-not-found)
  - [No visible output](#no-visible-output)
  - [Runtime works in preview but not in Ruffle](#runtime-works-in-preview-but-not-in-ruffle)
  - [Immediate game over / impossible game](#immediate-game-over--impossible-game)
- [10. Common Operational Failures](#10-common-operational-failures)
  - [Source archive is not the MTASC executable](#source-archive-is-not-the-mtasc-executable)
  - [Wrapper keeps showing the old SWF](#wrapper-keeps-showing-the-old-swf)
  - [Old screen text remains over gameplay](#old-screen-text-remains-over-gameplay)
  - [Random output hides display bugs](#random-output-hides-display-bugs)
- [11. Release Handoff](#11-release-handoff)

## 0. Decide Whether MTASC Is The Right Lane

MTASC is appropriate when:

```text
the SWF can be generated from AS2 classes
all stage objects can be created at runtime
there is no required Flash IDE Timeline animation
there are no required Library symbols except optional external/font SWFs
reproducible CLI build matters
```

Prefer Flash IDE / Animate publish when:

```text
Timeline animation matters
symbol placement and registration are authored visually
Button states are drawn in the Library
linked sounds/masks/library materiality are part of the craft
the artifact depends on designer-authored frames
```

For MTASC, remove Timeline assumptions. The app entry should be:

```actionscript
class AppName {
    static var app:AppName;

    static function main():Void {
        app = new AppName(_root);
    }

    function AppName(rootMc:MovieClip) {
        // create TextFields/MovieClips at runtime
    }
}
```

Do not use AS3 syntax.

## 1. Recommended Repository Shape

Use this structure:

```text
repo/
  Makefile
  tools/
    mtasc-builder/
      Dockerfile                   copied from this skill's scripts/mtasc-builder/
    build-ruffle-font-swf          optional, copied from this skill's scripts/
  samples/
    my-swf/
      wrapper.html
      wrapper_cdn.html             optional preview only
      my-swf.swf                   generated
      aa-font.swf                  optional generated Ruffle font source
      mtasc/
        Makefile
        src/
          MyApp.as
```

Root `Makefile`:

```make
RUNTIME ?= $(shell command -v docker 2>/dev/null || command -v podman 2>/dev/null)
MTASC_BUILDER_IMAGE ?= as2-retro-mtasc-builder:1.14
MTASC_PLATFORM ?= linux/amd64
SWF_SAMPLE ?= samples/my-swf

.PHONY: swf mtasc-builder-image check-container-runtime clean-swf

swf: mtasc-builder-image
	$(RUNTIME) run --rm --platform $(MTASC_PLATFORM) -v "$(CURDIR):/work" -w /work $(MTASC_BUILDER_IMAGE) make -C $(SWF_SAMPLE) -f mtasc/Makefile
	@test -f "$(SWF_SAMPLE)/my-swf.swf"

mtasc-builder-image: check-container-runtime
	$(RUNTIME) build --platform $(MTASC_PLATFORM) -t $(MTASC_BUILDER_IMAGE) tools/mtasc-builder

check-container-runtime:
	@if [ -z "$(RUNTIME)" ]; then \
		echo "Docker or Podman is required for the isolated MTASC builder."; \
		echo "Install Docker Desktop, Colima+Docker, or Podman, then run: make swf"; \
		exit 127; \
	fi

clean-swf:
	$(MAKE) -C $(SWF_SAMPLE) -f mtasc/Makefile clean
```

Sample `mtasc/Makefile`:

```make
OUT=my-swf.swf
SRC=mtasc/src/MyApp.as

.PHONY: all clean

all: $(OUT)

$(OUT): $(SRC)
	mtasc -cp mtasc/src -main -swf $(OUT) -header 390:640:30:ffffff -version 8 $(SRC)

clean:
	rm -f $(OUT)
```

## 2. Isolated MTASC Builder

Use a container because MTASC is old and usually absent from current package managers.

Copy the bundled builder from this skill into the repository rather than retyping it:

```sh
mkdir -p tools
cp -R <skill-dir>/scripts/mtasc-builder tools/mtasc-builder
```

`<skill-dir>` is the directory that contains this skill's `SKILL.md`. The [Dockerfile](../scripts/mtasc-builder/Dockerfile) pins the Debian base image by digest and fetches MTASC 1.14 and swfmill 0.3.6 from snapshot.debian.org with SHA256 checks. Keep those pins when editing it; an unpinned legacy package is the usual reason an old build stops reproducing.

Run:

```sh
make swf
```

Expected:

```text
Successfully tagged as2-retro-mtasc-builder:1.14
mtasc -cp mtasc/src -main -swf my-swf.swf -header 390:640:30:ffffff -version 8 mtasc/src/MyApp.as
```

## 3. Direct MTASC Command

If `mtasc` is already installed directly:

```sh
cd samples/my-swf
mtasc \
  -cp mtasc/src \
  -main \
  -swf my-swf.swf \
  -header 390:640:30:ffffff \
  -version 8 \
  mtasc/src/MyApp.as
```

Parameters:

```text
-cp       classpath root
-main     call static main()
-swf      output or updated SWF path
-header   width:height:fps:background
-version  SWF version; use 8 for conservative Flash 8 / Ruffle AS2 work
```

Use `-out` instead of `-swf` only when updating an existing SWF and writing a separate output file. For code-only generated SWFs, `-swf <out.swf>` with `-header` is enough.

## 4. MTASC-Friendly AS2 Rules

Use:

```text
class + static main()
_root.createEmptyMovieClip()
_root.createTextField()
MovieClip.onEnterFrame
MovieClip.onPress / onRelease / onReleaseOutside
Key.addListener
SharedObject.getLocal
TextFormat
```

Avoid:

```text
Timeline frame labels as required runtime state
Flash IDE stage instance assumptions
Library linkage assumptions unless imported separately
nested local functions that rely on Flash IDE quirks
AS3 package/Sprite/stage/addEventListener
```

For dynamic properties on MovieClips, MTASC without `-strict` is forgiving. If using `-strict`, prefer typed holder objects or explicit fields.

## 5. Ruffle Wrapper

Use Ruffle as the playback/publish surface. It is not the compiler.

For quick confirmation, the Ruffle CDN is acceptable. Pin the version and the explicit `ruffle.js` file so the demo does not follow the moving package default:

```html
<script src="https://unpkg.com/@ruffle-rs/ruffle@0.3.0/ruffle.js"></script>
```

For archival publish, vendor the Ruffle web package and deploy the JavaScript and WebAssembly files together:

```text
my-swf/
  wrapper.html
  my-swf.swf
  aa-font.swf      optional
  ruffle/
    ruffle.js
    *.wasm
```

Set `window.RufflePlayer.config` before loading `ruffle.js`. For small mobile-contained AS2 samples, default to full-stage visibility in the wrapper:

```html
<!doctype html>
<html lang="ja">
<head>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1, viewport-fit=cover">
  <title>my-swf.swf</title>
  <script>
    window.RufflePlayer = window.RufflePlayer || {};
    (function () {
      var debug = new URLSearchParams(window.location.search).get("debug") == "1";
      window.RufflePlayer.config = {
        ...(window.RufflePlayer.config || {}),
        autoplay: "on",
        unmuteOverlay: "hidden",
        letterbox: "on",
        scale: "showAll",
        forceScale: true,
        salign: "TL",
        forceAlign: true,
        contextMenu: "rightClickOnly",
        warnOnUnsupportedContent: true,
        logLevel: debug ? "debug" : "warn"
      };
    }());
  </script>
  <script src="./ruffle/ruffle.js"></script>
  <style>
    html, body {
      margin: 0;
      background: #fff;
      text-align: center;
      font-family: "MS Gothic", "Osaka", monospace;
    }
    .swfbox {
      width: min(390px, calc(100vw - 20px));
      aspect-ratio: 390 / 640;
      border: 1px solid #000;
      overflow: hidden;
      touch-action: none;
    }
    .swfbox object,
    .swfbox embed,
    .swfbox ruffle-player {
      display: block;
      width: 100%;
      height: 100%;
    }
  </style>
</head>
<body>
  <div class="swfbox">
    <object data="my-swf.swf?v=20260618" type="application/x-shockwave-flash" width="390" height="640">
      <param name="movie" value="my-swf.swf?v=20260618">
      <param name="quality" value="high">
      <param name="scale" value="showall">
      <param name="salign" value="tl">
      <param name="allowScriptAccess" value="sameDomain">
      <p>swfを再生できませんでした。</p>
    </object>
  </div>
</body>
</html>
```

Open the same wrapper with debug logging when diagnosing Ruffle behavior:

```text
wrapper.html?debug=1
```

Publish-server checks imported from Ruffle:

```text
.wasm files are served as application/wasm
SWF, font SWF, ruffle.js, and .wasm are same-origin or CORS-enabled
restrictive CSP allows WebAssembly compilation
wrapper uses cache-busted SWF/font-source paths during iteration
```

## 6. Japanese AA / Font Source SWF

If the SWF uses Japanese or AA in AS2 TextFields, Ruffle Web may not render glyphs correctly with device fonts.

The bundled builder image already contains `swfmill`. Generate a font-source SWF with the bundled script, inside the builder container:

```sh
cp <skill-dir>/scripts/build-ruffle-font-swf tools/build-ruffle-font-swf
tools/build-ruffle-font-swf aa-font.swf mtasc/src/MyApp.as
```

Arguments are the output SWF followed by every source file whose text must render (AS2 classes, frame scripts, copy files). The script downloads Noto Sans CJK JP from a pinned commit, checks its SHA256, and embeds each printable character found in those files plus a base ASCII set.

Wire it into the sample `mtasc/Makefile` so the font rebuilds whenever the text changes:

```make
FONT_OUT=aa-font.swf
FONT_BUILDER=../../tools/build-ruffle-font-swf

$(FONT_OUT): $(FONT_BUILDER) $(SRC)
	$(FONT_BUILDER) $(FONT_OUT) $(SRC)
```

Use redistributable fonts, for example Noto Sans CJK JP under the SIL Open Font License. Do not embed proprietary Mac/Windows system fonts in a distributable package. When you redistribute a font-source SWF, ship the font's license text (for OFL fonts, `OFL.txt`) next to it.

Prefer deriving the glyph list from the artifact's source string literals rather than hand-maintaining it. A hand-kept `glyphs="..."` silently drops glyphs whenever new text is added; the bundled [build-ruffle-font-swf](../scripts/build-ruffle-font-swf) derives the set from the source files it is given, so coverage cannot drift.

Minimal font XML (illustrative; this is what the bundled script generates, with the glyph set taken from source):

```xml
<?xml version="1.0" encoding="UTF-8"?>
<movie width="1" height="1" framerate="1">
  <background color="#ffffff"/>
  <frame>
    <font id="Noto Sans CJK JP" import="/tmp/NotoSansCJKjp-Regular.otf"
      glyphs="ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789 あいうえおアイウエオ！？ー（）＾ω∀Дﾟ｡　"/>
  </frame>
</movie>
```

Generate:

```sh
swfmill simple aa-font.xml aa-font.swf
```

Configure Ruffle:

```html
<script>
  // Merge into any existing config; do NOT overwrite it, or you drop the
  // playback settings (autoplay/scale/letterbox/...) set in the wrapper above.
  // Font config and playback config must end up in one merged object.
  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = {
    ...(window.RufflePlayer.config || {}),
    fontSources: ["aa-font.swf?v=20260618"],
    defaultFonts: {
      sans: ["Noto Sans CJK JP"],
      serif: ["Noto Sans CJK JP"],
      typewriter: ["Noto Sans CJK JP"]
    }
  };
</script>
```

Deploy:

```text
wrapper.html
my-swf.swf
aa-font.swf
ruffle/
```

Verify:

```sh
swfmill swf2xml aa-font.swf stdout | rg "DefineFont2|Noto Sans CJK JP" -n -C 1
```

## 7. Display Verification / Fixture States

Compiling a SWF only proves the compiler accepted the source. It does not prove that generated text, AA, or dynamic MovieClips render correctly in the wrapper.

When the artifact has random, generated, or data-driven visuals, provide a way to force representative states for inspection. Choose the simplest mechanism that fits the build lane:

```text
FlashVars passed by the wrapper
wrapper query parameter copied into FlashVars
preview-only AS2 variable
small source constant changed only during QA
```

Do not conflate this with Ruffle `?debug=1`, which is for runtime logging. A display fixture should affect what the SWF renders. Avoid maintaining a separate JavaScript gameplay preview unless the artifact is explicitly not a SWF.

Representative states to force:

```text
short text
longest text
multiline text / AA
largest dynamic MovieClip
loading/title/main/result frames
first second after START/RETRY
all Japanese/AA glyph families used by the artifact
minimum and maximum hit/display rectangles when gameplay or interaction depends on them
```

Inspect:

```text
TextField width/height, multiline, wordWrap, and font size
Stage bounds and wrapper scaling
cropping at top/bottom/left/right edges
glyph missing/garbled text
visible object vs hit rectangle mismatch
Ruffle object/embed replacement and current cache-busted SWF URL
```

Record whether the check was automated, browser-assisted, or manual. If a state cannot be forced yet, name that as remaining risk rather than treating random smoke play as complete coverage.

## 8. Publish Checklist

Before saying “published”:

```text
make swf succeeds
file my-swf.swf reports Macromedia Flash data
wrapper references current my-swf.swf with cache buster
wrapper references aa-font.swf when Japanese/AA TextFields are used
Ruffle script path is valid
Ruffle config is declared before ruffle.js
debug wrapper mode works with ?debug=1
all files are in one deploy directory
HTTP server serves SWF with 200, not 404
HTTP server serves .wasm as application/wasm
cross-origin SWF/font/Ruffle files have valid CORS, or everything is same-origin
Content Security Policy does not block WebAssembly execution
title screen appears in Ruffle
start/retry or primary interaction works
representative display states are forced and inspected when output is random/dynamic
console has no relevant errors
manual smoke test result is recorded
```

## 9. Common MTASC Compile Errors

### Class not found

Check:

```text
class name matches file path
-cp points to the package root
package directory structure matches class package if using packages
```

For simple no-package classes:

```text
mtasc/src/MyApp.as
class MyApp { ... }
mtasc -cp mtasc/src ... mtasc/src/MyApp.as
```

### No visible output

Check:

```text
static main() exists
-main was passed
main creates visible root objects
Stage size/header is correct
TextFields have width/height
TextField text format is applied after setting text when needed
```

### Runtime works in preview but not in Ruffle

Check:

```text
device font/glyph issue
cache-busted SWF path
Ruffle AS2 support issue
Ruffle .wasm MIME type
CORS for SWF/font/Ruffle assets
Content Security Policy blocking WebAssembly
wrapper scale/letterbox mismatch causing cropped stage
for-in cleanup assumptions
button onRelease/onReleaseOutside order
SharedObject permissions
```

### Immediate game over / impossible game

Check:

```text
gravity starts on same frame as button release
initial velocity
bounds check before player stabilizes
collision active during READY/start transition
first obstacle spawn too early
hit rectangle too large
```

Use a short grace period:

```actionscript
if (startGrace > 0) {
    startGrace--;
    vy = 0;
    return;
}
```

## 10. Common Operational Failures

### Source archive is not the MTASC executable

Symptom:

```text
chmod +x mtasc
sudo mv mtasc /opt/homebrew/bin/mtasc
mtasc -help
chmod: mtasc: No such file or directory
```

Cause:

```text
The downloaded file is source or the path is wrong, not a compiled binary.
```

Fix:

```text
Use the isolated builder with a pinned MTASC binary package, or deliberately build MTASC from source.
```

### Wrapper keeps showing the old SWF

Cause:

```text
HTTP/browser/Ruffle cache is serving an old app SWF or font-source SWF.
```

Fix:

```text
Add query-string cache busters to both app.swf and aa-font.swf, then verify the SWF bytes on disk before reloading.
```

### Old screen text remains over gameplay

Cause:

```text
AS2/Ruffle cleanup code did not remove both TextFields and MovieClips during a state transition.
```

Fix:

```actionscript
for (var key:String in mc) {
    var child:Object = mc[key];
    if (child.removeTextField != undefined) child.removeTextField();
    else if (child.removeMovieClip != undefined) child.removeMovieClip();
}
```

### Random output hides display bugs

Cause:

```text
The artifact only exposes random/generated states during normal play, so maximum text, multiline text, rare glyphs, or large dynamic clips were never inspected.
```

Fix:

```text
Add a fixture/debug-state pathway and force representative states before declaring the display verified.
```

## 11. Release Handoff

For another agent or human, report:

```text
Build command:
  make swf

Generated:
  samples/my-swf/my-swf.swf
  samples/my-swf/aa-font.swf

Preview:
  http://127.0.0.1:8765/samples/my-swf/wrapper_cdn.html

Archive deploy:
  wrapper.html
  my-swf.swf
  aa-font.swf
  ruffle/

Verified:
  file output
  SWF marker search
  Ruffle title screen
  representative display states
  first interaction

Known remaining risk:
  browser automation blocked / manual smoke still needed / CDN wrapper not archival
```
