//
//  RecentSearchCard.swift
//  IndiGoPrototype
//
//  Atom – recent search card.
//
//  Two variants driven by AlphaTheme:
//    - Ticket-shaped (4.1/5.0): semicircular notches, compact horizontal layout
//      Figma node: 2737:18792, BG shape: 2739:18925
//    - Square bordered (6.1): 160×160 card with type label, route, and detail rows
//      Figma node: 5665:63551
//

import SwiftUI

struct RecentSearchItem: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let subtitle: String
    let typeLabel: String
    let detailLine1Icon: String
    let detailLine1Text: String
    let detailLine2Icon: String
    let detailLine2Text: String

    init(
        from: String,
        to: String,
        subtitle: String,
        typeLabel: String = "Flight",
        detailLine1Icon: String = "icon-rs-calendar",
        detailLine1Text: String = "",
        detailLine2Icon: String = "icon-rs-pax",
        detailLine2Text: String = ""
    ) {
        self.from = from
        self.to = to
        self.subtitle = subtitle
        self.typeLabel = typeLabel
        self.detailLine1Icon = detailLine1Icon
        self.detailLine1Text = detailLine1Text
        self.detailLine2Icon = detailLine2Icon
        self.detailLine2Text = detailLine2Text
    }
}

// MARK: - Card view

struct RecentSearchCard: View {
    let item: RecentSearchItem
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        if theme.forYouRecentSearchUsesSquareCards {
            alpha61Card
        } else {
            alpha41Card
        }
    }

    // MARK: - Alpha 6.1 square bordered card (Figma 5665:63551)
    // Figma: 160×160 outer, 16px padding all sides, flex-col justify-between

    private var alpha61Card: some View {
        let w = theme.forYouRecentSearchCardWidth
        let h = theme.forYouRecentSearchCardHeight
        let r = theme.forYouRecentSearchCardCornerRadius

        return RoundedRectangle(cornerRadius: r)
            .fill(Color.white)
            .frame(width: w, height: h)
            .overlay(
                RoundedRectangle(cornerRadius: r)
                    .stroke(theme.forYouRecentSearchCardBorderColor, lineWidth: 1)
            )
            .overlay(alignment: .topLeading) {
                cardInnerContent
                    .padding(theme.forYouRecentSearchCardPadding)
            }
    }

    private var cardInnerContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.typeLabel)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(Color(hex: "25304B"))
                .lineLimit(1)

            Spacer(minLength: 0)

            bottomContent
        }
    }

    private var bottomContent: some View {
        VStack(alignment: .leading, spacing: 0) {
            routeRow

            VStack(alignment: .leading, spacing: 4) {
                detailRow(
                    iconName: item.detailLine1Icon,
                    text: item.detailLine1Text
                )
                detailRow(
                    iconName: item.detailLine2Icon,
                    text: item.detailLine2Text
                )
            }
        }
    }

    private var routeRow: some View {
        Group {
            if item.typeLabel == "Flight" {
                HStack(spacing: 8) {
                    Text(item.from)
                    Text("-")
                    Text(item.to)
                }
                .font(IndiGoFonts.displayXS())
                .foregroundStyle(IndiGoColors.indigoBlue)
                .lineLimit(1)
            } else {
                let displayText: String = {
                    if !item.from.isEmpty && !item.to.isEmpty {
                        return "\(item.from) - \(item.to)"
                    }
                    return item.from.isEmpty ? item.to : item.from
                }()
                Text(displayText)
                    .font(IndiGoFonts.displayXS())
                    .foregroundStyle(IndiGoColors.indigoBlue)
                    .lineLimit(1)
            }
        }
    }

    private func detailRow(iconName: String, text: String) -> some View {
        HStack(spacing: 4) {
            Image(iconName)
                .renderingMode(.original)
                .frame(width: 16, height: 16)
            Text(text)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.textDarkGrey)
                .lineLimit(1)
        }
    }

    // MARK: - Alpha 4.1/5.0 ticket-shaped card

    private var alpha41Card: some View {
        TicketShape(notchRadius: 10.215, cornerRadius: 8)
            .fill(Color.white)
            .shadow(color: Color(hex: "000099").opacity(0.06), radius: 6, x: 0, y: 0)
            .frame(
                width: theme.forYouRecentSearchCardWidth,
                height: theme.forYouRecentSearchCardHeight
            )
            .overlay(ticketContent)
    }

    private var ticketContent: some View {
        VStack(spacing: -6) {
            HStack(spacing: 0) {
                Text(item.from)
                    .font(IndiGoFonts.displaySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(maxWidth: .infinity)

                Image("icon-departure-circle")
                    .renderingMode(.original)
                    .frame(width: 47, height: 47)

                Text(item.to)
                    .font(IndiGoFonts.displaySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(maxWidth: .infinity)
            }
            .padding(.horizontal, 14)

            Text(item.subtitle)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
        }
        .padding(.top, 2)
        .padding(.bottom, 6)
    }
}

// MARK: - Ticket shape: rounded rect with semicircular notches on top & bottom

struct TicketShape: Shape {
    let notchRadius: CGFloat
    let cornerRadius: CGFloat

    func path(in rect: CGRect) -> Path {
        let cr = cornerRadius
        let nr = notchRadius
        let midX = rect.midX

        var path = Path()

        // Start at top-left corner (after corner radius)
        path.move(to: CGPoint(x: rect.minX + cr, y: rect.minY))

        // Top edge → notch center (left half)
        path.addLine(to: CGPoint(x: midX - nr, y: rect.minY))

        // Top notch (semicircle cut downward into the card)
        path.addArc(
            center: CGPoint(x: midX, y: rect.minY),
            radius: nr,
            startAngle: .degrees(180),
            endAngle: .degrees(0),
            clockwise: true
        )

        // Top edge → top-right corner
        path.addLine(to: CGPoint(x: rect.maxX - cr, y: rect.minY))

        // Top-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cr, y: rect.minY + cr),
            radius: cr,
            startAngle: .degrees(-90),
            endAngle: .degrees(0),
            clockwise: false
        )

        // Right edge
        path.addLine(to: CGPoint(x: rect.maxX, y: rect.maxY - cr))

        // Bottom-right corner
        path.addArc(
            center: CGPoint(x: rect.maxX - cr, y: rect.maxY - cr),
            radius: cr,
            startAngle: .degrees(0),
            endAngle: .degrees(90),
            clockwise: false
        )

        // Bottom edge → notch center (right half)
        path.addLine(to: CGPoint(x: midX + nr, y: rect.maxY))

        // Bottom notch (semicircle cut upward into the card)
        path.addArc(
            center: CGPoint(x: midX, y: rect.maxY),
            radius: nr,
            startAngle: .degrees(0),
            endAngle: .degrees(180),
            clockwise: true
        )

        // Bottom edge → bottom-left corner
        path.addLine(to: CGPoint(x: rect.minX + cr, y: rect.maxY))

        // Bottom-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + cr, y: rect.maxY - cr),
            radius: cr,
            startAngle: .degrees(90),
            endAngle: .degrees(180),
            clockwise: false
        )

        // Left edge
        path.addLine(to: CGPoint(x: rect.minX, y: rect.minY + cr))

        // Top-left corner
        path.addArc(
            center: CGPoint(x: rect.minX + cr, y: rect.minY + cr),
            radius: cr,
            startAngle: .degrees(180),
            endAngle: .degrees(270),
            clockwise: false
        )

        path.closeSubpath()
        return path
    }
}

// MARK: - Preview

#Preview("Ticket (5.0)") {
    HStack(spacing: 8) {
        RecentSearchCard(item: RecentSearchItem(
            from: "DEL", to: "BOM", subtitle: "Afternoon flight"
        ))
        RecentSearchCard(item: RecentSearchItem(
            from: "BHU", to: "DEL", subtitle: "Morning flight"
        ))
    }
    .padding(20)
    .background(Color.white)
    .alphaTheme(Alpha50Theme())
}

#Preview("Square (6.1)") {
    HStack(spacing: 8) {
        RecentSearchCard(item: RecentSearchItem(
            from: "DEL", to: "BLR", subtitle: "",
            typeLabel: "Flight",
            detailLine1Icon: "icon-rs-calendar",
            detailLine1Text: "May 23",
            detailLine2Icon: "icon-rs-pax",
            detailLine2Text: "2 PAX"
        ))
        RecentSearchCard(item: RecentSearchItem(
            from: "Food Walk", to: "", subtitle: "",
            typeLabel: "Sightseeing",
            detailLine1Icon: "icon-rs-calendar",
            detailLine1Text: "July 23 - Delhi",
            detailLine2Icon: "icon-rs-pax",
            detailLine2Text: "1 PAX"
        ))
    }
    .padding(20)
    .background(Color(hex: "F5F8FC"))
    .alphaTheme(Alpha61Theme())
}
