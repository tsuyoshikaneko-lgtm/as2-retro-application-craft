(function () {
  var CACHE_VERSION = "20260618-swf-only-v1";
  var RELEASE_LABEL = "ver.0.21";
  var APP_SWF = "boon-threader.swf";
  var FONT_SWF = "aa-font.swf";
  var FONT_NAME = "Noto Sans CJK JP";

  function queryParams() {
    return new URLSearchParams(window.location.search);
  }

  function cacheBust(path) {
    return path + "?v=" + encodeURIComponent(CACHE_VERSION);
  }

  function fixtureValue(params) {
    var fixture = params.get("fixture") || "";
    if (!fixture && params.get("burst") == "1") fixture = "burst";
    return fixture;
  }

  function flashvarsValue(params) {
    var fixture = fixtureValue(params);
    if (!fixture) return "";
    return "fixture=" + encodeURIComponent(fixture);
  }

  function ensureParam(objectEl, name) {
    var params = objectEl.getElementsByTagName("param");
    for (var i = 0; i < params.length; i++) {
      if (params[i].getAttribute("name") == name) return params[i];
    }
    var param = document.createElement("param");
    param.setAttribute("name", name);
    objectEl.appendChild(param);
    return param;
  }

  function setText(selector, value) {
    var nodes = document.querySelectorAll(selector);
    for (var i = 0; i < nodes.length; i++) nodes[i].textContent = value;
  }

  var params = queryParams();
  var wrapper = {
    appSwf: cacheBust(APP_SWF),
    cacheVersion: CACHE_VERSION,
    debug: params.get("debug") == "1",
    flashvars: flashvarsValue(params),
    fontSwf: cacheBust(FONT_SWF),
    releaseLabel: RELEASE_LABEL
  };

  window.BoonThreaderWrapper = wrapper;
  window.RufflePlayer = window.RufflePlayer || {};
  window.RufflePlayer.config = Object.assign({}, window.RufflePlayer.config || {}, {
    autoplay: "on",
    unmuteOverlay: "hidden",
    letterbox: "on",
    scale: "showAll",
    forceScale: true,
    salign: "TL",
    forceAlign: true,
    contextMenu: "rightClickOnly",
    warnOnUnsupportedContent: true,
    logLevel: wrapper.debug ? "debug" : "warn",
    fontSources: [wrapper.fontSwf],
    defaultFonts: {
      sans: [FONT_NAME],
      serif: [FONT_NAME],
      typewriter: [FONT_NAME]
    }
  });

  function applyWrapperConfig() {
    var objectEl = document.querySelector("[data-boon-swf]");
    if (!objectEl) return;

    objectEl.setAttribute("data", wrapper.appSwf);
    ensureParam(objectEl, "movie").setAttribute("value", wrapper.appSwf);
    ensureParam(objectEl, "flashvars").setAttribute("value", wrapper.flashvars);
    setText("[data-release-label]", wrapper.releaseLabel);
    setText("[data-cache-version]", wrapper.cacheVersion);
  }

  wrapper.apply = applyWrapperConfig;

  if (document.readyState == "loading") {
    document.addEventListener("DOMContentLoaded", applyWrapperConfig);
  } else {
    applyWrapperConfig();
  }
}());
