//
//  HomeHeaderView.swift
//  IndiGoPrototype
//
//  Molecule – Home header banner with scroll-driven transitions.
//
//  Layout from Figma (375pt design):
//    Expanded (428pt) – 3:9846:  StickyHeader(status44+gap24+greeting44+pb16) → gap24 → SearchPill(h60,px20) → gap24 → WelcomeComm → clipped
//    Compact  (207pt) – 3:6770:  StickyHeader → gap24 → SearchPill (welcome cropped away)
//    Inline   (139pt) – 3:7803:  StatusBar(44) → SearchPill+6Eskai+Profile in one row (px20, gap10)
//
//  The header height interpolates continuously from 428→139 as scrollOffset increases.
//  At 428→207 the welcome-comm is progressively clipped.
//  At 207→139 the greeting row collapses and search pill rearranges inline.
//

import SwiftUI

struct HomeHeaderView: View {
    let scrollOffset: CGFloat
    var onSearchTap: () -> Void = {}

    // Figma heights
    static let expandedHeight: CGFloat = 428
    static let compactHeight: CGFloat = 207
    static let inlineHeight: CGFloat = 139

    // Scroll ranges for each transition phase
    static let phase1Range: CGFloat = 180   // 428 → 207 over 180pt of scroll
    static let phase2Range: CGFloat = 80    // 207 → 139 over next 80pt of scroll
    static let totalCollapseRange: CGFloat = phase1Range + phase2Range

    static func headerHeight(for offset: CGFloat) -> CGFloat {
        let clamped = max(0, offset)
        if clamped <= phase1Range {
            let t = clamped / phase1Range
            return expandedHeight - (expandedHeight - compactHeight) * t
        }
        let p2 = clamped - phase1Range
        if p2 <= phase2Range {
            let t = p2 / phase2Range
            return compactHeight - (compactHeight - inlineHeight) * t
        }
        return inlineHeight
    }

    private var clampedOffset: CGFloat { max(0, scrollOffset) }

    var headerHeight: CGFloat {
        Self.headerHeight(for: clampedOffset)
    }

    // Progress values (0→1) for each phase
    private var phase1Progress: CGFloat {
        min(1, max(0, clampedOffset / Self.phase1Range))
    }
    private var phase2Progress: CGFloat {
        let p2 = clampedOffset - Self.phase1Range
        return min(1, max(0, p2 / Self.phase2Range))
    }

    private var isInlineMode: Bool { phase2Progress >= 1.0 }

    var body: some View {
        VStack(spacing: 0) {
            // Status bar (always 44pt)
            statusBarSpacer

            // Gap between status bar and greeting (24pt, collapses to 16pt in phase 2)
            let topGap = 24 - (8 * phase2Progress)
            Spacer().frame(height: topGap)

            // Greeting row (44pt, collapses during phase 2)
            if !isInlineMode {
                greetingRow
                    .padding(.horizontal, 24)
                    .frame(height: 44 * (1 - phase2Progress))
                    .opacity(Double(1 - phase2Progress))
                    .clipped()

                // Padding-bottom from sticky-header (16pt, collapses in phase 2)
                Spacer().frame(height: 16 * (1 - phase2Progress))
            }

            // Search section
            if isInlineMode {
                inlineRow
                    .padding(.horizontal, 20)
            } else if phase2Progress > 0 {
                inlineRow
                    .padding(.horizontal, 20)
                    .opacity(Double(phase2Progress))
            } else {
                // Full-width search pill (states 1 & 2)
                searchPill
                    .padding(.horizontal, 20)

                // Welcome comm (fades during phase 1, cropped by container)
                welcomeComm
                    .padding(.top, 24)
                    .opacity(Double(1 - phase1Progress))
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight)
        .background(bgLayer)
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16
            )
        )
        .shadow(
            color: isInlineMode ? .black.opacity(0.25) : .clear,
            radius: 8, x: 0, y: 4
        )
    }

    // MARK: - Status bar spacer (44pt for Dynamic Island / notch)

    private var statusBarSpacer: some View {
        Color.clear.frame(height: 44)
    }

    // MARK: - Greeting row: dotted-plane + "Hi there! / Ishika Verma" ... 6Eskai + Profile

    private var greetingRow: some View {
        HStack {
            HStack(spacing: 12) {
                Image("dotted-plane")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Hi there!")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(IndiGoColors.backgroundBase)
                    Text("Ishika Verma")
                        .font(IndiGoFonts.buttonWeb())
                        .foregroundStyle(IndiGoColors.backgroundBase)
                }
            }

            Spacer()

            HStack(spacing: 16) {
                sixEskaiButton
                avatarButton
            }
        }
        .frame(height: 44)
    }

    // MARK: - Full-width search pill (expanded & compact states)

    private var searchPill: some View {
        SearchWidgetView(
            mode: phase1Progress < 0.3 ? .expanded : .compact,
            onTap: onSearchTap
        )
    }

    // MARK: - Inline row (state 3): search pill + 6Eskai + avatar all in one row

    private var inlineRow: some View {
        SearchWidgetView(mode: .inline, onTap: onSearchTap)
    }

    // MARK: - Welcome comm section (Figma 3:9917 — 313x147, gap 24)

    private var welcomeComm: some View {
        VStack(alignment: .leading, spacing: 24) {
            VStack(alignment: .leading, spacing: 0) {
                Text("Athens, now boarding!")
                    .font(IndiGoFonts.displaySmall())       // Bauhaus Std Medium 24/32
                    .foregroundStyle(IndiGoColors.backgroundBase)
                    .tracking(-0.6)
                    .frame(width: 224, alignment: .leading)

                Text("Introducing, XLR Experience with non-stop flights between India and Greece.")
                    .font(IndiGoFonts.bodySmall())           // Poppins Regular 12/18
                    .foregroundStyle(IndiGoColors.backgroundBase)
            }
            .frame(width: 313, height: 115, alignment: .topLeading)

            pageIndicator
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 31)
    }

    // Figma 3:9921 — 303x8, pill 20x8, dots 8x8, gap 4
    private var pageIndicator: some View {
        HStack(spacing: 4) {
            RoundedRectangle(cornerRadius: 4)
                .fill(IndiGoColors.indigoBlue)
                .frame(width: 20, height: 8)
            Circle()
                .fill(IndiGoColors.indigoBlue.opacity(0.3))
                .frame(width: 8, height: 8)
            Circle()
                .fill(IndiGoColors.indigoBlue.opacity(0.3))
                .frame(width: 8, height: 8)
        }
        .frame(height: 8)
    }

    // MARK: - BG layer

    private var bgLayer: some View {
        ZStack {
            Image("header-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()

            LinearGradient(
                stops: [
                    .init(color: .white.opacity(0.0), location: 0.33),
                    .init(color: .white.opacity(0.5), location: 0.60)
                ],
                startPoint: .bottom,
                endPoint: .top
            )

            LinearGradient(
                stops: [
                    .init(color: .white.opacity(0.1), location: 0.65),
                    .init(color: .clear, location: 0.87)
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )

            LinearGradient(
                stops: [
                    .init(color: .clear, location: 0.44),
                    .init(color: .black.opacity(0.1), location: 0.69)
                ],
                startPoint: .topTrailing,
                endPoint: .bottomLeading
            )
        }
    }

    // MARK: - Shared buttons

    private var sixEskaiButton: some View {
        Button(action: {}) {
            Image("6eskai-entry")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)
        }
        .buttonStyle(.plain)
    }

    private var avatarButton: some View {
        Image("profile-avatar")
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: 36, height: 36)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(.white, lineWidth: 1))
    }
}

// MARK: - Previews

#Preview("Expanded – 428pt") {
    VStack(spacing: 0) {
        HomeHeaderView(scrollOffset: 0)
        Spacer()
    }
    .ignoresSafeArea(edges: .top)
}

#Preview("Compact – 207pt") {
    VStack(spacing: 0) {
        HomeHeaderView(scrollOffset: 180)
        Spacer()
    }
    .ignoresSafeArea(edges: .top)
}

#Preview("Inline – 139pt") {
    VStack(spacing: 0) {
        HomeHeaderView(scrollOffset: 300)
        Spacer()
    }
    .ignoresSafeArea(edges: .top)
}
