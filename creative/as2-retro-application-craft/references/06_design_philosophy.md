# Design Philosophy

## SWF as launched object

AS2-era SWF applications were often experienced as small launched objects, not scrollable documents.

The user did not simply read a page. They:

```text
opened a link
waited or saw Now Loading
pressed ENTER / START
entered a small fixed world
touched something
heard feedback
failed or got a tiny result
retried or left
```

This launched-object feeling matters more than visual nostalgia.

## Smallness

Smallness is a feature.

Prefer:

- one idea;
- one primary input;
- one or two screens;
- short loop;
- sparse text;
- quick failure or result;
- little local memory.

Avoid turning the artifact into a modern app with onboarding, settings, dashboards, share flows, achievements, and analytics.

## Constraint as form

AS2 constraints are not just limitations. They produce form:

```text
fixed Stage -> contained world
Timeline labels -> visible state chunks
MovieClip -> object with behavior and timeline
onEnterFrame -> direct motion body
Button states -> tactile UI
TextField fragility -> short status copy
SharedObject -> tiny memory
```

## Memory-correct, not museum-correct

Do not chase perfect historical reenactment at the expense of today’s interaction.

Use this principle:

```text
The goal is not period-perfect emulation.
The goal is memory-correct interaction.
```

AS2 code authenticity is important, but modern devices and networks change the result. Design for how the old interaction is remembered, translated into today’s context.

## Screen phenomenon before motif

Do not start by collecting nostalgic surface tokens.

First identify the screen phenomenon that made the old object feel familiar:

```text
comments crossing the screen
Now Loading before entry
a depressed button frame
a tiny fixed-world collision
a draggable MovieClip responding directly
a cheap sound after a click
a result panel with almost no explanation
```

Then choose motifs only when they serve that phenomenon. A famous AA, word, sound, or UI decoration is weak by itself; it becomes useful when it recreates the remembered way the viewer encountered, read, touched, waited for, or failed inside the SWF.

## No overstatement

Avoid making every artifact announce its theory.

Often the best artifact is:

```text
small
plain
slightly useless
immediately touchable
strangely familiar
```

Let the wrapper or social post mention AS2/Ruffle if needed. The artifact itself should not over-explain.
