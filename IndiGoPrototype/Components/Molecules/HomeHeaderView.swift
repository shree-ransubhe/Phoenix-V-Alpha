//
//  HomeHeaderView.swift
//  IndiGoPrototype
//
//  Molecule – Home sticky header overlay with scroll-driven transitions.
//
//  Architecture (from Figma 804:10305 / 917:11177):
//    The BG image lives in HomeView, NOT in this view. This view is a
//    transparent overlay that pins to the top via scroll offset.
//
//  State 1 – Expanded (207pt, Figma 804:10305):
//    StatusBar(44) + gap(24) + GreetingRow(44, px24) + pb(16)
//    + SearchPill(60, px20)  — total content ~188pt inside 207pt frame
//    No shadow. Greeting row visible.
//
//  State 2 – Inline (139pt, Figma 917:11177):
//    StatusBar(44) + pb(16)
//    + InlineRow(search + 6eskai + profile, px20, gap12) — total ~120pt inside 139pt frame
//    Shadow visible. Greeting row collapsed.
//
//  Transition: over 68pt of scroll (207→139), greeting row fades/collapses
//  and search pill rearranges inline with 6eskai + profile.
//

import SwiftUI

struct HomeHeaderView: View {
    let scrollOffset: CGFloat
    var onSearchTap: () -> Void = {}

    static let expandedHeight: CGFloat = 207
    static let inlineHeight: CGFloat = 139
    static let collapseRange: CGFloat = expandedHeight - inlineHeight  // 68pt

    static func headerHeight(for offset: CGFloat) -> CGFloat {
        let clamped = max(0, offset)
        if clamped >= collapseRange { return inlineHeight }
        let t = clamped / collapseRange
        return expandedHeight - (expandedHeight - inlineHeight) * t
    }

    private var clampedOffset: CGFloat { max(0, scrollOffset) }

    var headerHeight: CGFloat {
        Self.headerHeight(for: clampedOffset)
    }

    private var collapseProgress: CGFloat {
        min(1, max(0, clampedOffset / Self.collapseRange))
    }

    private var isInlineMode: Bool { collapseProgress >= 1.0 }

    private var showShadow: Bool { clampedOffset > 2 }

    var body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 44)

            if !isInlineMode {
                Spacer().frame(height: 24 * (1 - collapseProgress))

                greetingRow
                    .padding(.horizontal, 24)
                    .frame(height: 44 * (1 - collapseProgress))
                    .opacity(Double(1 - collapseProgress))
                    .clipped()

                Spacer().frame(height: 16 * (1 - collapseProgress))
            } else {
                Spacer().frame(height: 16)
            }

            if isInlineMode {
                SearchWidgetView(mode: .inline, onTap: onSearchTap)
                    .padding(.horizontal, 20)
            } else if collapseProgress > 0.5 {
                SearchWidgetView(mode: .inline, onTap: onSearchTap)
                    .padding(.horizontal, 20)
                    .opacity(Double((collapseProgress - 0.5) / 0.5))
            } else {
                SearchWidgetView(mode: .expanded, onTap: onSearchTap)
                    .padding(.horizontal, 20)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight)
        .background(headerBg)
        .shadow(
            color: showShadow ? .black.opacity(0.25) : .clear,
            radius: 8, x: 0, y: 4
        )
    }

    private var headerBg: some View {
        ZStack {
            if showShadow {
                Rectangle().fill(.ultraThinMaterial)
                    .opacity(Double(min(1, clampedOffset / 40)))
            } else {
                Color.clear
            }
        }
    }

    // MARK: - Greeting row

    private var greetingRow: some View {
        HStack {
            HStack(spacing: 12) {
                Image("dotted-plane")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 28, height: 28)
                    .foregroundStyle(IndiGoColors.backgroundBase)

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

    private var sixEskaiButton: some View {
        Button(action: {}) {
            Image("6eskai-entry")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)
        }
        .buttonStyle(.plain)
    }

    private var avatarButton: some View {
        Image("profile-avatar")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 32, height: 32)
            .clipShape(Circle())
            .overlay(Circle().strokeBorder(.white, lineWidth: 1))
    }
}

#Preview("Expanded – 207pt") {
    ZStack {
        Image("light-header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack(spacing: 0) {
            HomeHeaderView(scrollOffset: 0)
            Spacer()
        }
    }
    .ignoresSafeArea(edges: .top)
}

#Preview("Inline – 139pt") {
    ZStack {
        Image("light-header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack(spacing: 0) {
            HomeHeaderView(scrollOffset: 100)
            Spacer()
        }
    }
    .ignoresSafeArea(edges: .top)
}
