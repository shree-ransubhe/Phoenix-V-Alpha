import SwiftUI

/// A single flight result card with flight info at top and fare options at bottom.
/// Matches Figma node 3:8537 – each card has flight details + two fare family slots.
struct FlightResultCard: View {
    let flight: MockFlight
    var onStretchTap: () -> Void = {}
    var onEconomyTap: () -> Void = {}

    var body: some View {
        VStack(spacing: 0) {
            flightInfoSection
            fareSection
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.srpCardBorder, lineWidth: 1)
        )
        .shadow(color: IndiGoColors.srpCardShadow, radius: 2, x: 0, y: 0)
    }

    // MARK: - Flight Info (Figma node 3:8540)

    private var flightInfoSection: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xxs) {
            flightNumberBadge
            timeRouteRow
        }
        .padding(.horizontal, IndiGoSpacing.sm)
        .padding(.vertical, IndiGoSpacing.xs)
    }

    private var flightNumberBadge: some View {
        HStack(spacing: IndiGoSpacing.xxs) {
            IndiGoLogoShape(color: IndiGoColors.primaryMain)
                .frame(width: 8, height: 8)

            Text(flight.flightNumber)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
        }
        .padding(2)
    }

    /// Departure --- duration/stops --- Arrival row (Figma node 3:8590)
    private var timeRouteRow: some View {
        HStack(spacing: 0) {
            // Departure
            VStack(alignment: .leading, spacing: 0) {
                Text(flight.departureTime)
                    .font(IndiGoFonts.subHeading7())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                Text("\(flight.originCode), \(flight.originTerminal)")
                    .font(IndiGoFonts.bodyLight())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
            .frame(width: 80, alignment: .leading)

            Spacer(minLength: 0)

            // Center flight path
            flightCenterSection

            Spacer(minLength: 0)

            // Arrival
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

    /// Center section: airplane -> dashed line with dot -> circle, then duration + stops below
    private var flightCenterSection: some View {
        VStack(spacing: IndiGoSpacing.xxs) {
            flightPathVisual
            Text(flight.duration)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
            Text(flight.stopsLabel)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.primaryMain)
        }
    }

    /// Airplane icon -> dashed line -> landing circle
    private var flightPathVisual: some View {
        HStack(spacing: 0) {
            // Airplane SVG
            FlightPathAirplaneIcon()
                .fill(Color(hex: "7A85A0"))
                .frame(width: 8, height: 10)

            Spacer().frame(width: 4)

            // Dashed line with optional stop dot
            GeometryReader { geo in
                ZStack {
                    Path { path in
                        let y = geo.size.height / 2
                        path.move(to: CGPoint(x: 0, y: y))
                        path.addLine(to: CGPoint(x: geo.size.width, y: y))
                    }
                    .stroke(style: StrokeStyle(lineWidth: 1, dash: [3, 2]))
                    .foregroundStyle(Color(hex: "7A85A0").opacity(0.5))

                    if flight.stops > 0 {
                        Circle()
                            .fill(Color(hex: "7A85A0"))
                            .frame(width: 4, height: 4)
                    }
                }
            }
            .frame(height: 4)

            Spacer().frame(width: 4)

            // Landing circle SVG
            LandingCircleIcon()
        }
        .frame(width: 80, height: 10)
    }

    // MARK: - Fare Section (Figma node 3:8610)

    private var fareSection: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            stretchFareCell
            economyFareCell
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .padding(.top, IndiGoSpacing.xxs)
        .padding(.bottom, IndiGoSpacing.xs)
    }

    // MARK: - Stretch Fare (Figma node 3:8612)

    private var stretchFareCell: some View {
        Button(action: {
            HapticManager.lightImpact()
            onStretchTap()
        }) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: IndiGoSpacing.xs) {
                        Text("₹ \(flight.stretchPrice.formatted())")
                            .font(IndiGoFonts.subHeading7())
                            .foregroundStyle(IndiGoColors.primaryMain)

                        DropdownChevronIcon()
                    }

                    Text("+Earn \(flight.stretchBluChips.formatted()) IndiGo BluChips")
                        .font(IndiGoFonts.bodyExtraExtraSmall())
                        .foregroundStyle(IndiGoColors.accentDark)
                        .lineLimit(1)
                }
                .padding(.horizontal, IndiGoSpacing.xs)
                .padding(.vertical, IndiGoSpacing.xxs)
                .frame(maxWidth: .infinity, alignment: .leading)

                stretchBadge
            }
            .background(
                LinearGradient(
                    colors: [IndiGoColors.stretchGoldLight, .white.opacity(0)],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
        }
        .buttonStyle(.plain)
    }

    private var stretchBadge: some View {
        HStack(spacing: IndiGoSpacing.xxs) {
            StretchSeatIcon(color: .white)
                .frame(width: 14, height: 14)

            Text("Stretch | Business")
                .font(IndiGoFonts.bodyExtraExtraSmall())
                .foregroundStyle(.white)
                .lineLimit(1)
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(IndiGoColors.stretchGold)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(IndiGoColors.stretchGoldLight)
                .frame(height: 0.6)
        }
    }

    // MARK: - Economy Fare (Figma node 3:8621)

    private var economyFareCell: some View {
        Button(action: {
            HapticManager.lightImpact()
            onEconomyTap()
        }) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    HStack(spacing: IndiGoSpacing.xs) {
                        Text("₹ \(flight.economyPrice.formatted())")
                            .font(IndiGoFonts.subHeading7())
                            .foregroundStyle(IndiGoColors.primaryMain)

                        DropdownChevronIcon()
                    }

                    Text("+Earn \(flight.economyBluChips.formatted()) IndiGo BluChips")
                        .font(IndiGoFonts.bodyExtraExtraSmall())
                        .foregroundStyle(IndiGoColors.accentDark)
                        .lineLimit(1)
                }
                .padding(.horizontal, IndiGoSpacing.xs)
                .padding(.vertical, IndiGoSpacing.xxs)
                .frame(maxWidth: .infinity, alignment: .leading)

                economyBadge
            }
            .background(
                LinearGradient(
                    colors: [IndiGoColors.economyBlueLight, .white],
                    startPoint: .top,
                    endPoint: .bottom
                )
            )
            .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
        }
        .buttonStyle(.plain)
    }

    private var economyBadge: some View {
        HStack(spacing: IndiGoSpacing.xxs) {
            EconomySeatIcon(color: IndiGoColors.forYouTextSecondary)
                .frame(width: 14, height: 14)

            Text("Economy")
                .font(IndiGoFonts.bodyExtraExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .lineLimit(1)
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .padding(.vertical, 2)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(IndiGoColors.economyBlueBadge)
        .overlay(alignment: .top) {
            Rectangle()
                .fill(IndiGoColors.economyBlueBadgeBorder)
                .frame(height: 0.6)
        }
    }
}

#Preview {
    FlightResultCard(flight: MockFlights.sample[0])
        .padding()
        .background(Color(hex: "EAF8FF"))
}
