const express = require("express");
const cors = require("cors");
const fs = require("fs");
const path = require("path");

const app = express();
const PORT = process.env.PORT || 3100;
const SESSIONS_DIR = path.join(__dirname, "sessions");

fs.mkdirSync(SESSIONS_DIR, { recursive: true });

app.use(cors());
app.use(express.json({ limit: "10mb" }));

// ── Create session ────────────────────────────────────────────────────────────

app.post("/sessions", (req, res) => {
  const payload = req.body;
  if (!payload || !payload.sessionId) {
    return res.status(400).json({ error: "sessionId is required" });
  }
  const filePath = sessionFile(payload.sessionId);
  fs.writeFileSync(filePath, JSON.stringify(payload, null, 2));
  console.log(`[+] Session created: ${payload.sessionTitle || payload.sessionId}`);
  res.status(201).json({ sessionId: payload.sessionId });
});

// ── Complete / update session (full payload) ──────────────────────────────────

app.post("/sessions/:id/complete", (req, res) => {
  const payload = req.body;
  if (!payload) return res.status(400).json({ error: "Body required" });

  const filePath = sessionFile(req.params.id);
  fs.writeFileSync(filePath, JSON.stringify(payload, null, 2));
  console.log(`[✓] Session completed: ${payload.sessionTitle || req.params.id}`);
  res.json({ ok: true });
});

// ── Append events (incremental) ──────────────────────────────────────────────

app.post("/sessions/:id/events", (req, res) => {
  const filePath = sessionFile(req.params.id);
  if (!fs.existsSync(filePath)) {
    return res.status(404).json({ error: "Session not found" });
  }
  const session = JSON.parse(fs.readFileSync(filePath, "utf-8"));
  const events = req.body.events || [];

  for (const evt of events) {
    switch (evt.type) {
      case "step":
        session.steps = session.steps || [];
        session.steps.push(evt.data);
        break;
      case "tap":
        session.taps = session.taps || [];
        session.taps.push(evt.data);
        break;
      case "journey_complete":
        session.journeyCompleted = true;
        session.completedAt = evt.data?.timestamp;
        break;
      case "rating":
        Object.assign(session, evt.data);
        break;
    }
  }

  fs.writeFileSync(filePath, JSON.stringify(session, null, 2));
  res.json({ ok: true, eventsProcessed: events.length });
});

// ── List sessions ─────────────────────────────────────────────────────────────

app.get("/sessions", (_req, res) => {
  const files = fs.readdirSync(SESSIONS_DIR).filter((f) => f.endsWith(".json"));
  const sessions = files.map((f) => {
    const data = JSON.parse(fs.readFileSync(path.join(SESSIONS_DIR, f), "utf-8"));
    return {
      sessionId: data.sessionId,
      sessionTitle: data.sessionTitle,
      createdAt: data.createdAt,
      endedAt: data.endedAt,
      journeyCompleted: data.journeyCompleted || false,
    };
  });
  sessions.sort((a, b) => (b.createdAt || "").localeCompare(a.createdAt || ""));
  res.json(sessions);
});

// ── Get single session ────────────────────────────────────────────────────────

app.get("/sessions/:id", (req, res) => {
  const filePath = sessionFile(req.params.id);
  if (!fs.existsSync(filePath)) {
    return res.status(404).json({ error: "Session not found" });
  }
  res.json(JSON.parse(fs.readFileSync(filePath, "utf-8")));
});

// ── Export session as CSV ─────────────────────────────────────────────────────

app.get("/sessions/:id/csv", (req, res) => {
  const filePath = sessionFile(req.params.id);
  if (!fs.existsSync(filePath)) {
    return res.status(404).json({ error: "Session not found" });
  }
  const session = JSON.parse(fs.readFileSync(filePath, "utf-8"));
  const csv = sessionToCSV(session);

  res.setHeader("Content-Type", "text/csv");
  res.setHeader(
    "Content-Disposition",
    `attachment; filename="${session.sessionTitle || session.sessionId}.csv"`
  );
  res.send(csv);
});

// ── Export ALL sessions as CSV ────────────────────────────────────────────────

const TRACKED_SCREENS = [
  "HomeView",
  "BookLocationView",
  "BookDateView",
  "BookPassengerView",
  "PayModeView",
  "SRPView",
];

app.get("/export/csv", (_req, res) => {
  const files = fs.readdirSync(SESSIONS_DIR).filter((f) => f.endsWith(".json"));
  if (files.length === 0) {
    return res.status(404).json({ error: "No sessions found" });
  }

  const scrollDepthCols = TRACKED_SCREENS.map((s) => `scrollDepth_${s}`);
  const stepTimeCols = TRACKED_SCREENS.map((s) => `stepTimeSec_${s}`);
  const tapCountCols = TRACKED_SCREENS.map((s) => `tapCount_${s}`);

  const header = [
    "sessionId",
    "sessionTitle",
    "role",
    "experience",
    "ageBand",
    "device",
    "deviceModel",
    "screenSize",
    "osVersion",
    "appVersion",
    "audioConsent",
    "audioFileName",
    "createdAt",
    "endedAt",
    "journeyCompleted",
    "completedAt",
    "rating",
    "frustration",
    "feedback",
    "totalSteps",
    "totalTaps",
    "totalDurationSec",
    "avgTimePerStepSec",
    "longestStep",
    "longestStepDurationSec",
    "timeToFirstTapSec",
    ...scrollDepthCols,
    ...stepTimeCols,
    ...tapCountCols,
    "postTaskAnswers",
  ].join(",");

  const rows = files.map((f) => {
    const s = JSON.parse(fs.readFileSync(path.join(SESSIONS_DIR, f), "utf-8"));
    return sessionToRow(s);
  });

  res.setHeader("Content-Type", "text/csv");
  res.setHeader("Content-Disposition", 'attachment; filename="ut_sessions_all.csv"');
  res.send([header, ...rows].join("\n"));
});

function sessionToRow(s) {
  const d = s.demographics || {};
  const dm = s.deviceMetadata || {};
  const dur = durationSeconds(s.createdAt, s.endedAt);
  const ptAnswers = (s.postTaskAnswers || [])
    .map((a) => `${a.question}: ${a.answer}`)
    .join(" | ");

  const stepDurations = computeStepDurations(s.steps || []);
  const allDurations = Object.values(stepDurations);
  const avgTime =
    allDurations.length > 0
      ? (allDurations.reduce((a, b) => a + b, 0) / allDurations.length).toFixed(1)
      : "";

  let longestStep = "";
  let longestStepDur = "";
  if (allDurations.length > 0) {
    const maxDur = Math.max(...allDurations);
    longestStep = Object.keys(stepDurations).find(
      (k) => stepDurations[k] === maxDur
    );
    longestStepDur = maxDur.toFixed(1);
  }

  const timeToFirstTap = computeTimeToFirstTap(s);

  const scrollMap = {};
  for (const sd of s.scrollDepths || []) {
    scrollMap[sd.screenId] = Math.max(scrollMap[sd.screenId] || 0, sd.maxDepth);
  }

  const tapCountMap = {};
  for (const tap of s.taps || []) {
    tapCountMap[tap.screenId] = (tapCountMap[tap.screenId] || 0) + 1;
  }

  const scrollDepthVals = TRACKED_SCREENS.map((scr) =>
    scrollMap[scr] != null ? scrollMap[scr].toFixed(2) : ""
  );
  const stepTimeVals = TRACKED_SCREENS.map((scr) =>
    stepDurations[scr] != null ? stepDurations[scr].toFixed(1) : ""
  );
  const tapCountVals = TRACKED_SCREENS.map((scr) =>
    tapCountMap[scr] != null ? tapCountMap[scr] : ""
  );

  return [
    csvEscape(s.sessionId),
    csvEscape(s.sessionTitle),
    csvEscape(d.role),
    csvEscape(d.experience),
    csvEscape(d.ageBand),
    csvEscape(d.device),
    csvEscape(dm.deviceModel),
    csvEscape(dm.screenSize),
    csvEscape(dm.osVersion),
    csvEscape(dm.appVersion),
    s.audioConsent != null ? s.audioConsent : "",
    csvEscape(s.audioFileName),
    csvEscape(s.createdAt),
    csvEscape(s.endedAt),
    s.journeyCompleted || false,
    csvEscape(s.completedAt),
    s.rating ?? "",
    s.frustration ?? "",
    csvEscape(s.feedback),
    (s.steps || []).length,
    (s.taps || []).length,
    dur ?? "",
    avgTime,
    csvEscape(longestStep),
    longestStepDur,
    timeToFirstTap ?? "",
    ...scrollDepthVals,
    ...stepTimeVals,
    ...tapCountVals,
    csvEscape(ptAnswers),
  ].join(",");
}

function computeStepDurations(steps) {
  const durations = {};
  for (const step of steps) {
    const d = durationSeconds(step.enteredAt, step.leftAt);
    if (d != null) {
      const val = parseFloat(d);
      durations[step.screenId] = (durations[step.screenId] || 0) + val;
    }
  }
  return durations;
}

function computeTimeToFirstTap(session) {
  const taps = session.taps || [];
  if (taps.length === 0 || !session.createdAt) return null;
  const sessionStart = new Date(session.createdAt);
  const firstTap = new Date(taps[0].timestamp);
  return ((firstTap - sessionStart) / 1000).toFixed(1);
}

// ── Helpers ───────────────────────────────────────────────────────────────────

function sessionFile(id) {
  return path.join(SESSIONS_DIR, `${id}.json`);
}

function csvEscape(val) {
  if (val == null) return "";
  const str = String(val);
  if (str.includes(",") || str.includes('"') || str.includes("\n")) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

function durationSeconds(start, end) {
  if (!start || !end) return null;
  return ((new Date(end) - new Date(start)) / 1000).toFixed(1);
}

function sessionToCSV(session) {
  const lines = [];
  const dm = session.deviceMetadata || {};

  lines.push("# Session Summary");
  lines.push(`sessionId,${csvEscape(session.sessionId)}`);
  lines.push(`sessionTitle,${csvEscape(session.sessionTitle)}`);
  lines.push(`createdAt,${csvEscape(session.createdAt)}`);
  lines.push(`endedAt,${csvEscape(session.endedAt)}`);
  lines.push(`journeyCompleted,${session.journeyCompleted || false}`);
  lines.push(`rating,${session.rating ?? ""}`);
  lines.push(`frustration,${session.frustration ?? ""}`);
  lines.push(`feedback,${csvEscape(session.feedback)}`);

  const d = session.demographics || {};
  lines.push(`role,${csvEscape(d.role)}`);
  lines.push(`experience,${csvEscape(d.experience)}`);
  lines.push(`ageBand,${csvEscape(d.ageBand)}`);
  lines.push(`device,${csvEscape(d.device)}`);

  lines.push("");
  lines.push("# Device Metadata");
  lines.push(`deviceModel,${csvEscape(dm.deviceModel)}`);
  lines.push(`screenSize,${csvEscape(dm.screenSize)}`);
  lines.push(`osVersion,${csvEscape(dm.osVersion)}`);
  lines.push(`appVersion,${csvEscape(dm.appVersion)}`);

  lines.push("");
  lines.push("# Audio Recording");
  lines.push(`audioConsent,${session.audioConsent != null ? session.audioConsent : ""}`);
  lines.push(`audioFileName,${csvEscape(session.audioFileName)}`);

  lines.push("");
  lines.push("# Steps");
  lines.push("screenId,enteredAt,leftAt,durationSec");
  for (const step of session.steps || []) {
    const dur = durationSeconds(step.enteredAt, step.leftAt);
    lines.push(
      `${csvEscape(step.screenId)},${csvEscape(step.enteredAt)},${csvEscape(step.leftAt)},${dur ?? ""}`
    );
  }

  lines.push("");
  lines.push("# Scroll Depth (max per screen, 0.0 = top, 1.0 = bottom)");
  lines.push("screenId,maxDepth");
  for (const sd of session.scrollDepths || []) {
    lines.push(`${csvEscape(sd.screenId)},${sd.maxDepth.toFixed(2)}`);
  }

  lines.push("");
  lines.push("# Taps");
  lines.push("screenId,x,y,timestamp");
  for (const tap of session.taps || []) {
    lines.push(
      `${csvEscape(tap.screenId)},${tap.x},${tap.y},${csvEscape(tap.timestamp)}`
    );
  }

  if (session.postTaskAnswers?.length) {
    lines.push("");
    lines.push("# Post-task Answers");
    lines.push("question,answer");
    for (const a of session.postTaskAnswers) {
      lines.push(`${csvEscape(a.question)},${csvEscape(a.answer)}`);
    }
  }

  const stepDurations = computeStepDurations(session.steps || []);
  const allDurations = Object.values(stepDurations);
  if (allDurations.length > 0) {
    lines.push("");
    lines.push("# Comparative Metrics");
    const avgTime = (
      allDurations.reduce((a, b) => a + b, 0) / allDurations.length
    ).toFixed(1);
    lines.push(`avgTimePerStepSec,${avgTime}`);
    const maxDur = Math.max(...allDurations);
    const longestStep = Object.keys(stepDurations).find(
      (k) => stepDurations[k] === maxDur
    );
    lines.push(`longestStep,${csvEscape(longestStep)}`);
    lines.push(`longestStepDurationSec,${maxDur.toFixed(1)}`);
    const ttft = computeTimeToFirstTap(session);
    if (ttft != null) {
      lines.push(`timeToFirstTapSec,${ttft}`);
    }
  }

  return lines.join("\n");
}

// ── Start ─────────────────────────────────────────────────────────────────────

app.listen(PORT, () => {
  console.log(`UT Backend running on http://localhost:${PORT}`);
  console.log(`Sessions stored in ${SESSIONS_DIR}`);
});
