// BoonThreader.as
// MTASC-friendly ActionScript 2.0 source.
//
// Build from samples/boon-aa-threader:
//   mtasc -cp mtasc/src -main -swf boon-threader.swf -header 390:640:30:ffffff -version 8 mtasc/src/BoonThreader.as

import flash.display.BitmapData;

class BoonThreader {
    static var app:BoonThreader;

    var root:MovieClip;
    var STAGE_W:Number = 390;
    var STAGE_H:Number = 640;
    var PLAY_TOP:Number = 52;
    var PLAY_BOTTOM:Number = 596;
    var PLAYER_X:Number = 104;
    var PLAYER_AA:String = "⊂二二二（＾ω＾）二⊃";
    var PLAYER_AA_X:Number = -100;
    var PLAYER_AA_W:Number = 228;
    var PLAYER_AA_H:Number = 34;
    var PLAYER_AA_SIZE:Number = 20;
    var OB_START_X:Number = 412;
    var START_GRACE:Number = 60;
    var AUTO_TAP_FRAMES:Number = 18;
    var BURST_VISUAL_ALPHA_BASE:Number = 50;
    var BURST_VISUAL_ALPHA_ALT:Number = 18;
    var FONT_NAME:String = "_typewriter";

    var mode:String;
    var pressing:Boolean;
    var score:Number;
    var hi:Number;
    var playerY:Number;
    var vy:Number;
    var spawnWait:Number;
    var startGrace:Number;
    var autoTapFrames:Number;
    var waveIndex:Number;
    var phaseIndex:Number;
    var phasePassed:Number;
    var wavePassed:Number;
    var statusHold:Number;
    var lastLane:Number;
    var dynamicClips:Array;
    var bgRows:Array;
    var bgSpeeds:Array;
    var store:SharedObject;

    // Obstacle pools are built once and reused; rebuilding them on every spawn
    // allocated ~150 objects per obstacle on a 30fps mobile Ruffle target.
    var openingComments:Array;
    var warmupComments:Array;
    var risingComments:Array;
    var longComments:Array;
    var surprises:Array;
    var poolsBuilt:Boolean;

    var player:MovieClip;
    var playerBitmap:BitmapData;
    var scoreText:TextField;
    var hiText:TextField;
    var statusText:TextField;
    var titleLayer:MovieClip;
    var resultLayer:MovieClip;
    var bgLayer:MovieClip;
    var obstacleLayer:MovieClip;

    static function main():Void {
        app = new BoonThreader(_root);
    }

    function BoonThreader(rootMc:MovieClip) {
        root = rootMc;
        Stage.scaleMode = "noScale";
        Stage.align = "TL";

        mode = "loading";
        pressing = false;
        score = 0;
        hi = 0;
        playerY = 320;
        vy = 0;
        spawnWait = 42;
        startGrace = 0;
        autoTapFrames = 0;
        waveIndex = 0;
        phaseIndex = 0;
        phasePassed = 0;
        wavePassed = 0;
        statusHold = 0;
        lastLane = -1;
        dynamicClips = new Array();
        bgRows = new Array();
        bgSpeeds = new Array();

        // Keep this key in sync with frame_scripts.as (_root.appId) and spec.md.
        store = SharedObject.getLocal("boon_threader_v1");
        if (store.data.hi == undefined) store.data.hi = 0;
        hi = Number(store.data.hi);

        createBaseLayers();
        showLoading();
    }

    function createBaseLayers():Void {
        bgLayer = root.createEmptyMovieClip("mc_bg", 1);
        obstacleLayer = root.createEmptyMovieClip("mc_obstacles", 2);
        player = root.createEmptyMovieClip("mc_player", 3);
        titleLayer = root.createEmptyMovieClip("mc_title", 20);
        resultLayer = root.createEmptyMovieClip("mc_result", 21);

        root.createTextField("tf_score", 30, 12, 12, 180, 24);
        root.createTextField("tf_hi", 31, 215, 12, 160, 24);
        root.createTextField("tf_status", 32, 12, 604, 360, 24);
        scoreText = root.tf_score;
        hiText = root.tf_hi;
        statusText = root.tf_status;

        setupSingleLine(scoreText, 16, 0x000000, "left");
        setupSingleLine(hiText, 16, 0x000000, "right");
        setupSingleLine(statusText, 13, 0x000000, "center");
        updateHud();

        setupInput();
    }

    function setupInput():Void {
        root.onMouseDown = function():Void {
            BoonThreader.app.setPress(true);
        };
        root.onMouseUp = function():Void {
            BoonThreader.app.setPress(false);
        };

        var kl:Object = new Object();
        kl.onKeyDown = function():Void {
            if (Key.getCode() == Key.SPACE) BoonThreader.app.setPress(true);
        };
        kl.onKeyUp = function():Void {
            if (Key.getCode() == Key.SPACE) BoonThreader.app.setPress(false);
        };
        Key.addListener(kl);
    }

    function setPress(value:Boolean):Void {
        if (mode == "main") pressing = value;
    }

    function setupText(tf:TextField, size:Number, color:Number):Void {
        if (tf == undefined) return;
        tf.selectable = false;
        tf.embedFonts = false;
        tf.multiline = true;
        tf.wordWrap = false;
        var fmt:TextFormat = new TextFormat(FONT_NAME, size, color);
        fmt.align = "left";
        tf.setNewTextFormat(fmt);
        tf.setTextFormat(fmt);
    }

    function setupSingleLine(tf:TextField, size:Number, color:Number, align:String):Void {
        if (tf == undefined) return;
        tf.selectable = false;
        tf.embedFonts = false;
        tf.multiline = false;
        tf.wordWrap = false;
        var fmt:TextFormat = new TextFormat(FONT_NAME, size, color);
        fmt.align = align;
        tf.setNewTextFormat(fmt);
        tf.setTextFormat(fmt);
    }

    function setText(tf:TextField, value:String, size:Number, color:Number, align:String):Void {
        setupSingleLine(tf, size, color, align);
        tf.text = value;
        tf.setTextFormat(new TextFormat(FONT_NAME, size, color));
    }

    function pad(n:Number, digits:Number):String {
        var s:String = String(Math.floor(n));
        while (s.length < digits) s = "0" + s;
        return s;
    }

    function updateHud():Void {
        setText(scoreText, "SCORE " + pad(score, 6), 16, 0x000000, "left");
        setText(hiText, "HI " + pad(hi, 6), 16, 0x000000, "right");
    }

    function showLoading():Void {
        clearLayer(titleLayer);
        clearLayer(resultLayer);
        titleLayer.createTextField("tf_loading", 1, 40, 290, 310, 40);
        setText(titleLayer.tf_loading, "Now Loading...", 18, 0x000000, "center");

        var waitFrames:Number = 24;
        root.onEnterFrame = function():Void {
            waitFrames--;
            if (waitFrames <= 0) BoonThreader.app.showTitle();
        };
    }

    function showTitle():Void {
        mode = "title";
        delete root.onEnterFrame;
        clearLayer(titleLayer);
        clearLayer(resultLayer);
        cleanupDynamic();
        cleanupBackground();

        titleLayer.createTextField("tf_title", 1, 28, 150, 334, 180);
        setupText(titleLayer.tf_title, 18, 0x000000);
        titleLayer.tf_title.text = "ブーン弾幕よけ\n\n" + PLAYER_AA + "\n\nおしている間だけ上昇。\n流れるコメントをよけるだけ。";
        titleLayer.tf_title.setTextFormat(new TextFormat(FONT_NAME, 18, 0x000000));

        createButton(titleLayer, "btn_start", 55, 405, "TAP TO START", "start");
    }

    function createButton(holder:MovieClip, name:String, x:Number, y:Number, label:String, action:String):MovieClip {
        var btn:MovieClip = holder.createEmptyMovieClip(name, holder.getNextHighestDepth());
        btn._x = x;
        btn._y = y;
        btn.lineStyle(1, 0x000000, 100);
        btn.beginFill(0xffffff, 100);
        btn.moveTo(0, 0);
        btn.lineTo(280, 0);
        btn.lineTo(280, 58);
        btn.lineTo(0, 58);
        btn.lineTo(0, 0);
        btn.endFill();
        btn.createTextField("tf_label", 2, 0, 16, 280, 28);
        setText(btn.tf_label, label, 18, 0x000000, "center");
        btn.useHandCursor = true;
        btn.actionName = action;
        btn.baseY = y;
        btn.isPressed = false;
        btn.onPress = function():Void {
            this.isPressed = true;
            this._y = this.baseY + 2;
        };
        btn.onRelease = function():Void {
            var ready:Boolean = this.isPressed;
            this.isPressed = false;
            this._y = this.baseY;
            if (ready && this.actionName == "start") BoonThreader.app.startGame();
        };
        btn.onReleaseOutside = function():Void {
            this.isPressed = false;
            this._y = this.baseY;
        };
        return btn;
    }

    function startGame():Void {
        var burstFixture:Boolean = isBurstFixture();
        mode = "main";
        pressing = false;
        score = 0;
        playerY = 344;
        vy = -2.6;
        spawnWait = burstFixture ? 8 : 26;
        startGrace = burstFixture ? 18 : START_GRACE;
        autoTapFrames = AUTO_TAP_FRAMES;
        waveIndex = 0;
        phaseIndex = burstFixture ? 3 : 0;
        phasePassed = 0;
        wavePassed = burstFixture ? 12 : 0;
        statusHold = 0;
        lastLane = -1;
        clearLayer(titleLayer);
        clearLayer(resultLayer);
        cleanupDynamic();
        createBackground();
        createPlayer();
        updateHud();
        setText(statusText, "READY...", 13, 0x000000, "center");

        root.onEnterFrame = function():Void {
            BoonThreader.app.tick();
        };
    }

    function isBurstFixture():Boolean {
        return String(root.fixture) == "burst" || String(root.burst) == "1";
    }

    function drawPlayerSprite(mc:MovieClip):Void {
        mc.clear();
        var stamp:MovieClip = mc.createEmptyMovieClip("mc_stamp", 1);
        stamp.createTextField("tf_aa", 1, 0, 0, PLAYER_AA_W, PLAYER_AA_H);
        setupSingleLine(stamp.tf_aa, PLAYER_AA_SIZE, 0x000000, "center");
        stamp.tf_aa.text = PLAYER_AA;
        stamp.tf_aa.setTextFormat(new TextFormat(FONT_NAME, PLAYER_AA_SIZE, 0x000000));

        playerBitmap = new BitmapData(PLAYER_AA_W, PLAYER_AA_H, true, 0x00000000);
        playerBitmap.draw(stamp);
        stamp.removeMovieClip();

        var art:MovieClip = mc.createEmptyMovieClip("mc_art", 1);
        art._x = PLAYER_AA_X;
        art._y = -PLAYER_AA_H / 2;
        art.attachBitmap(playerBitmap, 1, "never", false);
    }

    function createPlayer():Void {
        clearLayer(player);
        drawPlayerSprite(player);
        setPlayer();
    }

    function setPlayer():Void {
        player._x = PLAYER_X;
        player._y = playerY;
        player._rotation = (pressing || autoTapFrames > 0 || vy < -0.2) ? -12 : 12;
    }

    function createBackground():Void {
        cleanupBackground();
        var patterns:Array = [
            "　　.　　　.　　　.　　　.　　　.　　　.　　　.",
            "　　　／￣＼　　　　orz　　　　／￣＼",
            "　.　　　　⊂二二二　　　.　　　　　.",
            "～～～～～～～～～～～～～～～～～～～～",
            "　　（＾ω＾）　　　.　　　（#ﾟДﾟ）"
        ];
        for (var i:Number = 0; i < 18; i++) {
            bgLayer.createTextField("tf_bg" + i, i + 1, -20 - Math.random() * 100, 58 + i * 30, 560, 24);
            var tf:TextField = bgLayer["tf_bg" + i];
            setupText(tf, 14, 0x999999);
            tf._alpha = 32;
            tf.text = patterns[i % patterns.length];
            bgRows.push(tf);
            bgSpeeds.push(0.35 + (i % 3) * 0.18);
        }
    }

    function tick():Void {
        var b:Number;
        for (b = 0; b < bgRows.length; b++) {
            var row:TextField = bgRows[b];
            row._x -= Number(bgSpeeds[b]);
            if (row._x < -180) row._x = 0;
        }

        if (mode != "main") return;

        if (startGrace > 0) {
            startGrace--;
            if (autoTapFrames > 0) {
                autoTapFrames--;
                vy -= 0.52;
            } else {
                vy += 0.30;
            }
            if (vy < -3.8) vy = -3.8;
            if (vy > 3.2) vy = 3.2;
            playerY += vy;
            if (playerY < PLAY_TOP + 82) {
                playerY = PLAY_TOP + 82;
                vy = 0.7;
                autoTapFrames = 0;
            }
            if (playerY > 365) {
                playerY = 365;
                vy = -0.6;
            }
            setPlayer();
            if (startGrace == 0) {
                setText(statusText, waveStatus(), 13, 0x000000, "center");
                autoTapFrames = 0;
                if (vy < 0.9) vy = 0.9;
            }
            return;
        }

        tickStatus();

        vy += 0.42;
        if (pressing) vy -= 0.86;
        if (vy > 6.4) vy = 6.4;
        if (vy < -5.8) vy = -5.8;
        playerY += vy;
        setPlayer();

        if (playerY < PLAY_TOP + 12 || playerY > PLAY_BOTTOM - 12) {
            gameOver();
            return;
        }

        spawnWait--;
        if (spawnWait <= 0) {
            spawnObstacle();
            spawnWait = nextSpawnWait();
        }

        for (var i:Number = dynamicClips.length - 1; i >= 0; i--) {
            var ob:MovieClip = dynamicClips[i];
            ob._x -= ob.speed;
            if (playerHitTest(ob.mc_hit)) {
                gameOver();
                return;
            }

            if (!ob.scored && ob._x + ob.obW < PLAYER_X - 46) {
                ob.scored = true;
                registerPass();
                updateHud();
            }

            if (ob._x < -ob.obW - 80) {
                ob.removeMovieClip();
                dynamicClips.splice(i, 1);
            }
        }
    }

    function spawnObstacle():Void {
        var d:Number = obstacleLayer.getNextHighestDepth();
        var ob:MovieClip = obstacleLayer.createEmptyMovieClip("ob" + d, d);
        var spec:Object = chooseObstacleSpec();

        ob._x = OB_START_X;
        ob._y = chooseLaneY(spec.h);
        ob.speed = currentObstacleSpeed();
        ob.scored = false;
        ob.obW = spec.w;
        ob.obH = spec.h;
        ob.hitX = spec.hitX;
        ob.hitY = spec.hitY;
        ob.hitW = spec.hitW;
        ob.hitH = spec.hitH;

        ob.createTextField("tf_aa", 3, 0, 0, spec.w + 28, spec.h + 18);
        setupText(ob.tf_aa, spec.fontSize, 0x000000);
        ob.tf_aa.text = String(spec.aa);
        ob.tf_aa.setTextFormat(new TextFormat(FONT_NAME, spec.fontSize, 0x000000));

        if (phaseIndex == 3) addBurstVisuals(ob, spec);

        ob.createEmptyMovieClip("mc_hit", 4);
        // Use alpha 1 (effectively invisible) rather than 0: Ruffle has been
        // inconsistent shape-hit-testing fully transparent fills.
        drawRect(ob.mc_hit, spec.hitX, spec.hitY, spec.hitW, spec.hitH, 1);

        dynamicClips.push(ob);
    }

    function playerHitTest(target:MovieClip):Boolean {
        var pts:Array = [
            [-78, 0], [-64, 0], [-50, 0], [-36, 0],
            [-12, -4], [0, -4], [12, -4], [-12, 4], [0, 4], [12, 4],
            [42, 0], [56, 0], [70, 0], [84, 0], [98, 0]
        ];
        for (var i:Number = 0; i < pts.length; i++) {
            var p:Array = pts[i];
            var pt:Object = { x: Number(p[0]), y: Number(p[1]) };
            player.localToGlobal(pt);
            if (target.hitTest(pt.x, pt.y, true)) return true;
        }
        return false;
    }

    function nextSpawnWait():Number {
        if (phaseIndex == 0) return 66 + Math.random() * 18;
        if (phaseIndex == 1) return 56 + Math.random() * 16;
        if (phaseIndex == 2) return 46 + Math.random() * 16;
        return 44 + Math.random() * 14;
    }

    function phaseLabel():String {
        if (phaseIndex == 0) return "待機";
        if (phaseIndex == 1) return "反応";
        if (phaseIndex == 2) return "盛り上がり";
        return "大弾幕";
    }

    function phaseTarget():Number {
        if (phaseIndex == 0) return 3;
        if (phaseIndex == 1) return 4;
        if (phaseIndex == 2) return 5;
        return 4;
    }

    function waveSpeedScale():Number {
        return Math.min(1.55, 1 + waveIndex * 0.08);
    }

    function currentObstacleSpeed():Number {
        var base:Number = 2.08;
        if (phaseIndex == 1) base = 2.16;
        if (phaseIndex == 2) base = 2.24;
        if (phaseIndex == 3) base = 2.18;
        return base * waveSpeedScale();
    }

    function waveStatus():String {
        return "WAVE " + String(waveIndex + 1) + " / " + phaseLabel();
    }

    function showStatus(value:String, frames:Number):Void {
        setText(statusText, value, 13, 0x000000, "center");
        statusHold = frames;
    }

    function tickStatus():Void {
        if (statusHold > 0) {
            statusHold--;
            if (statusHold == 0) setText(statusText, waveStatus(), 13, 0x000000, "center");
        }
    }

    function registerPass():Void {
        score++;
        phasePassed++;
        wavePassed++;
        if (phasePassed >= phaseTarget()) advancePhase();
    }

    function advancePhase():Void {
        phasePassed = 0;
        phaseIndex++;
        if (phaseIndex >= 4) {
            phaseIndex = 0;
            waveIndex++;
            wavePassed = 0;
            showStatus("WAVE CLEAR  SPEED UP", 58);
        } else {
            showStatus(waveStatus(), 42);
        }
    }

    function chooseLaneY(obH:Number):Number {
        var lanes:Array = [108, 194, 280, 366, 452];
        var idx:Number = Math.floor(Math.random() * lanes.length);
        if (idx == lastLane) idx = (idx + 1 + Math.floor(Math.random() * (lanes.length - 1))) % lanes.length;
        lastLane = idx;
        var y:Number = Number(lanes[idx]);
        if (y < PLAY_TOP + 22) y = PLAY_TOP + 22;
        if (y > PLAY_BOTTOM - obH - 22) y = PLAY_BOTTOM - obH - 22;
        return y;
    }

    function obstacleSpec(aa:String, w:Number, h:Number, fontSize:Number, hitX:Number, hitY:Number, hitW:Number, hitH:Number):Object {
        return { aa: aa, w: w, h: h, fontSize: fontSize, hitX: hitX, hitY: hitY, hitW: hitW, hitH: hitH };
    }

    function commentSpec(text:String, w:Number, fontSize:Number):Object {
        var h:Number = Math.round(fontSize * 1.35);
        return obstacleSpec(text, w, h, fontSize, 4, 2, w - 10, h - 5);
    }

    function burstSafeSpec(spec:Object):Object {
        spec.fontSize = Math.min(27, Number(spec.fontSize) + 2);
        spec.h = Math.round(Number(spec.fontSize) * 1.42);
        spec.hitX = Math.round(Number(spec.w) * 0.22);
        spec.hitY = 4;
        spec.hitW = Math.max(72, Math.round(Number(spec.w) * 0.46));
        spec.hitH = Math.max(16, Number(spec.h) - 12);
        return spec;
    }

    function burstVisualText(i:Number):String {
        var texts:Array = [
            "wwwwwwwwwwwwwwwwww",
            "88888888888888888888",
            "弾幕で前が見えない",
            "職人仕事しすぎ",
            "お前らの愛で見えない",
            "見えねえwwww",
            "弾幕濃すぎて読めない",
            "コメントが本編"
        ];
        return String(texts[i % texts.length]);
    }

    function addBurstVisuals(ob:MovieClip, spec:Object):Void {
        var offsets:Array = [-72, -46, 34, 60, 86];
        for (var i:Number = 0; i < offsets.length; i++) {
            var size:Number = 17 + (i % 3) * 2;
            var name:String = "tf_burst" + i;
            ob.createTextField(name, 10 + i, -18 - Math.random() * 26, Number(offsets[i]), Number(spec.w) + 150, 28);
            var tf:TextField = ob[name];
            setupText(tf, size, 0x000000);
            tf._alpha = burstVisualAlpha(i);
            tf.text = burstVisualText(i + score + waveIndex * 3);
            tf.setTextFormat(new TextFormat(FONT_NAME, size, 0x000000));
        }
    }

    function burstVisualAlpha(i:Number):Number {
        return BURST_VISUAL_ALPHA_BASE + (i % 2) * BURST_VISUAL_ALPHA_ALT;
    }

    function buildPools():Void {
        openingComments = [
            commentSpec("wktk", 58, 17),
            commentSpec("1ゲト", 58, 18),
            commentSpec("2ゲト", 58, 18),
            commentSpec("うぽつ", 58, 17),
            commentSpec("うp主乙", 72, 17),
            commentSpec("乙", 30, 18),
            commentSpec("初見", 52, 17),
            commentSpec("初見です", 82, 17),
            commentSpec("待機", 52, 17),
            commentSpec("待ってた", 74, 17),
            commentSpec("きた？", 58, 17),
            commentSpec("ktkr", 58, 17),
            commentSpec("まだ？", 58, 17),
            commentSpec("ここか", 58, 17),
            commentSpec("なつい", 58, 17),
            commentSpec("巡礼中", 70, 17),
            commentSpec("コメ少な", 78, 17),
            commentSpec("投稿日見た", 96, 17),
            commentSpec("ここすき", 78, 17),
            commentSpec("ざわ...", 78, 17),
            commentSpec("おお？", 58, 17),
            commentSpec("やあ", 38, 17),
            commentSpec("前から", 66, 17),
            commentSpec("遅刻", 52, 17),
            commentSpec("巡回", 52, 17),
            commentSpec("懐かしい", 86, 17),
            commentSpec("釣られた", 82, 17),
            commentSpec("サムネから", 100, 17),
            commentSpec("作業用?", 82, 17),
            commentSpec("米少な", 66, 17),
            commentSpec("再訪", 52, 17)
        ];
        warmupComments = [
            commentSpec("きたあああ", 104, 19),
            commentSpec("神回の予感", 118, 20),
            commentSpec("職人待機", 100, 20),
            commentSpec("これは伸びる", 118, 20),
            commentSpec("二番煎じ", 100, 20),
            commentSpec("マイリス確定", 128, 20),
            commentSpec("主コメ理解", 112, 20),
            commentSpec("鳥肌注意", 100, 20),
            commentSpec("今北産業", 100, 20),
            commentSpec("空耳やめろ", 122, 20),
            commentSpec("字幕職人待機", 142, 20),
            commentSpec("音量注意", 100, 20),
            commentSpec("ヘッドホン推奨", 156, 20),
            commentSpec("タグ理解", 100, 21),
            commentSpec("市場制圧", 104, 21),
            commentSpec("市場理解した", 126, 20),
            commentSpec("タグで察した", 126, 20),
            commentSpec("嫌な予感", 100, 20),
            commentSpec("もう草", 80, 20),
            commentSpec("お前かよ", 100, 20),
            commentSpec("謎の安心感", 122, 20),
            commentSpec("まだ序盤", 90, 20),
            commentSpec("もう楽しい", 112, 20),
            commentSpec("出落ちかよ", 112, 20),
            commentSpec("釣りじゃないだと", 170, 20),
            commentSpec("サムネ理解", 112, 20),
            commentSpec("市場から", 92, 20),
            commentSpec("作者巡回済み", 142, 20),
            commentSpec("謎の中毒性", 122, 20),
            commentSpec("忙しい人向け", 142, 20),
            commentSpec("ループ推奨", 112, 20),
            commentSpec("定期巡回", 100, 20),
            commentSpec("タグロック理解", 150, 20),
            commentSpec("草不可避", 100, 20),
            commentSpec("音ズレしてる?", 146, 20)
        ];
        risingComments = [
            commentSpec("うおおおおお", 138, 22),
            commentSpec("職人きたああ", 142, 22),
            commentSpec("コメント増えてきた", 178, 21),
            commentSpec("弾幕準備", 110, 22),
            commentSpec("弾幕用意しろ", 150, 22),
            commentSpec("職人仕事早い", 146, 22),
            commentSpec("コメ職人きた", 146, 22),
            commentSpec("ここで一時停止", 168, 21),
            commentSpec("黙ってマイリス", 160, 22),
            commentSpec("謎の技術", 108, 22),
            commentSpec("謎の感動", 108, 22),
            commentSpec("涙腺崩壊", 108, 22),
            commentSpec("全俺が泣いた", 142, 22),
            commentSpec("鳥肌立った", 126, 22),
            commentSpec("再生数おかしい", 160, 21),
            commentSpec("なぜ上がったし", 160, 21),
            commentSpec("市場が仕事した", 160, 21),
            commentSpec("タグが仕事してる", 178, 21),
            commentSpec("空耳がひどい", 146, 21),
            commentSpec("ここから鳥肌", 146, 22),
            commentSpec("これはひどい", 118, 20),
            commentSpec("こっちみんな", 126, 20),
            commentSpec("もっと評価されるべき", 190, 20),
            commentSpec("才能の無駄遣い", 160, 21),
            commentSpec("なぜ止めたし", 138, 20),
            commentSpec("腹筋崩壊", 108, 22),
            commentSpec("公式が病気", 128, 21),
            commentSpec("職人すげぇ", 126, 21),
            commentSpec("イヤホン推奨", 142, 20),
            commentSpec("エコノミー涙目", 160, 20),
            commentSpec("うますぎワロタ", 150, 21),
            commentSpec("シーク禁止", 122, 21),
            commentSpec("弾幕注意報", 126, 22),
            commentSpec("弾幕濃くなってきた", 205, 21),
            commentSpec("職人仕事しろ", 146, 22),
            commentSpec("神編集すぎる", 146, 22),
            commentSpec("主コメで泣いた", 152, 21),
            commentSpec("お使いのPCは正常です", 226, 20),
            commentSpec("ここに病院を建てよう", 220, 21),
            commentSpec("なぜ作ったし", 138, 22),
            commentSpec("誰得だよ", 100, 22),
            commentSpec("俺得動画", 100, 22),
            commentSpec("孔明の罠", 108, 22),
            commentSpec("フル希望", 98, 22),
            commentSpec("ループから抜け出せない", 242, 20),
            commentSpec("ランキングから来た", 190, 21),
            commentSpec("古参ホイホイ", 142, 22),
            commentSpec("懐古勢歓喜", 132, 22),
            commentSpec("謎の一体感", 122, 22),
            commentSpec("定期的に見たくなる", 210, 21),
            commentSpec("タグ荒ぶるな", 146, 22)
        ];
        longComments = [
            commentSpec("wwwwwwwwwwwwww", 270, 24),
            commentSpec("wwwwwwwwwwwwwwwwww", 325, 24),
            commentSpec("8888888888888888", 286, 24),
            commentSpec("88888888888888888888", 342, 24),
            commentSpec("弾幕薄いよ！なにやってんの！", 310, 22),
            commentSpec("弾幕で前が見えない", 250, 24),
            commentSpec("おまいら自重しろwww", 255, 23),
            commentSpec("コメントが本編", 180, 25),
            commentSpec("コメント職人の本気", 220, 24),
            commentSpec("字幕職人ありがとう", 220, 24),
            commentSpec("俺の腹筋を返せ", 190, 25),
            commentSpec("人類には早すぎる", 214, 24),
            commentSpec("なぜベストを尽くした", 250, 24),
            commentSpec("なぜランキング上がったし", 282, 23),
            commentSpec("もっと評価されるべき動画", 280, 23),
            commentSpec("もっと伸びろおおおお", 248, 24),
            commentSpec("お前らの愛で見えない", 260, 24),
            commentSpec("よく訓練されたコメント欄", 296, 23),
            commentSpec("全員訓練されすぎ", 215, 24),
            commentSpec("公式が最大手すぎる", 232, 24),
            commentSpec("職人仕事しすぎ", 190, 25),
            commentSpec("職人多すぎワロタ", 210, 24),
            commentSpec("市場が仕事しすぎ", 205, 24),
            commentSpec("コメントが完成してる", 235, 24),
            commentSpec("コメ非表示推奨", 185, 25),
            commentSpec("マイリス不可避", 180, 25),
            commentSpec("画面が見えないwww", 235, 24),
            commentSpec("見えねえwwww", 190, 25),
            commentSpec("なにこれこわい", 170, 25),
            commentSpec("なぜか泣ける", 160, 25),
            commentSpec("何度も来てしまう", 210, 24),
            commentSpec("ヘッドホンで聞け", 205, 24),
            commentSpec("ここからが本当の本編", 270, 23),
            commentSpec("タグ理解したら負け", 220, 24),
            commentSpec("伝説の始まり", 170, 25),
            commentSpec("ありがとう職人", 180, 25),
            commentSpec("ここから本番", 160, 25),
            commentSpec("提供：俺ら", 140, 25),
            commentSpec("wwwwwwwwwwwwwwwwwwwwww", 340, 24),
            commentSpec("888888888888888888888888", 340, 24),
            commentSpec("弾幕濃すぎて読めない", 260, 24),
            commentSpec("職人で画面が完成してる", 282, 23),
            commentSpec("コメントが動画を超えた", 260, 24),
            commentSpec("お前らどこから来た", 230, 24),
            commentSpec("ランキング民集合", 205, 24),
            commentSpec("古参も新参も泣いてる", 270, 23),
            commentSpec("ここに文化が残ってる", 255, 24),
            commentSpec("弾幕に参加せざるを得ない", 310, 23),
            commentSpec("ここまでテンプレ", 205, 24),
            commentSpec("なぜ最後まで見たし", 230, 24),
            commentSpec("巡礼会場はこちら", 210, 24),
            commentSpec("定期的に帰ってくる", 255, 24),
            commentSpec("コメント非表示にできない", 290, 23),
            commentSpec("もうコメント込みで作品", 270, 23),
            commentSpec("鳥肌注意報発令中", 230, 24),
            commentSpec("職人の無駄遣い", 205, 24),
            commentSpec("提供：コメント欄", 205, 24),
            commentSpec("お前らの一体感が怖い", 270, 23)
        ];
        surprises = [
            obstacleSpec("　∧∧\n＜(ﾟДﾟ,,)", 104, 42, 15, 10, 6, 78, 30),
            obstacleSpec("　∧＿∧\n＜（´∀｀　）", 126, 44, 15, 12, 6, 94, 32),
            obstacleSpec("　∧＿∧\n＜(´･ω･`)", 126, 44, 15, 10, 6, 96, 32),
            obstacleSpec("　('A`)\n＜ノヽノヽ\n　　くく", 92, 58, 16, 10, 7, 66, 42),
            obstacleSpec("＜ｷﾀ━━\n　(ﾟ∀ﾟ)\n　━━!!", 122, 62, 16, 8, 8, 96, 44),
            obstacleSpec("　＿＿＿_\n＜／　　 ＼\n /　＾　＾　＼\n |　　ω　　|", 150, 88, 15, 12, 10, 112, 62),
            obstacleSpec("　 ／￣￣＼\n＜／　_ノ　＼\n　|　（ ●）（●）\n　|　　 （__人）", 156, 90, 15, 10, 10, 118, 64)
        ];
        poolsBuilt = true;
    }

    function copySpec(s:Object):Object {
        return { aa: s.aa, w: s.w, h: s.h, fontSize: s.fontSize, hitX: s.hitX, hitY: s.hitY, hitW: s.hitW, hitH: s.hitH };
    }

    function chooseObstacleSpec():Object {
        if (!poolsBuilt) buildPools();
        if (score > 2 && phaseIndex != 3 && Math.random() < 0.10) return copySpec(surprises[Math.floor(Math.random() * surprises.length)]);
        var pool:Array = phaseIndex == 0 ? openingComments : (phaseIndex == 1 ? warmupComments : (phaseIndex == 2 ? risingComments : longComments));
        var spec:Object = copySpec(pool[Math.floor(Math.random() * pool.length)]);
        if (phaseIndex == 3) return burstSafeSpec(spec);
        return spec;
    }

    function gameOver():Void {
        if (mode != "main") return;
        mode = "result";
        pressing = false;
        delete root.onEnterFrame;
        if (score > hi) {
            hi = score;
            store.data.hi = hi;
            store.flush();
        }
        updateHud();
        clearLayer(resultLayer);
        resultLayer.createTextField("tf_result", 1, 28, 190, 334, 150);
        setupText(resultLayer.tf_result, 24, 0x000000);
        resultLayer.tf_result.text = "GAME OVER\n\nSCORE " + pad(score, 6) + "\nHI    " + pad(hi, 6);
        resultLayer.tf_result.setTextFormat(new TextFormat(FONT_NAME, 24, 0x000000));
        resultLayer.createTextField("tf_status", 2, 28, 355, 334, 30);
        setText(resultLayer.tf_status, "もう一回だけやる", 15, 0x000000, "center");
        createButton(resultLayer, "btn_retry", 55, 425, "RETRY", "start");
    }

    function cleanupDynamic():Void {
        for (var i:Number = dynamicClips.length - 1; i >= 0; i--) {
            if (dynamicClips[i] != undefined) dynamicClips[i].removeMovieClip();
        }
        dynamicClips = new Array();
    }

    function cleanupBackground():Void {
        for (var i:Number = bgRows.length - 1; i >= 0; i--) {
            if (bgRows[i] != undefined) bgRows[i].removeTextField();
        }
        bgRows = new Array();
        bgSpeeds = new Array();
    }

    function clearLayer(mc:MovieClip):Void {
        if (mc == undefined) return;
        // Collect keys first, then remove. Removing children while iterating with
        // for-in is undefined-order in AS2 and can skip children under Ruffle,
        // leaving stray TextFields/MovieClips after a state transition.
        var keys:Array = new Array();
        for (var key:String in mc) keys.push(key);
        for (var i:Number = 0; i < keys.length; i++) {
            var child:Object = mc[keys[i]];
            if (child.removeTextField != undefined) child.removeTextField();
            else if (child.removeMovieClip != undefined) child.removeMovieClip();
        }
        mc.clear();
    }

    function drawRect(mc:MovieClip, x:Number, y:Number, w:Number, h:Number, alphaValue:Number):Void {
        mc.clear();
        mc.beginFill(0x000000, alphaValue);
        mc.moveTo(x, y);
        mc.lineTo(x + w, y);
        mc.lineTo(x + w, y + h);
        mc.lineTo(x, y + h);
        mc.lineTo(x, y);
        mc.endFill();
    }
}
