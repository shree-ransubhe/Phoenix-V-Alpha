# Usability Testing Protocol -- IndiGo Prototype UT

> **Version:** 1.0  
> **Date:** March 2026  
> **Owner:** Design & Product Team  
> **Status:** Ready for review

---

## 1. Purpose

This protocol defines how we run moderated usability tests on the IndiGo mobile app prototype. The goal is to validate three specific areas before the next design iteration:

1. **Visual hierarchy of the "For You" section** -- can users tell what is interactive?
2. **Community carousel behaviour** -- is the expand/collapse "peek" pattern understood on mobile?
3. **End-to-end family booking flow** -- can users complete a booking for multiple travellers through to payment?

Data collected will be used to make evidence-based design decisions and resolve internal debates (see Section 4).

---

## 2. What Is the UT Build?

| Item | Detail |
|------|--------|
| **App name on device** | IndiGo Prototype UT |
| **Bundle ID** | `com.indigo.prototype.ut` |
| **Xcode scheme** | `IndiGoPrototype-UT` |
| **Compile flag** | `UT_VARIANT` -- all tracking code is gated behind this flag and absent from the main build |
| **Backend** | Lightweight Node.js server (`ut-backend/`), stores JSON per session on disk |

The UT build can be installed **alongside** the main prototype on the same device (different bundle ID).

---

## 3. Session Flow

```
App Launch
    |
    v
Announcement Screen
  "Help us improve your experience"
  (consent + what we collect)
    |
    v
Demographics Form
  Role / Experience / Age band / Device
    |
    v
Session Starts -- tracking begins
    |
    v
Home Screen (Explore tab)
  [Checkpoint 1] Observe "For You" section
  [Checkpoint 2] Observe Community carousel
    |
    v
Booking Flow
  BookLocation -> BookDate -> BookPassenger -> PayMode
  [Checkpoint 3] Family booking task
    |
    v
Search Results (SRP)
  "End UT Session" button
    |
    v
Post-Session Questionnaire
  Ease / Frustration ratings
  Community questions
  Free-text feedback
    |
    v
Export Session Data
  Share via Email / WhatsApp / AirDrop / Files
```

---

## 4. Mandatory Checkpoints

### Checkpoint 1 -- Visual Hierarchy of "For You" Section

**Objective:** Determine whether users can distinguish interactive elements from decorative ones.

**What is in the section:**
- My Bookings card (left) -- shows upcoming flights
- Location Promo card (top right) -- e.g. "Dubai, Starting at Rs 24,999" with arrow button
- Flight Status card (bottom right) -- "Check your flight status" with icon

**Interactive elements:** Header search pill, My Bookings rows, Location Promo arrow, Flight Status card.

**What we capture:**
- Tap heatmap over the section (normalised x,y coordinates + timestamp)
- First-tap target per user
- Time spent in the section before scrolling away
- Repeated taps on non-interactive text (possible confusion indicator)

**Success criteria:**
- Majority of first taps land on intended interactive elements
- No cluster of taps on purely decorative text/labels

**Facilitator script:**
> "Take a look at this first section. Feel free to tap anything that looks interesting to you."

---

### Checkpoint 2 -- Community Carousel Behaviour

**Objective:** Test whether the expand/collapse carousel (one full card + narrow "peek" strip, "1/3" pagination) is intuitive on mobile.

**Context -- internal debate:**

*Colleague's view:* "This behaviour is relevant for desktop where hover exists. I see two banners but it says 1/3 -- it's confusing. I'd prefer not to cut the width and give users an assumption that there are more banners to scroll."

*Counter-view:* "The peek strip and 1/3 badge are standard mobile patterns that signal more content. Worth testing."

**Current implementation:**
- One expanded card (300pt wide) + one collapsed strip (36pt) visible at all times
- Pagination badge shows "1/3", "2/3", "3/3"
- User can swipe or tap the strip to advance

**What we capture:**
- Swipe and tap events within the Community section
- Whether user advanced past the first card (discovered more content)
- Time spent in the section
- Post-task answers:
  - "How many community stories did you notice?"
  - "Did you try to see more? How?"
  - "Did the 1/3 indicator make sense?"

**Success criteria:**
- Most users discover there is more than one story (swipe or tap strip)
- Users correctly interpret "1/3" as "first of three"
- No strong confusion signal in post-task feedback

**Facilitator script:**
> "Scroll down to the Community area. Have a look and see what's there."
> (Pause. If user does not interact further:) "Is there anything else you'd like to explore here?"

**How this resolves the debate:**
If data shows most users discover multiple stories and don't report confusion, the current pattern is validated. If confusion is high or discovery is low, we consider full-width cards or a clearer affordance and re-test.

---

### Checkpoint 3 -- Family Booking to Payment

**Objective:** Confirm users can complete a realistic multi-passenger booking through to the payment step.

**Task (read to participant):**
> "Imagine you're booking a flight for your family. Book a flight from Delhi to Mumbai for 2 adults and 1 child, departing on [specific date]. Go as far as the payment step -- you don't need to enter payment details or complete the booking."

**Parameters (set per round):**
- Origin: Delhi (DEL)
- Destination: Mumbai (BOM)
- Date: A specific future date (facilitator chooses)
- Travellers: 2 adults + 1 child (minimum)
- End point: Pay mode screen = minimum success; Search Results = full success

**What we capture:**
- Per-step time: BookLocation, BookDate, BookPassenger, PayMode, SRP
- Total journey time (session start to journey_complete event)
- Drop-off step (if user abandons)
- Tap heatmap per screen
- Optional ease/frustration rating at end

**Success criteria:**
- User reaches PayMode screen without abandoning
- No single step takes disproportionately long (outlier > 2x median)
- Ease rating >= 3/5 on average

---

## 5. Data Captured Per Session

| Field | Type | Description |
|-------|------|-------------|
| `sessionId` | UUID | Unique session identifier |
| `sessionTitle` | String | Auto-generated: `UT_YYYY-MM-DD_HHmm_{role}_{experience}` |
| `demographics` | Object | Role, experience, age band, device |
| `createdAt` / `endedAt` | ISO8601 | Session timestamps |
| `steps[]` | Array | `{ screenId, enteredAt, leftAt }` per screen visited |
| `taps[]` | Array | `{ screenId, x, y, timestamp }` -- normalised 0-1 coordinates |
| `journeyCompleted` | Boolean | True when user reaches SRP |
| `completedAt` | ISO8601 | Timestamp of journey completion |
| `rating` | Int 1-5 | Post-session ease rating |
| `frustration` | Int 1-5 | Post-session frustration rating |
| `feedback` | String | Free-text feedback |
| `postTaskAnswers[]` | Array | Community section post-task answers |

**Storage:** One JSON file per session in `ut-backend/sessions/`. Backend also supports CSV export per session or bulk.

---

## 6. How to Run

### Prerequisites
- macOS with Xcode 15+
- Node.js 18+ installed
- This repository cloned

### Step 1 -- Start the backend

```bash
cd ut-backend
npm install       # first time only
npm start         # starts on http://localhost:3100
```

### Step 2 -- Regenerate Xcode project (if needed)

```bash
xcodegen generate
```

### Step 3 -- Build and run the UT app

1. Open `IndiGoPrototype.xcodeproj` in Xcode
2. Select the **IndiGoPrototype-UT** scheme
3. Choose a simulator or connected device
4. Build and Run (Cmd+R)

The app will show as "IndiGo Prototype UT" on the device home screen.

### Step 4 -- Conduct the session

Follow the session flow in Section 3. The facilitator should:
1. Let the participant read the announcement and fill demographics
2. Guide through the three checkpoints using the scripts above
3. After SRP, tap "End UT Session" or let the participant finish naturally
4. Ensure the participant completes the post-session questionnaire
5. **Export the session data** immediately via the share button (Email/WhatsApp/Files)

### Step 5 -- Retrieve data

**From the device:** Use "Export Session Data" on the completion screen. Share via Email, WhatsApp, AirDrop, or Save to Files.

**From the backend:**
- All sessions: `GET http://localhost:3100/sessions`
- Single session JSON: `GET http://localhost:3100/sessions/{id}`
- Single session CSV: `GET http://localhost:3100/sessions/{id}/csv`
- All sessions CSV: `GET http://localhost:3100/export/csv`

---

## 7. Export and Data Safety

**Every session should be exported immediately** to avoid data loss.

After each session, the facilitator should:
1. Tap "Export Session Data" on the completion screen
2. Choose Email, WhatsApp, AirDrop, or Save to Files
3. Send to the team inbox or save to the shared drive

This on-device export works **even when offline or when the backend is down**. The backend is a secondary store.

---

## 8. Data Handling and Privacy

- **No PII collected:** Demographics are limited to role, experience, age band, and device type. No names, emails, or phone numbers.
- **Consent:** Participant must read and accept the announcement screen before any tracking begins.
- **Retention:** Session data should be retained for the duration of the study plus 90 days, then deleted.
- **Access:** Only the design and product team should have access to raw session files.
- **Anonymisation:** In any shared reports or presentations, use session IDs or titles only -- never attribute findings to identifiable individuals.

---

## 9. Distributing the UT Build

**For internal testing:**
- Build and install via Xcode directly on connected devices
- Or use Ad Hoc distribution with a provisioning profile

**For wider distribution:**
- Upload to TestFlight using the **IndiGoPrototype-UT** scheme
- The UT app installs alongside the main prototype (different bundle ID)

---

## 10. Analysing Results

### Per-session review
1. Open the session JSON (from export or backend)
2. Check `steps[]` for time-on-step and drop-off points
3. Check `taps[]` for heatmap analysis (aggregate by screenId)
4. Review `postTaskAnswers` for qualitative Community feedback

### Aggregate analysis
1. Export all sessions via `GET /export/csv`
2. Open in Excel, Google Sheets, or any BI tool
3. Key metrics:
   - **For You:** First-tap target distribution, tap cluster analysis
   - **Community:** Discovery rate (% who advanced past card 1), "1/3 understood" rate
   - **Booking:** Median time per step, completion rate, average ease/frustration

### Heatmap generation (optional)
Use the tap data (normalised x,y per screenId) with a visualisation tool:
- Python (matplotlib + scipy gaussian_kde)
- Any web-based heatmap library

---

## 11. Appendix: User-Facing Announcement Text

The following text is shown in-app before the session begins:

> **Help us improve your experience**
>
> This is a usability testing version of the IndiGo app. We'll record:
> - Which screens you visit and how long you spend
> - Where you tap to understand usage patterns
>
> Your data is anonymous and used only for this research. No real bookings or payments will be made. You can stop at any time.
>
> **[I'm Ready]**

---

## 12. Appendix: Post-Session Questions

| # | Question | Format |
|---|----------|--------|
| 1 | How easy was the booking flow? | 1-5 scale (Hard to Easy) |
| 2 | How frustrated did you feel? | 1-5 scale (Not at all to Very) |
| 3 | How many community stories did you notice? | Free text |
| 4 | Did you try to see more? How? | Free text |
| 5 | Did the 1/3 indicator make sense? | Free text |
| 6 | Any other feedback? | Free text |

---

## 13. Contacts

| Role | Name | Notes |
|------|------|-------|
| Study lead | [Your name] | Owns protocol and analysis |
| Design | [Designer name] | Owns UI and Community carousel |
| Engineering | [Eng name] | Owns UT build and backend |
| Facilitator(s) | [Names] | Runs sessions with participants |

---

*End of protocol.*
