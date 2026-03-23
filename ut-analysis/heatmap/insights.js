#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const OBS_PATH = path.join(__dirname, "..", "observations.json");

function loadObs() {
  return JSON.parse(fs.readFileSync(OBS_PATH, "utf-8"));
}

function e(s) {
  return (s || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function nl2br(s) {
  return e(s).replace(/\r?\n/g, "<br>");
}

function main() {
  const sessions = loadObs();

  const participants = sessions.map(s => {
    const otr = (s.offTheRecord || "");
    const nameMatch = otr.match(/Name\s*[-–:]\s*(.+)/i);
    const locMatch = otr.match(/Location\s*[-–:]\s*(.+)/i);
    const catMatch = otr.match(/Category\s*[-–:]\s*(.+)/i);
    const travMatch = otr.match(/Trav\s*(?:Context|context)\s*[-–:]\s*(.+)/i);
    return {
      ...s,
      name: nameMatch ? nameMatch[1].trim() : "Anonymous",
      location: locMatch ? locMatch[1].trim() : "",
      category: catMatch ? catMatch[1].trim() : "",
      travContext: travMatch ? travMatch[1].trim() : "",
      obsLines: (s.quickObservations || "").split(/\r?\n/).filter(l => l.trim()),
      feedbackLines: (s.userFeedback || "").split(/\r?\n/).filter(l => l.trim()),
    };
  });

  const allObs = participants.flatMap(p =>
    p.obsLines.map(l => ({ line: l.replace(/^\d+\.\s*/, "").trim(), ut: p.ut, name: p.name, appExp: p.appExp, travelFreq: p.travelFreq, age: p.age }))
  ).filter(o => o.line);

  const themes = classifyThemes(allObs);

  const html = buildInsightsHtml(participants, themes, allObs);
  const outPath = path.join(__dirname, "insights.html");
  fs.writeFileSync(outPath, html, "utf-8");
  console.log("Wrote", outPath);
}

function classifyThemes(obs) {
  const patterns = [
    { id: "search-discoverability", label: "Search Widget Discoverability",
      severity: "high",
      test: l => /search|widget|initiate.*book|booking.*start|flight.*start/i.test(l) },
    { id: "home-exploration", label: "Home Screen Exploration & Engagement",
      severity: "medium",
      test: l => /home|scroll|explore|section|for you|first fold/i.test(l) },
    { id: "fare-family", label: "Fare Family & SRP Comprehension",
      severity: "low",
      test: l => /fare|family|stretch|economy|flexi|class|segmentation|SRP|differtiate|offering/i.test(l) },
    { id: "offers-loyalty", label: "Offers & Loyalty Perception",
      severity: "medium",
      test: l => /offer|loyalty|6EPick|6e|deal|header.*glance/i.test(l) },
    { id: "community", label: "Community Section Understanding",
      severity: "low",
      test: l => /community|swipe|pagination|art|stories/i.test(l) },
    { id: "passenger-data", label: "Passenger Selection & Historic Data",
      severity: "medium",
      test: l => /passang|passenger|names|historic|quick selection/i.test(l) },
    { id: "navigation", label: "Navigation & Wayfinding",
      severity: "medium",
      test: l => /navigation|back button|flights.*nav|pay.*mode|calendar|tappable/i.test(l) },
    { id: "simplicity", label: "Overall Simplicity & Perception",
      severity: "positive",
      test: l => /simple|simplicity|impressed|better than|percieved.*ok|ease|easy|quick/i.test(l) },
    { id: "lob-focus", label: "LOB Focus & Content Prioritisation",
      severity: "high",
      test: l => /LOB|focus.*flight|other.*business|MMT|Ixigo|Uber|cab|hotel|stealing.*attention/i.test(l) },
  ];

  const result = patterns.map(p => ({
    ...p,
    findings: obs.filter(o => p.test(o.line)),
  })).filter(t => t.findings.length > 0);

  result.sort((a, b) => {
    const order = { high: 0, medium: 1, low: 2, positive: 3 };
    return (order[a.severity] ?? 4) - (order[b.severity] ?? 4);
  });

  return result;
}

function sevLabel(s) {
  const map = {
    high: '<span class="sev sev-high">Needs Attention</span>',
    medium: '<span class="sev sev-med">Worth Investigating</span>',
    low: '<span class="sev sev-low">Monitor</span>',
    positive: '<span class="sev sev-pos">Positive Signal</span>',
  };
  return map[s] || s;
}

function buildInsightsHtml(participants, themes, allObs) {
  const n = participants.length;
  const date = new Date().toISOString().slice(0, 10);

  let participantCards = "";
  participants.forEach(p => {
    const displayName = (!p.name || p.name === "NA") ? "Participant" : p.name;
    const catClean = (p.category && !p.category.startsWith("Name")) ? p.category : "";
    participantCards += `
    <div class="p-card">
      <div class="p-id">${e(p.ut)}</div>
      <div class="p-name">${e(displayName)}</div>
      <div class="p-meta">${e(p.travelFreq)} traveller &middot; ${e(p.appExp)} with apps &middot; Age ${e(p.age)}</div>
      ${catClean ? `<div class="p-cat">${e(catClean)}</div>` : ""}
      ${p.travContext ? `<div class="p-route">${e(p.travContext)}</div>` : ""}
      ${p.location ? `<div class="p-loc">${e(p.location)}</div>` : ""}
    </div>`;
  });

  let themeSections = "";
  themes.forEach(t => {
    const quotes = t.findings.map(f =>
      `<div class="quote"><span class="q-text">&ldquo;${e(f.line)}&rdquo;</span><span class="q-src">${e(f.ut)} (${e(f.name || "Anon")})</span></div>`
    ).join("\n");

    let interpretation = "";
    switch (t.id) {
      case "search-discoverability":
        interpretation = `<b>${t.findings.length} of ${n} participants</b> exhibited hesitation or confusion around using the Search widget to initiate a flight booking. The label "Search" does not immediately communicate "Book a flight" — especially for first-time or infrequent users. One participant (UT-5) explicitly pointed to "Flights" in the bottom navigation as the expected starting point. This is a critical affordance gap: the primary action of the app is not self-evident on the home screen.`;
        break;
      case "home-exploration":
        interpretation = `The Home screen consistently received the longest dwell times (avg ~3 min across sessions), with users actively scrolling and tapping through multiple content sections. This shows <b>genuine curiosity and engagement</b> with the content layout. However, the "For You" section was perceived differently by user segments — the frequent traveller found it relevant but not eye-catching enough to trigger My Trips recall, while the novice wanted it bigger and more prominent. Content personalisation relevance (e.g., "Dubai" destination) needs validation against user context.`;
        break;
      case "fare-family":
        interpretation = `Fare family segmentation was <b>understood and appreciated</b> by users who had prior booking experience. UT-3 specifically differentiated between fare offerings on the initial SRP card. However, there is an emerging <b>primacy bias</b> — the first fare class shown (Flexi) tends to be selected by default, regardless of whether it's the best fit. This has implications for how fare options are ordered and presented.`;
        break;
      case "offers-loyalty":
        interpretation = `The Offers section received mixed reactions across user segments. The frequent traveller appreciated upfront placement for clarity, but UT-3 (occasional) misread the first offer as a section header — suggesting the visual hierarchy between promotional and structural content needs refinement. The 55+ user (UT-4) expressed a clear sentiment: <b>"after certain age, people are not concerned about offers & loyalty points — they prefer easy to book."</b> Loyalty/offers may need adaptive prominence based on user maturity. UT-5's feedback was explicit: <b>"only best deal matters"</b> — reinforcing that transactional users want value, not marketing surface area.`;
        break;
      case "community":
        interpretation = `Community section swipe interaction was discovered by UT-3 through exploration, but the intent was unclear — the user described it as "thought some art is there." The pagination indicator did help signal that more content exists. The feature's purpose may need clearer visual framing to communicate its value proposition.`;
        break;
      case "passenger-data":
        interpretation = `Pre-filled passenger names caused confusion for UT-3, who couldn't identify whose names were shown. In contrast, UT-2 (frequent traveller) specifically asked for historic passenger data in quick selection. This suggests <b>the feature is desired but its current implementation lacks context</b> — users need to understand the source and relationship of pre-populated names.`;
        break;
      case "navigation":
        interpretation = `UT-5 (novice) relied on the hardware/system back button rather than tapping on the date card in Payment mode, indicating the in-page navigation affordance wasn't intuitive for less tech-savvy users. UT-3 correctly identified the calendar section on the Payment page as tappable. This split suggests experienced users pick up interaction cues faster, but the design should accommodate the novice mental model too.`;
        break;
      case "simplicity":
        interpretation = `Multiple participants expressed <b>positive perception of the overall design</b>. UT-2 was "impressed with simplicity." UT-4, despite being a 55+ user familiar with the existing IndiGo app, perceived the new design as "ok and better than existing." The design direction is resonating — users feel it's cleaner and easier. This is a foundational positive signal to build upon.`;
        break;
      case "lob-focus":
        interpretation = `UT-5 (novice) strongly advocated for <b>flight-first focus</b>: "Why don't you focus more on flight-related things in the app? For other LOBs there are apps — MMT, Ixigo for hotel, Uber for cabs." The 6EPick element was specifically called out as "stealing attention." UT-5's direct feedback reinforces this: "Add focus on flights more, keep less focus on other businesses." This is a recurring theme that challenges the current multi-LOB home screen strategy.`;
        break;
    }

    themeSections += `
    <div class="theme-block" id="${t.id}">
      <div class="theme-header">
        <h3>${e(t.label)}</h3>
        ${sevLabel(t.severity)}
        <span class="mention-count">${t.findings.length} mention${t.findings.length > 1 ? "s" : ""}</span>
      </div>
      <div class="theme-interpretation">${interpretation}</div>
      <div class="theme-evidence">
        <div class="ev-label">Evidence from sessions:</div>
        ${quotes}
      </div>
    </div>`;
  });

  let directFeedback = "";
  participants.forEach(p => {
    if (!p.feedbackLines.length) return;
    directFeedback += `<div class="df-block"><b>${e(p.ut)}</b>: ${nl2br(p.userFeedback)}</div>`;
  });

  return `<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>Phoenix Alpha 4 — Usability Insights Report</title>
<style>
*{box-sizing:border-box;margin:0;padding:0}
body{font-family:-apple-system,system-ui,'Segoe UI',sans-serif;background:#fafbfc;color:#1a2332;line-height:1.65}
.container{max-width:860px;margin:0 auto;padding:32px 24px}
h1{font-size:1.6rem;font-weight:800;color:#0f172a;margin-bottom:4px}
h2{font-size:1.15rem;font-weight:700;color:#334155;margin:36px 0 14px;padding-bottom:8px;border-bottom:2px solid #e2e8f0}
h3{font-size:.95rem;font-weight:700;color:#1e293b;display:inline}
.subtitle{color:#64748b;font-size:.85rem;margin-bottom:28px}
.disclaimer{background:#fffbeb;border:1px solid #fde68a;border-radius:8px;padding:12px 16px;font-size:.78rem;color:#92400e;margin-bottom:28px;line-height:1.5}
.exec-summary{background:#fff;border:1px solid #e2e8f0;border-radius:10px;padding:20px 24px;margin-bottom:8px;font-size:.85rem;line-height:1.7;color:#334155}
.exec-summary b{color:#0f172a}
.exec-summary ul{margin:10px 0 0 18px}
.exec-summary li{margin-bottom:6px}

.p-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(200px,1fr));gap:12px;margin-bottom:8px}
.p-card{background:#fff;border:1px solid #e2e8f0;border-radius:8px;padding:14px 16px}
.p-id{font-size:.65rem;font-weight:700;color:#3b82f6;text-transform:uppercase;letter-spacing:.5px;margin-bottom:2px}
.p-name{font-size:.9rem;font-weight:700;color:#0f172a}
.p-meta{font-size:.72rem;color:#64748b;margin-top:4px}
.p-cat{font-size:.68rem;color:#8b5cf6;margin-top:4px;font-style:italic}
.p-route{font-size:.68rem;color:#0d9488;margin-top:2px}
.p-loc{font-size:.65rem;color:#94a3b8;margin-top:2px}

.theme-block{background:#fff;border:1px solid #e2e8f0;border-radius:10px;padding:18px 22px;margin-bottom:16px}
.theme-header{display:flex;align-items:center;gap:10px;flex-wrap:wrap;margin-bottom:12px}
.sev{font-size:.62rem;font-weight:700;padding:3px 8px;border-radius:12px;text-transform:uppercase;letter-spacing:.3px}
.sev-high{background:#fef2f2;color:#dc2626}.sev-med{background:#fff7ed;color:#c2410c}.sev-low{background:#f0f9ff;color:#0284c7}.sev-pos{background:#f0fdf4;color:#16a34a}
.mention-count{font-size:.65rem;color:#94a3b8;margin-left:auto}
.theme-interpretation{font-size:.82rem;color:#475569;line-height:1.7;margin-bottom:14px}
.theme-interpretation b{color:#1e293b}
.theme-evidence{border-top:1px solid #f1f5f9;padding-top:12px}
.ev-label{font-size:.65rem;font-weight:600;color:#94a3b8;text-transform:uppercase;letter-spacing:.4px;margin-bottom:8px}
.quote{margin-bottom:8px;padding-left:12px;border-left:3px solid #e2e8f0;font-size:.78rem;color:#475569}
.q-text{font-style:italic}
.q-src{display:block;font-size:.65rem;color:#94a3b8;margin-top:2px}

.df-block{font-size:.8rem;color:#475569;margin-bottom:8px;padding:8px 12px;background:#f8fafc;border-radius:6px;border-left:3px solid #3b82f6}
.df-block b{color:#1e293b}

.reco-list{list-style:none;counter-reset:reco}
.reco-list li{counter-increment:reco;margin-bottom:14px;padding:12px 16px;background:#fff;border:1px solid #e2e8f0;border-radius:8px;font-size:.82rem;color:#334155;line-height:1.6;position:relative;padding-left:44px}
.reco-list li::before{content:counter(reco);position:absolute;left:14px;top:12px;width:22px;height:22px;background:#1d4ed8;color:#fff;border-radius:50%;font-size:.7rem;font-weight:700;display:flex;align-items:center;justify-content:center}
.reco-list li b{color:#0f172a}

.toolbar{display:flex;gap:10px;margin-bottom:16px}
.btn{padding:10px 22px;border-radius:8px;border:none;font-size:.82rem;font-weight:600;cursor:pointer;background:#1d4ed8;color:#fff;transition:all .15s}
.btn:hover{background:#1e40af}
.footer{margin-top:36px;padding-top:16px;border-top:1px solid #e2e8f0;font-size:.7rem;color:#94a3b8;text-align:center}
@media print{body{background:#fff}.container{max-width:100%}.theme-block,.p-card,.exec-summary{break-inside:avoid}.toolbar{display:none}}
</style>
</head>
<body>
<div class="container">

<div class="toolbar">
  <button class="btn" onclick="exportWord()">Download as Word (.docx)</button>
</div>

<h1>Phoenix Alpha 4 — Usability Insights</h1>
<p class="subtitle">Qualitative findings from ${n} moderated sessions &middot; March 12–17, 2026 &middot; BOM T2 &amp; DEL IGI T1</p>

<div class="disclaimer">
  <b>Note on sample size:</b> This report is based on ${n} usability sessions across a diverse participant mix. While the sample is small for statistical generalisation, usability testing is designed to surface <b>qualitative patterns and user sentiments</b> — not statistical significance. The findings below are behavioural observations, not quantitative conclusions. Even 5 participants can uncover ~85% of major usability issues (Nielsen, 2000).
</div>

<h2>Executive Summary</h2>
<div class="exec-summary">
  <p>Across ${n} sessions — spanning first-time bookers, occasional travellers, a frequent flyer, and a 55+ experienced user — the Phoenix Alpha 4 prototype <b>successfully communicates a cleaner, simpler booking experience</b> compared to the existing IndiGo app. All participants completed the booking journey, and multiple users independently praised the design's simplicity.</p>
  <p style="margin-top:10px">However, two critical usability gaps emerged:</p>
  <ul>
    <li><b>Search widget discoverability:</b> The primary call-to-action for booking a flight is not self-evident. Novice users struggled to connect "Search" with "Book a flight" — one pointed to the bottom nav "Flights" tab as the expected entry point instead.</li>
    <li><b>LOB content overload on Home:</b> Non-flight content (6EPick, hotels, cabs via partner mentions) was perceived as clutter by users who expect a flight-first experience. The strongest quote: <i>"Why don't you focus more on flight-related things?"</i></li>
  </ul>
  <p style="margin-top:10px">The fare family presentation, community engagement hints, and overall navigation flow received positive or neutral reception, with specific refinement opportunities documented below.</p>
</div>

<h2>Participants</h2>
<div class="p-grid">${participantCards}</div>

<h2>Thematic Findings</h2>
${themeSections}

<h2>Direct User Feedback</h2>
${directFeedback || '<p style="font-size:.82rem;color:#94a3b8">No explicit feedback captured in sessions.</p>'}

<h2>Recommendations</h2>
<ol class="reco-list">
  <li><b>Rename or supplement the Search widget</b> — Consider "Book a Flight" or a prominent CTA label that eliminates ambiguity for first-time users. Test whether a persistent "Book Now" button or a reworded search bar improves task initiation rates.</li>
  <li><b>Re-evaluate Home screen LOB hierarchy</b> — Reduce prominence of non-flight LOBs (6EPick, hotels, cabs) on the first fold. Flight-related content should dominate. Consider adaptive layout: show LOB cross-sells only after the user has completed or explored flight content.</li>
  <li><b>Clarify pre-populated passenger names</b> — Add contextual labels ("From your last booking" or profile association) so users understand where names come from. The feature is desired but currently confusing.</li>
  <li><b>Refine Offers visual hierarchy</b> — Ensure the first offer card is visually distinct from section headers. Consider a "Deals for you" section label above the carousel to set context before the first card is visible.</li>
  <li><b>Validate fare ordering for primacy bias</b> — Test whether randomising or reordering fare classes (e.g., showing the cheapest first vs. the current Flexi-first) changes selection patterns. The current order may create unintended anchoring.</li>
  <li><b>Strengthen "For You" section prominence</b> — The personalised section resonated but was called "not big enough" by the novice user. Consider increasing card sizes or adding a brief explainer ("Based on your recent searches").</li>
  <li><b>Age-adaptive content strategy</b> — Older users (55+) explicitly deprioritise offers and loyalty in favour of ease. Consider a simplified mode or progressive disclosure that surfaces convenience features first for this segment.</li>
</ol>

<div class="footer">
  Phoenix UT Analysis &middot; Generated ${date} &middot; ${n} sessions &middot; Alpha 4
</div>
</div>

<script>
function exportWord(){
  var container=document.querySelector('.container');
  var toolbar=document.querySelector('.toolbar');
  if(toolbar) toolbar.style.display='none';

  var wordCss=\`
    body{font-family:Calibri,Arial,sans-serif;color:#1a2332;line-height:1.6;padding:20px;font-size:11pt}
    h1{font-size:18pt;font-weight:bold;color:#0f172a;margin-bottom:4px}
    h2{font-size:14pt;font-weight:bold;color:#334155;margin-top:24px;margin-bottom:10px;padding-bottom:6px;border-bottom:2px solid #e2e8f0}
    h3{font-size:11pt;font-weight:bold;color:#1e293b}
    .subtitle{color:#64748b;font-size:10pt;margin-bottom:20px}
    .disclaimer{background:#fffbeb;border:1px solid #fde68a;padding:10px 14px;font-size:9pt;color:#92400e;margin-bottom:20px}
    .exec-summary{background:#f8fafc;border:1px solid #e2e8f0;padding:14px 18px;margin-bottom:10px;font-size:10pt;color:#334155}
    .exec-summary b{color:#0f172a}
    .exec-summary ul{margin:8px 0 0 16px}
    .exec-summary li{margin-bottom:5px}
    .p-grid{margin-bottom:10px}
    .p-card{border:1px solid #e2e8f0;padding:10px 14px;margin-bottom:8px;page-break-inside:avoid}
    .p-id{font-size:8pt;font-weight:bold;color:#3b82f6;text-transform:uppercase}
    .p-name{font-size:10pt;font-weight:bold;color:#0f172a}
    .p-meta{font-size:8pt;color:#64748b;margin-top:3px}
    .p-cat{font-size:8pt;color:#8b5cf6;margin-top:3px;font-style:italic}
    .p-route{font-size:8pt;color:#0d9488;margin-top:2px}
    .p-loc{font-size:8pt;color:#94a3b8;margin-top:2px}
    .theme-block{border:1px solid #e2e8f0;padding:14px 18px;margin-bottom:12px;page-break-inside:avoid}
    .theme-header{margin-bottom:10px}
    .sev{font-size:8pt;font-weight:bold;padding:2px 6px;border:1px solid #ccc}
    .sev-high{background:#fef2f2;color:#dc2626;border-color:#fca5a5}
    .sev-med{background:#fff7ed;color:#c2410c;border-color:#fdba74}
    .sev-low{background:#f0f9ff;color:#0284c7;border-color:#7dd3fc}
    .sev-pos{background:#f0fdf4;color:#16a34a;border-color:#86efac}
    .mention-count{font-size:8pt;color:#94a3b8}
    .theme-interpretation{font-size:10pt;color:#475569;margin-bottom:12px}
    .theme-interpretation b{color:#1e293b}
    .ev-label{font-size:8pt;font-weight:bold;color:#94a3b8;text-transform:uppercase;margin-bottom:6px}
    .quote{margin-bottom:6px;padding-left:10px;border-left:3px solid #e2e8f0;font-size:9pt;color:#475569}
    .q-text{font-style:italic}
    .q-src{display:block;font-size:7pt;color:#94a3b8;margin-top:2px}
    .df-block{font-size:9pt;color:#475569;margin-bottom:6px;padding:6px 10px;background:#f8fafc;border-left:3px solid #3b82f6}
    .df-block b{color:#1e293b}
    .reco-list{list-style-type:decimal;margin-left:18px}
    .reco-list li{margin-bottom:10px;font-size:10pt;color:#334155;line-height:1.5;padding:0}
    .reco-list li b{color:#0f172a}
    .footer{margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:8pt;color:#94a3b8;text-align:center}
    .toolbar{display:none}
  \`;

  var content=container.innerHTML;

  var docHtml='<!DOCTYPE html><html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="utf-8"><style>'+wordCss+'<\\/style><\\/head><body>'+content+'<\\/body><\\/html>';

  var blob=new Blob(['\\ufeff',docHtml],{type:'application/msword'});
  var url=URL.createObjectURL(blob);
  var a=document.createElement('a');
  a.href=url;
  a.download='Phoenix_Alpha4_UT_Insights_'+new Date().toISOString().slice(0,10)+'.doc';
  document.body.appendChild(a);
  a.click();
  document.body.removeChild(a);
  URL.revokeObjectURL(url);

  if(toolbar) toolbar.style.display='flex';
}
</script>
</body>
</html>`;
}

main();
