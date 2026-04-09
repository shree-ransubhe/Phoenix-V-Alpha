# Usability Testing Protocol -- IndiGo Phoenix UT

> **Version:** 3.0 (Alpha 5.0)  
> **Date:** March 2026  
> **Owner:** Design & Product Team  
> **Status:** Ready for review  
> **Previous version:** 2.0 (Alpha 4.0)

---

## 1. Purpose

This protocol defines how we run moderated usability tests on the IndiGo Phoenix app prototype (Alpha 5.0). The goal is to validate **six specific areas** before the next design iteration:

1. **Homepage discovery and visual hierarchy** -- does the redesigned homepage (Recent Search, 6E Pick grid, offers, BluChip) guide users toward high-value actions?
2. **Search bar intent clarity** -- do users understand the search widget is for flight search (From-To-Date), not a general/AI search?
3. **Booking flow efficiency** -- can users complete the booking journey without unnecessary friction? (Stakeholder concern: 7 clicks to SRP vs 5 in current app)
4. **SRP fare comparison clarity** -- can users understand and compare fare families (Stretch vs Economy, Saver/Flexi/Upfront) without confusion?
5. **Community carousel behaviour** -- is the expand/collapse "peek" pattern understood on mobile? (Carried forward from Alpha 4.0 -- internal debate unresolved)
6. **Profile structure and findability** -- can users locate key actions in the restructured profile?

**Why this matters now:** A stakeholder review (24 March 2026) raised significant feedback across homepage, booking flow, SRP, and profile. Several points reflect technology or expert-user biases (e.g. click counting, assumption that peek patterns are desktop-only). This UT round is designed to collect evidence from real users to validate or challenge those assumptions before committing to redesign work.

Data collected will be used to make evidence-based design decisions and resolve internal debates (see Section 4).

---

## 2. What Is the UT Build?

| Item | Detail |
|------|--------|
| **App name on device** | IndiGo Alpha 5.0 UT |
| **Bundle ID** | `com.indigo.prototype.alpha5.ut` |
| **Xcode scheme** | `IndiGoPrototype-Alpha5-UT` |
| **Compile flags** | `ALPHA_5_0` + `UT_VARIANT` |
| **Theme** | `Alpha50Theme` (16px padding, 32px section spacing, IndiGo blue shadows, grid layouts) |
| **Backend** | Lightweight Node.js server (`ut-backend/`), stores JSON per session on disk |

The UT build installs **alongside** other prototype variants on the same device (unique bundle ID per target).

---

## 3. Session Flow

```
App Launch
    |
    v
Announcement Screen
  "Help us improve your experience"
  (No personal info collected — no name, mobile, etc.)
  [Audio recording starts discreetly — always on]
    |
    v
Demographics Form
  Travel frequency / Online booking frequency / Age band
  (Device is always "Provided" — auto-captured)
    |
    v
Session Starts
  -- Tracking begins (steps, taps, scroll depth)
  -- Device metadata captured automatically
  -- Screen snapshots captured for heatmap watermarks
  -- Audio recording active
    |
    v
Home Screen (Explore tab)
  [Checkpoint 1] Homepage discovery and visual hierarchy
  [Checkpoint 2] Search bar intent clarity
  [Checkpoint 5] Community carousel behaviour
    |
    v
Booking Flow
  BookLocation -> BookDate -> BookPassenger -> PayMode
  [Checkpoint 3] Booking flow efficiency
    |
    v
Search Results (SRP)
  [Checkpoint 4] Fare comparison clarity
  Fare selection triggers journey-complete overlay
  [Overlay taps tracked SEPARATELY from parent SRP]
    |
    v
Profile (facilitator-guided)
  [Checkpoint 6] Profile structure and findability
    |
    v
Post-Session Questionnaire
  Ease / Frustration ratings
  Search bar clarity question
  Comparison clarity question
  Community questions
  Free-text feedback
  -- Audio recording stops automatically
    |
    v
Export Session Data
  Share JSON + audio file via Email / WhatsApp / AirDrop / Files
  [Facilitator MUST export every session]
```

---

## 4. Mandatory Checkpoints

### Checkpoint 1 -- Homepage Discovery and Visual Hierarchy

**Objective:** Determine whether users can identify high-value actions and content on the redesigned Alpha 5.0 homepage -- specifically Recent Search, 6E Pick grid, Best Offers, and BluChip loyalty.

**Context -- stakeholder feedback being validated:**

| Stakeholder claim | Bias risk | What UT will tell us |
|---|---|---|
| "Flight CTA should be placed at the top for visibility" | Expert-user assumption; may not match scan patterns of new/casual users | Where do users' eyes (taps) go first? Is the search widget prominent enough at its current position? |
| "Improve visual hierarchy using images over text" | Aesthetic preference, not validated | Do users engage with image-led sections (6E Pick, One Click Away) more than text-led ones? |
| "Login & BlueChip loyalty must be positioned in the top fold" | Business priority ≠ user priority | Do users notice BluChip in the current position? Is it discoverable on first scroll? |
| "Reduce cognitive load for logged-in users" | General principle; need to identify where overload actually occurs | Which sections cause hesitation or confusion? (Time-to-first-tap, scroll depth) |

**What is in the Alpha 5.0 homepage (section order):**

| Section | Key elements |
|---------|-------------|
| **Header** | Collapsing sticky header with search widget + 6Eskai button + profile avatar |
| **For You (Recent Search)** | Horizontal scrollable recent search cards (replaces Alpha 4.0's My Bookings / Promo / Flight Status layout) |
| **6E Pick** | 2-column grid with Hotels, Sightseeing, Cabs, Experiences + "Explore more" footer |
| **Best Offers** | View all + prominent gradient card + offer list items |
| **BluChip** | Loyalty balance card with tier progress and unlock message |
| **Community** | Peek carousel with pagination (1/3) |
| **One Click Away** | Date-first destination cards + "View all +200 destinations" card |
| **Footer** | Stats grid (flights, passengers, routes, experience) |

**What we capture:**
- Tap heatmap over the full homepage (normalised x,y coordinates relative to full content height)
- First-tap target per user (which section/element gets the first interaction)
- Scroll depth on HomeView (how far down the page users explore)
- Time spent on HomeView before navigating away
- Per-section tap density (do some sections get ignored entirely?)
- Whether users notice BluChip without prompting

**Success criteria:**
- Users interact with the search widget without confusion about its purpose (validated further in Checkpoint 2)
- Recent Search cards receive taps (users recognise them as interactive)
- Scroll depth >= 0.5 for majority of users (they explore beyond the fold)
- No section receives zero engagement across all users
- BluChip card receives at least one glance/tap from >50% of users

**Facilitator script:**
> "This is the home screen of the app. Take your time to look around and explore anything that catches your eye. Feel free to scroll and tap on things."
> (Allow 60-90 seconds of free exploration before moving to Checkpoint 2.)

---

### Checkpoint 2 -- Search Bar Intent Clarity

**Objective:** Determine whether users understand that the search widget is for flight booking (From → To → Date), not a general search or AI assistant.

**Context -- stakeholder feedback being validated:**

| Stakeholder claim | Bias risk | What UT will tell us |
|---|---|---|
| "Search bar looks like a generic search / AI-style input" | Based on stakeholder's mental model; actual users may have different expectations from an airline app | Do users attempt to type free-text queries, or do they expect a From-To selection flow? |
| "Should be more intent-driven and intuitive (flight-focused)" | Solution proposed without evidence of the problem | Is there measurable confusion? What % of users tap the search bar expecting non-flight functionality? |

**What we capture:**
- Whether the user taps the search widget during free exploration (Checkpoint 1)
- User's verbal expectation before tapping (from audio: "I'll search for flights" vs "let me search for something")
- Behaviour after landing on BookLocationView -- do they seem surprised or confused?
- Post-task question: "What did you expect to happen when you tapped the search bar?"

**Success criteria:**
- Majority of users expect flight search when tapping the search widget
- No user expresses surprise that it leads to a From-To selection flow
- Audio recordings don't reveal confusion about the search bar's purpose

**Facilitator script:**
> (After free exploration) "I'd like you to start booking a flight. How would you begin?"
> (Observe: does the user immediately go to the search widget? Do they hesitate or look for an alternative entry point?)
> (After they tap) "What did you expect to happen when you tapped there?"

**How this resolves the debate:** If users naturally identify the search widget as the flight booking entry point and don't express confusion, the current design is adequate and the stakeholder concern is an expert-user bias. If multiple users express surprise or try to type free-text, the "intent-driven" redesign is warranted.

---

### Checkpoint 3 -- Booking Flow Efficiency

**Objective:** Measure whether the booking journey (Home → SRP) is efficient and whether the number of steps causes friction.

**Context -- stakeholder feedback being validated:**

| Stakeholder claim | Bias risk | What UT will tell us |
|---|---|---|
| "Current app: 5 clicks to SRP vs proposed: 7 clicks → needs optimisation" | Raw click count ≠ user effort; a clear 7-step flow may feel faster than a cramped 5-step one | Does the step count cause measurable friction? Which specific step takes the longest? |
| "Too many clicks across booking journey → streamline flow" | Click-counting heuristic without task-time evidence | Total journey time and per-step time will reveal if the flow is actually slow |
| "Easy destination change/edit during flow" | Valid usability principle | Do users attempt to go back and edit? How easily do they recover? |
| "Handle edge cases: if date not finalised, provide flexible search" | Feature request beyond current scope | Worth noting if users express uncertainty about dates |

**Task (read to participant):**
> "Imagine you're booking a flight for your family. Book a flight from Delhi to Mumbai for 2 adults and 1 child, departing on [specific date]. Go as far as selecting a fare on the search results -- you don't need to complete the booking."

**Parameters (set per round):**
- Origin: Delhi (DEL)
- Destination: Mumbai (BOM)
- Date: A specific future date (facilitator chooses)
- Travellers: 2 adults + 1 child (minimum)
- End point: Fare selection on SRP = success

**Booking flow steps (as implemented):**

| Step | Screen | screenId |
|------|--------|----------|
| 1 | Search widget tap | `HomeView` |
| 2 | Origin/destination selection | `BookLocationView` |
| 3 | Date selection | `BookDateView` |
| 4 | Traveller count | `BookPassengerView` |
| 5 | Payment mode / search | `PayModeView` |
| 6 | Search results | `SRPView` |

**What we capture:**
- Per-step time: BookLocationView, BookDateView, BookPassengerView, PayModeView, SRPView
- Total journey time (first tap on search widget to journey_complete event)
- Drop-off step (if user abandons or goes back)
- Back-navigation events (did user attempt to edit origin/destination/date after advancing?)
- Tap heatmap per screen (Y-axis accounts for scroll position)
- Verbal commentary on flow length (from audio)

**Success criteria:**
- User reaches SRP and selects a fare without abandoning
- No single step takes disproportionately long (outlier > 2× median across users)
- Total journey time is within acceptable range (benchmark against audio cues of frustration)
- Ease rating >= 3/5 on average
- Fewer than 20% of users verbally comment on "too many steps"

**How this resolves the debate:** If per-step times are low and users don't express friction, the 7-step flow is justified by its clarity. If a specific step is disproportionately slow (e.g. PayModeView), that step needs redesign -- not necessarily the step count.

---

### Checkpoint 4 -- SRP Fare Comparison Clarity

**Objective:** Determine whether users can understand fare differences, compare fare families, and make an informed selection on the Search Results Page.

**Context -- stakeholder feedback being validated:**

| Stakeholder claim | Bias risk | What UT will tell us |
|---|---|---|
| "Comparison experience is unclear" | Stated without specifying what's unclear | Which part of comparison do users struggle with? Toggle? Card content? Terminology? |
| "Enable side-by-side fare comparison" | Already implemented (Compare Fares bottom sheet) -- may be a visibility problem, not a feature gap | Do users discover the Compare Classes CTA? Do they use it? |
| "Make fare differences easily scannable" | Valid heuristic | Time spent on fare family sheets; tap patterns on Stretch vs Economy toggle |
| "Remove unnecessary labels (e.g. free text if already implied)" | Specific feedback; worth validating if labels actually cause confusion | Do users tap/hover on labels? Do they express confusion about terminology? |
| "Ensure offers are visible on SRP to avoid funnel drop-offs" | Business goal; offer visibility on SRP is not implemented in current prototype | Note: out of scope for this build; can add to observation notes |

**Current SRP implementation:**
- Sticky header with route summary, calendar strip, and quick filters
- "Compare classes" CTA → Compare Fares bottom sheet (Stretch vs Economy tabs, horizontal fare cards; reference only, no selection)
- Per-flight cards with two fare tiles (Stretch and Economy entry points)
- Fare Family bottom sheet per flight (Saver / Flexi / Upfront for Economy; variants for Stretch) with "Select" CTA

**What we capture:**
- Whether users tap "Compare classes" CTA (discovery rate)
- Time spent on Compare Fares overlay
- Tab switches between Stretch and Economy in Compare Fares
- Time spent on Fare Family bottom sheets
- Which fare tier users select (Saver vs Flexi vs Upfront)
- Taps on fare card elements (what are they trying to understand?)
- Overlay-specific heatmaps: `SRPView-CompareFares`, `SRPView-FareFamily-Stretch`, `SRPView-FareFamily-Economy`
- Post-task question: "How easy was it to understand the fare options?"
- Verbal commentary (from audio) about fare terminology or confusion

**Success criteria:**
- >50% of users discover the Compare Classes CTA without prompting
- Users can articulate the difference between at least two fare types after viewing
- No user selects a fare and then immediately goes back (regret indicator)
- Average time on fare family sheets is reasonable (not excessively long = confusion, not excessively short = not reading)

**Facilitator script:**
> (After user reaches SRP) "Take a look at the flights available. Choose the one that works best for your family."
> (If user selects a fare quickly without exploring comparison:) "Before you finalise, is there a way to compare what's included in different fares?"
> (After selection) "How easy was it to understand what you were getting with each fare option?"

**How this resolves the debate:** If users struggle with the comparison UI (low CTA discovery, long dwell times with verbal confusion, regret taps), the comparison experience needs redesign. If users navigate it smoothly, the current implementation is working and the stakeholder feedback may stem from expert familiarity with competitor apps.

---

### Checkpoint 5 -- Community Carousel Behaviour

**Objective:** Test whether the expand/collapse carousel (one full card + narrow "peek" strip, "1/3" pagination) is intuitive on mobile.

**Context -- internal debate (carried forward from Alpha 4.0):**

*Colleague's view:* "This behaviour is relevant for desktop where hover exists. I see two banners but it says 1/3 -- it's confusing. I'd prefer not to cut the width and give users an assumption that there are more banners to scroll."

*Counter-view:* "The peek strip and 1/3 badge are standard mobile patterns that signal more content. Worth testing."

**Status:** This checkpoint was part of Alpha 4.0 testing. If sufficient data was collected in Alpha 4.0, this can be deprioritised or used as a validation check. If Alpha 4.0 data was inconclusive, this remains a mandatory checkpoint.

**Alpha 5.0 implementation changes:**
- Section title now shown (theme: `communityShowsTitle: true`)
- Different card sizes and corner radii
- Collapsed overlay styling updated
- No "NoFilter" logo
- Updated typography

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

### Checkpoint 6 -- Profile Structure and Findability

**Objective:** Determine whether users can locate key profile actions in the current structure, and whether the searchable profile list is helpful or confusing.

**Context -- stakeholder feedback being validated:**

| Stakeholder claim | Bias risk | What UT will tell us |
|---|---|---|
| "Profile list is too long → needs restructuring" | Length perception varies; depends on information architecture, not just count | Do users struggle to find specific items? Do they scroll to the bottom? |
| "Search within profile is confusing → simplify or redesign" | Based on internal observation; real users may find it useful | Do users attempt to use search? Does it help them find what they need? |
| "CTAs which are less used can be put in accordion" | Assumption about frequency without user data | Which profile items do users tap? Which are ignored? |

**Current profile structure (Alpha 5.0):**
- Sticky header with avatar, name, BluChip tier
- Search/filter bar with aviation-contextual keyword matching
- Sections: YOUR INFORMATION, MY ORDER HISTORY, DISCOVER INDIGO BLUCHIP, OTHER INFORMATION
- Items include: Upgrade to Stretch, Flight Status, My Nominee, My Scratch Card, My Trips, Cabs, Insurance, 6E Add-ons, BluChip tiers, Partners, Settings, Help, Logout

**Task (read to participant):**
> "Imagine you want to check the status of an upcoming flight. Can you find where you'd do that?"
> (After completion:) "Now, imagine you want to see what partners are available for your BluChip points. Can you find that?"

**What we capture:**
- Whether the user finds "Flight Status" and how long it takes
- Whether the user uses the search bar or scrolls manually
- Tap heatmap on ProfileView (which items attract attention)
- Scroll depth on ProfileView
- Time to complete each findability task
- Verbal commentary on profile structure (from audio)

**Success criteria:**
- Users find both items within 30 seconds each
- At least some users discover and use the search functionality
- No user expresses frustration about the length or structure of the list
- Audio recordings don't reveal confusion about categorisation

**Facilitator script:**
> "Let me show you the profile section. Can you find where you'd check the status of an upcoming flight?"
> (Observe: scroll vs search, time taken, hesitation)
> "Great. Now can you find where you'd see BluChip partner options?"

**Note:** ProfileView is not currently instrumented with UT tracking. For Alpha 5.0 UT, **add `utInstrumented(screenId: "ProfileView")` to the ProfileView** to capture taps, scroll depth, and screen time. This is a code change required before testing.

---

## 5. Stakeholder Feedback Triage

The following table maps all stakeholder feedback from the 24 March review to whether they are tested in this UT round, and why or why not.

### Tested in this UT round

| # | Feedback item | Checkpoint | Rationale |
|---|---|---|---|
| 1 | Search bar looks like generic/AI search | CP2 | Direct user validation needed; stakeholder may have expert bias |
| 2 | Flight CTA should be at the top | CP1 | Tap heatmap will show what users gravitate toward first |
| 3 | 7 clicks to SRP vs 5 in current app | CP3 | Per-step time data will reveal if step count = actual friction |
| 4 | Too many clicks in booking journey | CP3 | Journey time + drop-off data |
| 5 | Comparison experience is unclear | CP4 | CTA discovery rate + fare family dwell time + verbal feedback |
| 6 | Side-by-side fare comparison needed | CP4 | Already implemented; testing if users discover and use it |
| 7 | Make fare differences scannable | CP4 | Overlay heatmaps + time-on-overlay |
| 8 | Remove unnecessary labels | CP4 | Verbal confusion signals from audio |
| 9 | Profile list too long | CP6 | Findability tasks + scroll depth + search usage |
| 10 | Search within profile is confusing | CP6 | Direct observation of search usage |
| 11 | Loyalty not visible in first fold | CP1 | Scroll depth + BluChip tap rate |
| 12 | Visual hierarchy: images over text | CP1 | Tap density per section (image-led vs text-led) |
| 13 | Reduce cognitive load | CP1, CP3 | Hesitation time, scroll depth, verbal cues |
| 14 | Peek carousel confusing on mobile | CP5 | Carry-forward; discovery rate + post-task questions |

### Not tested (out of scope for this build)

| # | Feedback item | Reason |
|---|---|---|
| 1 | Logged-in vs anonymous user journey | Prototype does not distinguish; only logged-in state is prototyped |
| 2 | Content-based suggestions in search | Not implemented in current build |
| 3 | Bottom globe should be interactive | Not implemented; would require new component |
| 4 | Trip Day component with time-sensitive cards | Not implemented |
| 5 | Boarding pass from homepage | Not implemented |
| 6 | Smart nudges for promos/reminders | Not implemented |
| 7 | Flexible date search | Not implemented |
| 8 | Multi-city booking | Explicitly out of scope per stakeholder meeting |
| 9 | Offers visible on SRP | Not implemented in prototype SRP |
| 10 | Animated cards for offers | Not implemented |
| 11 | Carousel UI for offers | Not implemented |
| 12 | Auto-apply promo codes | Not implemented |
| 13 | Contextual promo nudges | Not implemented |
| 14 | 6E Sky as conversational assistant | Only button exists; no chat/voice flow |
| 15 | Product-type CMS-driven content | Architecture concern, not testable in UT |
| 16 | Contextual notifications | Not implemented |
| 17 | Globalisation / currency formatting | Not in prototype |
| 18 | Gamification for loyalty | Not implemented |
| 19 | Mini app whitespace optimisation | Not in scope |

---

## 6. Data Captured Per Session

| Field | Type | Description |
|-------|------|-------------|
| `sessionId` | UUID | Unique session identifier |
| `sessionTitle` | String | Auto-generated: `UT_YYYY-MM-DD_HHmm_{role}_{experience}` |
| `demographics` | Object | Travel frequency, online booking frequency, age band. Device is always "Provided". |
| `deviceMetadata` | Object | Auto-captured: `deviceModel`, `screenSize`, `osVersion`, `appVersion` |
| `createdAt` / `endedAt` | ISO8601 | Session timestamps |
| `steps[]` | Array | `{ screenId, enteredAt, leftAt }` per screen visited (including overlays) |
| `taps[]` | Array | `{ screenId, x, y, timestamp, contentHeight }` -- Y normalised against full scroll content height |
| `scrollDepths[]` | Array | `{ screenId, maxDepth, timestamp }` -- 0.0 (top) to 1.0 (bottom) per screen |
| `journeyCompleted` | Boolean | True when user reaches SRP |
| `completedAt` | ISO8601 | Timestamp of journey completion |
| `rating` | Int 1-5 | Post-session ease rating |
| `frustration` | Int 1-5 | Post-session frustration rating |
| `feedback` | String | Free-text feedback |
| `postTaskAnswers[]` | Array | Community + search bar + comparison post-task answers |
| `audioConsent` | Boolean | Always `true` (recording is mandatory) |
| `audioFileName` | String | Filename of the recorded audio (M4A) |

**Storage:** One JSON file per session in `ut-backend/sessions/`. Audio files are stored on-device and included in the export bundle. Backend also supports CSV export per session or bulk.

### Device Metadata (auto-captured)

| Field | Example | Notes |
|-------|---------|-------|
| `deviceModel` | `iPhone15,2` | Hardware model identifier |
| `screenSize` | `393x852` | Logical points (width x height) |
| `osVersion` | `iOS 17.4` | OS name and version |
| `appVersion` | `1.0` | CFBundleShortVersionString |

### Tracked Screens (10 total)

| Screen ID | What it is | Status |
|-----------|------------|--------|
| `HomeView` | Home / Explore tab | Existing |
| `BookLocationView` | Origin/destination selection | Existing |
| `BookDateView` | Date picker | Existing |
| `BookPassengerView` | Traveller count | Existing |
| `PayModeView` | Payment mode | Existing |
| `SRPView` | Search results list | Existing |
| `SRPView-CompareFares` | Compare Fares overlay (tracked separately) | Existing |
| `SRPView-FareFamily-Stretch` | Fare Family overlay -- Stretch (tracked separately) | Existing |
| `SRPView-FareFamily-Economy` | Fare Family overlay -- Economy (tracked separately) | Existing |
| `ProfileView` | Profile / account screen | **NEW -- requires instrumentation** |

### Code Changes Required Before Testing

| Change | File | Description |
|--------|------|-------------|
| Add UT instrumentation to ProfileView | `Features/Profile/ProfileView.swift` | Add `.utInstrumented(screenId: "ProfileView")` modifier |
| Add `ProfileView` to TRACKED_SCREENS in backend | `ut-backend/server.js` | Include `ProfileView` in the tracked screens array for CSV export columns |
| Add post-task questions for search bar and comparison | `UT/UTSessionCompleteView.swift` | Add questions about search bar expectation and fare comparison clarity |

### Heatmap Y-Axis Algorithm

Tap Y-coordinates are normalised against the **full scroll content height**, not the visible viewport:

```
absoluteY = localTouchY + scrollView.contentOffset
normalisedY = absoluteY / scrollView.contentSize.height
```

This ensures heatmap dots are placed at the correct position even on scrollable pages (e.g. HomeView at ~3× viewport height).

### Screen Snapshots (for heatmap watermarks)

Each screen is automatically captured as a PNG the first time it's visited during a session. These screenshots are uploaded to the backend (`POST /screenshots/:screenId`) and stored in `ut-analysis/heatmap/screens/`. The heatmap generator uses these as watermark backgrounds.

### Scroll Depth Tracking

Scroll depth is captured per screen as a normalised value (0.0 = no scroll, 1.0 = scrolled to bottom). Tracked on all main screens plus overlays.

### Audio Recording

- **Format:** M4A (AAC, 22kHz mono, medium quality)
- **Consent:** Always on -- no toggle shown. The announcement screen clearly states no personal information is recorded.
- **Lifecycle:** Recording starts automatically when the session starts; stops when session ends.
- **Export:** Audio file is included alongside the JSON when the facilitator taps "Export Session Data"
- **Cross-reference:** `audioFileName` in the session JSON/CSV links to the audio file

---

## 7. How to Run

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
2. Select the **IndiGoPrototype-Alpha5-UT** scheme (not the Alpha 4 UT scheme)
3. Choose a simulator or connected device
4. Build and Run (Cmd+R)

The app will show as "IndiGo Alpha 5.0 UT" on the device home screen.

### Step 4 -- Conduct the session

Follow the session flow in Section 3. The facilitator should:
1. Let the participant read the announcement screen (audio recording starts discreetly)
2. Let the participant fill demographics (3 questions only -- no device question)
3. **Checkpoint 1:** Free homepage exploration (60-90 seconds)
4. **Checkpoint 2:** Observe search bar interaction and expectations
5. **Checkpoint 3:** Guide through family booking task using the script
6. **Checkpoint 4:** Observe SRP navigation and fare comparison
7. After fare selection, the journey-complete overlay appears automatically
8. **Checkpoint 5:** Navigate back to home and guide to Community section (if not already explored in CP1)
9. **Checkpoint 6:** Guide to Profile and conduct findability tasks
10. Ensure the participant completes the post-session questionnaire
11. **CRITICAL: Export the session data immediately** via the share button (Email/WhatsApp/Files)

### Step 5 -- Retrieve data

**From the device (preferred):** Use "Export Session Data" on the completion screen. This shares both the session JSON and the audio recording via Email, WhatsApp, AirDrop, or Save to Files.

**From the backend (secondary):**
- All sessions: `GET http://localhost:3100/sessions`
- Single session JSON: `GET http://localhost:3100/sessions/{id}`
- Single session CSV: `GET http://localhost:3100/sessions/{id}/csv`
- All sessions CSV: `GET http://localhost:3100/export/csv`
- Screen screenshots: `GET http://localhost:3100/screenshots`

> **Note:** Audio files are only available via on-device export. The backend stores JSON data and screen snapshots.

---

## 8. Export and Data Safety

**Every session MUST be exported immediately** to avoid data loss. The facilitator is the last line of defence.

After each session, the facilitator should:
1. Tap "Export Session Data" on the completion screen
2. This exports the session JSON **and** the audio recording as a bundle
3. Choose Email, WhatsApp, AirDrop, or Save to Files
4. Send to the team inbox or save to the shared drive
5. Verify the export was received before starting the next session

**Skip option:** A "Skip for now" button is available with a data-loss warning. Use only if export is not immediately possible -- but return and re-export later.

This on-device export works **even when offline or when the backend is down**. The backend is a secondary store for JSON only (no audio).

---

## 9. Data Handling and Privacy

- **No PII collected:** Demographics are limited to travel frequency, booking frequency, and age band. No names, emails, mobile numbers, or device selection. Device is always "Provided".
- **Consent:** Participant must read and accept the announcement screen before any tracking begins. The announcement explicitly states: "We will not record your name, mobile number, or any personal details."
- **Audio recording:** Always on (no toggle). Audio may contain identifiable voice data -- handle with extra care:
  - Store audio files in a restricted shared drive (not public channels)
  - Delete audio after transcription and analysis is complete
  - Never share raw audio in presentations or reports
- **Retention:** Session data should be retained for the duration of the study plus 90 days, then deleted. Audio files should be deleted after transcription.
- **Access:** Only the design and product team should have access to raw session files and audio recordings.
- **Anonymisation:** In any shared reports or presentations, use session IDs or titles only -- never attribute findings to identifiable individuals.

---

## 10. Distributing the UT Build

**For internal testing:**
- Build and install via Xcode directly on connected devices
- Or use Ad Hoc distribution with a provisioning profile

**For wider distribution:**
- Upload to TestFlight using the **IndiGoPrototype-Alpha5-UT** scheme
- The UT app installs alongside other prototype variants (unique bundle ID)

---

## 11. Analysing Results

### Per-session review
1. Open the session JSON (from export or backend)
2. Check `steps[]` for time-on-step and drop-off points
3. Check `taps[]` for heatmap analysis (aggregate by screenId -- overlays and ProfileView are separate)
4. Check `scrollDepths[]` to see how far users scrolled on each screen
5. Review `postTaskAnswers` for qualitative feedback (Community, search bar, comparison)
6. Listen to audio recording for verbal cues, confusion, and think-aloud commentary

### Heatmap generation (automatic watermarks)

Screen screenshots are captured automatically on first visit and stored in `ut-analysis/heatmap/screens/`. Run:

```bash
node ut-analysis/heatmap/generate.js
open ut-analysis/heatmap/view.html
```

Heatmaps are overlaid on the actual UI screenshots. Overlays (Compare Fares, Fare Family Stretch/Economy) and ProfileView have their own separate heatmaps.

### Aggregate analysis (enhanced CSV)
1. Export all sessions via `GET /export/csv`
2. Open in Excel, Google Sheets, or any BI tool
3. The CSV includes **comparative columns** for cross-session analysis:

| Column | Description |
|--------|-------------|
| `deviceModel` / `screenSize` / `osVersion` / `appVersion` | Device context for each session |
| `audioConsent` / `audioFileName` | Audio recording status and file cross-reference |
| `avgTimePerStepSec` | Average time across all steps in the session |
| `longestStep` / `longestStepDurationSec` | Which screen took the most time (friction indicator) |
| `timeToFirstTapSec` | Seconds from session start to first interaction |
| `scrollDepth_{screen}` | Max scroll depth per screen (0.0-1.0) |
| `stepTimeSec_{screen}` | Total time spent on each screen |
| `tapCount_{screen}` | Number of taps per screen (density indicator) |

4. **Key metrics by checkpoint:**

| Checkpoint | Key metrics |
|------------|------------|
| **CP1: Homepage** | First-tap target distribution, scroll depth on HomeView, per-section tap density, BluChip interaction rate |
| **CP2: Search bar** | Time-to-first-tap on search widget, verbal expectation alignment (from audio), post-task answer analysis |
| **CP3: Booking flow** | Per-step time (BookLocation → BookDate → BookPassenger → PayMode → SRP), total journey time, drop-off step, back-navigation frequency |
| **CP4: SRP comparison** | Compare Classes CTA discovery rate, overlay dwell time, tab switch count, fare selection patterns, overlay heatmaps |
| **CP5: Community** | Discovery rate (% who advanced past card 1), "1/3 understood" rate, scroll depth in Community zone |
| **CP6: Profile** | Findability task completion time, search usage rate, scroll depth on ProfileView, tap distribution by section |
| **Cross-cutting** | Audio transcripts correlated with quantitative data, ease/frustration ratings, free-text themes |

### Stakeholder feedback resolution matrix

After collecting data from all sessions, fill in this matrix to resolve each stakeholder debate:

| Stakeholder claim | Data source | Finding | Recommendation |
|---|---|---|---|
| Search bar looks generic | CP2 post-task + audio | _[fill after testing]_ | _[validate/reject/modify]_ |
| 7 clicks too many | CP3 per-step times | _[fill after testing]_ | _[validate/reject/modify]_ |
| Comparison unclear | CP4 CTA discovery + dwell time | _[fill after testing]_ | _[validate/reject/modify]_ |
| Profile too long | CP6 findability + scroll depth | _[fill after testing]_ | _[validate/reject/modify]_ |
| Profile search confusing | CP6 search usage rate | _[fill after testing]_ | _[validate/reject/modify]_ |
| BluChip not visible | CP1 scroll depth + tap rate | _[fill after testing]_ | _[validate/reject/modify]_ |
| Peek carousel desktop-only | CP5 discovery rate | _[fill after testing]_ | _[validate/reject/modify]_ |

### Audio transcription (optional)
Recorded M4A files can be transcribed using:
- Apple's built-in transcription (share to Notes app)
- Any speech-to-text service (Whisper, Otter.ai, etc.)
- Correlate transcript timestamps with session events for rich documentation

---

## 12. Version History

| Version | Alpha | Date | Key changes |
|---------|-------|------|-------------|
| 1.0 | Alpha 4.0 | Feb 2026 | Initial protocol: 3 checkpoints (For You, Community, Booking) |
| 2.0 | Alpha 4.0 | Mar 2026 | Added audio recording, overlay tracking, screen snapshots, enhanced CSV |
| **3.0** | **Alpha 5.0** | **Mar 2026** | **Expanded to 6 checkpoints; added search bar, SRP comparison, profile; stakeholder feedback triage; uses Alpha5-UT target** |
| 4.0 | Alpha 6.1 | Apr 2026 | New targets `IndiGoPrototype-Alpha61` / `IndiGoPrototype-Alpha61-UT`; `ALPHA_6_1` flag; `Alpha61Theme`; `com.indigo.prototype.alpha61[.ut]` bundle IDs; UT data in `ut-analysis/alpha6/` |

### What changed from Protocol 2.0 to 3.0

| Area | Before (v2.0 / Alpha 4.0) | After (v3.0 / Alpha 5.0) |
|------|---------------------------|--------------------------|
| Target / scheme | `IndiGoPrototype-UT` with `UT_VARIANT` only | `IndiGoPrototype-Alpha5-UT` with `ALPHA_5_0` + `UT_VARIANT` |
| Theme | Alpha 4.1 (20px padding, original layouts) | Alpha 5.0 (16px padding, 32px sections, grid layouts, shadows) |
| Checkpoints | 3 (For You hierarchy, Community, Booking) | 6 (+Search bar, +SRP comparison, +Profile) |
| Homepage "For You" | My Bookings + Location Promo + Flight Status | Recent Search cards (Alpha 5.0 layout) |
| 6E Pick | Horizontal carousel | 2-column grid + Explore more |
| Tracked screens | 9 | 10 (+ProfileView) |
| Post-session questions | 6 (ease, frustration, 3 community, 1 open) | 10 (+search bar, +comparison, +profile) |
| Stakeholder context | Internal design debates only | Full stakeholder review triage with bias analysis |
| Resolution framework | Per-checkpoint success criteria | Success criteria + stakeholder feedback resolution matrix |

---

## 13. Appendix: User-Facing Announcement Text

The following text is shown in-app before the session begins:

> **Help us improve your experience**
>
> - We'll observe how you navigate the app to understand what works and what doesn't.
> - Your interactions will be captured to understand usage patterns -- no personal information is collected.
> - We will not record your name, mobile number, or any personal details. All data is anonymous.
> - No real bookings or payments will be made. You can stop at any time -- there are no wrong answers.
>
> **[I'm Ready]**

---

## 14. Appendix: Post-Session Questions

| # | Question | Format | Checkpoint |
|---|----------|--------|------------|
| 1 | How easy was the booking flow? | 1-5 scale (Hard to Easy) | CP3 |
| 2 | How frustrated did you feel? | 1-5 scale (Not at all to Very) | All |
| 3 | What did you expect when you tapped the search bar? | Free text | CP2 |
| 4 | How easy was it to understand the fare options? | 1-5 scale (Hard to Easy) | CP4 |
| 5 | How many community stories did you notice? | Free text | CP5 |
| 6 | Did you try to see more? How? | Free text | CP5 |
| 7 | Did the 1/3 indicator make sense? | Free text | CP5 |
| 8 | How easy was it to find things in the profile? | 1-5 scale (Hard to Easy) | CP6 |
| 9 | Did you use the search bar in the profile section? Was it helpful? | Free text | CP6 |
| 10 | Any other feedback? | Free text | All |

---

## 15. Appendix: Facilitator Cheat Sheet

Quick reference for facilitators during sessions. Print this page.

### Before each session
- [ ] Backend running (`npm start` in `ut-backend/`)
- [ ] Device has IndiGo Alpha 5.0 UT installed (check app name on home screen)
- [ ] Previous session exported (verify receipt)

### During the session

| Time | Action | Script |
|------|--------|--------|
| 0:00 | Start | Let participant read announcement, tap "I'm Ready" |
| 0:30 | Demographics | Participant fills 3 questions |
| 1:00 | **CP1: Homepage** | "This is the home screen. Take your time to look around and explore anything that catches your eye." |
| 2:30 | **CP2: Search bar** | "I'd like you to start booking a flight. How would you begin?" → After tap: "What did you expect to happen when you tapped there?" |
| 3:00 | **CP3: Booking** | "Book a flight from Delhi to Mumbai for 2 adults and 1 child, departing on [date]. Go as far as selecting a fare." |
| 7:00 | **CP4: SRP** | "Take a look at the flights available. Choose the one that works best for your family." → If needed: "Is there a way to compare what's included?" |
| 9:00 | Journey complete overlay | Let participant read, tap "Continue to Feedback" |
| 9:30 | **CP5: Community** | Navigate to Home → "Scroll down to the Community area. Have a look." → "Is there anything else you'd like to explore here?" |
| 10:30 | **CP6: Profile** | "Can you find where you'd check the status of an upcoming flight?" → "Can you find BluChip partner options?" |
| 12:00 | Questionnaire | Participant fills post-session questions |
| 14:00 | **Export** | Tap "Export Session Data" → send via Email/WhatsApp/AirDrop |

### After each session
- [ ] Verify export was received
- [ ] Note any technical issues or observations not captured by the app
- [ ] Reset app state if needed (force quit and relaunch)

---

## 16. Contacts

| Role | Name | Notes |
|------|------|-------|
| Study lead | Shreenivas Ransubhe | Owns protocol and analysis |
| Design Lead | Ishika | Owns UI and Community carousel |
| Design Team | Ani, Rahul, Seemant | Design decisions and UI building |
| Engineering | Shreenivas | Owns UT build and backend |
| Facilitator | Shreenivas | Runs sessions with participants |
| Co-facilitator(s) | Khushboo, Ankit, Jonty | Attends sessions with participants |

---

*End of protocol.*
