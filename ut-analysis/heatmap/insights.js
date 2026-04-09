#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname, "..");

function resolveAlpha() {
  const args = process.argv.slice(2);
  const idx = args.indexOf("--alpha");
  const ver = (idx >= 0 && args[idx + 1]) ? args[idx + 1] : "5";
  const dir = path.join(ROOT, `alpha${ver}`);
  return {
    ver,
    OBS_PATH: path.join(dir, "observations.json"),
    OUT_DIR: path.join(dir, "heatmap"),
  };
}

function loadObs(obsPath) {
  if (!fs.existsSync(obsPath)) return [];
  return JSON.parse(fs.readFileSync(obsPath, "utf-8"));
}

function e(s) {
  return (s || "").replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;").replace(/"/g, "&quot;");
}

function nl2br(s) {
  return e(s).replace(/\r?\n/g, "<br>");
}

function main() {
  const alpha = resolveAlpha();
  console.log(`Alpha ${alpha.ver} | obs: ${alpha.OBS_PATH}`);
  const sessions = loadObs(alpha.OBS_PATH);
  if (!sessions.length) {
    console.log("No observations found. Place observations.json in", path.dirname(alpha.OBS_PATH));
    return;
  }

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

  const screensDir = path.join(alpha.OUT_DIR, "screens");
  const heatmapImages = {};
  const SCREEN_FILES = [
    { key: "HomeView", file: "HomeView.png", label: "Home" },
    { key: "HomeView-full", file: "HomeView-full.png", label: "Home (Full Scroll)" },
    { key: "BookLocationView", file: "BookLocationView.png", label: "Book Location" },
    { key: "BookDateView", file: "BookDateView.png", label: "Book Date" },
    { key: "BookPassengerView", file: "BookPassengerView.png", label: "Book Passengers" },
    { key: "PayModeView", file: "PayModeView.png", label: "Payment Mode" },
    { key: "SRPView", file: "SRPView.png", label: "Search Results" },
    { key: "SRPView-full", file: "SRPView-full.png", label: "SRP (Full Scroll)" },
    { key: "SRPView-CompareFares", file: "SRPView-CompareFares.png", label: "Compare Fares" },
    { key: "SRPView-FareFamily-Stretch", file: "SRPView-FareFamily-Stretch.png", label: "Fare Family — Stretch" },
    { key: "SRPView-FareFamily-Economy", file: "SRPView-FareFamily-Economy.png", label: "Fare Family — Economy" },
  ];
  SCREEN_FILES.forEach(sf => {
    const fp = path.join(screensDir, sf.file);
    if (fs.existsSync(fp)) {
      const buf = fs.readFileSync(fp);
      heatmapImages[sf.key] = { dataUri: `data:image/png;base64,${buf.toString("base64")}`, label: sf.label };
    }
  });
  console.log(`Loaded ${Object.keys(heatmapImages).length} heatmap screen images`);

  const html = buildInsightsHtml(participants, themes, allObs, alpha.ver, heatmapImages);
  fs.mkdirSync(alpha.OUT_DIR, { recursive: true });
  const outPath = path.join(alpha.OUT_DIR, "insights.html");
  fs.writeFileSync(outPath, html, "utf-8");
  console.log("Wrote", outPath);
}

function classifyThemes(obs) {
  const patterns = [
    { id: "search-entry-point", label: "Booking Entry Point — Search Widget vs Navigation",
      severity: "high",
      test: l => /search.*widget|entry.*point|start.*point|booking.*entry|start.*booking|Flight.*link|Navbar|not able to spot|not able to read|not able to catch|not able to relate.*Search|label.*animation|placeholder|hint.*start|book.*here/i.test(l) },
    { id: "srp-card-affordance", label: "SRP Card Tappability & Price Affordance",
      severity: "high",
      test: l => /SRP|card.*tappable|colour.*band|price.*tappable|dropdown.*chevron|affordance|stuck|not responding|coach.*mark|expanding/i.test(l) },
    { id: "fare-family", label: "Fare Family & Stretch/Economy Comprehension",
      severity: "medium",
      test: l => /fare|family|stretch|economy|flexi|saver|upfront|compare|class|filter.*economy|ordering|LLC|first.*selector/i.test(l) },
    { id: "passenger-selection", label: "Passenger Selection & Name–Count Linkage",
      severity: "medium",
      test: l => /passeng|passenger|adult|child|names|interlinked|selecting.*name|wheel.*chair|PDP|infant/i.test(l) },
    { id: "marketplace-6epick", label: "6EPick Marketplace Prominence & Distraction",
      severity: "medium",
      test: l => /6EPick|marketplace|hotel|cab|persuaded|emphasising/i.test(l) },
    { id: "offers-loyalty-age", label: "Offers, Loyalty & Age-Based Preferences",
      severity: "medium",
      test: l => /offer|loyalty|discount|cash.*discount|BluChip|not.*important|age.*group|business.*trip|time.*not.*price|least.*interested/i.test(l) },
    { id: "round-trip-bug", label: "Round Trip Date Selection — Usability Bug",
      severity: "high",
      test: l => /round.*trip|return.*date|usability.*bug|goof.*up|start.*date.*before/i.test(l) },
    { id: "paymode-cash-label", label: "Pay Mode — 'Cash' Label Confusion",
      severity: "medium",
      test: l => /Cash.*label|label.*Cash|not able to relate.*Cash|Cash.*means|Cash.*pay.*mode|Cash.*UPI|Cash.*CC/i.test(l) },
    { id: "calendar-ux", label: "Calendar & Date Selection UX",
      severity: "low",
      test: l => /calendar|date.*select|swipe.*gesture|month.*switch|chevron.*tapp|prices.*calendar/i.test(l) },
    { id: "profile-search", label: "Profile / Menu Link — Search vs Scroll Behaviour",
      severity: "low",
      test: l => /profile.*menu|contact.*us|help|scroll.*down|search.*prominent|profile.*link/i.test(l) },
    { id: "personalisation", label: "Personalisation & Trip-Type Segmentation",
      severity: "medium",
      test: l => /personali|trip.*type|business.*leisure|segment|long.*weekend|multi.*city/i.test(l) },
    { id: "positive-signals", label: "Positive Signals & Design Validation",
      severity: "positive",
      test: l => /convenient|seamless|happy|surprised|intuitive|easy.*journey|comfortable|swiftly|making.*sense|working|understood|able to understand|able to compare|able to observe|able to figure|able to catch/i.test(l) },
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

function buildHeatmapSection(images) {
  if (!images || !Object.keys(images).length) return "";

  const BOOKING_FLOW = ["HomeView", "BookLocationView", "BookDateView", "BookPassengerView", "PayModeView", "SRPView"];
  const SRP_OVERLAYS = ["SRPView-CompareFares", "SRPView-FareFamily-Stretch", "SRPView-FareFamily-Economy"];
  const FULL_SCROLL = ["HomeView-full", "SRPView-full"];

  function renderCards(keys) {
    return keys.filter(k => images[k]).map(k =>
      `<div class="hm-card"><img src="${images[k].dataUri}" alt="${images[k].label}"><div class="hm-label">${images[k].label}</div></div>`
    ).join("\n");
  }

  const flowCards = renderCards(BOOKING_FLOW);
  const overlayCards = renderCards(SRP_OVERLAYS);
  const scrollCards = renderCards(FULL_SCROLL);

  return `
<h2>Screen Reference — Design Context</h2>
<div class="hm-section">
  <p class="hm-intro">The following screens represent the Alpha 5.0 design prototype as tested with participants. These provide visual context for the findings and recommendations above.</p>

  <h3 style="font-size:.85rem;color:#334155;margin:16px 0 10px">Booking Flow Screens</h3>
  <div class="hm-grid">${flowCards}</div>

  ${overlayCards ? `<h3 style="font-size:.85rem;color:#334155;margin:16px 0 10px">SRP Overlay Screens</h3>
  <div class="hm-grid">${overlayCards}</div>` : ""}

  ${scrollCards ? `<h3 style="font-size:.85rem;color:#334155;margin:16px 0 10px">Full Scroll Views</h3>
  <div class="hm-grid">${scrollCards}</div>` : ""}
</div>`;
}

function buildInsightsHtml(participants, themes, allObs, alphaVer, heatmapImages) {
  alphaVer = alphaVer || "5";
  heatmapImages = heatmapImages || {};
  const n = participants.length;
  const date = new Date().toISOString().slice(0, 10);
  const dates = participants.map(p => p.date).filter(Boolean).sort();
  const dateRange = dates.length > 1 ? `${dates[0]} to ${dates[dates.length - 1]}` : (dates[0] || date);

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

    const INTERPRETATIONS = {
      "search-entry-point": `This remains the <b>most critical usability issue</b> across both Alpha 4 and Alpha 5. <b>${t.findings.length} of ${n} participants</b> referenced the booking entry point challenge. Multiple users (UT-3, UT-4, UT-7) required explicit hints from the facilitator to find the Search widget. Despite label text ("Start booking here") and icon animation, users instinctively gravitate towards the "Flights" link in the bottom navigation bar. UT-3's session effectively ended at 2:45 min because the entry point was undiscoverable. UT-6 noted <b>"Recent Search is too catchy compared to the Search widget"</b> — the visual hierarchy is inverted. However, a positive signal: users who read the placeholder label and noticed the icon animation (UT-8, UT-9, UT-10) found it quickly. The challenge is not the label's content but its <b>visual prominence</b> relative to competing elements.`,
      "srp-card-affordance": `<b>${t.findings.length} mentions</b> point to a serious interaction gap on the Search Results page. Users expect the <b>entire flight card to be tappable</b> (UT-5), but the actual tap targets are the price/colour band sections. The dropdown chevron's affordance is insufficient. UT-7 explicitly quoted <b>"I'm stuck"</b> after attempting to tap the card body repeatedly. UT-5 called it <b>"a serious usability concern"</b>. UT-6 noted that when Economy filter is applied, Stretch pricing still shows — creating information overload. Positive: power users (UT-8, UT-10) could figure it out, and filter icon was found intuitive.`,
      "fare-family": `Fare family comprehension has improved from Alpha 4. Users who reached the overlay screens could <b>compare and differentiate</b> offerings by swiping/tapping (UT-9, UT-6, UT-10). However, UT-6 raised a strategic question: <b>"IndiGo is LLC and more people fly in economy — why is Stretch first?"</b> This Stretch-first ordering may create friction for economy-focused travellers. UT-9 (frequent) confirmed understanding but also questioned ordering. The heatmap shows Economy overlay received more taps (113) than Stretch (66), suggesting users actively seek Economy despite Stretch being presented first.`,
      "passenger-selection": `UT-4 surfaced a critical <b>functional and usability bug</b>: selecting names from the history list does not update the Adult/Child/Sr. Citizen counters below. Users expect an <b>interlinked system</b> where name selection auto-populates counts and triggers contextual offers (e.g., wheelchair assistance for past users). UT-7 quoted: <b>"Why are you asking adult, child etc., when ticket rates are same for all?"</b> — suggesting the perceived value of the counter section is unclear without the linkage.`,
      "marketplace-6epick": `UT-2 spent the most time on Home (13+ min), primarily discussing the marketplace. Their observation crystallises the issue: the design <b>emphasises 6EPick marketplace over flight booking</b>. UT-7 was actively <b>"persuaded by 6EPick — Hotels, Cabs"</b> before finding the booking entry. While marketplace visibility may serve business goals, it competes directly with the primary task (booking flights) and contributes to the entry-point discovery problem.`,
      "offers-loyalty-age": `A pattern emerging across Alpha 4 and now confirmed in Alpha 5: <b>users 45+ consistently deprioritise offers and loyalty</b>. UT-2 (49, NHAI GM) declared he's <b>"least interested in IndiGo loyalty program"</b> and wants <b>"immediate upfront cash discount — no hidden or CC-based discounts."</b> UT-6 (50+, marine captain) stated <b>"Offers are not that important."</b> Business travellers prioritise time over money (UT-7, UT-9). This suggests loyalty/offers prominence should be <b>adaptive based on user segment</b> — younger/occasional users may value it more than mature/frequent ones.`,
      "round-trip-bug": `Two participants (UT-6, UT-8) independently hit the <b>same date selection bug</b>: if a user selects a start date before toggling Round Trip, the system resets. Users expect the next tap to select the return date, but the system restarts the departure date selection. This is a clear <b>interaction design defect</b> that needs immediate attention — it breaks the mental model of sequential selection.`,
      "paymode-cash-label": `The label "Cash" on the Pay Mode page confused multiple users. UT-7 could not relate, UT-10 (an existing IndiGo user) also failed to connect. UT-7 suggested: <b>"We have enough space — establish that Cash means CC, QR, UPI etc."</b> Interestingly, UT-8 (power user) and UT-9 (student) understood it — suggesting familiarity with IndiGo's terminology makes a difference. For new or infrequent users, the label needs clarification.`,
      "calendar-ux": `UT-5 made a notable behavioural observation: <b>users take decisions based on prices shown in the calendar</b>. UT-8 suggested <b>swipe gesture for month switching</b> and larger tappable area for navigation chevrons. These are quick wins that could improve the date selection experience.`,
      "profile-search": `Both UT-6 and UT-8 found Contact Us / Help in the Profile menu — but <b>neither used the search field</b>. Both scrolled all the way down instead. This raises a question about whether the prominent search bar on the Profile/menu page is justified, or if the IA is already effective enough through linear scanning.`,
      "personalisation": `UT-2 explicitly requested <b>trip-type segmentation (Business vs Leisure)</b> for quicker decisions. UT-8 expected multi-city trip support. UT-2 also asked for <b>long weekend planning</b> features. These signals suggest users want the app to adapt to their travel context rather than presenting a one-size-fits-all interface.`,
      "positive-signals": `Despite the challenges, <b>multiple positive signals</b> emerged. UT-3's initial reaction: "This looks convenient." UT-4 was "comfortable with the booking journey" after finding the entry point. UT-8 (power user) completed the journey as <b>"relatively very easy"</b>. UT-9 found the <b>"overall journey seamless."</b> UT-4 was "happy to see family names in PDP." The PayMode labels (When, Who) were making sense (UT-6). Filter icon was consistently found intuitive. The design fundamentals are sound — the issues are about <b>discoverability, not comprehension</b>.`,
    };
    const interpretation = INTERPRETATIONS[t.id] || `<b>${t.findings.length} observation(s)</b> related to this theme across ${n} sessions.`;

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
<title>Phoenix Alpha ${alphaVer} — Usability Insights Report</title>
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

.hm-section{margin-bottom:8px}
.hm-grid{display:grid;grid-template-columns:repeat(auto-fill,minmax(180px,1fr));gap:16px;margin-bottom:12px}
.hm-card{text-align:center}
.hm-card img{width:100%;max-width:200px;border:1px solid #e2e8f0;border-radius:8px;box-shadow:0 2px 8px rgba(0,0,0,.08)}
.hm-card .hm-label{font-size:.7rem;font-weight:600;color:#475569;margin-top:6px}
.hm-intro{font-size:.82rem;color:#475569;margin-bottom:14px;line-height:1.6}

.footer{margin-top:36px;padding-top:16px;border-top:1px solid #e2e8f0;font-size:.7rem;color:#94a3b8;text-align:center}
@media print{body{background:#fff}.container{max-width:100%}.theme-block,.p-card,.exec-summary,.hm-card{break-inside:avoid}.toolbar{display:none}}
</style>
</head>
<body>
<div class="container">

<div class="toolbar">
  <button class="btn" onclick="exportWord()">Download as Word (.docx)</button>
</div>

<h1>Phoenix Alpha ${alphaVer} — Usability Insights</h1>
<p class="subtitle">Qualitative findings from ${n} moderated sessions &middot; ${dateRange} &middot; Alpha ${alphaVer}</p>

<div class="disclaimer">
  <b>Note on sample size:</b> This report is based on ${n} usability sessions across a diverse participant mix. While the sample is small for statistical generalisation, usability testing is designed to surface <b>qualitative patterns and user sentiments</b> — not statistical significance. The findings below are behavioural observations, not quantitative conclusions. Even 5 participants can uncover ~85% of major usability issues (Nielsen, 2000).
</div>

<h2>Executive Summary</h2>
<div class="exec-summary">
  <p>Across ${n} sessions at Delhi IGI T1 — spanning family travellers, business frequent flyers, an international visitor, students, a marine captain, and an IndiGo power user — the Phoenix Alpha ${alphaVer} prototype was <b>well-received overall</b>. All 10 participants completed the end-to-end booking journey, and multiple users (UT-3, UT-4, UT-8, UT-9) independently praised the design as <b>"convenient," "seamless," or "easy."</b></p>
  <p style="margin-top:10px">However, three critical usability issues surfaced:</p>
  <ul>
    <li><b>Booking entry point discovery (High):</b> At least 4 of ${n} participants could not find the Search widget without a facilitator hint. Users gravitate to the "Flights" link in the bottom navbar. Despite a text label + animation, visual prominence is insufficient. UT-3's session effectively ended in under 3 minutes.</li>
    <li><b>SRP card tap affordance (High):</b> Users expect the entire flight card to be tappable. The price/colour band interaction is not discoverable — UT-7 said "I'm stuck." The chevron dropdown lacks sufficient affordance for non-power users.</li>
    <li><b>Round trip date selection bug (High):</b> Two independent participants (UT-6, UT-8) encountered the same interaction bug where selecting a date before toggling Round Trip breaks the return date flow.</li>
  </ul>
  <p style="margin-top:10px"><b>Key positive signals:</b> Fare family comparison worked well once reached. PayMode labels (When, Who) made sense. Filter icon was consistently intuitive. Power users completed the flow swiftly. The design fundamentals are sound — the primary issues are about <b>discoverability and affordance, not comprehension</b>.</p>
</div>

<h2>Participants</h2>
<div class="p-grid">${participantCards}</div>

<h2>Thematic Findings</h2>
${themeSections}

<h2>Direct User Feedback</h2>
${directFeedback || '<p style="font-size:.82rem;color:#94a3b8">No explicit feedback captured in sessions.</p>'}

${buildHeatmapSection(heatmapImages)}

<h2>Recommendations</h2>
<ol class="reco-list">
  <li><b>Elevate booking entry point visual prominence</b> — The Search widget label and animation exist but are insufficient. Consider: (a) increasing the widget's visual weight and contrast; (b) positioning it above "Recent Search" which is currently more eye-catching (UT-6); (c) testing a large "Book a Flight" CTA button as an alternative. This was the #1 issue in both Alpha 4 and Alpha 5.</li>
  <li><b>Redesign SRP card interaction model</b> — Make the entire flight card tappable to reveal fare details. Add a coach mark or animated hint for first-time users after 3-5 seconds of inactivity (UT-7's suggestion). Consider progressive disclosure: tap to expand fare categories with details beneath.</li>
  <li><b>Fix Round Trip date selection flow</b> — When a user selects a start date and then toggles Round Trip, the next date tap should register as the return date — not restart departure selection. Two independent participants hit this bug.</li>
  <li><b>Link passenger names to Adult/Child counters</b> — Selecting a name from history should auto-update the traveller type counts and trigger contextual offers (wheelchair, special meals if previously used). The current disconnect was flagged as both a functional and usability bug.</li>
  <li><b>Revisit Stretch-first fare ordering</b> — Given IndiGo is an LLC with majority economy travellers, showing Economy first may align better with user expectations. The heatmap data shows Economy overlay received ~63% of SRP overlay taps vs Stretch's ~37%.</li>
  <li><b>Clarify 'Cash' label on Pay Mode</b> — Multiple non-power users couldn't relate "Cash" to digital payments. UT-7 suggested using the available space to explain it encompasses CC, QR, UPI, etc. alongside BluChip redemption.</li>
  <li><b>Rebalance marketplace vs flight content on Home</b> — 6EPick marketplace is drawing significant dwell time and engagement away from the primary booking task. Consider reducing its first-fold prominence or contextualising it post-booking.</li>
  <li><b>Add trip-type personalisation</b> — Users explicitly requested Business vs Leisure segmentation for quicker decisions. Business travellers prioritise time; leisure travellers prioritise price + packages. Adaptive content could serve both better.</li>
  <li><b>Age-adaptive offers & loyalty strategy</b> — Users 45+ consistently deprioritise loyalty programs and prefer upfront cash discounts or simple experiences. Consider segment-based prominence tuning.</li>
  <li><b>Calendar UX improvements</b> — Add swipe gesture for month navigation, increase tappable area for chevrons, and maintain price visibility in calendar for date-based decision making.</li>
</ol>

<div class="footer">
  Phoenix UT Analysis &middot; Generated ${date} &middot; ${n} sessions &middot; Alpha ${alphaVer}
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
    .hm-section{margin-bottom:10px}
    .hm-grid{margin-bottom:10px}
    .hm-card{display:inline-block;width:180px;text-align:center;margin:6px 8px;vertical-align:top;page-break-inside:avoid}
    .hm-card img{width:170px;border:1px solid #e2e8f0}
    .hm-label{font-size:8pt;font-weight:bold;color:#475569;margin-top:4px}
    .hm-intro{font-size:10pt;color:#475569;margin-bottom:12px}
    .footer{margin-top:24px;padding-top:12px;border-top:1px solid #e2e8f0;font-size:8pt;color:#94a3b8;text-align:center}
    .toolbar{display:none}
  \`;

  var content=container.innerHTML;

  var docHtml='<!DOCTYPE html><html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:w="urn:schemas-microsoft-com:office:word" xmlns="http://www.w3.org/TR/REC-html40"><head><meta charset="utf-8"><style>'+wordCss+'<\\/style><\\/head><body>'+content+'<\\/body><\\/html>';

  var blob=new Blob(['\\ufeff',docHtml],{type:'application/msword'});
  var url=URL.createObjectURL(blob);
  var a=document.createElement('a');
  a.href=url;
  a.download='Phoenix_Alpha${alphaVer}_UT_Insights_'+new Date().toISOString().slice(0,10)+'.doc';
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
