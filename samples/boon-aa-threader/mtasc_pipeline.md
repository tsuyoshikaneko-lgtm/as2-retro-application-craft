# MTASC / Ruffle Pipeline Feasibility

## Conclusion

This sample can be made into a real SWF through an MTASC-first pipeline, but it should be treated as a separate build target from the Flash IDE / Timeline handoff.

The current `frame_scripts.as` version assumes:

```text
Timeline labels
stage TextField instances
stage MovieClip instances
Library linkage IDs
```

MTASC works better when the SWF is generated from AS2 classes and all stage objects are created at runtime:

```text
static main()
_root.createTextField()
_root.createEmptyMovieClip()
onEnterFrame
onMouseDown / onMouseUp
SharedObject
Ruffle wrapper
```

For this AA-only game, that is a good fit because there are no bitmap assets and sound can be optional.

## Local Tool Status

Checked locally:

```text
host mtasc: missing
host swfmill: missing
ruffle desktop: missing
Homebrew: present
```

Homebrew search result:

```text
swfmill: available
mtasc: not found in default Homebrew search
ruffle: not found in default Homebrew search
```

Ruffle can still be used on the web by placing the Ruffle web package beside the wrapper or by using an official CDN script. Ruffle also documents a Homebrew tap for the desktop app, but that is a playback/test tool, not the AS2 compiler.

Build status in this environment:

```text
SWF generated: yes
output: samples/boon-aa-threader/boon-threader.swf
font source: samples/boon-aa-threader/aa-font.swf
verified: make swf completed through operations/mtasc-builder/
builder mtasc: pinned Debian snapshot package
builder swfmill: pinned Debian snapshot package
```

Generated SWFs are local/release artifacts. They are intentionally not tracked in Git; rebuild them with `make swf` or collect a static hosting directory with `make dist`.

Repository build entry:

```sh
make swf
```

That target uses `operations/mtasc-builder/` to build inside a container. It requires Docker Desktop or Podman on the host.

## Recommended Pipeline

```text
src/BoonThreader.as
  -> mtasc -main -swf boon-threader.swf -header 390:640:30:ffffff -version 8
  -> swfmill builds aa-font.swf from Noto Sans CJK JP for Ruffle fontSources
  -> wrapper.html loads boon-threader.swf through Ruffle
  -> make dist collects wrapper_config.js + SWFs + OFL.txt for static hosting
  -> optional self-hosted Ruffle release adds wrapper.html + ruffle web package
```

`swfmill` is used only for the Ruffle font-source SWF. The game itself remains code-drawn AS2 and MTASC-first.

## Proposed Commands

From this sample directory:

```sh
cd samples/boon-aa-threader
make -f mtasc/Makefile
```

From the repository root with the isolated builder:

```sh
make swf
```

For a static hosting directory:

```sh
make dist
```

Equivalent direct command:

```sh
mtasc \
  -cp mtasc/src \
  -main \
  -swf boon-threader.swf \
  -header 390:640:30:ffffff \
  -version 8 \
  mtasc/src/BoonThreader.as
```

## Distribution

Use the existing `wrapper.html` after `boon-threader.swf` is produced, or use `make dist` to collect the CDN-wrapper demo files under `dist/boon-aa-threader/`.

For static hosting:

```text
dist/boon-aa-threader/
  index.html
  wrapper_config.js
  boon-threader.swf
  aa-font.swf
  OFL.txt
```

For self-hosted Ruffle:

```text
samples/boon-aa-threader/
  boon-threader.swf
  aa-font.swf
  wrapper.html
  ruffle/
    ruffle.js
    *.wasm
```

For CDN Ruffle, replace:

```html
<script src="./ruffle/ruffle.js"></script>
```

with:

```html
<script src="https://unpkg.com/@ruffle-rs/ruffle@0.3.0/ruffle.js"></script>
```

Pin the CDN version for demos. Self-hosting is preferable for stable archival behavior.

The wrapper keeps the SWF as a fixed 390 x 640 AS2 coordinate world, but asks Ruffle to scale with `showAll` so narrow mobile viewports do not crop the game. Open the wrapper with `?debug=1` when diagnosing Ruffle load/runtime behavior. For display fixtures, keep the target as the SWF and pass FlashVars through the wrapper, for example `?debug=1&fixture=burst`.

Before release, confirm:

```text
.wasm is served as application/wasm
SWF/font/Ruffle files are same-origin or CORS-enabled
Content Security Policy does not block WebAssembly
```

For quick local confirmation while the repository server is running:

```sh
make serve
```

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html
```

## Risks

- MTASC is old and may require manual installation or building from source.
- MTASC is stricter than Flash IDE's compiler; avoid frame-script habits and nested named functions.
- Code-only SWF loses some Flash IDE materiality, but it gains reproducible CLI builds.
- Sound linkage is the main missing piece. To keep `se_click`, `se_pass`, and `se_hit`, use `swfmill` to build a library SWF or return to Flash IDE publishing.
- Ruffle support for AS1/AS2 is strong enough for this conservative pattern, but final behavior still needs smoke-checking.
- Japanese AA source encoding must be compile-checked with the actual MTASC binary used for release.

## Decision

Use MTASC for the build pipeline if reproducible CLI SWF output matters more than Flash IDE-authored Timeline/Library texture.

Keep the Flash IDE handoff as the more historically authentic source, and keep the MTASC source as the deployable/CI-friendly source.

## References

- Ruffle: https://ruffle.rs/
- Ruffle GitHub / build and install notes: https://github.com/ruffle-rs/ruffle
- Ruffle web embedding guide: https://github.com/ruffle-rs/ruffle/wiki/Using-Ruffle
- MTASC source: https://github.com/ncannasse/mtasc
- swfmill source and library-generation notes: https://github.com/djcsdy/swfmill
- fluby, an older MTASC + swfmill + Rake project generator precedent: https://github.com/bomberstudios/fluby
