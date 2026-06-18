# Repository Agent Guide

This repository is a Codex / Claude Code skill pack for making small retro ActionScript 2.0 / Flash 8 applications with AI while preserving old Flash hand-feel.

## Boundaries

- `creative/as2-retro-application-craft/` is for artifact design, AS2-era authoring memory, prompts, review rubrics, and templates.
- `operations/as2-swf-debug-pipeline/` is for MTASC builds, SWF publish, Ruffle wrappers, cache, fonts, and runtime debugging.
- `operations/mtasc-builder/` is the isolated legacy toolchain. Do not install old MTASC tooling on the host unless the user explicitly asks.
- `samples/` contains concrete working artifacts.

## Agent Entrypoints

- Inside this repo, both tools can reach the skills via repo-local symlinks to the canonical directories: `.claude/skills/` (Claude Code) and `.agents/skills/` (Codex-compatible repo-local layout).
- For a user-global install, symlink the canonical skill directories into `~/.claude/skills/` (Claude Code) or `$CODEX_HOME/skills` / `~/.codex/skills` (Codex).
- `CLAUDE.md` imports this file with `@AGENTS.md`; keep shared rules here and Claude-specific notes in `CLAUDE.md`.
- `agents/openai.yaml` is Codex UI metadata. Claude ignores it; do not remove it for Claude compatibility.

## Boon AA Threader Source Of Truth

For `samples/boon-aa-threader/`, the playable artifact is the SWF.

- Build source: `samples/boon-aa-threader/mtasc/src/BoonThreader.as`
- Flash IDE handoff mirror: `samples/boon-aa-threader/frame_scripts.as`
- Ruffle wrapper config: `samples/boon-aa-threader/wrapper_config.js`
- Generated local artifacts: `boon-threader.swf`, `aa-font.swf`
- Wrapper files: `wrapper.html`, `wrapper_cdn.html`

Do not add a separate JavaScript gameplay preview. It drifts from the SWF and weakens debugging. If a representative state is needed, add a SWF fixture through FlashVars and test it through Ruffle.

## Build And Verify

From the repository root:

```sh
make swf
```

Then open the SWF through the local wrapper:

```sh
make serve
```

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1
```

Force the burst fixture through the same SWF:

```text
http://127.0.0.1:8765/samples/boon-aa-threader/wrapper_cdn.html?debug=1&fixture=burst
```

Use `wrapper_cdn.html` for quick demos/previews and `wrapper.html` for archival/self-hosted Ruffle releases.

## Maintenance Rules

- Do not commit generated `.swf` files. Build them with `make swf` locally or in CI, then deploy the generated static files to the demo host.
- Use `make dist-demo` (also the default `make dist`) for the CDN-backed public demo. Use `make dist-selfhosted` only after vendoring the Ruffle web package under the sample.
- Change wrapper cache busters, Ruffle settings, and FlashVars forwarding only in `wrapper_config.js`.
- If gameplay copy, AA, or Japanese glyph coverage changes, rebuild both `boon-threader.swf` and `aa-font.swf`. The font glyph set is derived automatically from the source string literals in `BoonThreader.as` and `frame_scripts.as` by `operations/mtasc-builder/build-ruffle-font-swf`, so new comment strings get their glyphs without hand-editing a glyph list — but you must rerun `make swf` so `aa-font.swf` picks them up.
- Keep `BoonThreader.as` and `frame_scripts.as` behaviorally equivalent when changing controls, waves, collision, copy, or state transitions. Two deliberate lane differences are allowed and must be kept in sync: (1) sound exists only in the Flash IDE lane (`frame_scripts.as`); the MTASC build is silent. (2) the SharedObject key must be identical in both (`boon_threader_v1`).
- Keep wrappers plain. They are SWF placement surfaces, not landing pages.
- When deploying the sample, ship `OFL.txt` alongside the generated `aa-font.swf`. The font glyphs are redistributed under the SIL Open Font License and the license text must travel with them. See root `LICENSE` and `THIRD-PARTY-NOTICES.md`.
- Static hosting targets should receive generated artifacts, not become the source of truth. If the hosting build environment cannot run the Docker/Podman MTASC builder, build in local/CI and deploy the resulting static directory.
- Before publishing, run `make swf`, `git diff --check`, and a Ruffle smoke check.
