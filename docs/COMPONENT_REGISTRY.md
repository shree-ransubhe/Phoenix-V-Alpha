# Component Registry

> Single source of truth for all Atoms and Molecules.
> **@-mention this file** (`@docs/COMPONENT_REGISTRY.md`) when asking an agent
> to work on any component — it provides path, type, and Figma nodes at a glance.

## Atoms (`Components/Atoms/`)

| File | Description | Figma Nodes (Alpha) |
|------|-------------|---------------------|
| `BluChipBalanceCard.swift` | IndiGo BluChip loyalty balance card | 1033:10441 (4.1), 5602:85032 (6.1) |
| `ChipView.swift` | Chip / tag; uses design tokens | — |
| `FlightStatusCard.swift` | "Flight Status" quick-action card | 765:8859 (4.1) |
| `IconButton.swift` | Icon-only button; uses design tokens | — |
| `LocationPromoCard.swift` | Destination promo card (city + price) | 765:8850 (4.1) |
| `MyBookingsCard.swift` | "My Bookings" card (upcoming flights) | 765:8828 (4.1) |
| `OfferHighlighterCard.swift` | Hero promo card (Best Offers section) | 85:6023 (4.1) |
| `OfferListItem.swift` | Single offer row in Best Offers list | 85:6048 (4.1) |
| `OneClickAwayCard.swift` | Destination card for "One Click Away" carousel | 826:9866 (4.1), 2440:40859 (5.0) |
| `PrimaryButton.swift` | Primary CTA button; uses design tokens | — |
| `ProminentOfferCard.swift` | Full-bleed image promo card (Best Offers 5.0) | 2481:36812 (5.0) |
| `RecentSearchCard.swift` | Ticket-shaped "recent search" card | 2737:18792, 2739:18925 (5.0) |
| `SixEPickCard.swift` | Service card for "6E Pick" section | 260:10168 (4.1), 2453:26526 (5.0) |
| `SixEskaiButton.swift` | 6eSkai assistant entry point button | 2279:25586 (5.0) |

## Molecules (`Components/Molecules/`)

| File | Description | Figma Nodes (Alpha) |
|------|-------------|---------------------|
| `BestOffersSection.swift` | "Best Offers" / "Find exciting offers here" | 85:5939 (4.1), 2279:25606 (5.0) |
| `BottomNavBar.swift` | Bottom navigation bar ("Sticky Footer") | 1166:10237 (4.1) |
| `CommunitySection.swift` | Community carousel (expand/collapse transitions) | 85:6085 (4.1), 2463:31397 (5.0) |
| `FlightOffersFooterSection.swift` | "India by IndiGo" corporate footer section | 85:6323 (4.1) |
| `ForYouSection.swift` | "For You" section on Explore page | — |
| `HeaderBarView.swift` | Sticky header (back + title + trailing) for Book/SRP | — |
| `HomeHeaderView.swift` | Home sticky header with scroll-driven transitions | 804:10305, 917:11177 (4.1) |
| `OneClickAwaySection.swift` | "One Click Away" section (4.1 + 5.0 layouts) | 85:6087 (4.1), 2463:31104 (5.0) |
| `SearchWidgetView.swift` | Search widget pill with typewriter animation | 2440:44284 (5.0) |
| `SixEPickSection.swift` | "Beyond Flights explore 6EPick" section | 260:10026 (4.1), 2453:26526 (5.0) |

## Feature-Local Components (`Features/**/Components/`)

| File | Description | Figma Nodes (Alpha) |
|------|-------------|---------------------|
| `SRP/Components/CompareFaresBottomSheet.swift` | Compare fares bottom sheet | — |
| `SRP/Components/FareFamilyBottomSheet.swift` | Fare family bottom sheet | — |
| `SRP/Components/FlightResultCard.swift` | Flight result card | — |
| `SRP/Components/SRPCalendarStrip.swift` | SRP calendar strip | — |
| `SRP/Components/SRPCompareClassesCTA.swift` | SRP compare classes CTA | — |
| `SRP/Components/SRPIcons.swift` | SRP icon set | — |
| `SRP/Components/SRPQuickFilters.swift` | SRP quick filters | — |
| `SRP/Components/SRPReferenceCard.swift` | SRP reference card | — |

---

## How to Use This File

1. **When asking an agent to version a component for Alpha 6.1:**
   `@docs/COMPONENT_REGISTRY.md` — "Update OneClickAwaySection for Alpha 6.1; Figma node: [paste node]."
2. **When a new Figma node is finalized for 6.1:** Add it to the table in the
   "Figma Nodes" column with `(6.1)` suffix.
3. **Do NOT add new rows** unless a genuinely new component is created with
   user consent (per `.cursor/rules/atoms-molecules-versioning.mdc`).
