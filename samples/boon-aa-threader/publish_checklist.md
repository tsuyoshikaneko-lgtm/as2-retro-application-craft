# Publish / Ruffle Smoke Check

This sample supports two publish lanes: Flash IDE / Animate handoff and MTASC code-only build. The local verification target is always the Ruffle-loaded SWF.

## Publish Checklist

```text
□ Document type is ActionScript 2.0.
□ Stage is 390 x 640.
□ fps is 30.
□ Timeline labels are loading / title / main / result.
□ Common helper block and setupLoadingFrame() are on frame 1.
□ setupTitleFrame() is called on the title frame.
□ setupMainFrame() is called on the main frame.
□ setupResultFrame() is called on the result frame.
□ ObstacleAA has linkage ID mc_aa_obstacle and Export for ActionScript enabled.
□ Sound linkage IDs are se_click, se_pass, se_hit.
□ Stage instances match flash_ide_setup.md exactly.
□ TextFields are selectable=false and device-font based.
□ Generated publish file name is boon-threader.swf.
□ MTASC build path also succeeds with `make swf` when using the code-only sample.
□ Generated `.swf` files are not committed to Git.
```

## Ruffle Smoke Check

Open `wrapper.html` after publishing and check:

```text
□ Ruffle script path loads.
□ Ruffle config is declared before `ruffle.js` through `wrapper_config.js`.
□ `wrapper.html?debug=1` raises Ruffle logging for diagnosis.
□ `wrapper.html?debug=1&fixture=burst` opens the SWF in the burst display fixture.
□ boon-threader.swf loads inside the 390 x 640 box.
□ The full Stage remains visible on a narrow phone viewport.
□ Now Loading... appears briefly.
□ TAP TO START starts the game.
□ The player visually reads exactly as `⊂二二二（＾ω＾）二⊃`.
□ The visible player AA and its collision angle tilt together.
□ Collision uses points inside the AA strokes; fingertip grazes and pre-contact gaps stay safe.
□ Player automatically rises once during READY instead of staying still.
□ Tap/hold rises and release falls.
□ Space key also works on desktop.
□ AA background rows scroll faintly.
□ danmaku-comment-style text flows from the right.
□ Comments progress from waiting/first-post energy to reaction, crowd energy, and climax phrases.
□ The wave loop repeats as waiting -> reaction -> rising -> burst, then returns to waiting.
□ Wave clear raises obstacle speed, but burst spacing and small hit rectangles keep the game playable.
□ Burst looks dense on screen, but only the main comment carries collision.
□ Nostalgic AA appears only occasionally as a surprise.
□ Passing one obstacle increments SCORE.
□ Collision with an AA object causes GAME OVER.
□ Out-of-bounds top/bottom causes GAME OVER.
□ RETRY restarts without duplicating old obstacles.
□ HI score persists in SharedObject.
□ (Flash IDE lane only) Sound starts only after user action. The MTASC build generated as boon-threader.swf is silent.
□ Mobile text remains readable and the finger does not cover critical score text.
□ Wrapper remains plain and placement-like.
```

## Web Publish Checks

```text
□ Deploy the generated `dist/boon-aa-threader/` static files to the chosen static host.
□ For self-hosted Ruffle, deploy wrapper.html, wrapper_config.js, boon-threader.swf, aa-font.swf, OFL.txt, and ruffle/ together.
□ CDN Ruffle is used only for quick demos/previews, not archival releases.
□ .wasm files are served as application/wasm.
□ SWF/font/Ruffle assets are same-origin or CORS-enabled.
□ Content Security Policy does not block WebAssembly execution.
□ SWF and aa-font.swf paths include cache busters from wrapper_config.js while iterating.
```
