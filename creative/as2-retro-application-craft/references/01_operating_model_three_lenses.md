# Operating Model: Three Lenses

Use this reference before major design or review.

The skill works because it balances three different forms of authenticity.

## 1. Former Flash creator lens

This lens asks:

```text
Would someone who actually built Flash/AS2 projects recognize the authoring logic?
```

Look for:

- Stage as a fixed coordinate system;
- Timeline labels as state boundaries;
- Library symbols, not modern components;
- Linkage IDs for dynamic creation;
- Instance names for stage references;
- registration point assumptions;
- Button up/over/down/hit thinking;
- MovieClip timelines;
- frame scripts;
- `onEnterFrame` motion;
- `hitTest` collision;
- `attachMovie` / `removeMovieClip` lifecycle;
- depth management;
- `SharedObject` local persistence;
- linked sounds;
- `trace()` debugging;
- known traps such as Export in first frame and missing instance names.

## 2. Former Flash viewer lens

This lens asks:

```text
Would someone who often clicked Flash links feel the old interaction rhythm?
```

They may not know AS2. They remember:

- `Now Loading...`;
- `ENTER` / `START`;
- sound feedback;
- small closed worlds;
- plain wrapper pages;
- touching weird things;
- failing quickly;
- `GAME OVER` / `RETRY`;
- odd unimportant artifacts;
- sending links to friends.

Do not over-explain. Viewer memory is often triggered by timing, sound, smallness, and interaction sequence more than by visual decoration.

## 3. Agent Skill distribution lens

This lens asks:

```text
Can another agent use this skill without needing the original conversation?
```

A distributable skill should:

- have a clear triggering scope;
- avoid bloated description metadata;
- separate core instructions from references;
- avoid recipe lock-in;
- mark assumptions in templates;
- include boundary eval prompts;
- clarify dependencies, especially Ruffle;
- support planning, code generation, review, and prompting.

## Review order

When reviewing an artifact, ask in this order:

1. Is it actually AS2/SWF in structure?
2. Does it feel like Flash IDE authoring, not just retro styling?
3. Does the viewer interaction rhythm work today?
4. Does mobile viewing translate the memory correctly?
5. Is the wrapper plain enough?
6. Can another agent reproduce the craft from the skill?
