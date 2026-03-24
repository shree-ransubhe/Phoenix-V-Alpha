//
//  BottomNavBar.swift
//  IndiGoPrototype
//
//  Molecule – Bottom navigation bar ("Sticky Footer").
//
//  Figma node: 1166:10237
//
//  Figma v2 specs:
//    Menu Bar:      backdrop-blur 8px, bg rgba(255,255,255,0.8),
//                   radius 40, padding 4,
//                   shadow 0 4px 28px rgba(0,0,153,0.04)
//    Nav items:     60w x 44h, radius 40
//      Active:      liquid glass indicator (blur + refraction), icon/text #009
//      Inactive:    bg clear, icon/text #4B5772
//    6EPick btn:    52 x 52, bg #25304B, radius 40
//    Safe area:     native
//

import SwiftUI

// MARK: - Data model

enum NavTab: String, CaseIterable, Identifiable {
    case explore  = "Explore"
    case flights  = "Flights"
    case hello6E  = "Hello 6E"
    case checkIn  = "Check-in"

    var id: String { rawValue }

    var iconAsset: String {
        switch self {
        case .explore:  return "nav-explore"
        case .flights:  return "nav-flights"
        case .hello6E:  return "nav-hello6e"
        case .checkIn:  return "nav-checkin"
        }
    }
}

// MARK: - Bottom Nav Bar

struct BottomNavBar: View {
    @Binding var selectedTab: NavTab
    var on6EPickTap: () -> Void = {}

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
        .padding(IndiGoSpacing.xxs)
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

        return Button {
            HapticManager.selection()
            withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 2) {
                Image(tab.iconAsset)
                    .renderingMode(.template)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                Text(tab.rawValue)
                    .font(IndiGoFonts.navLabel())
                    .lineSpacing(0)
            }
            .foregroundStyle(isActive ? IndiGoColors.textIndigoBlue : IndiGoColors.textDarkGrey)
            .frame(width: 60, height: 44)
            .frame(maxWidth: .infinity)
            .background {
                if isActive {
                    LiquidGlassBlob()
                        .matchedGeometryEffect(id: "liquidGlass", in: glassNS)
                }
            }
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
            .foregroundStyle(.white)
            .frame(width: 52, height: 52)
            .background(
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(IndiGoColors.backgroundBase)
            )
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Liquid Glass Blob

/// A frosted-glass indicator that refracts whatever is behind it,
/// similar to the iOS 26 liquid glass / Zomato nav style.
/// Uses a real .ultraThinMaterial backdrop blur so content behind
/// shows through with distortion, plus layered gradients for
/// the specular highlight and edge refraction.
private struct LiquidGlassBlob: View {
    private let shape = RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)

    var body: some View {
        ZStack {
            // 1. Real backdrop blur -- this is the key layer that makes
            //    content behind the blob appear frosted/refracted
            shape
                .fill(.ultraThinMaterial)

            // 2. Tinted glass body -- very light white overlay so
            //    the blur reads as "glass" not just blurry
            shape
                .fill(Color.white.opacity(0.45))

            // 3. Specular highlight -- top-left light catch,
            //    fading to transparent at bottom-right
            shape
                .fill(
                    .radialGradient(
                        colors: [
                            Color.white.opacity(0.7),
                            Color.white.opacity(0.0)
                        ],
                        center: .topLeading,
                        startRadius: 0,
                        endRadius: 60
                    )
                )

            // 4. Rainbow refraction tint -- very subtle color shift
            //    across the blob (like light through a prism)
            shape
                .fill(
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

            // 5. Glass edge border -- thin bright stroke that catches
            //    light at the top and fades at the bottom
            shape
                .strokeBorder(
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

            // 6. Inner shadow / depth -- inset darker edge at bottom
            //    gives the blob a 3D raised feel
            shape
                .strokeBorder(
                    .linearGradient(
                        colors: [
                            Color.clear,
                            Color.black.opacity(0.04)
                        ],
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
