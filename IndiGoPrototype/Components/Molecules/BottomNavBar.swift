//
//  BottomNavBar.swift
//  IndiGoPrototype
//
//  Molecule – Bottom navigation bar ("Sticky Footer").
//
//  Figma node: 260:7239 (375 x 80)
//
//  Figma specs:
//    Sticky Footer: backdrop-blur 8px, bg rgba(255,255,255,0.12),
//                   pt 4, px 12, gap 12,
//                   shadow 0 0 28px rgba(0,0,153,0.04)
//    Nav Bar:       gap 4, shadow 0 0 12px rgba(0,0,153,0.16)
//    Menu Bar:      backdrop-blur 8px, bg rgba(255,255,255,0.9),
//                   radius 40, padding 4,
//                   shadow 0 4px 28px rgba(0,0,153,0.04)
//    Nav items:     56w x 44h (Check-in 53w), px 16, py 8, radius 40
//      Active:      bg white, shadow 0 0 12px rgba(0,0,153,0.16),
//                   icon/text #009
//      Inactive:    bg clear, icon/text #4B5772
//    Label:         Poppins Regular 10 / lineHeight 16
//    6EPick btn:    52 x 52, bg #25304B, radius 40,
//                   px 8, py 4, icon 20x20, label white 10pt
//    Safe area: native (not hardcoded; iOS handles home indicator inset)
//

import SwiftUI

// MARK: - Data model

enum NavTab: String, CaseIterable, Identifiable {
    case explore  = "Explore"
    case flights  = "Flights"
    case hello6E  = "Hello 6E"
    case checkIn  = "Check-in"

    var id: String { rawValue }

    /// Asset catalog image name (SVG, template-rendered for tinting)
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

    // Figma shadow colors
    private let shadowCardSoft = Color(hex: "000099").opacity(0.16)   // 0 0 12 #00009929
    private let shadowGlobalNav = Color(hex: "000099").opacity(0.04)  // 0 4 28 #0000990A
    private let shadowFooter = Color(hex: "000099").opacity(0.04)     // 0 0 28 #0000990A

    var body: some View {
        navBarRow
            .padding(.top, IndiGoSpacing.xs)            // pt 8
            .padding(.horizontal, IndiGoSpacing.sm)     // px 12
            .padding(.bottom, IndiGoSpacing.xs)         // pb 8
            .background(
                .ultraThinMaterial
            )
            .background(IndiGoColors.stickyFooterBg)
            .shadow(color: shadowFooter, radius: 14, x: 0, y: 0)
            .fixedSize(horizontal: false, vertical: true)
    }

    // MARK: - Nav Bar row (Menu Bar + 6EPick button)

    private var navBarRow: some View {
        HStack(spacing: IndiGoSpacing.xxs) { // gap 4
            menuBar
            sixEPickButton
        }
        .shadow(color: shadowCardSoft, radius: 6, x: 0, y: 0) // 0 0 12 → radius 6
    }

    // MARK: - Menu Bar (4 nav items inside pill, space-between)

    private var menuBar: some View {
        HStack(spacing: 0) {
            ForEach(NavTab.allCases) { tab in
                navItem(tab)
                    .frame(maxWidth: .infinity) // distribute evenly across pill width
            }
        }
        .padding(IndiGoSpacing.xxs) // padding 4
        .frame(maxWidth: .infinity)
        .background(
            // backdrop-blur 8px + bg rgba(255,255,255,0.9)
            ZStack {
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                    .fill(IndiGoColors.navBarBlur)
            }
        )
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl))
        .shadow(color: shadowGlobalNav, radius: 14, x: 0, y: 4) // 0 4 28 → radius 14
    }

    // MARK: - Single nav item

    private func navItem(_ tab: NavTab) -> some View {
        let isActive = selectedTab == tab

        return Button {
            withAnimation(.easeInOut(duration: 0.2)) {
                selectedTab = tab
            }
        } label: {
            VStack(spacing: 0) {
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
            .frame(height: 44)                          // match Figma height
            .frame(maxWidth: .infinity)                  // fill available width for larger tap target
            .background(
                Group {
                    if isActive {
                        RoundedRectangle(cornerRadius: IndiGoSpacing.radiusXxxl)
                            .fill(IndiGoColors.background)
                            .shadow(color: shadowCardSoft, radius: 6, x: 0, y: 0)
                            .frame(width: 56, height: 44) // visual highlight stays 56pt
                    }
                }
            )
        }
        .buttonStyle(.plain)
        .contentShape(Rectangle())                       // full-width tap area
    }

    // MARK: - 6EPick button

    private var sixEPickButton: some View {
        Button(action: on6EPickTap) {
            VStack(spacing: 0) {
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

// MARK: - Preview

#Preview {
    ZStack {
        Color(hex: "F5F5F5").ignoresSafeArea()
        VStack {
            Spacer()
            BottomNavBar(selectedTab: .constant(.explore))
        }
    }
}
