//
//  RecentSearchCard.swift
//  IndiGoPrototype
//
//  Atom – ticket-shaped "recent search" card with semicircular notches
//  on top and bottom edges.
//  Figma node: 2737:18792, BG shape: 2739:18925
//

import SwiftUI

struct RecentSearchItem: Identifiable {
    let id = UUID()
    let from: String
    let to: String
    let subtitle: String
}

// MARK: - Card view

struct RecentSearchCard: View {
    let item: RecentSearchItem

    private let cardWidth: CGFloat = 200
    private let cardHeight: CGFloat = 84

    var body: some View {
        TicketShape(notchRadius: 10.215, cornerRadius: 8)
            .fill(Color.white)
            .shadow(color: Color(hex: "000099").opacity(0.06), radius: 6, x: 0, y: 0)
            .frame(width: cardWidth, height: cardHeight)
            .overlay(cardContent)
    }

    private var cardContent: some View {
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

#Preview {
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
}
