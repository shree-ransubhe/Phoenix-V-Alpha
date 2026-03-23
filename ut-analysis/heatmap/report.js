#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const RAW_DIR = path.join(__dirname, "..", "raw");
const OBS_PATH = path.join(__dirname, "..", "observations.json");
const SCREENS = ["HomeView", "BookLocationView", "BookDateView", "BookPassengerView", "PayModeView", "SRPView"];
const SCREEN_SHORT = { HomeView: "Home", BookLocationView: "Location", BookDateView: "Date", BookPassengerView: "Passengers", PayModeView: "Payment", SRPView: "SRP" };

function loadSessions() {
  return fs.readdirSync(RAW_DIR).filter(f => f.endsWith(".json")).sort()
    .map(f => JSON.parse(fs.readFileSync(path.join(RAW_DIR, f), "utf-8")));
}

function dur(a, b) {
  if (!a || !b) return null;
  return (new Date(b) - new Date(a)) / 1000;
}

function fmtDur(sec) {
  if (sec == null) return "-";
  if (sec < 60) return sec.toFixed(0) + "s";
  const m = Math.floor(sec / 60);
  const s = Math.round(sec % 60);
  return m + "m " + (s < 10 ? "0" : "") + s + "s";
}

function analyze(session) {
  const d = session.demographics || {};
  const dm = session.deviceMetadata || {};
  const stepDur = {};
  for (const st of session.steps || []) {
    if (!st.enteredAt || !st.leftAt) continue;
    const secs = dur(st.enteredAt, st.leftAt);
    if (secs != null) stepDur[st.screenId] = (stepDur[st.screenId] || 0) + secs;
  }
  const tapCount = {};
  for (const t of session.taps || []) tapCount[t.screenId] = (tapCount[t.screenId] || 0) + 1;
  const totalDur = dur(session.createdAt, session.endedAt);
  const journeyDur = dur(session.createdAt, session.completedAt);
  let longestScreen = null, longestDur = 0;
  for (const [k, v] of Object.entries(stepDur)) if (v > longestDur) { longestScreen = k; longestDur = v; }

  const postTaskSummary = (session.postTaskAnswers || [])
    .filter(q => q.answer && q.answer.trim())
    .map(q => `${q.question}: ${q.answer.trim()}`)
    .join("\n");

  return {
    title: session.sessionTitle,
    sessionId: session.sessionId,
    date: session.createdAt ? session.createdAt.slice(0, 10) : "",
    role: d.role || "",
    experience: d.experience || "",
    ageBand: d.ageBand || "",
    device: dm.deviceModel || d.device || "",
    os: dm.osVersion || "",
    audioConsent: session.audioConsent,
    audioFile: session.audioFileName || null,
    journeyCompleted: session.journeyCompleted,
    rating: session.rating,
    frustration: session.frustration,
    feedback: (session.feedback || "").trim(),
    postTaskSummary,
    totalDur, journeyDur,
    totalTaps: (session.taps || []).length,
    stepDur, tapCount,
    longestScreen: longestScreen ? SCREEN_SHORT[longestScreen] || longestScreen : "-",
    longestDur,
  };
}

function loadObservations() {
  if (!fs.existsSync(OBS_PATH)) return [];
  try { return JSON.parse(fs.readFileSync(OBS_PATH, "utf-8")); } catch { return []; }
}

function main() {
  const sessions = loadSessions();
  const rows = sessions.map((s, i) => ({ ut: `UT-${i + 1}`, ...analyze(s) }));
  const obs = loadObservations();
  for (const o of obs) {
    const row = rows.find(r => r.ut === o.ut);
    if (!row) continue;
    if (o.appExp) row.experience = o.appExp;
    if (o.age) row.ageBand = o.age;
    if (o.recordingLink) row.recordingLink = o.recordingLink;
    if (o.transcriptionLink) row.transcriptionLink = o.transcriptionLink;
    row.quickObservations = o.quickObservations || "";
    row.offTheRecord = o.offTheRecord || "";
    if (o.userFeedback && !row.feedback) row.feedback = o.userFeedback;
  }
  const outPath = path.join(__dirname, "report.html");
  fs.writeFileSync(outPath, buildHtml(rows), "utf-8");
  console.log("Wrote", outPath, "| sessions:", rows.length);
}

function e(s) { return (s || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;"); }

function buildHtml(rows) {
  const avgRating = rows.length ? (rows.reduce((a, r) => a + (r.rating || 0), 0) / rows.length).toFixed(1) : "-";
  const avgFrust = rows.length ? (rows.reduce((a, r) => a + (r.frustration || 0), 0) / rows.length).toFixed(1) : "-";
  const completionRate = rows.length ? Math.round(rows.filter(r => r.journeyCompleted).length / rows.length * 100) : 0;
  const totalTapsAll = rows.reduce((a, r) => a + r.totalTaps, 0);
  const avgDur = rows.filter(r => r.totalDur).length ? fmtDur(rows.reduce((a, r) => a + (r.totalDur || 0), 0) / rows.filter(r => r.totalDur).length) : "-";

  function distrib(arr) {
    const m = {};
    arr.forEach(v => { if (v) m[v] = (m[v] || 0) + 1; });
    return Object.entries(m).map(([k, v]) => `${k}&nbsp;<b>${v}</b>`).join(" &middot; ");
  }
  const roleDist = distrib(rows.map(r => r.role));
  const expDist = distrib(rows.map(r => r.experience));
  const ageDist = distrib(rows.map(r => r.ageBand));

  let screenSummaryRows = "";
  for (const sc of SCREENS) {
    const label = SCREEN_SHORT[sc];
    const times = rows.map(r => r.stepDur[sc] || 0);
    const taps = rows.map(r => r.tapCount[sc] || 0);
    const avgT = (times.reduce((a, b) => a + b, 0) / (times.length || 1)).toFixed(1);
    screenSummaryRows += `<tr><td>${label}</td><td>${avgT}s</td><td>${taps.reduce((a, b) => a + b, 0)}</td></tr>\n`;
  }

  let sessionRows = "";
  rows.forEach((r, i) => {
    const sid = e(r.title);
    const hasAudio = r.audioConsent && r.audioFile;
    const screenCells = SCREENS.map(sc => {
      const t = r.stepDur[sc];
      const taps = r.tapCount[sc] || 0;
      return `<td class="sc"><span class="t">${t ? t.toFixed(1) + "s" : "-"}</span><span class="tp">${taps}t</span></td>`;
    }).join("");

    sessionRows += `<tr data-idx="${i}">
<td class="ut-num">${r.ut}</td>
<td>${e(r.date)}</td>
<td>${e(r.role)}</td>
<td>${e(r.experience)}</td>
<td>${e(r.ageBand)}</td>
<td>${e(r.device)}</td>
<td>${e(r.os)}</td>
<td class="c">${hasAudio ? '<span class="b by">Y</span>' : '<span class="b bn">N</span>'}</td>
<td><input class="li" placeholder="Paste link..." data-key="${sid}__rec" value="${e(r.recordingLink || "")}"></td>
<td><input class="li" placeholder="Paste link..." data-key="${sid}__trans" value="${e(r.transcriptionLink || "")}"></td>
<td class="c"><span class="rt">${r.rating || "-"}</span></td>
<td class="c"><span class="fr">${r.frustration || "-"}</span></td>
<td>${fmtDur(r.totalDur)}</td>
<td>${fmtDur(r.journeyDur)}</td>
<td class="c">${r.journeyCompleted ? '<span class="b by">Y</span>' : '<span class="b bn">N</span>'}</td>
<td>${r.longestScreen} (${fmtDur(r.longestDur)})</td>
<td class="c">${r.totalTaps}</td>
${screenCells}
<td class="fb">${e(r.feedback)}</td>
<td class="fb">${e(r.postTaskSummary)}</td>
<td><textarea class="oi" rows="3" data-key="${sid}__obs">${e(r.quickObservations || "")}</textarea></td>
<td><textarea class="oi" rows="3" data-key="${sid}__otr">${e(r.offTheRecord || "")}</textarea></td>
</tr>\n`;
  });

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>UT Analysis Report — Alpha 4</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,system-ui,'Segoe UI',sans-serif;background:#f5f7fa;color:#1a2332;padding:24px}
h1{font-size:1.5rem;font-weight:700;margin-bottom:4px}
.meta{color:#5a6b80;font-size:.82rem;margin-bottom:20px}
.summary-grid{display:flex;gap:12px;margin-bottom:24px;flex-wrap:wrap}
.summary-card{background:#fff;border-radius:10px;padding:14px 18px;border:1px solid #e2e8f0;min-width:120px;flex:1}
.summary-card .label{font-size:.68rem;text-transform:uppercase;letter-spacing:.5px;color:#6b7f96;margin-bottom:4px}
.summary-card .val{font-size:1.4rem;font-weight:700;color:#1a2332}
.summary-card .val.green{color:#16a34a}
.summary-card .val.amber{color:#d97706}
.summary-card .val-sm{font-size:.82rem;font-weight:500;color:#334155;line-height:1.6}
.section-title{font-size:1rem;font-weight:700;margin:24px 0 10px;color:#334155}
.toolbar{display:flex;gap:10px;margin-bottom:16px;align-items:center}
.btn{padding:8px 18px;border-radius:8px;border:none;font-size:.78rem;font-weight:600;cursor:pointer;transition:all .15s}
.btn-primary{background:#1d4ed8;color:#fff}.btn-primary:hover{background:#1e40af}
.btn-outline{background:#fff;color:#334155;border:1px solid #cbd5e1}.btn-outline:hover{background:#f1f5f9}
table{width:100%;border-collapse:collapse;background:#fff;border-radius:10px;overflow:hidden;border:1px solid #e2e8f0;font-size:.72rem}
th{background:#f1f5f9;color:#475569;font-weight:600;text-transform:uppercase;letter-spacing:.3px;font-size:.62rem;padding:8px 6px;text-align:left;position:sticky;top:0;z-index:2;border-bottom:2px solid #e2e8f0;white-space:nowrap}
td{padding:6px;border-bottom:1px solid #f1f5f9;vertical-align:top}
tr:hover td{background:#f8fafc}
.ut-num{font-weight:700;color:#3b82f6;white-space:nowrap}
.c{text-align:center}
.b{display:inline-block;padding:2px 7px;border-radius:10px;font-size:.62rem;font-weight:600}
.by{background:#dcfce7;color:#16a34a}.bn{background:#fef2f2;color:#991b1b}
.rt,.fr{font-weight:700;font-size:.82rem}
.sc{text-align:center;line-height:1.5}
.sc .t{display:block;font-weight:600;color:#334155;font-size:.72rem}
.sc .tp{display:block;font-size:.58rem;color:#94a3b8}
.fb{max-width:160px;font-size:.68rem;color:#475569;white-space:pre-line}
.li{width:130px;font-size:.62rem;border:1px solid #e2e8f0;border-radius:4px;padding:3px 5px;color:#3b82f6;background:#fafbfc}
.li:focus{outline:none;border-color:#3b82f6}
.oi{width:220px;font-size:.65rem;border:1px solid #e2e8f0;border-radius:4px;padding:4px 5px;color:#334155;background:#fafbfc;resize:vertical;font-family:inherit}
.oi:focus{outline:none;border-color:#3b82f6}
.screen-summary{max-width:460px}
.screen-summary td,.screen-summary th{padding:6px 12px}
.table-wrap{overflow-x:auto;border-radius:10px;border:1px solid #e2e8f0}
@media print{body{background:#fff;padding:8px}.li,.oi{border:none;background:transparent}th{background:#f1f5f9!important;-webkit-print-color-adjust:exact;print-color-adjust:exact}.btn,.toolbar{display:none}}
</style>
</head>
<body>
<h1>UT Analysis Report — Alpha 4</h1>
<p class="meta">Generated ${new Date().toISOString().slice(0, 10)} &bull; ${rows.length} sessions &bull; Fill in links and notes, then export</p>

<div class="summary-grid">
  <div class="summary-card"><div class="label">Sessions</div><div class="val">${rows.length}</div></div>
  <div class="summary-card"><div class="label">Completion</div><div class="val green">${completionRate}%</div></div>
  <div class="summary-card"><div class="label">Avg Rating</div><div class="val">${avgRating}<span style="font-size:.7rem;color:#94a3b8">/5</span></div></div>
  <div class="summary-card"><div class="label">Avg Frustration</div><div class="val amber">${avgFrust}<span style="font-size:.7rem;color:#94a3b8">/5</span></div></div>
  <div class="summary-card"><div class="label">Avg Duration</div><div class="val">${avgDur}</div></div>
  <div class="summary-card"><div class="label">Total Taps</div><div class="val">${totalTapsAll}</div></div>
</div>

<h3 class="section-title">Participant Profile</h3>
<div class="summary-grid">
  <div class="summary-card"><div class="label">Travel Frequency</div><div class="val-sm">${roleDist || "-"}</div></div>
  <div class="summary-card"><div class="label">App Experience</div><div class="val-sm">${expDist || "-"}</div></div>
  <div class="summary-card"><div class="label">Age Bands</div><div class="val-sm">${ageDist || "-"}</div></div>
</div>

<h3 class="section-title">Per-Screen Summary</h3>
<table class="screen-summary"><tr><th>Screen</th><th>Avg Time</th><th>Total Taps</th></tr>${screenSummaryRows}</table>

<h3 class="section-title">Session Details</h3>
<div class="toolbar">
  <button class="btn btn-primary" onclick="exportXlsx()">Export to Excel (.xlsx)</button>
  <span style="font-size:.7rem;color:#6b7f96">Includes your filled-in links and notes. Copy last row into your main Excel.</span>
</div>
<div class="table-wrap">
<table id="mainTable">
  <thead><tr>
    <th>#</th><th>Date</th><th>Travel Freq.</th><th>App Exp.</th><th>Age</th><th>Device</th><th>OS</th>
    <th>Audio</th><th>Recording Link</th><th>Transcription Link</th>
    <th>Rating</th><th>Frust.</th><th>Total Time</th><th>Journey Time</th>
    <th>Completed</th><th>Longest Screen</th><th>Taps</th>
    ${SCREENS.map(sc => `<th>${SCREEN_SHORT[sc]}</th>`).join("")}
    <th>Feedback</th><th>Post-Task Answers</th><th>Quick Observations</th><th>Off the Record Notes</th>
  </tr></thead>
  <tbody>${sessionRows}</tbody>
</table>
</div>

<script src="https://cdn.sheetjs.com/xlsx-0.20.3/package/dist/xlsx.full.min.js"></script>
<script>
(function(){
  document.querySelectorAll('.li,.oi').forEach(function(el){
    var k='utr__'+el.dataset.key;
    var stored=localStorage.getItem(k);
    if(stored && stored!==el.value) el.value=stored;
    el.addEventListener('input',function(){localStorage.setItem(k,el.value)});
  });
})();

function exportXlsx(){
  var tbl=document.getElementById('mainTable');
  var headers=[];
  tbl.querySelectorAll('thead th').forEach(function(th){headers.push(th.textContent.trim())});
  var data=[headers];
  tbl.querySelectorAll('tbody tr').forEach(function(tr){
    var row=[];
    tr.querySelectorAll('td').forEach(function(td){
      var inp=td.querySelector('input,textarea');
      if(inp){row.push(inp.value||'');return}
      var badge=td.querySelector('.b');
      if(badge){row.push(badge.textContent.trim());return}
      var timeEl=td.querySelector('.t');
      if(timeEl){
        var taps=td.querySelector('.tp');
        row.push(timeEl.textContent.trim()+(taps?' / '+taps.textContent.trim():''));
        return;
      }
      row.push(td.textContent.trim());
    });
    data.push(row);
  });
  var ws=XLSX.utils.aoa_to_sheet(data);

  var colWidths=headers.map(function(h,i){
    var max=h.length;
    data.forEach(function(r){if(r[i]&&r[i].length>max)max=r[i].length});
    return{wch:Math.min(Math.max(max+2,8),40)};
  });
  ws['!cols']=colWidths;

  var wb=XLSX.utils.book_new();
  XLSX.utils.book_append_sheet(wb,ws,'UT Sessions');
  XLSX.writeFile(wb,'UT_Analysis_Alpha4_'+new Date().toISOString().slice(0,10)+'.xlsx');
}
</script>
</body>
</html>`;
}

main();
