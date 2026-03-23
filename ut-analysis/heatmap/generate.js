#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname, "..");
const RAW_DIR = path.join(ROOT, "raw");
const SCREENS_DIR = path.join(__dirname, "screens");

const SCREEN_ORDER = [
  "HomeView",
  "BookLocationView",
  "BookDateView",
  "BookPassengerView",
  "PayModeView",
  "SRPView",
];

const SCREEN_LABELS = {
  HomeView: "Home",
  BookLocationView: "Book Location",
  BookDateView: "Book Date",
  BookPassengerView: "Book Passengers",
  PayModeView: "Payment Mode",
  SRPView: "Search Results",
};

const VIEWPORT_HEIGHT = 852;
const VIEWPORT_WIDTH = 393;
const VIEWPORT_RATIO = VIEWPORT_HEIGHT / VIEWPORT_WIDTH;

const KNOWN_CONTENT_RATIOS = {
  HomeView: 3.1,
  SRPView: 1.85,
  BookLocationView: 1.0,
  BookDateView: 1.0,
  BookPassengerView: 1.2,
  PayModeView: 1.0,
};

const GRID_X = 48;

function aggregateTaps(rawDir) {
  if (!fs.existsSync(rawDir))
    return { screens: {}, sessionCount: 0, srpOverlay: { stretch: 0, economy: 0 } };

  const files = fs.readdirSync(rawDir).filter((f) => f.endsWith(".json"));
  const screens = {};
  let sessionCount = 0;
  let stretchTaps = 0;
  let economyTaps = 0;

  for (const f of files) {
    let session;
    try {
      session = JSON.parse(fs.readFileSync(path.join(rawDir, f), "utf-8"));
    } catch (_) {
      continue;
    }
    const taps = session.taps || [];
    if (taps.length === 0) continue;
    sessionCount++;

    for (const t of taps) {
      const sid = t.screenId;
      if (!sid) continue;

      if (!screens[sid]) {
        screens[sid] = {
          tapCount: 0,
          rawTaps: [],
          maxContentHeight: null,
        };
      }

      screens[sid].tapCount++;
      screens[sid].rawTaps.push({ x: t.x || 0, y: t.y || 0 });

      if (t.contentHeight && t.contentHeight > 0) {
        const ratio = t.contentHeight / VIEWPORT_HEIGHT;
        if (!screens[sid].maxContentHeight || ratio > screens[sid].maxContentHeight) {
          screens[sid].maxContentHeight = ratio;
        }
      }

      if (sid === "SRPView" && (t.y || 0) > 0.30) {
        if ((t.x || 0) < 0.5) stretchTaps++;
        else economyTaps++;
      }
    }
  }

  for (const sid of Object.keys(screens)) {
    const s = screens[sid];
    const folds = s.maxContentHeight || KNOWN_CONTENT_RATIOS[sid] || 1.0;
    s.folds = folds;
    const gridY = Math.round(GRID_X * VIEWPORT_RATIO * folds);
    s.gridY = gridY;
    s.grid = Array(gridY).fill(0).map(() => Array(GRID_X).fill(0));
    s.maxCount = 0;

    for (const t of s.rawTaps) {
      const gx = Math.min(GRID_X - 1, Math.max(0, Math.floor(t.x * GRID_X)));
      const gy = Math.min(gridY - 1, Math.max(0, Math.floor(t.y * gridY)));
      s.grid[gy][gx]++;
    }

    let max = 0;
    for (let i = 0; i < gridY; i++)
      for (let j = 0; j < GRID_X; j++)
        if (s.grid[i][j] > max) max = s.grid[i][j];
    s.maxCount = max;

    delete s.rawTaps;
  }

  return { screens, sessionCount, srpOverlay: { stretch: stretchTaps, economy: economyTaps } };
}

function imgToDataUri(filePath) {
  if (!fs.existsSync(filePath)) return null;
  return "data:image/png;base64," + fs.readFileSync(filePath).toString("base64");
}

function main() {
  const rawDir =
    process.argv.find((a) => a.startsWith("--raw-dir="))?.split("=")[1] || RAW_DIR;

  const data = aggregateTaps(rawDir);

  const screenImages = {};
  for (const sid of SCREEN_ORDER) {
    screenImages[sid] = imgToDataUri(path.join(SCREENS_DIR, `${sid}.png`));
  }
  screenImages["HomeView-full"] = imgToDataUri(path.join(SCREENS_DIR, "HomeView-full.png"));
  screenImages["SRPView-full"] = imgToDataUri(path.join(SCREENS_DIR, "SRPView-full.png"));
  screenImages["SRPView-Stretch"] = imgToDataUri(path.join(SCREENS_DIR, "SRPView-Stretch.png"));
  screenImages["SRPView-Economy"] = imgToDataUri(path.join(SCREENS_DIR, "SRPView-Economy.png"));

  const stripped = JSON.parse(JSON.stringify(data));
  Object.values(stripped.screens || {}).forEach((s) => {
    if (s.grid && s.grid.length > 200) {
      delete s.grid;
    }
  });
  fs.writeFileSync(path.join(__dirname, "data.json"), JSON.stringify(stripped, null, 2), "utf-8");

  const viewPath = path.join(__dirname, "view.html");
  fs.writeFileSync(viewPath, buildHtml(data, screenImages), "utf-8");
  console.log(
    "Wrote", viewPath,
    "| sessions:", data.sessionCount,
    "| screens:", Object.keys(data.screens).length,
    "| SRP overlay — Stretch:", data.srpOverlay.stretch, "Economy:", data.srpOverlay.economy
  );
}

function esc(obj) {
  return JSON.stringify(obj).replace(/</g, "\\u003c").replace(/>/g, "\\u003e");
}

function buildHtml(data, screenImages) {
  const totalSrp = data.srpOverlay.stretch + data.srpOverlay.economy;
  const stretchPct = totalSrp > 0 ? Math.round((data.srpOverlay.stretch / totalSrp) * 100) : 0;
  const economyPct = totalSrp > 0 ? 100 - stretchPct : 0;

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>UT Tap Heat Maps — Alpha 4</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,system-ui,'Segoe UI',sans-serif;background:#0c0f14;color:#d8e0ea;padding:32px 28px 60px}
h1{font-size:1.4rem;font-weight:700;letter-spacing:-.3px}
.subtitle{color:#6b7a8d;font-size:.82rem;margin:6px 0 28px}
.grid{display:flex;flex-wrap:wrap;gap:36px;align-items:flex-start}
.screen-card{flex-shrink:0}
.screen-card h2{font-size:.82rem;font-weight:600;color:#7b93ab;margin-bottom:6px;letter-spacing:.4px;text-transform:uppercase}
.screen-card .folds-tag{font-size:.65rem;color:#4a5a6a;margin-bottom:10px}
.phone{position:relative;width:240px;border-radius:20px;overflow:hidden;background:#111620;border:2px solid #232b3a;box-shadow:0 12px 40px rgba(0,0,0,.5)}
.phone.scrollable{border-radius:12px}
.phone-bg{position:absolute;top:0;left:0;width:100%;height:100%;object-fit:fill;pointer-events:none;z-index:1}
.phone-bg.faded{opacity:.30}
.phone-bg.full-page{object-fit:cover;object-position:top}
.heat-layer{position:absolute;top:0;left:0;width:100%;height:100%;z-index:2}
.dot{position:absolute;border-radius:50%;transform:translate(-50%,-50%);pointer-events:none}
.fold-line{position:absolute;left:0;width:100%;border-top:1px dashed rgba(255,255,255,.12);z-index:3;pointer-events:none}
.fold-label{position:absolute;right:6px;top:-9px;font-size:7px;color:rgba(255,255,255,.25);z-index:3}
.legend{margin-top:10px;font-size:.68rem;color:#546070;display:flex;justify-content:space-between;align-items:center}
.legend-bar{display:flex;gap:2px;align-items:center}
.swatch{width:10px;height:10px;border-radius:2px;display:inline-block}

.srp-section{margin-top:48px;padding:24px;background:#141924;border-radius:16px;border:1px solid #232b3a;max-width:740px}
.srp-section h2{font-size:1rem;font-weight:700;margin-bottom:16px;color:#a0b4c8}
.overlay-row{display:flex;gap:24px;align-items:flex-start;flex-wrap:wrap}
.overlay-card{flex:1;min-width:200px;position:relative;border-radius:16px;overflow:hidden;border:2px solid #232b3a;background:#111620}
.overlay-card img{width:100%;display:block;opacity:.35}
.overlay-stat{position:absolute;bottom:0;left:0;right:0;padding:12px 16px;background:linear-gradient(transparent,rgba(0,0,0,.85));color:#fff}
.overlay-stat .label{font-size:.72rem;text-transform:uppercase;letter-spacing:.5px;color:#8fa0b4}
.overlay-stat .val{font-size:1.6rem;font-weight:800;letter-spacing:-.5px}
.overlay-stat .pct{font-size:.85rem;font-weight:600;color:#6ee7b7}
.overlay-bar{display:flex;height:6px;border-radius:3px;overflow:hidden;margin-top:12px;background:#1e2736}
.bar-stretch{background:linear-gradient(90deg,#c5923e,#d4a853);height:100%}
.bar-economy{background:linear-gradient(90deg,#3b82f6,#60a5fa);height:100%}
.overlay-legend{display:flex;gap:20px;margin-top:10px;font-size:.72rem;color:#6b7a8d}
.overlay-legend span{display:flex;align-items:center;gap:5px}
.overlay-legend .sw-s{width:8px;height:8px;border-radius:2px;background:#d4a853}
.overlay-legend .sw-e{width:8px;height:8px;border-radius:2px;background:#60a5fa}

@media print{body{background:#fff;color:#111}.phone{border-color:#ccc;background:#f5f5f5}.phone-bg{opacity:.2}}
</style>
</head>
<body>
<h1>UT Tap Heat Maps — Alpha 4</h1>
<p class="subtitle">Sessions: ${data.sessionCount} &nbsp;&bull;&nbsp; Dots = taps over actual screens &nbsp;&bull;&nbsp; Scrollable pages show full content height with fold markers</p>

<div class="grid" id="maps"></div>

<div class="srp-section">
  <h2>SRP Overlay Analysis — Stretch vs Economy</h2>
  <div class="overlay-row">
    <div class="overlay-card" id="ov-stretch"></div>
    <div class="overlay-card" id="ov-economy"></div>
  </div>
  <div class="overlay-bar">
    <div class="bar-stretch" style="width:${stretchPct}%"></div>
    <div class="bar-economy" style="width:${economyPct}%"></div>
  </div>
  <div class="overlay-legend">
    <span><i class="sw-s"></i>Stretch — ${data.srpOverlay.stretch} taps (${stretchPct}%)</span>
    <span><i class="sw-e"></i>Economy — ${data.srpOverlay.economy} taps (${economyPct}%)</span>
  </div>
</div>

<script>
var DATA=${esc(data)};
var IMAGES=${esc(screenImages)};
var LABELS=${esc(SCREEN_LABELS)};
var ORDER=${esc(SCREEN_ORDER)};
var VP_RATIO=${VIEWPORT_RATIO};

ORDER.forEach(function(sid){
  var s=DATA.screens[sid];
  if(!s)return;
  var folds=s.folds||1;
  var baseW=240;
  var singleH=Math.round(baseW*VP_RATIO);
  var phoneH=Math.round(singleH*folds);
  var isScrollable=folds>1.15;

  var card=document.createElement('div');
  card.className='screen-card';
  card.innerHTML='<h2>'+sid+(LABELS[sid]?' — '+LABELS[sid]:'')+'</h2>';
  if(isScrollable){
    var tag=document.createElement('div');
    tag.className='folds-tag';
    tag.textContent=folds.toFixed(1)+'x viewport height — '+Math.round(folds)+' fold'+(Math.round(folds)>1?'s':'');
    card.appendChild(tag);
  }

  var phone=document.createElement('div');
  phone.className='phone'+(isScrollable?' scrollable':'');
  phone.style.height=phoneH+'px';
  phone.style.width=baseW+'px';

  var imgKey=sid;
  if(IMAGES[sid+'-full'])imgKey=sid+'-full';
  if(IMAGES[imgKey]){
    var bg=document.createElement('img');
    bg.className='phone-bg faded'+(isScrollable?' full-page':'');
    bg.src=IMAGES[imgKey];
    phone.appendChild(bg);
  }

  if(isScrollable){
    for(var fi=1;fi<Math.ceil(folds);fi++){
      var fline=document.createElement('div');
      fline.className='fold-line';
      fline.style.top=(fi*singleH)+'px';
      var flbl=document.createElement('span');
      flbl.className='fold-label';
      flbl.textContent='fold '+(fi+1);
      fline.appendChild(flbl);
      phone.appendChild(fline);
    }
  }

  var hl=document.createElement('div');
  hl.className='heat-layer';
  var gridY=s.gridY||Math.round(48*VP_RATIO*folds);
  var max=s.maxCount||1;
  for(var gy=0;gy<gridY;gy++){
    if(!s.grid[gy])continue;
    for(var gx=0;gx<48;gx++){
      var v=s.grid[gy][gx]||0;
      if(!v)continue;
      var t=v/max;
      var dot=document.createElement('div');
      dot.className='dot';
      dot.style.left=((gx+.5)/48*100)+'%';
      dot.style.top=((gy+.5)/gridY*100)+'%';
      var sz=6+t*16;
      dot.style.width=sz+'px';
      dot.style.height=sz+'px';
      var r=Math.round(255*Math.min(1,t*1.8));
      var g=Math.round(60*(1-t));
      var b=Math.round(160*(1-t)+30);
      var a=.3+t*.6;
      dot.style.background='rgba('+r+','+g+','+b+','+a+')';
      dot.style.boxShadow='0 0 '+(3+t*14)+'px rgba('+r+','+g+','+b+','+(a*.8)+')';
      hl.appendChild(dot);
    }
  }
  phone.appendChild(hl);
  card.appendChild(phone);

  var leg=document.createElement('div');
  leg.className='legend';
  leg.innerHTML='<span>'+s.tapCount+' taps</span><div class="legend-bar"><div class="swatch" style="background:rgba(30,30,180,.5)"></div>low<div class="swatch" style="background:rgba(220,50,60,.7)"></div>mid<div class="swatch" style="background:rgba(255,80,20,.95)"></div>hot</div>';
  card.appendChild(leg);

  document.getElementById('maps').appendChild(card);
});

['Stretch','Economy'].forEach(function(type){
  var key='SRPView-'+type;
  var el=document.getElementById('ov-'+type.toLowerCase());
  if(!el)return;
  if(IMAGES[key]){
    var img=document.createElement('img');
    img.src=IMAGES[key];
    el.appendChild(img);
  }
  var stat=document.createElement('div');
  stat.className='overlay-stat';
  var count=type==='Stretch'?DATA.srpOverlay.stretch:DATA.srpOverlay.economy;
  var total=DATA.srpOverlay.stretch+DATA.srpOverlay.economy;
  var pct=total>0?Math.round(count/total*100):0;
  stat.innerHTML='<div class="label">'+type+'</div><div class="val">'+count+' <span class="pct">('+pct+'%)</span></div>';
  el.appendChild(stat);
});
</script>
</body>
</html>`;
}

main();
