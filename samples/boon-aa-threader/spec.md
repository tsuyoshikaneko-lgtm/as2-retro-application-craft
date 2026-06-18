# boon-threader.swf Spec

## 1. Artifact

```text
boon-threader.swf
```

Small mobile-first AS2 / Flash 8 one-button AA dodge game inspired by the old "threading" control feel.

## 2. Type

```text
one-button game
AA/text interaction
```

## 3. Viewing Assumption

```text
Primary: mobile
Secondary: desktop
Distribution: X/social link or direct link
Wrapper: plain Ruffle placement page
```

Mobile is primary. Desktop should still work with mouse press/release and Space key.

## 4. Interaction Memory

Preserve:

```text
Now Loading...
TAP TO START
small fixed SWF world
one input only
AA character flying
danmaku-comment-style text flowing from the right
cheap hit/pass sound
quick GAME OVER
RETRY
score zero padding
```

Avoid:

```text
modern mobile app shell
long tutorial
share buttons
achievement system
polished physics
```

## 5. Stage

```text
Stage size: 390 x 640
fps: 30
Scale mode: noScale
Alignment: TL
Background: white
```

## 6. Timeline Labels

```text
frame 1: loading
frame 2: title
frame 3: main
frame 4: result
```

## 7. Frame-Script Placement

```text
frame "loading":
- common helpers
- SharedObject setup
- loading ritual

frame "title":
- setup title TextFields
- setup btn_start
- no whole-stage game input yet

frame "main":
- setup mc_player, mc_bg, mc_holder
- setup whole-stage press/release
- start one-button game loop

frame "result":
- cleanup dynamic clips
- setup btn_retry
- show score / hi score
```

Frame-specific setup must run on the frame where its stage instances exist.

## 8. Library Symbols

| Symbol | Type | Linkage ID | Registration | Purpose |
|---|---|---|---|---|
| PlayerAA | MovieClip | none | center | Stage instance `mc_player`; code creates AA TextField and hit clip inside it. |
| ObstacleAA | MovieClip | `mc_aa_obstacle` | top-left | Dynamically attached obstacle holder; code creates AA TextFields and hit clips. |
| Holder | MovieClip | none | top-left | Stage instance `mc_holder`; dynamic obstacles live here. |
| BackgroundAA | MovieClip | none | top-left | Stage instance `mc_bg`; code creates scrolling AA background rows. |
| StartButton | MovieClip | none | top-left | Stage instance `btn_start`; large mobile target. |
| RetryButton | MovieClip | none | top-left | Stage instance `btn_retry`; large mobile target. |
| click.wav | Sound | `se_click` | n/a | Button press feedback. |
| pass.wav | Sound | `se_pass` | n/a | Score increment feedback. |
| hit.wav | Sound | `se_hit` | n/a | Game over feedback. |

## 9. Stage Instances

| Instance name | Symbol | Frame | Purpose |
|---|---|---|---|
| `tf_loading` | TextField | loading | Shows `Now Loading...`. |
| `tf_title` | TextField | title | Title and short instruction. |
| `btn_start` | StartButton | title | Starts the game. |
| `tf_score` | TextField | main | `SCORE 000000`. |
| `tf_hi` | TextField | main | `HI 000000`. |
| `tf_status` | TextField | main/result | Short status text. |
| `mc_bg` | BackgroundAA | main | AA background layer. |
| `mc_holder` | Holder | main | Dynamic obstacle holder. |
| `mc_player` | PlayerAA | main | Flying AA player. |
| `tf_result` | TextField | result | Result score copy. |
| `btn_retry` | RetryButton | result | Retry. |

## 10. Layers

```text
actions
ui
player
objects
background
```

`actions` is always the top layer. Keep hit clips inside MovieClips, not as visible art.

## 11. Input

```text
main input: whole-stage press / release
mobile: tap and hold to rise, release to fall
desktop: mouse down/up and Space key
hover: optional only on title/retry buttons
opening: one automatic upward tap during READY grace
```

## 12. Danmaku Art Direction

Player:

```text
⊂二二二（＾ω＾）二⊃
```

The player must visually reproduce this exact AA string. Do not replace it with approximate line art. If rotated dynamic text becomes brittle in a specific Ruffle/browser combination, rasterize the exact visible AA once and rotate it. Collision should be sampled by points placed inside the AA strokes, not by broad rotated rectangles, so visual near-misses remain safe and fingertip grazes do not feel unfair.

Comment obstacle examples:

```text
wktk
1ゲト
うぽつ
乙
初見
待機
きた？
ざわ...
釣られた
サムネから
神回の予感
職人待機
これは伸びる
今北産業
作者巡回済み
謎の中毒性
ループ推奨
タグロック理解
まだ序盤
うおおおおお
コメント増えてきた
弾幕準備
弾幕注意報
もっと評価されるべき
才能の無駄遣い
なぜ止めたし
公式が病気
エコノミー涙目
ここに病院を建てよう
ランキングから来た
古参ホイホイ
弾幕薄いよ！なにやってんの！
おまいら自重しろwww
コメントが本編
俺の腹筋を返せ
人類には早すぎる
よく訓練されたコメント欄
お前らの愛で見えない
弾幕濃すぎて読めない
コメントが動画を超えた
ここに文化が残ってる
弾幕に参加せざるを得ない
伝説の始まり
ありがとう職人
ここから本番
提供：俺ら
```

Surprise AA examples:

```text
　∧∧
＜(ﾟДﾟ,,)

　∧＿∧
＜（´∀｀　）

＜ｷﾀ━━
　(ﾟ∀ﾟ)
　━━!!
```

Obstacles should primarily read as danmaku-comment-style flowing text, not walls or physical objects. The pool has a loose comment-thread arc: waiting and first-post comments, first reactions, rising crowd energy, then full-screen applause/chaos. A small probability inserts nostalgic AA such as ギコ, モナー, しょぼーん, ドクオ, キター, やる夫-like forms, or やらない夫-like forms. The collision remains a simple AS2-style rectangle inside each text object, intentionally smaller than the visible text for mobile play.

Background is made from faint scrolling AA rows, not from bitmap art.

## 13. Wave Design

```text
1 wave = waiting -> reaction -> rising -> burst
waiting:  3 passed comments
reaction: 4 passed comments
rising:   5 passed comments
burst:    4 passed comments
wave clear: return to waiting and raise obstacle speed
```

The burst phase should be visually obvious: larger text, longer comments, and more "wwww" / "8888" / crowd phrases. It must not become a hard wall. Keep burst collision rectangles much narrower than the visible text, use fixed vertical lanes, avoid spawning two consecutive comments on the same lane, and add extra non-colliding comments around the main obstacle when the screen needs denser visual danmaku.

Wave difficulty is speed-led:

```text
speed scale = min(1.55, 1.00 + waveIndex * 0.08)
spawn spacing is phase-based, not aggressively compressed by wave
```

## 14. Scoring

```text
Score increments when one comment object fully passes the player.
High score is saved in SharedObject.
Score display uses zero padding.
Difficulty starts forgiving: short waiting comments, moderate speed, and a readable spawn interval.
The obstacle pool loops through waiting, reaction, rising, and burst phases every wave. Occasional nostalgic AA remains rare and does not appear during burst, so it feels like a surprise instead of disrupting the main wave rhythm.
After start/retry, give a short READY grace period before bounds, obstacle spawn, and collision checks begin. During that grace period, apply one automatic upward tap so the player immediately floats instead of freezing at center.
```

SharedObject:

```text
name: boon_threader_v1
data: hi, soundOn
flush: on game over and sound toggle
```

## 15. Wrapper

```text
SWF: boon-threader.swf
Ruffle path: ./ruffle/ruffle.js
Shared wrapper config: wrapper_config.js
Stage box: 390 x 640
Wrapper copy: minimal Japanese note only
```

Local SWF fixtures:

```text
?debug=1                 Ruffle runtime logging
?fixture=burst           pass fixture=burst to the SWF through FlashVars
?burst=1                 compatibility alias for fixture=burst
```

Do not maintain a separate JavaScript gameplay preview. Ruffle-loaded SWF behavior is the only playable verification target.

## 16. Known Constraints

- `frame_scripts.as` and `flash_ide_setup.md` are Flash IDE handoff artifacts; the MTASC path builds the checked SWF.
- Sound (the `se_click` / `se_pass` / `se_hit` linkage and the `soundOn` toggle) exists only in the Flash IDE lane, which can carry Library sounds. The MTASC code-only build that ships as `boon-threader.swf` is intentionally silent. Treat sound as a Flash-IDE-lane-only feature, not a behavioral difference to be "fixed" in the MTASC source.
- The SharedObject key must match across both lanes. Use `boon_threader_v1` in `frame_scripts.as` (`_root.appId`), in `BoonThreader.as` (`SharedObject.getLocal`), and in section 14 of this spec, so a player keeps one high score regardless of which lane produced the SWF.
- The AS2 code assumes Flash IDE / Animate stage instances and Timeline labels.
- AA rendering depends on available device fonts. Use MS Gothic / Osaka-like fonts where possible.
- Ruffle behavior is close enough for this conservative AS2 pattern, but final behavior must be smoke-checked after publishing.
