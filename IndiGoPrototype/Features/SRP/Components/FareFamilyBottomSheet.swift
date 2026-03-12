import SwiftUI

/// Fare Selector bottom sheet — lets user pick a fare family for a given flight.
/// Reuses the same visual construct as CompareFaresBottomSheet (handle, segmented tab,
/// swipeable carousel) and adds flight summary + price with Select CTA.
///
/// Figma: 976:9807 (Economy), 976:10093 (Stretch), 976:10022 (flight card).
struct FareFamilyBottomSheet: View {
    let flight: MockFlight
    let initialFareType: FareSheetType
    @Binding var isPresented: Bool
    @State private var fareType: FareSheetType = .economy
    @State private var selectedIndex: Int = 1
    @State private var dragOffset: CGFloat = 0

    enum FareSheetType {
        case stretch
        case economy
    }

    private var fareOptions: [FareOption] {
        switch fareType {
        case .stretch: return flight.stretchFares
        case .economy: return flight.economyFares
        }
    }

    private let cardWidth: CGFloat = 160

    private var toggleActivePillColor: Color {
        fareType == .stretch ? IndiGoColors.stretchGold : IndiGoColors.primaryMain
    }

    private var toggleTrackColor: Color {
        fareType == .stretch ? Color(hex: "ECF9FF") : Color(hex: "FFF9EB")
    }

    var body: some View {
        VStack(spacing: 0) {
            sheetHandle
                .padding(.top, 16)
                .padding(.bottom, 12)

            flightSummaryCard
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            fareTypeToggle
                .padding(.horizontal, 20)
                .padding(.bottom, 12)

            fareCarousel

            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .background(.white)
        .onAppear {
            fareType = initialFareType
            selectedIndex = initialFareType == .economy ? 1 : 0
        }
    }

    // MARK: - Sheet Handle

    private var sheetHandle: some View {
        RoundedRectangle(cornerRadius: 8)
            .fill(Color(hex: "7A85A0"))
            .frame(width: 40, height: 4)
    }

    // MARK: - Flight Summary Card (Figma 976:10022)

    private var flightSummaryCard: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack(spacing: 4) {
                Image(systemName: "airplane")
                    .font(.system(size: 8))
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                Text(flight.flightNumber)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
            .padding(.horizontal, 2)

            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(flight.departureTime)
                        .font(IndiGoFonts.subHeading7())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    Text("\(flight.originCode), \(flight.originTerminal)")
                        .font(IndiGoFonts.bodyLight())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
                .frame(width: 80, alignment: .leading)

                Spacer()

                VStack(spacing: 4) {
                    Text(flight.duration)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    Text(flight.stopsLabel)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.primaryMain)
                }

                Spacer()

                VStack(alignment: .trailing, spacing: 0) {
                    Text(flight.arrivalTime)
                        .font(IndiGoFonts.subHeading7())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    Text("\(flight.destinationCode), \(flight.destinationTerminal)")
                        .font(IndiGoFonts.bodyLight())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
                .frame(width: 80, alignment: .trailing)
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            RoundedCorners(tl: 12, tr: 12)
                .fill(.white)
        )
    }

    // MARK: - Fare Type Toggle (interactive)

    private var fareTypeToggle: some View {
        HStack(spacing: 0) {
            togglePill(type: .stretch)
            togglePill(type: .economy)
        }
        .padding(4)
        .background(toggleTrackColor)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(IndiGoColors.srpCardBorder, lineWidth: 1)
        )
        .animation(.easeInOut(duration: 0.25), value: fareType)
    }

    private func togglePill(type: FareSheetType) -> some View {
        let isActive = fareType == type
        let title = type == .stretch ? "Stretch" : "Economy"

        return Button {
            guard fareType != type else { return }
            withAnimation(.spring(response: 0.3)) {
                fareType = type
                selectedIndex = type == .economy ? 1 : 0
                dragOffset = 0
            }
        } label: {
            Text(title)
                .font(IndiGoFonts.bodySmallMedium())
                .foregroundStyle(isActive ? .white : IndiGoColors.primaryMain)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 8)
                .background(isActive ? toggleActivePillColor : .clear)
                .clipShape(Capsule())
                .overlay(
                    isActive
                        ? Capsule().strokeBorder(IndiGoColors.secondaryLight, lineWidth: 1)
                        : nil
                )
                .shadow(
                    color: isActive ? Color(hex: "4C5D9E").opacity(0.08) : .clear,
                    radius: 6, x: 0, y: 0
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Swipeable Fare Carousel

    private var fareCarousel: some View {
        let options = fareOptions
        let count = options.count
        let step = cardWidth - 20

        return ZStack {
            ForEach(Array(options.enumerated()), id: \.element.id) { index, option in
                let baseOffset = CGFloat(index - selectedIndex) * step
                let offset = baseOffset + dragOffset
                let normalizedDist = min(abs(offset) / step, 1.0)
                let isActive = index == selectedIndex && abs(dragOffset) < 20

                FareSelectorCard(
                    option: option,
                    isActive: isActive,
                    isStretch: fareType == .stretch,
                    accentColor: fareType == .stretch ? IndiGoColors.stretchGold : IndiGoColors.secondaryBright,
                    badgeBg: badgeBgColor(for: option.fareFamily),
                    badgeTextColor: badgeTextColor(for: option.fareFamily)
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

                    withAnimation(.spring(response: 0.4, dampingFraction: 0.8)) {
                        selectedIndex = newIndex
                        dragOffset = 0
                    }
                }
        )
    }

    // MARK: - Badge Colors

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

// MARK: - Fare Selector Card (with price + Select CTA)

private struct FareSelectorCard: View {
    let option: FareOption
    let isActive: Bool
    let isStretch: Bool
    let accentColor: Color
    let badgeBg: Color
    let badgeTextColor: Color

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

            if isActive {
                dividerLine
                    .padding(.top, 10)
                pricingSection
                    .padding(.top, 8)
                selectButton
                    .padding(.top, 8)
                    .padding(.bottom, 4)
            }
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
            Text(option.fareFamily.rawValue)
                .font(.custom("BauhausStd-Medium", size: 16))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Text(option.fareFamily.subtitle)
                .font(IndiGoFonts.bodySmallMedium())
                .foregroundStyle(badgeTextColor)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 2)
                .background(badgeBg)
        }
    }

    private var perksSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            perkRow(perkKey: "cabin", boldText: option.fareFamily.cabinBag, regularText: "Cabin bag")
            perkRow(perkKey: "checkin", boldText: option.fareFamily.checkinBag, regularText: "Checkin bag")

            ForEach(option.fareFamily.perks, id: \.self) { perk in
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
            HStack(spacing: 2) {
                Text("₹ \(option.price.formatted())")
                    .font(.custom("Poppins-SemiBold", size: 16))
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text("/ Pax")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Text("+Earn \(option.bluChips.formatted()) IndiGo BluChips")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.accentDark)
        }
    }

    private var selectButton: some View {
        Button(action: {}) {
            Text("Select")
                .font(IndiGoFonts.buttonMobile())
                .foregroundStyle(.white)
                .padding(.horizontal, 24)
                .padding(.vertical, 8)
                .background(IndiGoColors.primaryMain)
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(.white, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private func splitPerk(_ perk: String) -> (bold: String, regular: String) {
        let parts = perk.components(separatedBy: " ")
        guard parts.count > 1 else { return (perk, "") }
        return (parts[0], parts.dropFirst().joined(separator: " "))
    }
}

// MARK: - Rounded Top Corners Shape

private struct RoundedCorners: Shape {
    var tl: CGFloat = 0
    var tr: CGFloat = 0

    func path(in rect: CGRect) -> Path {
        var path = Path()
        path.move(to: CGPoint(x: rect.minX, y: rect.maxY))
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + tl))
        path.addArc(
            center: CGPoint(x: rect.minX + tl, y: rect.minY + tl),
            radius: tl, startAngle: .degrees(180), endAngle: .degrees(270), clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX - tr, y: rect.minY))
        path.addArc(
            center: CGPoint(x: rect.maxX - tr, y: rect.minY + tr),
            radius: tr, startAngle: .degrees(270), endAngle: .degrees(0), clockwise: false
        )
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY))
        path.closeSubpath()
        return path
    }
}

#Preview("Stretch") {
    FareFamilyBottomSheet(
        flight: MockFlights.sample[0],
        initialFareType: .stretch,
        isPresented: .constant(true)
    )
}

#Preview("Economy") {
    FareFamilyBottomSheet(
        flight: MockFlights.sample[0],
        initialFareType: .economy,
        isPresented: .constant(true)
    )
}
