import SwiftUI

/// Compare Fares bottom sheet – reference-only (no selection CTA).
/// Figma: node 3:8916 (full sheet), 3:8917 (container),
///        3:8919 (segmented tab), 3:9069 / 1167:10666 (fare cards).
struct CompareFaresBottomSheet: View {
    @Binding var isPresented: Bool
    @State private var selectedTab: TabType = .economy
    @State private var selectedIndex: Int = 1
    @State private var dragOffset: CGFloat = 0

    enum TabType: String, CaseIterable {
        case stretch = "Stretch"
        case economy = "Economy"
    }

    private var currentFamilies: [FareFamily] {
        switch selectedTab {
        case .stretch: return [.stretchRegular, .stretchPlus]
        case .economy: return [.saver, .flexi, .upfront]
        }
    }

    private let cardWidth: CGFloat = 160

    var body: some View {
        VStack(spacing: 0) {
            sheetHandle
                .padding(.top, 16)
                .padding(.bottom, 20)

            fareToggle
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            fareCarousel
                .id(selectedTab)
                .transition(.opacity.combined(with: .scale(scale: 0.97)))
                .frame(height: 310)
                .padding(.bottom, 8)
        }
        .frame(maxWidth: .infinity, alignment: .top)
        .background(.white)
        .animation(.easeInOut(duration: 0.3), value: selectedTab)
    }

    // MARK: - Sheet Handle (Figma 3:8918)

    private var sheetHandle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "7A85A0"))
            .frame(width: 40, height: 4)
    }

    // MARK: - Segmented Tab (Economy: 3:8919, Stretch: 1167:10587)

    private var toggleActivePillColor: Color {
        selectedTab == .stretch ? IndiGoColors.stretchGold : IndiGoColors.primaryMain
    }

    private var toggleTrackColor: Color {
        selectedTab == .stretch ? Color(hex: "ECF9FF") : Color(hex: "FFF9EB")
    }

    private var fareToggle: some View {
        HStack(spacing: 0) {
            ForEach(TabType.allCases, id: \.rawValue) { tab in
                Button {
                    HapticManager.selection()
                    withAnimation(.spring(response: 0.3)) {
                        selectedTab = tab
                        selectedIndex = tab == .economy ? 1 : 0
                    }
                } label: {
                    Text(tab.rawValue)
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(selectedTab == tab ? .white : IndiGoColors.primaryMain)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 8)
                        .background(
                            selectedTab == tab
                                ? toggleActivePillColor
                                : .clear
                        )
                        .clipShape(Capsule())
                        .overlay(
                            selectedTab == tab
                                ? Capsule()
                                    .strokeBorder(IndiGoColors.secondaryLight, lineWidth: 1)
                                : nil
                        )
                        .shadow(
                            color: selectedTab == tab
                                ? Color(hex: "4C5D9E").opacity(0.08)
                                : .clear,
                            radius: 6, x: 0, y: 0
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(4)
        .background(toggleTrackColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(IndiGoColors.srpCardBorder, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.25), value: selectedTab)
    }

    // MARK: - Swipeable Fare Carousel

    private var fareCarousel: some View {
        let families = currentFamilies
        let count = families.count
        let step = cardWidth - 20

        return ZStack {
            ForEach(Array(families.enumerated()), id: \.element.id) { index, family in
                let baseOffset = CGFloat(index - selectedIndex) * step
                let offset = baseOffset + dragOffset
                let normalizedDist = min(abs(offset) / step, 1.0)
                let isActive = index == selectedIndex && abs(dragOffset) < 20

                CompareFareCard(
                    family: family,
                    isActive: isActive,
                    isStretch: selectedTab == .stretch,
                    accentColor: selectedTab == .stretch ? IndiGoColors.stretchGold : IndiGoColors.secondaryBright,
                    badgeBg: badgeBgColor(for: family),
                    badgeTextColor: badgeTextColor(for: family)
                )
                .frame(width: cardWidth)
                .scaleEffect(isActive ? 1.0 : 0.88 - normalizedDist * 0.04)
                .opacity(isActive ? 1.0 : 0.7 - normalizedDist * 0.15)
                .rotation3DEffect(
                    .degrees(offset == 0 ? 0 : (offset < 0 ? 15 : -15)),
                    axis: (x: 0, y: 1, z: 0),
                    perspective: 0.5
                )
                .offset(x: offset)
                .zIndex(isActive ? 10 : Double(count - abs(index - selectedIndex)))
                .onTapGesture {
                    guard index != selectedIndex else { return }
                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedIndex = index
                        dragOffset = 0
                    }
                }
                .animation(.spring(response: 0.4, dampingFraction: 0.8), value: selectedIndex)
            }
        }
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
        .gesture(
            DragGesture()
                .onChanged { value in
                    dragOffset = value.translation.width
                }
                .onEnded { value in
                    let threshold: CGFloat = 40
                    let velocity = value.predictedEndTranslation.width - value.translation.width
                    var newIndex = selectedIndex

                    if value.translation.width < -threshold || velocity < -100 {
                        newIndex = min(selectedIndex + 1, count - 1)
                    } else if value.translation.width > threshold || velocity > 100 {
                        newIndex = max(selectedIndex - 1, 0)
                    }

                    if newIndex != selectedIndex {
                        HapticManager.selection()
                    }

                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedIndex = newIndex
                        dragOffset = 0
                    }
                }
        )
    }

    // MARK: - Badge (subtitle strap) colors
    // Economy: Bright Blue #00AEE5, Stretch/Stetch+: Light Gold #FFF8E3

    private func badgeBgColor(for family: FareFamily) -> Color {
        switch family {
        case .superSaver, .saver, .flexi, .upfront:
            return IndiGoColors.secondaryBright
        case .stretchRegular, .stretchPlus, .premiumBusiness:
            return Color(hex: "FFF8E3")
        }
    }

    private func badgeTextColor(for family: FareFamily) -> Color {
        switch family {
        case .stretchRegular, .stretchPlus, .premiumBusiness:
            return IndiGoColors.stretchGold
        default: return .white
        }
    }
}

// MARK: - Compare Fare Card (content-hugging, no fixed height)

private struct CompareFareCard: View {
    let family: FareFamily
    let isActive: Bool
    let isStretch: Bool
    let accentColor: Color
    let badgeBg: Color
    let badgeTextColor: Color

    private var price: Int {
        switch family {
        case .superSaver: return 3500
        case .saver: return 5088
        case .flexi: return 5210
        case .upfront: return 7888
        case .stretchRegular: return 28587
        case .stretchPlus, .premiumBusiness: return 29003
        }
    }

    private var borderColor: Color {
        if isStretch {
            return isActive ? IndiGoColors.stretchGold : IndiGoColors.srpCardBorder
        }
        return isActive ? IndiGoColors.secondaryBright : IndiGoColors.srpCardBorder
    }

    var body: some View {
        VStack(spacing: 0) {
            headerSection
            perksSection
                .padding(.top, 12)
            dividerLine
                .padding(.top, 10)
            pricingSection
                .padding(.top, 8)
        }
        .padding(.vertical, 12)
        .frame(maxWidth: .infinity)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .stroke(borderColor, lineWidth: isActive ? 2 : 1)
        )
        .shadow(
            color: isActive
                ? Color(hex: "4C5D9E").opacity(0.25)
                : Color(hex: "000000").opacity(0.08),
            radius: isActive ? 16.7 : 8,
            x: 0,
            y: isActive ? 0 : 8
        )
    }

    private var headerSection: some View {
        VStack(spacing: 9) {
            Text(family.rawValue)
                .font(.custom("BauhausStd-Medium", size: 16))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Text(family.subtitle)
                .font(IndiGoFonts.bodySmallMedium())
                .foregroundStyle(badgeTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)
                .background(badgeBg)
        }
    }

    private var perksSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            perkRow(perkKey: "cabin", boldText: family.cabinBag, regularText: "Cabin bag")
            perkRow(perkKey: "checkin", boldText: family.checkinBag, regularText: "Checkin bag")

            ForEach(family.perks, id: \.self) { perk in
                let parts = splitPerk(perk)
                perkRow(perkKey: perk, boldText: parts.bold, regularText: parts.regular)
            }
        }
        .padding(.horizontal, 8)
    }

    private func perkRow(perkKey: String, boldText: String, regularText: String) -> some View {
        let iconColor = isStretch ? IndiGoColors.stretchGold : IndiGoColors.accentDark
        return HStack(spacing: 2) {
            perkIconView(for: perkKey, color: iconColor)
                .frame(width: 18, height: 18)
                .frame(width: 22, height: 22)

            (
                Text(boldText)
                    .font(IndiGoFonts.bodySmallMedium())
                    .foregroundColor(IndiGoColors.forYouTextPrimary)
                +
                Text(" " + regularText)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundColor(IndiGoColors.forYouTextSecondary)
            )
            .lineLimit(1)
            .minimumScaleFactor(0.85)
        }
        .frame(height: 22)
    }

    @ViewBuilder
    private func perkIconView(for key: String, color: Color) -> some View {
        let lower = key.lowercased()
        if lower.contains("cabin") {
            FarePerkIcons.CabinBag(color: color)
        } else if lower.contains("checkin") {
            FarePerkIcons.CheckinBag(color: color)
        } else if lower.contains("forward") || lower.contains("fast") {
            FarePerkIcons.FastForward(color: color)
        } else if lower.contains("meal") || lower.contains("veg") {
            FarePerkIcons.Meal(color: color)
        } else if lower.contains("seat") {
            FarePerkIcons.Seat(color: color)
        } else if lower.contains("cancel") {
            FarePerkIcons.Cancellation(color: color)
        } else if lower.contains("change") || lower.contains("date") {
            FarePerkIcons.PlanChange(color: color)
        } else if lower.contains("plan") {
            FarePerkIcons.PlanChange(color: color)
        } else {
            FarePerkIcons.CabinBag(color: color)
        }
    }

    private var dividerLine: some View {
        Rectangle()
            .fill(IndiGoColors.secondaryMain)
            .frame(height: 1)
    }

    private var pricingSection: some View {
        VStack(spacing: 0) {
            Text("Starting from")
                .font(IndiGoFonts.bodySmallMedium())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            HStack(spacing: 0) {
                Text("₹ \(price.formatted())")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text("/ Pax")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Text("+Earn 6,200 IndiGo BluChips")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.accentDark)
        }
    }

    private func splitPerk(_ perk: String) -> (bold: String, regular: String) {
        let parts = perk.components(separatedBy: " ")
        guard parts.count > 1 else { return (perk, "") }
        return (parts[0], parts.dropFirst().joined(separator: " "))
    }
}

#Preview {
    CompareFaresBottomSheet(isPresented: .constant(true))
}
