// AS2 Retro Application Generic Frame-Script Skeleton v3.1
// ------------------------------------------------------------
// This is a shared FRAME-SCRIPT SKELETON for ActionScript 2.0.
// It assumes Flash IDE / Animate authoring with Timeline labels,
// Library symbols, linkage IDs, stage instances, and TextFields.
//
// Do NOT paste this into an empty AS file expecting a standalone app.
// Put common helpers on an early actions frame, then call the setup
// function for each Timeline label from that label's own frame script,
// after its stage instances exist.
//
// Example Timeline labels:
//   loading, title, main, result
//
// Example stage instances, depending on frame:
//   title:  tf_status, btn_start
//   main:   tf_status, mc_holder
//   result: tf_status, btn_retry
//
// Example library linkage IDs, depending on artifact:
//   mc_fx, se_click, se_result
// ------------------------------------------------------------

Stage.scaleMode = "noScale";
Stage.align = "TL";
stop();

// ------------------------------------------------------------
// Shared state. Keep this small and artifact-specific.
// ------------------------------------------------------------
_root.appId = "sample_as2_retro_app"; // Change per artifact to avoid SharedObject collisions.
_root.mode = "boot";
_root.primaryDown = false;
_root.soundOn = true;
_root.dynamicClips = new Array();
_root.resultText = "";
_root.localStore = SharedObject.getLocal(String(_root.appId));

if (_root.localStore.data.soundOn == undefined) _root.localStore.data.soundOn = true;
if (_root.localStore.data.visited == undefined) _root.localStore.data.visited = false;

_root.soundOn = _root.localStore.data.soundOn;
_root.localStore.data.visited = true;

function flushLocal():Void {
    _root.localStore.data.soundOn = _root.soundOn;
    _root.localStore.flush();
}

// ------------------------------------------------------------
// Text helpers
// ------------------------------------------------------------
function setupText(tf:TextField):Void {
    if (tf == undefined) return;
    tf.selectable = false;
    tf.embedFonts = false;
}

function setStatus(message:String):Void {
    if (tf_status == undefined) return;
    setupText(tf_status);
    tf_status.text = message;
}

// ------------------------------------------------------------
// Sound helpers. Requires Library sounds exported for ActionScript
// with linkage IDs such as se_click and se_result.
// ------------------------------------------------------------
function playSE(linkageId:String):Void {
    if (!_root.soundOn) return;
    var s:Sound = new Sound();
    s.attachSound(linkageId);
    s.start();
}

function toggleSound():Void {
    _root.soundOn = !_root.soundOn;
    flushLocal();
    setStatus(_root.soundOn ? "SOUND ON" : "SOUND OFF");
}

// ------------------------------------------------------------
// MovieClip-button helper. Hover is optional; press/release feedback
// is the important mobile translation.
// ------------------------------------------------------------
function setupButton(btn:MovieClip, action:Function):Void {
    if (btn == undefined) return;
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
        this._y = this.baseY + 1;
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

// ------------------------------------------------------------
// Whole-stage input pattern. Use when the artifact's primary action
// is tap, long press, or release.
// ------------------------------------------------------------
function setupWholeStagePress():Void {
    _root.onMouseDown = function():Void {
        _root.primaryDown = true;
    };
    _root.onMouseUp = function():Void {
        _root.primaryDown = false;
    };
}

function clearWholeStagePress():Void {
    delete _root.onMouseDown;
    delete _root.onMouseUp;
    _root.primaryDown = false;
}

// ------------------------------------------------------------
// Optional keyboard support. Register once; avoid duplicate listeners.
// ------------------------------------------------------------
var keyListener:Object = new Object();
keyListener.onKeyDown = function():Void {
    if (Key.getCode() == Key.SPACE) _root.primaryDown = true;
};
keyListener.onKeyUp = function():Void {
    if (Key.getCode() == Key.SPACE) _root.primaryDown = false;
};
Key.addListener(keyListener);

// ------------------------------------------------------------
// Dynamic MovieClip lifecycle
// ------------------------------------------------------------
function getHolder():MovieClip {
    if (mc_holder != undefined) return mc_holder;
    return _root;
}

function attachDynamic(linkageId:String, prefix:String, holder:MovieClip):MovieClip {
    if (holder == undefined) holder = getHolder();
    var d:Number = holder.getNextHighestDepth();
    var mc:MovieClip = holder.attachMovie(linkageId, prefix + d, d);
    if (mc != undefined) _root.dynamicClips.push(mc);
    return mc;
}

function cleanupDynamic():Void {
    for (var i:Number = _root.dynamicClips.length - 1; i >= 0; i--) {
        if (_root.dynamicClips[i] != undefined) {
            _root.dynamicClips[i].removeMovieClip();
        }
    }
    _root.dynamicClips = new Array();
}

// ------------------------------------------------------------
// Navigation. These functions move the playhead. The target frame
// should run its own setup script after frame instances exist.
// ------------------------------------------------------------
function goTitle():Void {
    cleanupDynamic();
    clearWholeStagePress();
    _root.mode = "title";
    gotoAndStop("title");
}

function goMain():Void {
    cleanupDynamic();
    _root.mode = "main";
    gotoAndStop("main");
}

function goResult(message:String):Void {
    cleanupDynamic();
    clearWholeStagePress();
    _root.mode = "result";
    _root.resultText = message;
    playSE("se_result");
    gotoAndStop("result");
}

// ------------------------------------------------------------
// Frame setup examples. Call these from each label's actions frame,
// not before gotoAndStop() reaches that label.
// ------------------------------------------------------------
function setupTitleFrame():Void {
    stop();
    clearWholeStagePress();
    setupText(tf_status);
    setupButton(btn_start, goMain);
    setStatus("TAP TO START");
}

function setupMainFrame():Void {
    stop();
    setupText(tf_status);
    setupWholeStagePress();
    setStatus("TOUCH");
}

function setupResultFrame():Void {
    stop();
    clearWholeStagePress();
    setupText(tf_status);
    setupButton(btn_retry, goMain);
    if (_root.resultText == "") _root.resultText = "DONE";
    setStatus(String(_root.resultText));
}

// ------------------------------------------------------------
// Copy the relevant call to each Timeline label's frame script:
//
// frame "title":
//   setupTitleFrame();
//
// frame "main":
//   setupMainFrame();
//
// frame "result":
//   setupResultFrame();
// ------------------------------------------------------------

trace("AS2 retro application generic skeleton v3.1 loaded");
