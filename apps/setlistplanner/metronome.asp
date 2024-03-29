
<!DOCTYPE html>
<html lang="en" >
<head>
  <meta charset="UTF-8">  
  
    <script>
	window.HUB_EVENTS={ASSET_ADDED:"ASSET_ADDED",ASSET_DELETED:"ASSET_DELETED",ASSET_DESELECTED:"ASSET_DESELECTED",ASSET_SELECTED:"ASSET_SELECTED",ASSET_UPDATED:"ASSET_UPDATED",CONSOLE_CHANGE:"CONSOLE_CHANGE",CONSOLE_CLOSED:"CONSOLE_CLOSED",CONSOLE_EVENT:"CONSOLE_EVENT",CONSOLE_OPENED:"CONSOLE_OPENED",CONSOLE_RUN_COMMAND:"CONSOLE_RUN_COMMAND",CONSOLE_SERVER_CHANGE:"CONSOLE_SERVER_CHANGE",EMBED_ACTIVE_PEN_CHANGE:"EMBED_ACTIVE_PEN_CHANGE",EMBED_ACTIVE_THEME_CHANGE:"EMBED_ACTIVE_THEME_CHANGE",EMBED_ATTRIBUTE_CHANGE:"EMBED_ATTRIBUTE_CHANGE",EMBED_RESHOWN:"EMBED_RESHOWN",FORMAT_FINISH:"FORMAT_FINISH",FORMAT_ERROR:"FORMAT_ERROR",FORMAT_START:"FORMAT_START",IFRAME_PREVIEW_RELOAD_CSS:"IFRAME_PREVIEW_RELOAD_CSS",IFRAME_PREVIEW_URL_CHANGE:"IFRAME_PREVIEW_URL_CHANGE",KEY_PRESS:"KEY_PRESS",LINTER_FINISH:"LINTER_FINISH",LINTER_START:"LINTER_START",PEN_CHANGE_SERVER:"PEN_CHANGE_SERVER",PEN_CHANGE:"PEN_CHANGE",PEN_EDITOR_CLOSE:"PEN_EDITOR_CLOSE",PEN_EDITOR_CODE_FOLD:"PEN_EDITOR_CODE_FOLD",PEN_EDITOR_ERRORS:"PEN_EDITOR_ERRORS",PEN_EDITOR_EXPAND:"PEN_EDITOR_EXPAND",PEN_EDITOR_FOLD_ALL:"PEN_EDITOR_FOLD_ALL",PEN_EDITOR_LOADED:"PEN_EDITOR_LOADED",PEN_EDITOR_REFRESH_REQUEST:"PEN_EDITOR_REFRESH_REQUEST",PEN_EDITOR_RESET_SIZES:"PEN_EDITOR_RESET_SIZES",PEN_EDITOR_SIZES_CHANGE:"PEN_EDITOR_SIZES_CHANGE",PEN_EDITOR_UI_CHANGE_SERVER:"PEN_EDITOR_UI_CHANGE_SERVER",PEN_EDITOR_UI_CHANGE:"PEN_EDITOR_UI_CHANGE",PEN_EDITOR_UI_DISABLE:"PEN_EDITOR_UI_DISABLE",PEN_EDITOR_UI_ENABLE:"PEN_EDITOR_UI_ENABLE",PEN_EDITOR_UNFOLD_ALL:"PEN_EDITOR_UNFOLD_ALL",PEN_ERROR_INFINITE_LOOP:"PEN_ERROR_INFINITE_LOOP",PEN_ERROR_RUNTIME:"PEN_ERROR_RUNTIME",PEN_ERRORS:"PEN_ERRORS",PEN_LIVE_CHANGE:"PEN_LIVE_CHANGE",PEN_LOGS:"PEN_LOGS",PEN_MANIFEST_CHANGE:"PEN_MANIFEST_CHANGE",PEN_MANIFEST_FULL:"PEN_MANIFEST_FULL",PEN_PREVIEW_FINISH:"PEN_PREVIEW_FINISH",PEN_PREVIEW_START:"PEN_PREVIEW_START",PEN_SAVED:"PEN_SAVED",POPUP_CLOSE:"POPUP_CLOSE",POPUP_OPEN:"POPUP_OPEN",POST_CHANGE:"POST_CHANGE",POST_SAVED:"POST_SAVED",PROCESSING_FINISH:"PROCESSING_FINISH",PROCESSING_START:"PROCESSED_STARTED"},"object"!=typeof window.CP&&(window.CP={}),window.CP.PenTimer={programNoLongerBeingMonitored:!1,timeOfFirstCallToShouldStopLoop:0,_loopExits:{},_loopTimers:{},START_MONITORING_AFTER:2e3,STOP_ALL_MONITORING_TIMEOUT:5e3,MAX_TIME_IN_LOOP_WO_EXIT:2200,exitedLoop:function(E){this._loopExits[E]=!0},shouldStopLoop:function(E){if(this.programKilledSoStopMonitoring)return!0;if(this.programNoLongerBeingMonitored)return!1;if(this._loopExits[E])return!1;var _=this._getTime();if(0===this.timeOfFirstCallToShouldStopLoop)return this.timeOfFirstCallToShouldStopLoop=_,!1;var o=_-this.timeOfFirstCallToShouldStopLoop;if(o<this.START_MONITORING_AFTER)return!1;if(o>this.STOP_ALL_MONITORING_TIMEOUT)return this.programNoLongerBeingMonitored=!0,!1;try{this._checkOnInfiniteLoop(E,_)}catch{return this._sendErrorMessageToEditor(),this.programKilledSoStopMonitoring=!0,!0}return!1},_sendErrorMessageToEditor:function(){try{if(this._shouldPostMessage()){var E={topic:HUB_EVENTS.PEN_ERROR_INFINITE_LOOP,data:{line:this._findAroundLineNumber()}};parent.postMessage(E,"*")}else this._throwAnErrorToStopPen()}catch{this._throwAnErrorToStopPen()}},_shouldPostMessage:function(){return document.location.href.match(/boomboom/)},_throwAnErrorToStopPen:function(){throw"We found an infinite loop in your Pen. We've stopped the Pen from running. More details and workarounds at https://blog.codepen.io/2016/06/08/can-adjust-infinite-loop-protection-timing/"},_findAroundLineNumber:function(){var E=new Error("ignored"),_=0;if(E.stack){var o=E.stack.match(/boomboom\S+:(\d+):\d+/);o&&(_=o[1])}return _},_checkOnInfiniteLoop:function(E,_){if(!this._loopTimers[E])return this._loopTimers[E]=_,!1;if(_-this._loopTimers[E]>this.MAX_TIME_IN_LOOP_WO_EXIT)throw"Infinite Loop found on loop: "+E},_getTime:function(){return Date.now()}},window.CP.shouldStopExecution=function(E){var _=window.CP.PenTimer.shouldStopLoop(E);return!0===_&&console.warn("[CodePen]: An infinite loop (or a loop taking too long) was detected, so we stopped its execution. More details at https://blog.codepen.io/2016/06/08/can-adjust-infinite-loop-protection-timing/"),_},window.CP.exitedLoop=function(E){window.CP.PenTimer.exitedLoop(E)};</script>


  <title>Metronome</title>

  

  
  
<style>
@import url(https://fonts.googleapis.com/css?family=Open+Sans:400,300,700,600);
@import url(//cdnjs.cloudflare.com/ajax/libs/font-awesome/4.1.0/css/font-awesome.min.css);
body {
  background: #404040;
  font-family: "Open Sans", sans-serif;
}

input[type=range] {
  -webkit-appearance: none !important;
  max-height: 3px;
  position: relative;
  top: -3px;
  background: #DDD;
}

input[type=range]::-webkit-slider-thumb {
  -webkit-appearance: none !important;
  width: 15px;
  height: 15px;
  position: relative;
  top: -1px;
  background: #222;
}

input[type=checkbox] {
  display: none;
}

input[type=checkbox] + label {
  display: inline-block !important;
  height: 15px;
  width: 15px;
  margin: 0px 4px 0px 0px !important;
  padding: 0px;
  position: relative;
  top: 4px;
  background: #FFF;
  cursor: pointer;
}
input[type=checkbox] + label:before {
  content: "";
  display: inline-block;
  width: 4px;
  height: 8px;
  background: #F38630;
  opacity: 0;
  position: relative;
  top: -5px;
  right: -1px;
  transform: skewX(0deg);
  transition: all 0.24s;
}
input[type=checkbox] + label:after {
  content: "";
  display: inline-block;
  width: 4px;
  height: 15px;
  background: #F38630;
  opacity: 0;
  position: relative;
  top: -5px;
  right: -3px;
  transform: skewX(0deg);
  transition: all 0.24s;
}

input[type=checkbox]:checked + label:before {
  transform: skewX(30deg);
  opacity: 1;
}
input[type=checkbox]:checked + label:after {
  transform: skewX(-30deg);
  opacity: 1;
}

.container {
  width: 100%;
}

header {
  height: 65px;
  background: #879BAD;
  color: #2a353e;
  font-size: 36px;
  font-weight: 400;
  text-align: center;
  padding: 5px;
}

.metronome-container {
  width: 75%;
  height: auto;
  position: relative;
  margin: 40px auto;
  background: #2f2f2f;
}
.metronome-container .options-btn {
  color: #FFF;
  font-size: 22px;
  position: absolute;
  top: 20px;
  right: 15px;
  transform: rotateZ(0deg);
  cursor: pointer;
  transition: transform 0.3s;
}
.metronome-container .options-btn:hover {
  transform: rotateZ(60deg);
}
.metronome-container .options-active {
  max-height: 1000px !important;
  padding: 15px;
  overflow: visible !important;
}
.metronome-container .options {
  max-height: 0px;
  background: #FFF;
  color: #333;
  overflow: hidden;
  transition: all 0.25s;
  position: absolute;
  top: 50px;
  right: 15px;
}
.metronome-container .options .up {
  color: #FFF;
  font-size: 22px;
  position: absolute;
  top: -14px;
  right: 3px;
  z-index: 500;
  transform: rotateZ(180deg);
}
.metronome-container .options label {
  display: block;
  margin-top: 10px;
}
.metronome-container .counter {
  width: 100%;
  padding-bottom: 10px;
  background: #404040;
  text-align: center;
}
.metronome-container .counter .dot {
  width: 15px;
  height: 15px;
  display: inline-block;
  margin: 25px 10px 10px 10px;
  background: #FFF;
  border-radius: 50%;
  cursor: pointer;
  transition: all 0.3s;
}
.metronome-container .counter .active {
  background: #5ec2ff;
}
.metronome-container .controls {
  color: #FFF;
  padding: 20px;
  text-align: center;
}
.metronome-container .controls label {
  display: block;
  margin-bottom: 18px;
}
.metronome-container .controls label span {
  background: #FFF;
  color: #222;
  padding: 5px;
}
.metronome-container .controls label span i {
  cursor: pointer;
  transition: color 0.2s;
}
.metronome-container .controls label span i:hover {
  color: #FA6900;
}
.metronome-container .controls input {
  width: 30px;
  border: 0px solid;
  color: #222;
  text-align: center;
  padding: 4px;
}
.metronome-container .controls select {
  border: 0px;
  color: #222;
}
.metronome-container .controls .play-btn {
  width: 45%;
  background: #D6E26D;
  border: 0px;
  border-radius: 5px;
  padding: 12px;
  color: #3d430d;
  transition: background 0.3s;
}
.metronome-container .controls .play-btn:hover {
  background: #e8efad;
}
.metronome-container .controls .tap-btn {
  width: 45%;
  background: #888;
  border: 0px;
  border-radius: 5px;
  padding: 12px;
  color: #fbfbfb;
  transition: background 0.3s;
}
.metronome-container .controls .tap-btn:hover {
  background: #959595;
}

footer {
  width: 50%;
  height: auto;
  background: #FFF;
  color: #444;
  padding: 10px;
  margin: 50px auto;
}
</style>

  <script>
  window.console = window.console || function(t) {};
</script>

  <script>
  /**
 * StyleFix 1.0.3 & PrefixFree 1.0.7
 * @author Lea Verou
 * MIT license
 */(function(){function t(e,t){return[].slice.call((t||document).querySelectorAll(e))}if(!window.addEventListener)return;var e=window.StyleFix={link:function(t){try{if(t.rel!=="stylesheet"||t.hasAttribute("data-noprefix"))return}catch(n){return}var r=t.href||t.getAttribute("data-href"),i=r.replace(/[^\/]+$/,""),s=t.parentNode,o=new XMLHttpRequest,u;o.onreadystatechange=function(){o.readyState===4&&u()};u=function(){var n=o.responseText;if(n&&t.parentNode&&(!o.status||o.status<400||o.status>600)){n=e.fix(n,!0,t);if(i){n=n.replace(/url\(\s*?((?:"|')?)(.+?)\1\s*?\)/gi,function(e,t,n){return/^([a-z]{3,10}:|\/|#)/i.test(n)?e:'url("'+i+n+'")'});var r=i.replace(/([\\\^\$*+[\]?{}.=!:(|)])/g,"\\$1");n=n.replace(RegExp("\\b(behavior:\\s*?url\\('?\"?)"+r,"gi"),"$1")}var u=document.createElement("style");u.textContent=n;u.media=t.media;u.disabled=t.disabled;u.setAttribute("data-href",t.getAttribute("href"));s.insertBefore(u,t);s.removeChild(t);u.media=t.media}};try{o.open("GET",r);o.send(null)}catch(n){if(typeof XDomainRequest!="undefined"){o=new XDomainRequest;o.onerror=o.onprogress=function(){};o.onload=u;o.open("GET",r);o.send(null)}}t.setAttribute("data-inprogress","")},styleElement:function(t){if(t.hasAttribute("data-noprefix"))return;var n=t.disabled;t.textContent=e.fix(t.textContent,!0,t);t.disabled=n},styleAttribute:function(t){var n=t.getAttribute("style");n=e.fix(n,!1,t);t.setAttribute("style",n)},process:function(){t('link[rel="stylesheet"]:not([data-inprogress])').forEach(StyleFix.link);t("style").forEach(StyleFix.styleElement);t("[style]").forEach(StyleFix.styleAttribute)},register:function(t,n){(e.fixers=e.fixers||[]).splice(n===undefined?e.fixers.length:n,0,t)},fix:function(t,n,r){for(var i=0;i<e.fixers.length;i++)t=e.fixers[i](t,n,r)||t;return t},camelCase:function(e){return e.replace(/-([a-z])/g,function(e,t){return t.toUpperCase()}).replace("-","")},deCamelCase:function(e){return e.replace(/[A-Z]/g,function(e){return"-"+e.toLowerCase()})}};(function(){setTimeout(function(){t('link[rel="stylesheet"]').forEach(StyleFix.link)},10);document.addEventListener("DOMContentLoaded",StyleFix.process,!1)})()})();(function(e){function t(e,t,r,i,s){e=n[e];if(e.length){var o=RegExp(t+"("+e.join("|")+")"+r,"gi");s=s.replace(o,i)}return s}if(!window.StyleFix||!window.getComputedStyle)return;var n=window.PrefixFree={prefixCSS:function(e,r,i){var s=n.prefix;n.functions.indexOf("linear-gradient")>-1&&(e=e.replace(/(\s|:|,)(repeating-)?linear-gradient\(\s*(-?\d*\.?\d*)deg/ig,function(e,t,n,r){return t+(n||"")+"linear-gradient("+(90-r)+"deg"}));e=t("functions","(\\s|:|,)","\\s*\\(","$1"+s+"$2(",e);e=t("keywords","(\\s|:)","(\\s|;|\\}|$)","$1"+s+"$2$3",e);e=t("properties","(^|\\{|\\s|;)","\\s*:","$1"+s+"$2:",e);if(n.properties.length){var o=RegExp("\\b("+n.properties.join("|")+")(?!:)","gi");e=t("valueProperties","\\b",":(.+?);",function(e){return e.replace(o,s+"$1")},e)}if(r){e=t("selectors","","\\b",n.prefixSelector,e);e=t("atrules","@","\\b","@"+s+"$1",e)}e=e.replace(RegExp("-"+s,"g"),"-");e=e.replace(/-\*-(?=[a-z]+)/gi,n.prefix);return e},property:function(e){return(n.properties.indexOf(e)?n.prefix:"")+e},value:function(e,r){e=t("functions","(^|\\s|,)","\\s*\\(","$1"+n.prefix+"$2(",e);e=t("keywords","(^|\\s)","(\\s|$)","$1"+n.prefix+"$2$3",e);return e},prefixSelector:function(e){return e.replace(/^:{1,2}/,function(e){return e+n.prefix})},prefixProperty:function(e,t){var r=n.prefix+e;return t?StyleFix.camelCase(r):r}};(function(){var e={},t=[],r={},i=getComputedStyle(document.documentElement,null),s=document.createElement("div").style,o=function(n){if(n.charAt(0)==="-"){t.push(n);var r=n.split("-"),i=r[1];e[i]=++e[i]||1;while(r.length>3){r.pop();var s=r.join("-");u(s)&&t.indexOf(s)===-1&&t.push(s)}}},u=function(e){return StyleFix.camelCase(e)in s};if(i.length>0)for(var a=0;a<i.length;a++)o(i[a]);else for(var f in i)o(StyleFix.deCamelCase(f));var l={uses:0};for(var c in e){var h=e[c];l.uses<h&&(l={prefix:c,uses:h})}n.prefix="-"+l.prefix+"-";n.Prefix=StyleFix.camelCase(n.prefix);n.properties=[];for(var a=0;a<t.length;a++){var f=t[a];if(f.indexOf(n.prefix)===0){var p=f.slice(n.prefix.length);u(p)||n.properties.push(p)}}n.Prefix=="Ms"&&!("transform"in s)&&!("MsTransform"in s)&&"msTransform"in s&&n.properties.push("transform","transform-origin");n.properties.sort()})();(function(){function i(e,t){r[t]="";r[t]=e;return!!r[t]}var e={"linear-gradient":{property:"backgroundImage",params:"red, teal"},calc:{property:"width",params:"1px + 5%"},element:{property:"backgroundImage",params:"#foo"},"cross-fade":{property:"backgroundImage",params:"url(a.png), url(b.png), 50%"}};e["repeating-linear-gradient"]=e["repeating-radial-gradient"]=e["radial-gradient"]=e["linear-gradient"];var t={initial:"color","zoom-in":"cursor","zoom-out":"cursor",box:"display",flexbox:"display","inline-flexbox":"display",flex:"display","inline-flex":"display"};n.functions=[];n.keywords=[];var r=document.createElement("div").style;for(var s in e){var o=e[s],u=o.property,a=s+"("+o.params+")";!i(a,u)&&i(n.prefix+a,u)&&n.functions.push(s)}for(var f in t){var u=t[f];!i(f,u)&&i(n.prefix+f,u)&&n.keywords.push(f)}})();(function(){function s(e){i.textContent=e+"{}";return!!i.sheet.cssRules.length}var t={":read-only":null,":read-write":null,":any-link":null,"::selection":null},r={keyframes:"name",viewport:null,document:'regexp(".")'};n.selectors=[];n.atrules=[];var i=e.appendChild(document.createElement("style"));for(var o in t){var u=o+(t[o]?"("+t[o]+")":"");!s(u)&&s(n.prefixSelector(u))&&n.selectors.push(o)}for(var a in r){var u=a+" "+(r[a]||"");!s("@"+u)&&s("@"+n.prefix+u)&&n.atrules.push(a)}e.removeChild(i)})();n.valueProperties=["transition","transition-property"];e.className+=" "+n.prefix;StyleFix.register(n.prefixCSS)})(document.documentElement);
  
  </script>

  
</head>

<body translate="no">
  <div class="container" style="margin-top:0px">

  <section class="metronome-container" style="margin-top:0px">
    <div class="counter"></div >
    
    <i class="fa fa-cog options-btn"></i>

    <div class="controls">
      <label>BPM: <span>
                    <i class="fa fa-minus bpm-minus"></i>
                    <input type="text" value="<%=server.htmlENcode(left(request.querystring("sBPM"),3))%>" class="bpm-input" />
                    <i class="fa fa-plus bpm-plus"></i>
                  </span>
      </label>
      <label>
        Beat: <input type="text" value="4" class="ts-top" /></label>
      <div style="margin-bottom: 15px;">
        <input type="checkbox" id="timer-check" />
        <label for="timer-check"></label>
        
        Timer: <input type="text" value="<%=server.htmlENcode(left(request.querystring("sBPM"),3))%>" class="timer" />
      </div>

      <button class="tap-btn">Tap</button>
      <button class="play-btn">Play</button>
    </div>
    
    <div class="options">
      <i class="fa fa-caret-down up"></i>
      <label>Off Beat Pitch: <input type="range" min="0" max="500" value="200" class="beat-range" /></label>
      <label>Accent Pitch: <input type="range" min="0" max="500" value="380" class="accent-range" /></label>
    </div>
  </section>
</div>

  <script src='//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.3/jquery.min.js'></script>
<script src='//cdnjs.cloudflare.com/ajax/libs/FitText.js/1.1/jquery.fittext.min.js'></script>
      <script id="rendered-js" >
window.AudioContext = window.AudioContext || window.webkitAudioContext;
var context = new AudioContext();
var timer,noteCount,counting,accentPitch = 380,offBeatPitch = 200;
var delta = 0;
var curTime = 0.0;

// Load up dots on pageload
$("document").ready(function () {
  $(".ts-top").trigger("change");
  $("header").fitText(1, { maxFontSize: "46px" });
});


/*
Scheduling Help by: https://www.html5rocks.com/en/tutorials/audio/scheduling/
*/
function schedule() {
  while (curTime < context.currentTime + 0.1) {if (window.CP.shouldStopExecution(0)) break;
    playNote(curTime);
    updateTime();
  }window.CP.exitedLoop(0);
  timer = window.setTimeout(schedule, 0.1);
}

function updateTime() {
  curTime += 60.0 / parseInt($(".bpm-input").val(), 10);
  noteCount++;
}

/* Play note on a delayed interval of t */
function playNote(t) {
  var note = context.createOscillator();

  if (noteCount == parseInt($(".ts-top").val(), 10))
  noteCount = 0;

  if ($(".counter .dot").eq(noteCount).hasClass("active"))
  note.frequency.value = accentPitch;else

  note.frequency.value = offBeatPitch;

  note.connect(context.destination);

  note.start(t);
  note.stop(t + 0.05);

  $(".counter .dot").attr("style", "");

  $(".counter .dot").eq(noteCount).css({
    transform: "translateY(-10px)",
    background: "#F75454" });

}

function countDown() {
  var t = $(".timer");

  if (parseInt(t.val(), 10) > 0 && counting === true)
  {
    t.val(parseInt(t.val(), 10) - 1);
    window.setTimeout(countDown, 1000);
  } else

  {
    $(".play-btn").click();
    t.val(60);
  }
}

/* Tap tempo */
$(".tap-btn").click(function () {
  var d = new Date();
  var temp = parseInt(d.getTime(), 10);

  $(".bpm-input").val(Math.ceil(60000 / (temp - delta)));
  delta = temp;
});

/* Add or subtract bpm */
$(".bpm-minus, .bpm-plus").click(function () {
  if ($(this).hasClass("bpm-minus"))
  $(".bpm-input").val(parseInt($(".bpm-input").val(), 10) - 1);else

  $(".bpm-input").val(parseInt($(".bpm-input").val(), 10) + 1);
});

/* Change pitches for tones in options */
$(".beat-range, .accent-range").change(function () {
  if ($(this).hasClass("beat-range"))
  offBeatPitch = $(this).val();else

  accentPitch = $(this).val();
});

/* Activate dots for accents */
$(document).on("click", ".counter .dot", function () {
  $(this).toggleClass("active");
});

$(".options-btn").click(function () {
  $(".options").toggleClass("options-active");
});

/* Add dots when time signature is changed */
$(".ts-top, .ts-bottom").on("change", function () {
  var _counter = $(".counter");
  _counter.html("");

  for (var i = 0; i < parseInt($(".ts-top").val(), 10); i++)
  {if (window.CP.shouldStopExecution(1)) break;
    var temp = document.createElement("div");
    temp.className = "dot";

    if (i === 0)
    temp.className += " active";

    _counter.append(temp);
  }window.CP.exitedLoop(1);
});


/* Play and stop button */
$(".play-btn").click(function () {
  if ($(this).data("what") === "pause")
  {
    // ====== Pause ====== //
    counting = false;
    window.clearInterval(timer);
    $(".counter .dot").attr("style", "");
    $(this).data("what", "play").attr("style", "").text("Play");
  } else
  {
    // ====== Play ====== //

    if ($("#timer-check").is(":checked"))
    {
      counting = true;
      countDown();
    }

    curTime = context.currentTime;
    noteCount = parseInt($(".ts-top").val(), 10);
    schedule();

    $(this).data("what", "pause").css({
      background: "#F75454",
      color: "#FFF" }).
    text("Stop");
  }
});
//# sourceURL=pen.js
    </script>

  
</body>

</html>
