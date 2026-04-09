# UT Analysis — Multi-Version

Central place for User Test session data, observations, and heat maps. Designed so **new data never overwrites** what you've added manually.

## Folder structure

```
ut-analysis/
├── alpha4/                  # Archived Alpha 4 data (5 sessions, Mar 2026)
│   ├── raw/                 # Session JSON exports
│   ├── heatmap/             # Generated reports & heat maps
│   │   └── screens/         # Screen PNGs for heatmap watermarks
│   ├── observations.json    # Qualitative observations from Excel
│   └── master.csv           # Session master sheet
│
├── alpha5/                  # Alpha 5.0 data
│   ├── raw/                 # Drop new session JSONs here
│   ├── heatmap/             # Generated reports & heat maps
│   │   └── screens/         # Drop Alpha 5 screen PNGs here
│   ├── transcripts/         # Optional transcript files
│   ├── observations.json    # (created after Excel import)
│   └── master.csv           # (created on first ingest)
│
├── alpha6/                  # Alpha 6.1 data (current)
│   ├── raw/                 # Drop Alpha 6.1 session JSONs here
│   ├── heatmap/             # Generated reports & heat maps
│   │   └── screens/         # Drop Alpha 6.1 screen PNGs here
│   ├── transcripts/         # Optional transcript files
│   ├── observations.json    # (created after Excel import)
│   └── master.csv           # (created on first ingest)
│
├── ingest.js                # Append sessions to master.csv
├── heatmap/
│   ├── generate.js          # Tap heatmaps → view.html
│   ├── report.js            # Session table → report.html
│   └── insights.js          # Qualitative insights → insights.html
└── README.md
```

## Key differences across Alphas

| Aspect | Alpha 4 | Alpha 5.0 | Alpha 6.1 |
|--------|---------|-----------|-----------|
| **Build target** | `IndiGoPrototype-UT` | `IndiGoPrototype-Alpha5-UT` | `IndiGoPrototype-Alpha61-UT` |
| **Theme** | Alpha41Theme | Alpha50Theme | Alpha61Theme |
| **Bundle ID** | `com.indigo.prototype.ut` | `com.indigo.prototype.alpha5.ut` | `com.indigo.prototype.alpha61.ut` |
| **Compile flag** | `UT_VARIANT` | `ALPHA_5_0 UT_VARIANT` | `ALPHA_6_1 UT_VARIANT` |
| **UT data folder** | `ut-analysis/alpha4/` | `ut-analysis/alpha5/` | `ut-analysis/alpha6/` |
| **Audio consent** | User toggle on consent screen | Always on (no toggle) | TBD |
| **Experience question** | "Experience with booking apps" → New / Comfortable / Expert | "How often do you book flights or hotels online?" → Never / Sometimes / Regularly / All the time | TBD |
| **Device field** | User selects Personal / Provided | Hardcoded as "Provided" | TBD |

## Workflow

All scripts accept `--alpha <version>` (defaults to **5** if omitted). Use `--alpha 6` for Alpha 6.1 data.

### 1. Ingest sessions (append-only)

```bash
# Alpha 5 (default)
node ut-analysis/ingest.js

# Alpha 4 (re-process archived data)
node ut-analysis/ingest.js --alpha 4

# Point at external raw folder
node ut-analysis/ingest.js --raw-dir "/path/to/Raw data"
```

### 2. Generate heat maps

```bash
node ut-analysis/heatmap/generate.js              # Alpha 5
node ut-analysis/heatmap/generate.js --alpha 4     # Alpha 4
```

Output: `alpha5/heatmap/view.html` (or `alpha4/heatmap/view.html`)

### 3. Generate consolidated report

```bash
node ut-analysis/heatmap/report.js                 # Alpha 5
node ut-analysis/heatmap/report.js --alpha 4       # Alpha 4
```

Output: `alpha5/heatmap/report.html` with Excel export

### 4. Generate qualitative insights

```bash
node ut-analysis/heatmap/insights.js               # Alpha 5
node ut-analysis/heatmap/insights.js --alpha 4     # Alpha 4
```

Output: `alpha5/heatmap/insights.html` with Word export

### 5. Add transcripts

```bash
# Place transcript files in alpha5/transcripts/{sessionTitle}.txt
node ut-analysis/ingest.js --update-transcripts
```

## Preparing for Alpha 6.1 sessions

1. **Build the UT app**: Use the `IndiGoPrototype-Alpha61-UT` target in Xcode
2. **Run sessions**: The app auto-records audio + on-device transcription
3. **Export JSON + audio**: Share sheet from the session complete screen
4. **Drop files here**: Place JSONs in `ut-analysis/alpha6/raw/`
5. **Drop screen PNGs**: Place Alpha 6.1 screen captures in `ut-analysis/alpha6/heatmap/screens/` for heatmap watermarks
6. **Run pipeline**: `node ut-analysis/ingest.js --alpha 6` → heatmap → report → insights

### Previous: Alpha 5 sessions

Use `--alpha 5` (the default) for Alpha 5.0 data. Files are in `ut-analysis/alpha5/`.

## Master CSV columns

- **sessionId** — Unique id (dedup key)
- **ut_number** — Auto: UT-1, UT-2, …
- **sessionTitle** — From JSON
- **name** — Manual: participant name
- **recording_yn** — Y if audio recorded
- **location** — Manual: e.g. Delhi IGI T1
- **travel_context** — Manual: e.g. DEL–NMI
- **quick_observations** — From transcript or manual
- **transcript** — Full transcript text
- **created_at**, **role**, **experience**, **age_band**, **device**, **journey_completed**, **rating**, **frustration**, **feedback** — From session JSON
