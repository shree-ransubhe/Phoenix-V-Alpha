# UT Analysis — Alpha 4

Central place for User Test session data, observations, and heat maps. Designed so **new data never overwrites** what you’ve added manually (e.g. Name, Location, Travel context in the master sheet).

## Folder structure

| Path | Purpose |
|------|--------|
| `raw/` | Drop session JSON files here (and optionally keep audio elsewhere). Ingest reads from here. |
| `transcripts/` | Optional transcript per session. Name = `{sessionTitle}.txt` (e.g. `UT_2026-03-17_1807_Occasional_Comfortable.txt`). Used to fill **Quick observations** when you run update. |
| `master.csv` | Single source of truth: one row per session. Open in Excel to add Name, Location, Travel context; run ingest/update to append new sessions or refresh observations from transcripts. |
| `heatmap/` | Heat map data and a view you can open in a browser and screenshot to share. |

## Workflow

### 1. Add new sessions (append-only)

- Copy session JSON (and optionally audio) from your export into `raw/`.
- From the repo root run:
  ```bash
  node ut-analysis/ingest.js
  ```
  Or from `ut-analysis`: `node ingest.js`
- New sessions are **appended** to `master.csv`. Existing rows (and any manual edits you made in Excel) are **never overwritten**.

### 2. Add transcripts and refresh observations

- Put transcript text in `transcripts/{sessionTitle}.txt` (e.g. from Whisper, Apple Notes, Otter).
- Run:
  ```bash
  node ut-analysis/ingest.js --update-transcripts
  ```
- For each transcript file, the script finds the matching session in `master.csv` and updates the **Transcript** and **Quick observations** columns only. Other columns (Name, Location, etc.) are left as-is.

### 3. Heat map view (for screenshots)

- From the repo root:
  ```bash
  node ut-analysis/heatmap/generate.js
  ```
  Or from `ut-analysis`: `node heatmap/generate.js`
- Open `ut-analysis/heatmap/view.html` in a browser (double-click or `open ut-analysis/heatmap/view.html`).
- Use this view to take screenshots to share with the team.

### 4. Process files from somewhere else

You can point ingest at another folder (e.g. OneDrive) without copying into the repo:

```bash
node ut-analysis/ingest.js --raw-dir "/path/to/UX Strategy/Phoenix/UT/Raw data"
```

## Master CSV columns

- **sessionId** — Unique id (used to avoid duplicates).
- **ut_number** — Auto: UT-1, UT-2, … (order of first appearance).
- **sessionTitle** — From JSON (e.g. `UT_2026-03-17_1807_Occasional_Comfortable`).
- **name** — Manual: participant name.
- **recording_yn** — From JSON: Y if audio recorded, N otherwise.
- **location** — Manual: e.g. Delhi IGI T1.
- **travel_context** — Manual: e.g. DEL–NMI.
- **quick_observations** — From transcript (when you run `--update-transcripts`) or manual; shareable English bullets.
- **transcript** — Full transcript text when you add a transcript file and run update.
- **created_at**, **role**, **experience**, **age_band**, **device**, **journey_completed**, **rating**, **frustration**, **feedback** — From session JSON.

You can add more columns in Excel; ingest only touches the columns it knows about and appends new rows for new `sessionId`s.

## Alpha 5

For Alpha 5, context (e.g. route, location, device) can be captured in additional columns or a separate schema; this layout can be extended without changing the append-only behaviour.
