// boon-threader.swf frame scripts
// ActionScript 2.0 / Flash 8
// ------------------------------------------------------------
// This file is not a standalone app.
// Do NOT paste the whole file into one frame.
// Copy each section to the matching Timeline label frame:
//   frame 1 "loading": common block + setupLoadingFrame();
//   frame 2 "title":   title section, ending with setupTitleFrame();
//   frame 3 "main":    main section, ending with setupMainFrame();
//   frame 4 "result":  result section, ending with setupResultFrame();
// ------------------------------------------------------------

// ============================================================
// frame 1 "loading" / actions layer
// common block starts here
// ============================================================

import flash.display.BitmapData;

Stage.scaleMode = "noScale";
Stage.align = "TL";
stop();

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

_root.appId = "boon_threader_v1";
_root.mode = "loading";
_root.primaryDown = false;
_root.score = 0;
_root.resultScore = 0;
_root.soundOn = true;
_root.frameCount = 0;
_root.spawnWait = 0;
_root.startGrace = 0;
_root.autoTapFrames = 0;
_root.waveIndex = 0;
_root.phaseIndex = 0;
_root.phasePassed = 0;
_root.wavePassed = 0;
_root.statusHold = 0;
_root.lastLane = -1;
_root.dynamicClips = new Array();
_root.bgRows = new Array();
_root.bgSpeeds = new Array();
_root.store = SharedObject.getLocal(String(_root.appId));

if (_root.store.data.hi == undefined) _root.store.data.hi = 0;
if (_root.store.data.soundOn == undefined) _root.store.data.soundOn = true;
_root.soundOn = _root.store.data.soundOn;

function setupText(tf:TextField, size:Number, color:Number):Void {
    if (tf == undefined) return;
    tf.selectable = false;
    tf.embedFonts = false;
    tf.multiline = true;
    tf.wordWrap = false;
    var fmt:TextFormat = new TextFormat("_typewriter", size, color);
    fmt.align = "left";
    tf.setNewTextFormat(fmt);
    tf.setTextFormat(fmt);
}

function setSingleLine(tf:TextField, textValue:String, size:Number, color:Number, align:String):Void {
    if (tf == undefined) return;
    tf.selectable = false;
    tf.embedFonts = false;
    tf.multiline = false;
    tf.wordWrap = false;
    var fmt:TextFormat = new TextFormat("_typewriter", size, color);
    fmt.align = align;
    tf.setNewTextFormat(fmt);
    tf.text = textValue;
    tf.setTextFormat(fmt);
}

function padNumber(n:Number, digits:Number):String {
    var s:String = String(Math.floor(n));
    while (s.length < digits) s = "0" + s;
    return s;
}

function isBurstFixture():Boolean {
    return String(_root.fixture) == "burst" || String(_root.burst) == "1";
}

function updateScoreText():Void {
    setSingleLine(tf_score, "SCORE " + padNumber(_root.score, 6), 16, 0x000000, "left");
    setSingleLine(tf_hi, "HI " + padNumber(Number(_root.store.data.hi), 6), 16, 0x000000, "right");
}

function saveLocal():Void {
    if (Number(_root.score) > Number(_root.store.data.hi)) {
        _root.store.data.hi = Number(_root.score);
    }
    _root.store.data.soundOn = _root.soundOn;
    _root.store.flush();
}

function playSE(linkageId:String):Void {
    if (!_root.soundOn) return;
    var s:Sound = new Sound();
    s.attachSound(linkageId);
    s.start();
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

function clearWholeStagePress():Void {
    delete _root.onMouseDown;
    delete _root.onMouseUp;
    _root.primaryDown = false;
}

function setupWholeStagePress():Void {
    _root.onMouseDown = function():Void {
        _root.primaryDown = true;
    };
    _root.onMouseUp = function():Void {
        _root.primaryDown = false;
    };
}

var keyListener:Object = new Object();
keyListener.onKeyDown = function():Void {
    if (Key.getCode() == Key.SPACE && _root.mode == "main") _root.primaryDown = true;
};
keyListener.onKeyUp = function():Void {
    if (Key.getCode() == Key.SPACE) _root.primaryDown = false;
};
Key.addListener(keyListener);

function drawButton(btn:MovieClip, labelText:String):Void {
    if (btn == undefined) return;
    btn.clear();
    btn.lineStyle(1, 0x000000, 100);
    btn.beginFill(0xffffff, 100);
    btn.moveTo(0, 0);
    btn.lineTo(280, 0);
    btn.lineTo(280, 58);
    btn.lineTo(0, 58);
    btn.lineTo(0, 0);
    btn.endFill();
    if (btn.tf_label != undefined) btn.tf_label.removeTextField();
    btn.createTextField("tf_label", 2, 0, 16, 280, 28);
    setSingleLine(btn.tf_label, labelText, 18, 0x000000, "center");
}

function setupButton(btn:MovieClip, labelText:String, action:Function):Void {
    if (btn == undefined) return;
    drawButton(btn, labelText);
    btn.baseY = btn._y;
    btn.useHandCursor = true;
    btn.onRollOver = function():Void {
        this._alpha = 75;
    };
    btn.onRollOut = function():Void {
        this._alpha = 100;
        this._y = this.baseY;
    };
    btn.onPress = function():Void {
        this._y = this.baseY + 2;
        playSE("se_click");
    };
    btn.onRelease = function():Void {
        this._y = this.baseY;
        this._alpha = 100;
        action();
    };
    btn.onReleaseOutside = function():Void {
        this._y = this.baseY;
        this._alpha = 100;
    };
}

function cleanupDynamic():Void {
    for (var i:Number = _root.dynamicClips.length - 1; i >= 0; i--) {
        if (_root.dynamicClips[i] != undefined) {
            _root.dynamicClips[i].removeMovieClip();
        }
    }
    _root.dynamicClips = new Array();
}

function cleanupBackground():Void {
    for (var i:Number = _root.bgRows.length - 1; i >= 0; i--) {
        if (_root.bgRows[i] != undefined) {
            _root.bgRows[i].removeTextField();
        }
    }
    _root.bgRows = new Array();
    _root.bgSpeeds = new Array();
}

function goTitle():Void {
    delete _root.onEnterFrame;
    cleanupDynamic();
    cleanupBackground();
    clearWholeStagePress();
    _root.mode = "title";
    gotoAndStop("title");
}

function goMain():Void {
    delete _root.onEnterFrame;
    cleanupDynamic();
    cleanupBackground();
    clearWholeStagePress();
    _root.mode = "main";
    gotoAndStop("main");
}

function goResult():Void {
    delete _root.onEnterFrame;
    saveLocal();
    cleanupDynamic();
    cleanupBackground();
    clearWholeStagePress();
    _root.resultScore = _root.score;
    _root.mode = "result";
    playSE("se_hit");
    gotoAndStop("result");
}

function setupLoadingFrame():Void {
    stop();
    clearWholeStagePress();
    setSingleLine(tf_loading, "Now Loading...", 18, 0x000000, "center");
    var waitFrames:Number = 24;
    _root.onEnterFrame = function():Void {
        waitFrames--;
        if (waitFrames <= 0) {
            goTitle();
        }
    };
}

// Call this on frame 1:
setupLoadingFrame();

// ============================================================
// frame 2 "title" / actions layer
// Copy only this section to frame 2.
// ============================================================

function setupTitleFrame():Void {
    stop();
    delete _root.onEnterFrame;
    clearWholeStagePress();

    var titleCopy:String = "";
    titleCopy += "ブーン弾幕よけ\n\n";
    titleCopy += PLAYER_AA + "\n\n";
    titleCopy += "おしている間だけ上昇。\n";
    titleCopy += "流れるコメントをよけるだけ。";
    setupText(tf_title, 18, 0x000000);
    tf_title.text = titleCopy;
    tf_title.setTextFormat(new TextFormat("_typewriter", 18, 0x000000));

    setupButton(btn_start, "TAP TO START", function():Void {
        goMain();
    });
}

// Call this on frame 2:
setupTitleFrame();

// ============================================================
// frame 3 "main" / actions layer
// Copy only this section to frame 3.
// ============================================================

function nextSpawnWait():Number {
    if (_root.phaseIndex == 0) return 66 + Math.random() * 18;
    if (_root.phaseIndex == 1) return 56 + Math.random() * 16;
    if (_root.phaseIndex == 2) return 46 + Math.random() * 16;
    return 44 + Math.random() * 14;
}

function phaseLabel():String {
    if (_root.phaseIndex == 0) return "待機";
    if (_root.phaseIndex == 1) return "反応";
    if (_root.phaseIndex == 2) return "盛り上がり";
    return "大弾幕";
}

function phaseTarget():Number {
    if (_root.phaseIndex == 0) return 3;
    if (_root.phaseIndex == 1) return 4;
    if (_root.phaseIndex == 2) return 5;
    return 4;
}

function waveSpeedScale():Number {
    return Math.min(1.60, 1 + Number(_root.waveIndex) * 0.12);
}

function currentObstacleSpeed():Number {
    var base:Number = 2.08;
    if (_root.phaseIndex == 1) base = 2.16;
    if (_root.phaseIndex == 2) base = 2.24;
    if (_root.phaseIndex == 3) base = 2.18;
    return base * waveSpeedScale();
}

function speedLabel():String {
    var n:Number = Math.round(waveSpeedScale() * 100);
    var whole:Number = Math.floor(n / 100);
    var frac:Number = n - whole * 100;
    return "x" + String(whole) + "." + (frac < 10 ? "0" : "") + String(frac);
}

function waveStatus():String {
    return "WAVE " + String(Number(_root.waveIndex) + 1) + " / " + phaseLabel() + "  SPD " + speedLabel();
}

function showStatus(value:String, frames:Number):Void {
    setSingleLine(tf_status, value, 13, 0x000000, "center");
    _root.statusHold = frames;
}

function tickStatus():Void {
    if (Number(_root.statusHold) > 0) {
        _root.statusHold--;
        if (Number(_root.statusHold) == 0) setSingleLine(tf_status, waveStatus(), 13, 0x000000, "center");
    }
}

function registerPass():Void {
    _root.score++;
    _root.phasePassed++;
    _root.wavePassed++;
    if (Number(_root.phasePassed) >= phaseTarget()) advancePhase();
}

function advancePhase():Void {
    _root.phasePassed = 0;
    _root.phaseIndex++;
    if (Number(_root.phaseIndex) >= 4) {
        _root.phaseIndex = 0;
        _root.waveIndex++;
        _root.wavePassed = 0;
        showStatus("WAVE CLEAR  SPD " + speedLabel(), 58);
    } else {
        showStatus(waveStatus(), 42);
    }
}

function chooseLaneY(obH:Number):Number {
    var lanes:Array = [108, 194, 280, 366, 452];
    var idx:Number = Math.floor(Math.random() * lanes.length);
    if (idx == Number(_root.lastLane)) idx = (idx + 1 + Math.floor(Math.random() * (lanes.length - 1))) % lanes.length;
    _root.lastLane = idx;
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

// Return a copy so callers (burstSafeSpec) never mutate a shared pool object.
// Matches BoonThreader.as; keep both in sync.
function copySpec(s:Object):Object {
    return { aa: s.aa, w: s.w, h: s.h, fontSize: s.fontSize, hitX: s.hitX, hitY: s.hitY, hitW: s.hitW, hitH: s.hitH };
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
        tf.text = burstVisualText(i + Number(_root.score) + Number(_root.waveIndex) * 3);
        tf.setTextFormat(new TextFormat("_typewriter", size, 0x000000));
    }
}

function burstVisualAlpha(i:Number):Number {
    return BURST_VISUAL_ALPHA_BASE + (i % 2) * BURST_VISUAL_ALPHA_ALT;
}

function chooseObstacleSpec():Object {
    var openingComments:Array = [
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
    var warmupComments:Array = [
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
    var risingComments:Array = [
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
    var longComments:Array = [
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
    var surprises:Array = [
        obstacleSpec("　∧∧\n＜(ﾟДﾟ,,)", 104, 42, 15, 10, 6, 78, 30),
        obstacleSpec("　∧＿∧\n＜（´∀｀　）", 126, 44, 15, 12, 6, 94, 32),
        obstacleSpec("　∧＿∧\n＜(´･ω･`)", 126, 44, 15, 10, 6, 96, 32),
        obstacleSpec("　('A`)\n＜ノヽノヽ\n　　くく", 92, 58, 16, 10, 7, 66, 42),
        obstacleSpec("＜ｷﾀ━━\n　(ﾟ∀ﾟ)\n　━━!!", 122, 62, 16, 8, 8, 96, 44),
        obstacleSpec("　＿＿＿_\n＜／　　 ＼\n /　＾　＾　＼\n |　　ω　　|", 150, 88, 15, 12, 10, 112, 62),
        obstacleSpec("　 ／￣￣＼\n＜／　_ノ　＼\n　|　（ ●）（●）\n　|　　 （__人）", 156, 90, 15, 10, 10, 118, 64)
    ];
    if (_root.score > 2 && _root.phaseIndex != 3 && Math.random() < 0.10) return copySpec(surprises[Math.floor(Math.random() * surprises.length)]);
    var pool:Array = _root.phaseIndex == 0 ? openingComments : (_root.phaseIndex == 1 ? warmupComments : (_root.phaseIndex == 2 ? risingComments : longComments));
    var spec:Object = copySpec(pool[Math.floor(Math.random() * pool.length)]);
    if (_root.phaseIndex == 3) return burstSafeSpec(spec);
    return spec;
}

function drawPlayerSprite(mc:MovieClip):Void {
    mc.clear();
    var stamp:MovieClip = mc.createEmptyMovieClip("mc_stamp", 1);
    stamp.createTextField("tf_aa", 1, 0, 0, PLAYER_AA_W, PLAYER_AA_H);
    setSingleLine(stamp.tf_aa, PLAYER_AA, PLAYER_AA_SIZE, 0x000000, "center");

    var bmp:BitmapData = new BitmapData(PLAYER_AA_W, PLAYER_AA_H, true, 0x00000000);
    bmp.draw(stamp);
    stamp.removeMovieClip();

    var art:MovieClip = mc.createEmptyMovieClip("mc_art", 1);
    art._x = PLAYER_AA_X;
    art._y = -PLAYER_AA_H / 2;
    art.attachBitmap(bmp, 1, "never", false);
    mc.aaBitmap = bmp;
}

function createPlayerArt():Void {
    if (mc_player == undefined) return;
    if (mc_player.tf_aa != undefined) mc_player.tf_aa.removeTextField();
    drawPlayerSprite(mc_player);
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
        mc_player.localToGlobal(pt);
        if (target.hitTest(pt.x, pt.y, true)) return true;
    }
    return false;
}

function createBackground():Void {
    cleanupBackground();
    if (mc_bg == undefined) return;

    var patterns:Array = [
        "　　.　　　.　　　.　　　.　　　.　　　.　　　.",
        "　　　／￣＼　　　　orz　　　　／￣＼",
        "　.　　　　⊂二二二　　　.　　　　　.",
        "～～～～～～～～～～～～～～～～～～～～",
        "　　（＾ω＾）　　　.　　　（#ﾟДﾟ）"
    ];

    for (var i:Number = 0; i < 18; i++) {
        mc_bg.createTextField("tf_bg" + i, i + 1, -20 - Math.random() * 100, 58 + i * 30, 560, 24);
        var tf:TextField = mc_bg["tf_bg" + i];
        setupText(tf, 14, 0x999999);
        tf._alpha = 32;
        tf.text = patterns[i % patterns.length];
        _root.bgRows.push(tf);
        _root.bgSpeeds.push(0.35 + (i % 3) * 0.18);
    }
}

function attachObstacle():MovieClip {
    if (mc_holder == undefined) return undefined;
    var d:Number = mc_holder.getNextHighestDepth();
    var ob:MovieClip = mc_holder.attachMovie("mc_aa_obstacle", "ob" + d, d);
    if (ob == undefined) return undefined;
    var spec:Object = chooseObstacleSpec();

    ob._x = OB_START_X;
    ob._y = chooseLaneY(spec.h);
    ob.speed = currentObstacleSpeed();
    ob.scored = false;
    ob.obW = spec.w;
    ob.obH = spec.h;

    ob.createTextField("tf_aa", 3, 0, 0, spec.w + 28, spec.h + 18);
    setupText(ob.tf_aa, spec.fontSize, 0x000000);
    ob.tf_aa.text = String(spec.aa);
    ob.tf_aa.setTextFormat(new TextFormat("_typewriter", spec.fontSize, 0x000000));

    if (Number(_root.phaseIndex) == 3) addBurstVisuals(ob, spec);

    ob.createEmptyMovieClip("mc_hit", 4);
    // alpha 1 (effectively invisible); Ruffle has been inconsistent shape-hit-
    // testing fully transparent fills. Keep in sync with BoonThreader.as.
    drawRect(ob.mc_hit, spec.hitX, spec.hitY, spec.hitW, spec.hitH, 1);

    _root.dynamicClips.push(ob);
    return ob;
}

function setupMainFrame():Void {
    stop();
    var burstFixture:Boolean = isBurstFixture();
    _root.mode = "main";
    _root.score = 0;
    _root.frameCount = 0;
    _root.spawnWait = burstFixture ? 8 : 26;
    _root.startGrace = burstFixture ? 18 : START_GRACE;
    _root.autoTapFrames = AUTO_TAP_FRAMES;
    _root.waveIndex = 0;
    _root.phaseIndex = burstFixture ? 3 : 0;
    _root.phasePassed = 0;
    _root.wavePassed = burstFixture ? 12 : 0;
    _root.statusHold = 0;
    _root.lastLane = -1;
    _root.primaryDown = false;

    setupWholeStagePress();
    cleanupDynamic();
    createBackground();
    createPlayerArt();

    mc_player._x = PLAYER_X;
    mc_player._y = 344;
    mc_player.vy = -2.6;
    mc_player._rotation = -12;

    updateScoreText();
    setSingleLine(tf_status, "READY...", 13, 0x000000, "center");

    _root.onEnterFrame = function():Void {
        if (_root.mode != "main") return;

        _root.frameCount++;

        for (var b:Number = 0; b < _root.bgRows.length; b++) {
            var row:TextField = _root.bgRows[b];
            row._x -= Number(_root.bgSpeeds[b]);
            if (row._x < -180) row._x = 0;
        }

        var gravity:Number = 0.42;
        var lift:Number = 0.86;
        var maxFall:Number = 6.4;
        var maxRise:Number = -5.8;

        if (_root.startGrace > 0) {
            _root.startGrace--;
            if (_root.autoTapFrames > 0) {
                _root.autoTapFrames--;
                mc_player.vy -= 0.52;
            } else {
                mc_player.vy += 0.30;
            }
            if (mc_player.vy < -3.8) mc_player.vy = -3.8;
            if (mc_player.vy > 3.2) mc_player.vy = 3.2;
            mc_player._y += mc_player.vy;
            if (mc_player._y < PLAY_TOP + 82) {
                mc_player._y = PLAY_TOP + 82;
                mc_player.vy = 0.7;
                _root.autoTapFrames = 0;
            }
            if (mc_player._y > 365) {
                mc_player._y = 365;
                mc_player.vy = -0.6;
            }
            mc_player._rotation = (_root.primaryDown || _root.autoTapFrames > 0 || mc_player.vy < -0.2) ? -12 : 12;
            if (_root.startGrace == 0) {
                _root.autoTapFrames = 0;
                if (mc_player.vy < 0.9) mc_player.vy = 0.9;
                setSingleLine(tf_status, waveStatus(), 13, 0x000000, "center");
            }
            return;
        }

        tickStatus();

        mc_player.vy += gravity;
        if (_root.primaryDown) mc_player.vy -= lift;
        if (mc_player.vy > maxFall) mc_player.vy = maxFall;
        if (mc_player.vy < maxRise) mc_player.vy = maxRise;
        mc_player._y += mc_player.vy;

        mc_player._rotation = (_root.primaryDown || mc_player.vy < -0.2) ? -12 : 12;

        if (mc_player._y < PLAY_TOP + 12 || mc_player._y > PLAY_BOTTOM - 12) {
            goResult();
            return;
        }

        _root.spawnWait--;
        if (_root.spawnWait <= 0) {
            attachObstacle();
            _root.spawnWait = nextSpawnWait();
        }

        for (var i:Number = _root.dynamicClips.length - 1; i >= 0; i--) {
            var ob:MovieClip = _root.dynamicClips[i];
            if (ob == undefined) continue;
            ob._x -= ob.speed;

            if (playerHitTest(ob.mc_hit)) {
                goResult();
                return;
            }

            if (!ob.scored && ob._x + ob.obW < PLAYER_X - 46) {
                ob.scored = true;
                registerPass();
                updateScoreText();
                playSE("se_pass");
            }

            if (ob._x < -ob.obW - 80) {
                ob.removeMovieClip();
                _root.dynamicClips.splice(i, 1);
            }
        }
    };
}

// Call this on frame 3:
setupMainFrame();

// ============================================================
// frame 4 "result" / actions layer
// Copy only this section to frame 4.
// ============================================================

function setupResultFrame():Void {
    stop();
    delete _root.onEnterFrame;
    clearWholeStagePress();

    var resultCopy:String = "";
    resultCopy += "GAME OVER\n\n";
    resultCopy += "SCORE " + padNumber(_root.resultScore, 6) + "\n";
    resultCopy += "HI    " + padNumber(Number(_root.store.data.hi), 6);

    setupText(tf_result, 24, 0x000000);
    tf_result.text = resultCopy;
    tf_result.setTextFormat(new TextFormat("_typewriter", 24, 0x000000));

    setSingleLine(tf_status, "もう一回だけやる", 15, 0x000000, "center");
    setupButton(btn_retry, "RETRY", function():Void {
        goMain();
    });
}

// Call this on frame 4:
setupResultFrame();
