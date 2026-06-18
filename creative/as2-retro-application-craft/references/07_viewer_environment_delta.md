# Viewer Environment Delta

A faithful AS2/SWF implementation does not automatically recreate the old viewer experience.

The original Flash experience was shaped by:

```text
slow connections
smaller screens
lower pixel density
mouse and keyboard input
plugin behavior
PC speakers
browser security assumptions
weird link discovery
plain placement pages
```

Modern viewers often arrive through:

```text
smartphones
fast networks
high-DPI screens
social previews
muted browsers
Ruffle
short attention windows
```

Design must account for that difference.

## 1. Loading changed

Then:

```text
loading was real
waiting created entry tension
Now Loading was functional and ceremonial
```

Now:

```text
assets may load instantly
fake waiting can feel annoying
```

Design response:

- use short loading rituals;
- do not force long waits;
- use loading to switch mental mode, not to simulate bad bandwidth.

## 2. Screen density changed

Then:

```text
640×480 or 550×400 felt substantial
MS Gothic-like text had hard edges
AA was read on lower-density displays
```

Now:

```text
high-DPI screens can make old sizes feel tiny or too smooth
mobile screens change proportions
font substitution can break AA
```

Design response:

- treat Stage as a contained object;
- choose mobile-aware dimensions if mobile is primary;
- keep AA short and large;
- avoid relying on long AA art.

## 3. Input changed

Then:

```text
cursor, hover, click, keyboard were natural
```

Now:

```text
touch has no hover
finger covers content
small controls fail
keyboard is absent
```

Design response:

- translate hover to press feedback;
- use large touch areas;
- let desktop hover be secondary;
- avoid tiny required buttons.

## 4. Sound changed

Then:

```text
sound often surprised the user
a cheap speaker sound became part of the memory
```

Now:

```text
autoplay is restricted
phones may be muted
users dislike unexpected audio
```

Design response:

- start sound after user action;
- keep effects short;
- maintain tactile click/impact feedback;
- include SOUND ON/OFF when useful.

## 5. Performance changed

Then:

```text
Flash could stutter
CPU mattered
24/30fps hardness was common
```

Now:

```text
modern browsers may make simple SWFs too smooth
Ruffle behavior differs from Flash Player
```

Design response:

- do not over-smooth motion;
- keep frame-rate-bound character;
- prefer simple per-frame motion over polished engine motion.

## 6. Plugin feeling changed

Then:

```text
Flash Player felt like a separate object inside the browser
right-click menus, no text selection, fixed SWF islands
```

Now:

```text
Ruffle translates SWF into modern browser behavior
```

Design response:

- do not hide Ruffle entirely;
- frame the SWF as a placed object;
- keep wrapper plain.

## 7. Discovery changed

Then:

```text
links from friends, boards, blogs, Flash warehouses
```

Now:

```text
X videos, screenshots, short previews
```

Design response:

- social preview should reveal the premise but not exhaust the experience;
- first 5–10 seconds should be legible;
- link page should still feel like an object placement, not an ad campaign.

## Review question

Ask:

```text
Is this merely AS2-correct, or is it viewer-memory-correct under modern conditions?
```
