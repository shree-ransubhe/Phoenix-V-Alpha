#!/usr/bin/env node
"use strict";

const fs = require("fs");
const path = require("path");

const ROOT = path.join(__dirname);

function resolveAlpha(args) {
  const idx = args.indexOf("--alpha");
  const ver = (idx >= 0 && args[idx + 1]) ? args[idx + 1] : "5";
  const dir = path.join(ROOT, `alpha${ver}`);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
    fs.mkdirSync(path.join(dir, "raw"), { recursive: true });
    fs.mkdirSync(path.join(dir, "transcripts"), { recursive: true });
  }
  return {
    ver,
    RAW_DIR: path.join(dir, "raw"),
    TRANSCRIPTS_DIR: path.join(dir, "transcripts"),
    MASTER_CSV: path.join(dir, "master.csv"),
  };
}

const LEGACY_RAW_DIR = path.join(ROOT, "raw");
const LEGACY_MASTER_CSV = path.join(ROOT, "master.csv");

let MASTER_CSV_RESOLVED = LEGACY_MASTER_CSV;
let TRANSCRIPTS_DIR_RESOLVED = path.join(ROOT, "transcripts");

const MASTER_HEADERS = [
  "sessionId",
  "ut_number",
  "sessionTitle",
  "name",
  "recording_yn",
  "location",
  "travel_context",
  "quick_observations",
  "transcript",
  "created_at",
  "role",
  "experience",
  "age_band",
  "device",
  "journey_completed",
  "rating",
  "frustration",
  "feedback",
];

function csvEscape(val) {
  if (val == null || val === undefined) return "";
  const str = String(val).replace(/\r?\n/g, " ").trim();
  if (str.includes(",") || str.includes('"') || str.includes("\n")) {
    return `"${str.replace(/"/g, '""')}"`;
  }
  return str;
}

function parseCSVLine(line) {
  const out = [];
  let cur = "";
  let inQuotes = false;
  for (let i = 0; i < line.length; i++) {
    const c = line[i];
    if (c === '"') {
      if (inQuotes && line[i + 1] === '"') {
        cur += '"';
        i++;
      } else {
        inQuotes = !inQuotes;
      }
    } else if (inQuotes) {
      cur += c;
    } else if (c === ",") {
      out.push(cur);
      cur = "";
    } else {
      cur += c;
    }
  }
  out.push(cur);
  return out;
}

function readMaster() {
  if (!fs.existsSync(MASTER_CSV_RESOLVED)) {
    return { headers: MASTER_HEADERS, rows: [], bySessionId: new Map() };
  }
  const raw = fs.readFileSync(MASTER_CSV_RESOLVED, "utf-8");
  const lines = raw.split(/\r?\n/).filter((l) => l.length > 0);
  if (lines.length === 0) {
    return { headers: MASTER_HEADERS, rows: [], bySessionId: new Map() };
  }
  const headers = parseCSVLine(lines[0]);
  const rows = [];
  const bySessionId = new Map();
  for (let i = 1; i < lines.length; i++) {
    const cells = parseCSVLine(lines[i]);
    const row = {};
    headers.forEach((h, j) => {
      row[h] = cells[j] !== undefined ? cells[j] : "";
    });
    rows.push(row);
    if (row.sessionId) bySessionId.set(row.sessionId, row);
  }
  return { headers, rows, bySessionId };
}

function sessionToRow(session, utNumber) {
  const d = session.demographics || {};
  const recording =
    session.audioConsent && session.audioFileName ? "Y" : "N";
  const transcript = (session.transcript || "").trim();
  return {
    sessionId: session.sessionId || "",
    ut_number: `UT-${utNumber}`,
    sessionTitle: session.sessionTitle || "",
    name: "",
    recording_yn: recording,
    location: "",
    travel_context: "",
    quick_observations: transcript ? transcript.slice(0, 2000) : "",
    transcript: transcript,
    created_at: session.createdAt || "",
    role: d.role || "",
    experience: d.experience || "",
    age_band: d.ageBand || "",
    device: d.device || "",
    journey_completed: session.journeyCompleted ? "Y" : "N",
    rating: session.rating != null ? String(session.rating) : "",
    frustration: session.frustration != null ? String(session.frustration) : "",
    feedback: (session.feedback || "").trim(),
  };
}

function rowToCSVLine(row, headers) {
  return headers.map((h) => csvEscape(row[h] ?? "")).join(",");
}

function writeMaster(state) {
  const lines = [state.headers.join(",")];
  for (const row of state.rows) {
    const out = {};
    state.headers.forEach((h) => (out[h] = row[h]));
    lines.push(rowToCSVLine(out, state.headers));
  }
  fs.writeFileSync(MASTER_CSV_RESOLVED, lines.join("\n") + "\n", "utf-8");
}

function ingestFromRaw(rawDir) {
  if (!fs.existsSync(rawDir)) {
    console.error("Raw dir not found:", rawDir);
    process.exit(1);
  }
  const files = fs.readdirSync(rawDir).filter((f) => f.endsWith(".json"));
  if (files.length === 0) {
    console.log("No JSON files in", rawDir);
    return;
  }

  const state = readMaster();
  let nextUt = state.rows.length + 1;
  let added = 0;

  for (const f of files.sort()) {
    const fp = path.join(rawDir, f);
    let session;
    try {
      session = JSON.parse(fs.readFileSync(fp, "utf-8"));
    } catch (e) {
      console.warn("Skip (invalid JSON):", f);
      continue;
    }
    const sid = session.sessionId;
    if (!sid) {
      console.warn("Skip (no sessionId):", f);
      continue;
    }
    if (state.bySessionId.has(sid)) {
      continue;
    }
    const row = sessionToRow(session, nextUt);
    state.rows.push(row);
    state.bySessionId.set(sid, row);
    nextUt++;
    added++;
    console.log("+", row.sessionTitle || sid);
  }

  if (added > 0) {
    writeMaster(state);
    console.log("Appended", added, "session(s) to master.csv");
  } else {
    console.log("No new sessions to add.");
  }
}

function updateFromTranscripts() {
  if (!fs.existsSync(TRANSCRIPTS_DIR_RESOLVED)) {
    console.log("No transcripts dir:", TRANSCRIPTS_DIR_RESOLVED);
    return;
  }
  const state = readMaster();
  const byTitle = new Map();
  state.rows.forEach((r) => {
    const t = (r.sessionTitle || "").trim();
    if (t) byTitle.set(t, r);
  });

  const files = fs.readdirSync(TRANSCRIPTS_DIR_RESOLVED).filter(
    (f) => f.endsWith(".txt") || f.endsWith(".md")
  );
  let updated = 0;
  for (const f of files) {
    const base = path.basename(f, path.extname(f));
    const row = byTitle.get(base);
    if (!row) {
      console.warn("No matching session for transcript:", f);
      continue;
    }
    const fp = path.join(TRANSCRIPTS_DIR_RESOLVED, f);
    const text = fs.readFileSync(fp, "utf-8").trim();
    row.transcript = text;
    if (!row.quick_observations) {
      row.quick_observations = text.slice(0, 2000);
    }
    updated++;
    console.log("Updated transcript:", base);
  }
  if (updated > 0) {
    writeMaster(state);
    console.log("Updated", updated, "row(s) with transcript.");
  }
}

function main() {
  const args = process.argv.slice(2);
  const alpha = resolveAlpha(args);
  console.log(`Alpha ${alpha.ver} | raw: ${alpha.RAW_DIR} | csv: ${alpha.MASTER_CSV}`);

  let rawDir = alpha.RAW_DIR;
  const updateTranscripts = args.includes("--update-transcripts");
  const rawDirIdx = args.indexOf("--raw-dir");
  if (rawDirIdx >= 0 && args[rawDirIdx + 1]) {
    rawDir = args[rawDirIdx + 1];
  }

  MASTER_CSV_RESOLVED = alpha.MASTER_CSV;
  TRANSCRIPTS_DIR_RESOLVED = alpha.TRANSCRIPTS_DIR;

  if (updateTranscripts) {
    updateFromTranscripts();
  }
  ingestFromRaw(rawDir);
}

main();
