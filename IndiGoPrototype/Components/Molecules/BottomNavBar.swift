//
//  BottomNavBar.swift
//  IndiGoPrototype
//
//  Molecule – Bottom navigation bar ("Sticky Footer").
//
//  Figma nodes: 1166:10237 (Alpha 5.0), 5658:77842 (Alpha 6.1)
//
//  Theme-driven properties:
//    navShowsLiquidGlass      – liquid glass blob behind active tab (5.0) vs flat (6.1)
//    navActiveExploreIconAsset – outline (5.0) vs filled (6.1)
//    navActiveLabelFont       – regular (5.0) vs semi-bold (6.1)
//    navActiveTextColor       – indigo-blue (5.0) vs base-dark (6.1)
//    navActiveShadowColor/Radius – none (5.0) vs card-soft (6.1)
//    navSixEPickBg/FgColor    – dark bg + white text (5.0) vs glass bg + blue text (6.1)
//    navFourthTabLabel/Icon   – Check-in (5.0) vs My trips (6.1)
//

import SwiftUI

// MARK: - Data model

enum NavTab: CaseIterable, Identifiable {
    case explore
    case flights
    case hello6E
    case fourthTab

    var id: String {
        switch self {
        case .explore:   return "explore"
        case .flights:   return "flights"
        case .hello6E:   return "hello6E"
        case .fourthTab: return "fourthTab"
        }
    }

    func label(theme: any AlphaTheme) -> String {
        switch self {
        case .explore:   return "Explore"
        case .flights:   return "Flights"
        case .hello6E:   return "Hello 6E"
        case .fourthTab: return theme.navFourthTabLabel
        }
    }

    func iconAsset(theme: any AlphaTheme, isActive: Bool) -> String {
        switch self {
        case .explore:   return isActive ? theme.navActiveExploreIconAsset : "nav-explore"
        case .flights:   return isActive ? theme.navActiveFlightsIconAsset : "nav-flights"
        case .hello6E:   return "nav-hello6e"
        case .fourthTab: return theme.navFourthTabIcon
        }
    }

    func usesOriginalRendering(theme: any AlphaTheme, isActive: Bool) -> Bool {
        if !theme.navShowsLiquidGlass {
            if self == .explore && isActive { return true }
            if self == .flights && isActive { return true }
            if self == .fourthTab && theme.navFourthTabIconIsOriginal { return true }
        }
        return false
    }
}

// MARK: - Bottom Nav Bar

struct BottomNavBar: View {
    @Binding var selectedTab: NavTab
    var on6EPickTap: () -> Void = {}

    @Environment(\.alphaTheme) private var theme
    @Namespace private var glassNS

    private let shadowGlobalNav = Color(hex: "000099").opacity(0.04)
    private let shadowFooter = Color(hex: "000099").opacity(0.04)

    var body: some View {
        navBarRow
            .padding(.top, IndiGoSpacing.xs)
            .padding(.horizontal, IndiGoSpacing.sm)
            .padding(.bottom, IndiGoSpacing.xs)
            .background(.ultraThinMaterial)
            .background(IndiGoColors.stickyFooterBg)
            .shadow(color: shadowFooter, radius: 14, x: 0, y: 0)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Nav Bar row

    private var navBarRow: some View {
        HStack(spacing: IndiGoSpacing.xxs) {
            menuBar
            sixEPickButton
        }
    }

    // MARK: - Menu Bar

    private var menuBar: some View {
        HStack(spacing: 0) {
            ForEach(NavTab.allCases) { tab in
                navItem(tab)
                    .frame(maxWidth: .infinity)
            }
        }
        .padding(.leading, IndiGoSpacing.xxs)
        .padding(.trailing, IndiGoSpacing.xs)
        .padding(.vertical, IndiGoSpacing.xxs)
        .frame(maxWidth: .infinity)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(IndiGoColors.navBarBlur)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl))
        .shadow(color: shadowGlobalNav, radius: 14, x: 0, y: 4)
    }

    // MARK: - Single nav item

    private func navItem(_ tab: NavTab) -> some View {
        let isActive = selectedTab == tab
        let asset = tab.iconAsset(theme: theme, isActive: isActive)
        let usesOriginal = tab.usesOriginalRendering(theme: theme, isActive: isActive)

        return Button {
            HapticManager.selection()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 2) {
                Group {
                    if usesOriginal {
                        Image(asset)
                            .renderingMode(.original)
                            .resizable()
                            .scaledToFit()
                    } else {
                        Image(asset)
                            .renderingMode(.template)
                            .resizable()
                            .scaledToFit()
                    }
                }
                .frame(width: 20, height: 20)

                Text(tab.label(theme: theme))
                    .font(isActive ? theme.navActiveLabelFont : theme.navInactiveLabelFont)
                    .lineSpacing(0)
            }
            .foregroundStyle(isActive ? theme.navActiveTextColor : theme.navInactiveTextColor)
            .frame(width: isActive ? 60 : 56, height: 44)
            .frame(maxWidth: .infinity)
            .background {
                if isActive && theme.navShowsLiquidGlass {
                    LiquidGlassBlob()
                        .matchedGeometryEffect(id: "liquidGlass", in: glassNS)
                }
            }
            .shadow(
                color: isActive ? theme.navActiveShadowColor : .clear,
                radius: isActive ? theme.navActiveShadowRadius : 0,
                x: 0, y: 0
            )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())
    }

    // MARK: - 6EPick button

    private var sixEPickButton: some View {
        Button(action: {
            HapticManager.mediumImpact()
            on6EPickTap()
        }) {
            VStack(spacing: 2) {
                Image("nav-6epick")
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text("6EPick")
                    .font(IndiGoFonts.navLabel())
                    .lineSpacing(0)
                    .frame(maxWidth: .infinity)
            }
            .foregroundStyle(theme.navSixEPickFgColor)
            .frame(width: 52, height: 52)
            .background(
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(theme.navSixEPickBgColor)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Liquid Glass Blob

/// Frosted-glass indicator (Alpha 4.1 / 5.0 only).
/// Uses real .ultraThinMaterial backdrop blur + layered gradients.
private struct LiquidGlassBlob: View {
    private let shape = RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)

    var body: some View {
        ZStack {
            shape.fill(.ultraThinMaterial)
            shape.fill(Color.white.opacity(0.45))
            shape.fill(
                .radialGradient(
                    colors: [Color.white.opacity(0.7), Color.white.opacity(0.0)],
                    center: .topLeading,
                    startRadius: 0,
                    endRadius: 60
                )
            )
            shape.fill(
                .linearGradient(
                    colors: [
                        Color(hex: "E8D5F5").opacity(0.15),
                        Color(hex: "D5E8F5").opacity(0.10),
                        Color(hex: "F5E8D5").opacity(0.12)
                    ],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            )
            shape.strokeBorder(
                .linearGradient(
                    colors: [
                        Color.white.opacity(0.9),
                        Color.white.opacity(0.3),
                        Color.white.opacity(0.15)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 0.75
            )
            shape.strokeBorder(
                .linearGradient(
                    colors: [Color.clear, Color.black.opacity(0.04)],
                    startPoint: .top,
                    endPoint: .bottom
                ),
                lineWidth: 1.5
            )
            .padding(0.75)
        }
        .frame(width: 60, height: 44)
        .shadow(color: Color.white.opacity(0.5), radius: 4, x: 0, y: 0)
        .shadow(color: Color.black.opacity(0.06), radius: 8, x: 0, y: 2)
    }
}

// MARK: - Preview

#Preview("Over dark content") {
    ZStack {
        LinearGradient(
            colors: [Color(hex: "25304B"), Color(hex: "3D4A6B")],
            startPoint: .top,
            endPoint: .bottom
        )
        .ignoresSafeArea()

        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.orange.opacity(0.9))
                    .frame(height: 120)
                    .overlay { Text("Card A").foregroundStyle(.white) }
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.green.opacity(0.9))
                    .frame(height: 120)
                    .overlay { Text("Card B").foregroundStyle(.white) }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 4)

            BottomNavBar(selectedTab: .constant(.explore))
        }
    }
}

#Preview("Over light content") {
    ZStack {
        Color.white.ignoresSafeArea()

        VStack(spacing: 0) {
            Spacer()

            HStack(spacing: 12) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.red.opacity(0.7))
                    .frame(height: 120)
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.blue.opacity(0.7))
                    .frame(height: 120)
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 4)

            BottomNavBar(selectedTab: .constant(.flights))
        }
    }
}
