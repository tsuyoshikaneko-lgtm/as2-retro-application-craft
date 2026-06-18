# Tooling Boundaries

Use this reference when an AS2/SWF artifact needs mature practice from Ruffle, MTASC, swfmill, or older Flash project tooling without losing this package's purpose:

```text
former Flash makers using AI to make small, tactile, retro AS2/SWF applications today
```

## Boundary

### Ruffle

Ruffle is the runtime and web placement layer, not the compiler.

Ruffle's AVM1 (AS2) support is partial and actively evolving. Treat any specific runtime behavior here as something to verify against the current Ruffle build, not a fixed guarantee.

Use it for:

- Keep the old `<object>` / `<embed>` shape when preserving a Flash-like page. Ruffle's polyfill can replace legacy Flash embeds with little wrapper code.
- Put `window.RufflePlayer.config` before loading `ruffle.js`.
- Use the CDN only for fast preview. For durable releases, place the Ruffle web package beside the wrapper and deploy the `.js` and `.wasm` files together.
- Use explicit wrapper configuration for small touch games.

```js
window.RufflePlayer = window.RufflePlayer || {};
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
  logLevel: "warn"
};
```

For local diagnosis, let the wrapper switch to `logLevel: "debug"` with a query parameter such as `?debug=1`.

For Japanese AA or device-font TextFields, configure `fontSources` and `defaultFonts`. This is not decorative CSS; Ruffle loads glyph outlines from the font-source SWFs and uses `defaultFonts` to substitute them for the device-font families (`sans` / `serif` / `typewriter`).

Publish checks imported from Ruffle:

- `.wasm` is served as `application/wasm`;
- cross-origin SWF/font/Ruffle files have CORS headers or are served from the same origin;
- restrictive Content Security Policy allows WebAssembly compilation;
- cache-busting is applied to the app SWF and font-source SWF during iteration.

Source: https://github.com/ruffle-rs/ruffle/wiki/Using-Ruffle

### MTASC

MTASC is a code compiler for AS2. It is not a Flash IDE replacement.

Use it when:

- Use MTASC when all required Stage objects can be created at runtime.
- Use Flash IDE / Animate when Timeline animation, visual symbol placement, Button states, masks, sounds, or Library texture are part of the craft.
- For MTASC, make the entry explicit:

```actionscript
class AppName {
    static var app:AppName;

    static function main():Void {
        app = new AppName(_root);
    }
}
```

- Keep the command inspectable:

```sh
mtasc -cp mtasc/src -main -swf app.swf -header 390:640:30:ffffff -version 8 mtasc/src/AppName.as
```

Source: https://github.com/ncannasse/mtasc

### swfmill

swfmill is best treated as a SWF asset/font construction and inspection tool.

Use it for:

- Use simple XML to package fonts, images, clips, or library SWFs.
- Use it for Ruffle font-source SWFs when AA/TextFields need Japanese glyphs.
- Keep the glyph list intentional. Missing glyphs are a publish bug.
- Pin and inspect outputs because swfmill itself is old and documented as alpha-quality.
- For redistributable samples, use redistributable fonts only. Do not package proprietary OS fonts.

Source: https://github.com/djcsdy/swfmill

### Old MTASC Project Generators

Old tools such as `fluby` show a useful precedent: AS projects were often made reproducible with a generator, a build file, and a predictable source/assets layout.

Import the shape, not the stack:

- Root build command.
- Sample-local source directory.
- Generated SWF beside its wrapper.
- Clear separation between source, generated artifact, and publish wrapper.

For this repository, prefer `Makefile` + isolated container builder over old Ruby/Rake host setup.

Source: https://github.com/bomberstudios/fluby

## What Not To Import

Do not import modern game-engine abstractions just because they are mature.

Avoid:

```text
HTML5 Canvas rewrites
AS3 display-list patterns
React/Pixi/Phaser structures
desktop-only keyboard control
marketing-page wrappers
automatic nostalgia effects
```

The value is not "a modern clone of Flash." The value is a real AS2/SWF artifact whose build and wrapper make it playable now.
