# Prompting Guidelines for AS2 Retro Applications

Use this when asking another AI/agent to generate AS2 plans, code, wrappers, or reviews.

## Core prompt pattern

```text
You are designing a small ActionScript 2.0 / Flash 8 / SWF application.
Do not write AS3, JavaScript, Canvas, React, or modern game-engine code.
Use AS2-era authoring practice: Stage, Timeline labels, Library symbols, linkage IDs, instance names, MovieClip behavior, frame scripts, onEnterFrame, hitTest, attachMovie/removeMovieClip, Button states, TextFields, SharedObject, and linked sounds where useful.

The output should feel structurally authentic to 2000s Flash authoring, but it should be viewable today through Ruffle and modern mobile/social contexts.
Translate Flash-era interaction memory into touch-native input when mobile viewing is expected.
```

## Anti-drift clauses

Always include bans when requesting code:

```text
Do not use package, class, Sprite, the AS3 lowercase stage object, addEventListener, Event.ENTER_FRAME, let, const, Canvas, React, or JavaScript game loops.
```

Always include preferred constructs:

```text
Use stop(), gotoAndStop(), onEnterFrame, onPress, onRelease, onReleaseOutside, onRollOver, onRollOut, attachMovie(), removeMovieClip(), attachSound(), hitTest(), SharedObject.getLocal(), _root, getNextHighestDepth(), Stage.scaleMode="noScale", Stage.align="TL", TextField.selectable=false, trace().
```

## Request the Flash IDE setup

For implementation prompts, ask for:

```text
Stage size / fps
Timeline labels
Frame-script placement by label
Library symbols
Symbol types
Linkage IDs
Instance names
Registration points
Layer plan
Sound linkage
Frame-script locations
Wrapper assumptions
Publish / Ruffle smoke-check assumptions
```

Also ask the agent to avoid generic game scaffolding unless the artifact is a game:

```text
Choose an archetype-appropriate skeleton. Do not add score, gravity, collision, or GAME OVER logic unless the artifact actually needs it.
```

## Request mobile translation

If the artifact will spread through X/social links, include:

```text
Assume many viewers will open this on a smartphone.
Do not treat mobile as a fallback.
Translate hover and mouse memory into tap, long press, release, large hit areas, and contained mobile-stage design.
```

## Review prompt

```text
Review this AS2/SWF plan through three lenses:
1. former Flash creator;
2. former Flash viewer;
3. Agent Skill distribution expert.

Check AS2 authenticity, Flash IDE materiality, frame-script placement, archetype fit, viewer environment delta, mobile interaction translation under the viewer lens, wrapper plainness, publish/Ruffle assumptions, and whether the artifact over-explains itself.
```

## Minimal generation prompt

```text
Create a small AS2 / Flash 8 / SWF application spec and code skeleton for [artifact idea].
It should feel like a small 2000s Flash object but be usable from mobile via Ruffle.
Use Stage + Timeline + Library + Symbols. Include linkage IDs, instance names, frame labels, frame-script placement, Button states, TextFields, sound policy, dynamic clip cleanup, publish/Ruffle smoke checks, and a plain wrapper HTML note.
Avoid AS3, JS, Canvas, modern app UI, and heavy nostalgia parody.
```
