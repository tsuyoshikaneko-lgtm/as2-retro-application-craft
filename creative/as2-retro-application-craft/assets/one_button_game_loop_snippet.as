// Optional one-button game loop snippet for AS2 Retro Application Craft v3.1
// ------------------------------------------------------------
// Use this only for one-button games or close variants.
// Paste into the "main" frame after setupMainFrame(), where these
// instances exist:
//   mc_player, mc_holder, tf_score, tf_hi
//
// Required Library linkage IDs:
//   mc_obstacle, se_hit
//
// Requires helpers from as2_application_skeleton.as:
//   attachDynamic(), cleanupDynamic(), setupText(), goResult()
// ------------------------------------------------------------

_root.score = 0;
if (_root.localStore.data.hi == undefined) _root.localStore.data.hi = 0;

setupText(tf_score);
setupText(tf_hi);

function padNumber(n:Number, digits:Number):String {
    var s:String = String(Math.floor(n));
    while (s.length < digits) s = "0" + s;
    return s;
}

function updateGameText():Void {
    if (tf_score != undefined) tf_score.text = "SCORE " + padNumber(_root.score, 6);
    if (tf_hi != undefined) tf_hi.text = "HI    " + padNumber(Number(_root.localStore.data.hi), 6);
}

function finishGame():Void {
    if (Number(_root.score) > Number(_root.localStore.data.hi)) {
        _root.localStore.data.hi = Number(_root.score);
    }
    _root.localStore.flush();
    playSE("se_hit");
    goResult("GAME OVER");
}

var vy:Number = 0;
var gravity:Number = 0.8;
var lift:Number = 1.6;
var spawnWait:Number = 0;

updateGameText();

_root.onEnterFrame = function():Void {
    if (_root.mode != "main") return;
    if (mc_player == undefined) return;

    vy += gravity;
    if (_root.primaryDown) vy -= lift;
    mc_player._y += vy;

    if (mc_player._y < 20) {
        mc_player._y = 20;
        vy = 0;
    }
    if (mc_player._y > Stage.height - 20) {
        finishGame();
        return;
    }

    spawnWait--;
    if (spawnWait <= 0) {
        var ob:MovieClip = attachDynamic("mc_obstacle", "ob", mc_holder);
        if (ob != undefined) {
            ob._x = Stage.width + 40;
            ob._y = 40 + Math.random() * (Stage.height - 80);
            ob.speed = 4 + Math.random() * 3;
        }
        spawnWait = 28 + Math.random() * 20;
    }

    for (var i:Number = _root.dynamicClips.length - 1; i >= 0; i--) {
        var mc:MovieClip = _root.dynamicClips[i];
        if (mc == undefined) continue;
        mc._x -= mc.speed;

        if (mc.hitTest(mc_player)) {
            finishGame();
            return;
        }

        if (mc._x < -80) {
            mc.removeMovieClip();
            _root.dynamicClips.splice(i, 1);
            _root.score++;
            updateGameText();
        }
    }
};
