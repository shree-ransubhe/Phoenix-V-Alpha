//
//  HomeHeaderView.swift
//  IndiGoPrototype
//
//  Molecule – Home sticky header overlay with scroll-driven transitions.
//
//  Architecture:
//    The BG image lives in HomeView, NOT in this view. This view is a
//    transparent overlay that pins to the top via scroll offset.
//
//  Alpha 4.1/5.0 (Figma 804:10305 / 917:11177):
//    Expanded 207pt → Inline 139pt (68pt collapse range)
//    GreetingRow fades, search pill goes inline with 6eskai + avatar.
//
//  Alpha 6.1 (Figma 5602:84907 / 5602:84926 / 5656:57938):
//    Expanded 224pt → Inline 124pt (100pt collapse range)
//    StatusBar(44) + HeaderRow(48) + LOBTabs(44) + gap(16) + SearchBar(56) + gap(16)
//    Inline: StatusBar(44) + gap(12) + SearchRow(56) + gap(12)
//    HeaderRow and LOBTabs collapse away on scroll.
//

import SwiftUI

struct HomeHeaderView: View {
    let scrollOffset: CGFloat
    var onSearchTap: () -> Void = {}
    var onProfileTap: () -> Void = {}
    var onMoreTap: () -> Void = {}
    @Environment(\.alphaTheme) private var theme

    static let expandedHeight: CGFloat = ThemeProvider.current.headerExpandedHeight
    static let inlineHeight: CGFloat = ThemeProvider.current.headerInlineHeight
    static let collapseRange: CGFloat = ThemeProvider.current.headerCollapseRange

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
        if theme.searchShowsLOBTabs {
            alpha61Body
        } else {
            legacyBody
        }
    }

    // MARK: - Alpha 6.1 body (Figma 5602:84907)

    private var alpha61Body: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: theme.headerStatusBarHeight)

            if !isInlineMode {
                alpha61HeaderRow
                    .padding(.horizontal, theme.headerHorizontalPadding)
                    .frame(height: theme.headerGreetingRowHeight * (1 - collapseProgress))
                    .opacity(Double(1 - collapseProgress))
                    .clipped()

                LOBTabBar(selectedTab: "Flights", onMoreTap: onMoreTap)
                    .frame(height: 44 * (1 - collapseProgress))
                    .opacity(Double(1 - collapseProgress))
                    .clipped()

                Spacer().frame(height: theme.headerBottomPadding * (1 - collapseProgress))
            } else {
                Spacer().frame(height: 12)
            }

            if isInlineMode {
                SearchWidgetView(mode: .inline, onTap: onSearchTap, onProfileTap: onProfileTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
            } else if collapseProgress > 0.5 {
                SearchWidgetView(mode: .inline, onTap: onSearchTap, onProfileTap: onProfileTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
                    .opacity(Double((collapseProgress - 0.5) / 0.5))
            } else {
                SearchWidgetView(mode: .expanded, onTap: onSearchTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight)
        .background(alpha61HeaderBg)
        .shadow(
            color: showShadow ? .black.opacity(0.25) : .clear,
            radius: 8, x: 0, y: 4
        )
    }

    // MARK: - Alpha 6.1 header row (Figma 5602:84909)
    // IndiGo Logo (24x24) + "Hi Ishika!" + 6Eskai + Avatar

    private var alpha61HeaderRow: some View {
        HStack {
            HStack(spacing: 12) {
                Image("dotted-plane")
                    .resizable()
                    .renderingMode(.template)
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 24, height: 24)
                    .foregroundStyle(IndiGoColors.indigoBlue)

                Text("Hi Ishika!")
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(Color(hex: "25304B"))
                    .lineLimit(1)
            }

            Spacer()

            HStack(spacing: 16) {
                SixEskaiButton()
                alpha61AvatarButton
            }
        }
        .padding(.vertical, 12)
    }

    private var alpha61AvatarButton: some View {
        Button(action: onProfileTap) {
            Image("icon-avatar-person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    private var alpha61HeaderBg: some View {
        ZStack {
            if showShadow {
                Color.white
                    .opacity(Double(min(1, clampedOffset / 40)))
            } else {
                Color.clear
            }
        }
    }

    // MARK: - Legacy 4.1/5.0 body

    private var legacyBody: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: theme.headerStatusBarHeight)

            if !isInlineMode {
                Spacer().frame(height: theme.headerTopGap * (1 - collapseProgress))

                legacyGreetingRow
                    .padding(.horizontal, theme.headerHorizontalPadding)
                    .frame(height: theme.headerGreetingRowHeight * (1 - collapseProgress))
                    .opacity(Double(1 - collapseProgress))
                    .clipped()

                Spacer().frame(height: theme.headerBottomPadding * (1 - collapseProgress))
            } else {
                Spacer().frame(height: theme.headerBottomPadding)
            }

            if isInlineMode {
                SearchWidgetView(mode: .inline, onTap: onSearchTap, onProfileTap: onProfileTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
            } else if collapseProgress > 0.5 {
                SearchWidgetView(mode: .inline, onTap: onSearchTap, onProfileTap: onProfileTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
                    .opacity(Double((collapseProgress - 0.5) / 0.5))
            } else {
                SearchWidgetView(mode: .expanded, onTap: onSearchTap)
                    .padding(.horizontal, theme.headerSearchHorizontalPadding)
            }

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
        .frame(height: headerHeight)
        .background(legacyHeaderBg)
        .shadow(
            color: showShadow ? .black.opacity(0.25) : .clear,
            radius: theme.headerShadowRadius, x: 0, y: theme.headerShadowY
        )
    }

    private var legacyHeaderBg: some View {
        ZStack {
            if showShadow {
                Rectangle().fill(.ultraThinMaterial)
                    .opacity(Double(min(1, clampedOffset / 40)))
            } else {
                Color.clear
            }
        }
    }

    // MARK: - Legacy greeting row (4.1/5.0)

    private var legacyGreetingRow: some View {
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
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(IndiGoColors.backgroundBase)
                    Text("Ishika Verma")
                        .font(IndiGoFonts.buttonWeb())
                        .foregroundStyle(IndiGoColors.backgroundBase)
                }
            }

            Spacer()

            HStack(spacing: 16) {
                SixEskaiButton()
                legacyAvatarButton
            }
        }
        .frame(height: 44)
    }

    private var legacyAvatarButton: some View {
        Button(action: onProfileTap) {
            Image("profile-avatar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - LOB Tab Bar (Alpha 6.1, Figma 5602:88589)

struct LOBTabBar: View {
    let selectedTab: String
    var onMoreTap: () -> Void = {}

    private let tabs = ["Flights", "Hotels", "Cabs", "Sightseeing", "More"]

    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs, id: \.self) { tab in
                if tab == "More" {
                    Button(action: onMoreTap) {
                        tabLabel(tab, isSelected: tab == selectedTab)
                    }
                    .buttonStyle(.plain)
                } else {
                    tabLabel(tab, isSelected: tab == selectedTab)
                }
            }
        }
        .padding(.horizontal, 16)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(IndiGoColors.indigoBlue.opacity(0.1))
                .frame(height: 1)
        }
    }

    private func tabLabel(_ title: String, isSelected: Bool) -> some View {
        VStack(spacing: 0) {
            Text(title)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundStyle(isSelected ? Color(hex: "25304B") : IndiGoColors.indigoBlue)
                .frame(height: 44)
                .frame(maxWidth: .infinity)

            Rectangle()
                .fill(isSelected ? Color(hex: "25304B") : Color.clear)
                .frame(height: 2)
        }
    }
}

// MARK: - Previews

#Preview("Expanded – Legacy") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack(spacing: 0) {
            HomeHeaderView(scrollOffset: 0)
            Spacer()
        }
    }
    .ignoresSafeArea(edges: .top)
}

#Preview("Expanded – Alpha 6.1") {
    VStack(spacing: 0) {
        HomeHeaderView(scrollOffset: 0)
        Spacer()
    }
    .background(Color(hex: "F5F8FC"))
    .ignoresSafeArea(edges: .top)
    .environment(\.alphaTheme, Alpha61Theme())
}

#Preview("Inline – Alpha 6.1") {
    VStack(spacing: 0) {
        HomeHeaderView(scrollOffset: 200)
        Spacer()
    }
    .background(Color(hex: "F5F8FC"))
    .ignoresSafeArea(edges: .top)
    .environment(\.alphaTheme, Alpha61Theme())
}
