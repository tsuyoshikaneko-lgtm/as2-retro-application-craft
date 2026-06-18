# Review Rubric

Use this rubric before finalizing generated plans, code, prompts, or wrapper HTML.

## A. Former Flash creator lens

```text
□ Is it actually AS2, not AS3 or JS?
□ Does it name Stage size and fps?
□ Does it use Timeline labels or frame-state thinking?
□ Are frame-specific setup scripts placed after their stage instances exist?
□ Does it define Library symbols?
□ Does it distinguish linkage IDs from instance names?
□ Does it mention registration points where motion/alignment matters?
□ Does it use MovieClip as the main behavior/visual unit?
□ Does it use onEnterFrame for per-frame body where appropriate?
□ Does it use attachMovie/removeMovieClip for dynamic clips where appropriate?
□ Is depth/lifecycle cleanup handled?
□ Is hitTest or simple collision handled in an AS2-like way?
□ Are Button states handled, including onReleaseOutside?
□ Are TextFields made non-selectable where appropriate?
□ Is SharedObject used only for small local memory?
□ Is sound linkage / attachSound considered when sound is present?
□ Are Flash IDE traps mentioned when relevant: Export in first frame, instance-name missing, listener duplication?
□ Does the skeleton match the archetype instead of forcing score/game/collision state everywhere?
□ Does the code avoid AS3 constructs?
```

## B. Former Flash viewer lens

```text
□ Does it feel like launching a small object, not opening a modern app?
□ Is there a brief entry rhythm: loading/start/touch?
□ Can the user understand the premise quickly?
□ Does touching produce immediate feedback?
□ Is sound used sparingly but tactically?
□ Is there a short loop of reaction, failure, result, or retry?
□ Does the nostalgic choice recreate a screen phenomenon, not just name-drop old motifs?
□ Is the wrapper plain and placement-like?
□ Does the artifact avoid over-explaining its theory?
□ Would a viewer say “あったなー、こういうの” rather than “retro-themed”?
```

## C. Mobile viewer translation subcheck

```text
□ Is mobile treated as primary when social distribution is expected?
□ Does the main interaction work with tap / long press / release?
□ Is hover optional, not required?
□ Are controls thumb-sized or whole-stage?
□ Are AA and text readable on mobile?
□ Does the finger cover important information?
□ Is the play/result loop short enough?
□ Is sound initiated after user action?
□ Does the stage remain a contained SWF object?
□ Does the UI avoid becoming a modern mobile app shell?
```

## D. Agent Skill distribution lens

```text
□ Is the requested output scoped clearly?
□ Are assumptions stated?
□ Are dependencies such as Ruffle stated?
□ Are templates marked as skeletons when they assume Flash IDE stage instances?
□ Are publish/Ruffle smoke checks included when the user wants a previewable artifact?
□ Is the prompt/output reusable without the original conversation?
□ Is the skill not over-triggering for generic nostalgia or modern web work?
□ Are review and implementation artifacts separated?
```

## E. Failure signals

The artifact is drifting if:

```text
- It looks retro but is architecturally modern.
- It uses AS3 syntax.
- It becomes a polished mobile app.
- It requires desktop-only interaction even though social/mobile viewing is expected.
- It explains its concept more than it lets the user touch it.
- It adds too many old-web decorations.
- It hides implementation assumptions.
- It presents frame scripts or templates as if they were already a compiled SWF.
- It initializes frame-specific stage instances before the playhead reaches their frame.
```
