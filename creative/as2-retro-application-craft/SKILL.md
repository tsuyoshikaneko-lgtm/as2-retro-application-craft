---
name: as2-retro-application-craft
description: >
  Use for designing, implementing, prompting, or reviewing small ActionScript 2.0 / Flash 8 / SWF applications that should feel structurally authentic to 2000s Flash authoring while being deployable through modern Ruffle wrappers, including mobile-first viewing contexts. Focus on Stage, Timeline, Library symbols, linkage IDs, instance names, registration points, frame-script placement, optional MTASC code-only builds, MovieClip behavior, onEnterFrame, hitTest, attachMovie/removeMovieClip, Button states, TextFields, SharedObject, sound linkage, fixed/contained SWF UI, plain wrapper pages, publish/Ruffle smoke checks, and memory-correct translation of Flash-era interactions to touch. Do not use for AS3, AIR, Flex, HTML5 Canvas, WebGL, React, Pixi, p5, generic retro styling without AS2/SWF implementation, or nostalgia essays without artifact design.
---

# AS2 Retro Application Craft

## Purpose

Use this skill to create or review **small retro ActionScript 2.0 applications** that feel like they were authored under the constraints of 2000s Flash, while still being usable when reached from modern links, Ruffle, and smartphones.

This is not a recipe for a single artifact such as `よけるだけ.swf`. It is an authoring lens for many small SWF objects: games, click toys, pseudo-tools, diagnostics, galleries, sound panels, text/AA widgets, kiosks, interactive poems, and small simulations.

The goal is not period-perfect emulation. The goal is **memory-correct interaction**:

```text
old enough in structure that former Flash makers recognize it;
small enough that former viewers feel “あったなー、こういうの”;
modern enough in wrapping and input translation that people can actually try it today.
```

## Core refactor: three lenses

Always design and review through three lenses.

### 1. Former Flash creator lens

Does it feel like someone actually worked in Flash IDE with AS2?

Look for Stage, Timeline, Library, symbols, linkage IDs, instance names, registration points, frame labels, Button states, `onEnterFrame`, `hitTest`, `attachMovie`, `removeMovieClip`, `SharedObject`, depth cleanup, `trace()`, `Stage.scaleMode`, and the small traps people remember.

### 2. Former Flash viewer lens

Does it recreate the remembered experience, not just the file format?

Look for launching, waiting briefly, entering, touching, hearing, failing, retrying, smallness, plain wrapper pages, and the “something weird was placed here” feeling.

Modern devices and networks change this. Do not assume a faithful AS2 implementation automatically recreates the old viewing experience.

### 3. Agent Skill distribution lens

Is the skill usable by another agent without absorbing too much history?

Keep instructions focused. Separate core rules, references, templates, review rubrics, and eval prompts. Do not hide required assumptions such as Flash IDE instances, Ruffle not being bundled, or wrapper dependencies.

## When to use

Use this skill when a request involves any of the following:

- creating an ActionScript 2.0 / Flash 8 / SWF artifact;
- designing an AS2-era mini application rather than a modern web app;
- prompting another AI/agent to write AS2 without drifting into AS3 or JavaScript;
- reviewing AS2 code, Flash IDE setup, symbols, wrapper HTML, or Ruffle placement;
- making modern smartphone access preserve Flash-era interaction memory;
- producing a small retro application whose value comes from AS2-era structure, not just retro visuals.

## When not to use

Do not use this skill for:

- AS3, AIR, Flex, or modern Flash runtimes;
- HTML5 Canvas, WebGL, React, PixiJS, p5.js, Three.js, Unity, or modern game engines;
- pure “平成レトロ” visual styling without AS2/SWF implementation;
- historical essays that do not lead to an artifact, prompt, review, or wrapper;
- high-end interactive art that should use modern browser APIs;
- accessibility-critical or production-grade applications where AS2/SWF constraints are inappropriate.

## Primary workflow

1. **Classify the app object**: game, toy, pseudo-tool, diagnostic, gallery, sound panel, kiosk, text/AA interaction, simulation, interactive movie.
2. **Choose the dominant viewing context**: mobile-first, desktop-supported, or desktop-only archival. Default to **mobile-first viewing** when the artifact will spread through X or social links.
3. **Name the remembered screen phenomenon before choosing motifs**: identify what the old artifact *did on screen* and how viewers encountered it, rather than starting from a list of nostalgic tokens. Examples: a comment layer crossing the playfield, a loading pause, a cheap button depression, a tiny result panel, a draggable MovieClip, a sound-panel click.
4. **Map the concept to AS2 authoring primitives**:
   - Stage size and frame rate;
   - Timeline labels;
   - Library symbols and linkage IDs;
   - Stage instances and instance names;
   - registration points and hit areas;
   - TextFields, Buttons, sounds, dynamic clips;
   - depth ranges and cleanup;
   - local memory and wrapper parameters.
5. **Translate interaction memory, not input devices**:
   - hover → press feedback;
   - mouse click → tap or long press;
   - keyboard shortcut → large touch action;
   - fixed desktop SWF → contained mobile SWF object.
6. **Choose sparse UI details**: use only the details needed by the artifact. Avoid old-web parody.
7. **Choose the source mode**:
   - Flash IDE / Timeline source is the default when creator memory, Library symbols, frame labels, sounds, masks, or instance placement matter.
   - MTASC code-only source is acceptable when reproducible CLI SWF output matters and the artifact can generate its Stage objects at runtime.
   - When borrowing from existing OSS practice, import the Ruffle / MTASC / swfmill boundary, not a modern engine architecture.
8. **Choose the right implementation skeleton**: use the generic frame-script skeleton for Flash IDE handoff; use an AS2 `class` with `static main()` only for explicit MTASC targets; add archetype-specific loops only when the artifact needs them.
9. **Implement with AS2-era constraints**: `stop()`, frame labels, `gotoAndStop`, `onEnterFrame`, `attachMovie`, `hitTest`, `SharedObject`, Button callbacks, `attachSound`, and cleanup.
10. **Place frame scripts deliberately**: common helpers can live in an early `actions` frame; setup that touches `btn_start`, `tf_score`, `mc_player`, or other stage instances belongs on the frame where those instances exist.
11. **Wrap plainly**: the HTML should feel like a placement surface, not a marketing page. Use Ruffle if needed, and disclose assumptions.
12. **Keep the playable source of truth in the SWF**: if the artifact is meant to ship as SWF, verify the Ruffle-loaded SWF rather than a parallel JavaScript reimplementation.
13. **Review and smoke-check** through all three lenses before finalizing.

## Implementation boundary

This skill can produce specs, Flash IDE setup plans, AS2 frame scripts, MTASC class targets, linkage/instance maps, wrapper HTML, prompts, and review notes. It cannot compile a working `.swf` by itself unless a Flash/Animate authoring environment or a local MTASC-compatible toolchain is available.

When generating implementation output:

- state whether the output is a Flash IDE frame script, an external `.as` include, an MTASC class target, a wrapper template, or a review;
- never imply that `assets/as2_application_skeleton.as` is a standalone application;
- include frame-script placement notes for each Timeline label;
- for MTASC targets, explicitly say which Timeline/Library assumptions were removed and which objects are created at runtime;
- for representative display states, prefer FlashVars or an AS2 fixture path in the SWF over a separate JS preview that can drift;
- include a publish/Ruffle smoke-check checklist when the user is trying to ship or preview the artifact.

Use archetype-specific code only when the artifact needs it. A diagnostic tool should not inherit score/gravity/collision logic just because a game skeleton exists.

## Required abstraction model

Always think in these layers before writing code:

```text
Stage           fixed coordinate world, desktop or mobile-contained
Timeline        coarse app states as frame labels
Library         reusable Graphic / Button / MovieClip / Sound symbols
Linkage ID      string used by attachMovie() / attachSound()
Instance name   stage object name used by code
Registration    origin point that shapes motion, hit tests, rotation, alignment
MovieClip       visual object + independent timeline + behavior container
Depth           draw order and lifecycle management
TextField       fragile device-font/status UI surface
Button          up/over/down/hit object or MovieClip-button with callbacks
Sound           linked library asset controlled by Sound.attachSound()
SharedObject    tiny local persistence
Build target     Flash IDE publish or MTASC code-only SWF generation
Wrapper HTML    SWF placement surface and Ruffle bridge
Viewer delta    differences caused by modern devices, networks, sound policies, and social previews
```

If the output does not mention Stage, Timeline, Library, linkage IDs, and instance names where relevant, it is probably too modern or too vague.

## Non-negotiable AS2 constraints

Generated code must be ActionScript 2.0.

Ban:

```text
package
AS3-style class/package structure in frame-script output
Sprite
stage        AS3 lowercase stage display object (the AS2 uppercase Stage class — Stage.scaleMode / Stage.align — is required and allowed)
addEventListener
Event.ENTER_FRAME
let / const
Canvas / JavaScript game loops
React / modern component architecture
```

Prefer:

```text
stop()
gotoAndStop / gotoAndPlay
onEnterFrame
onPress / onRelease / onReleaseOutside / onRollOver / onRollOut
attachMovie / removeMovieClip
attachSound
hitTest
SharedObject.getLocal
_root
_x / _y / _alpha / _visible / _xscale / _yscale
getNextHighestDepth
Key.addListener / Key.removeListener
Stage.scaleMode = "noScale"
Stage.align = "TL"
TextField.selectable = false
trace()
AS2 class + static main() only for explicit MTASC targets
```

## Mobile-first correction

Do not treat mobile as a compromise. Modern viewers will often arrive from X or social feeds on phones.

Use this principle:

```text
Translate Flash-era interaction memory into touch-native form.
Do not copy PC-era inputs literally.
```

For mobile-first artifacts:

- use large tap or long-press areas;
- avoid depending on hover;
- make press/release feedback tactile;
- keep AA and text large enough;
- keep one play/session loop short;
- let the stage remain a contained object rather than a modern responsive app;
- use sound only after user action, but preserve click/impact feedback;
- allow desktop affordances as secondary, not primary.

## Reference selection

Use these references selectively:

- `references/01_operating_model_three_lenses.md` — overall creator/viewer/distribution lens.
- `references/02_as2_authoring_core.md` — Stage, Timeline, Library, symbols, linkage, instances.
- `references/03_flash_ide_materiality.md` — Flash IDE work-memory: registration points, layers, symbol types, sounds, masks, publish traps.
- `references/04_ui_detail_language.md` — Flash UI details and how not to turn them into parody.
- `references/05_implementation_constraints.md` — AS2 code constraints, lifecycle, input, sound, TextField, Ruffle concerns.
- `references/06_design_philosophy.md` — launched SWF object philosophy and memory-correct design.
- `references/07_viewer_environment_delta.md` — why faithful AS2 implementation is not enough under modern devices/networks.
- `references/08_mobile_viewer_translation.md` — smartphone-first translation rules.
- `references/09_application_archetypes.md` — app forms beyond a single recipe.
- `references/10_review_rubric.md` — three-lens review checklist.
- `references/11_prompting_guidelines.md` — prompting another AI/agent to generate AS2.
- `references/12_publish_and_verify.md` — Flash IDE publish and Ruffle smoke-check workflow.
- `references/13_tooling_boundaries.md` — Ruffle, MTASC, swfmill, and old project-generator boundaries worth preserving.
- `assets/as2_application_skeleton.as` — generic frame-script skeleton with explicit assumptions.
- `assets/one_button_game_loop_snippet.as` — optional game loop snippet for one-button games only.
- `assets/application_spec_template.md` — project spec template.
- `assets/flash_ide_setup_template.md` — Flash IDE authoring setup.
- `assets/ruffle_wrapper_template.html` — plain mobile-aware Ruffle wrapper.

## Companion skill handoff

If the request is primarily about compiling, publishing, or debugging an already-defined SWF, hand off to the companion operational skill:

```text
../../operations/as2-swf-debug-pipeline/
```

Use that skill for:

```text
MTASC publishing how-to
make swf
isolated MTASC builder setup
generated SWF byte inspection
Ruffle wrapper failures
Japanese AA font-source SWF generation
browser cache/stale SWF debugging
publish smoke checks
```

Keep this skill focused on what the AS2 artifact should be and how it should feel. Use the companion skill for how to compile, publish, and debug the SWF artifact.

## Output expectations

Depending on the request, produce one or more of:

- retro AS2 application plan;
- Flash IDE setup checklist;
- AS2 frame-script code;
- symbol/linkage/instance map;
- input translation plan for mobile viewers;
- Ruffle wrapper HTML;
- MTASC build target and Makefile notes;
- authenticity review;
- prompt for another agent;
- refactor notes for existing AS2/SWF work.

For implementation outputs, include:

```text
Stage size / fps
Mobile vs desktop viewing assumption
Build lane: Flash IDE Timeline or MTASC code-only
Timeline labels
Frame-script placement by label
Library symbols / linkage IDs
Stage instances / instance names
Registration point assumptions
Input model and touch translation
TextFields
Button states
Sound linkage and sound policy
Dynamic clip lifecycle
Persistence, if any
Cleanup rules
Wrapper / Ruffle notes
Known constraints
```

## Definition of done

An output using this skill is done when:

- It is clearly AS2, not AS3 or JS wearing Flash skin.
- The design is expressed through Stage, Timeline, Library, Symbols, instances, and frame scripts.
- Frame scripts that touch stage instances run only after those instances exist on the current frame.
- The code skeleton matches the artifact archetype instead of forcing game state into every object.
- UI details are sparse and functional, not parody.
- Implementation constraints are acknowledged rather than hidden.
- Publish/Ruffle assumptions and smoke checks are stated when the artifact is meant to be viewed.
- Playable verification targets the actual SWF when SWF is the intended artifact.
- If MTASC is chosen, the AS2 class target, build command, and any unverified local toolchain gap are stated.
- Mobile viewing is handled as a primary translation problem when applicable.
- Former Flash makers recognize the authoring logic.
- Former Flash viewers recognize the interaction rhythm.
- Another agent can reuse the output without needing the whole conversation history.
