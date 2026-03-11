//
//  OneClickAwayCard.swift
//  IndiGoPrototype
//
//  Atom – destination card for the "One Click Away" carousel.
//  Tall portrait card with background image, gradient overlay,
//  destination name, date range, pricing and Explore / Book CTAs.
//  Figma node: 826:9866
//

import SwiftUI

struct OneClickAwayCard: View {
    let destination: Destination
    var onExplore: () -> Void = {}
    var onBook: () -> Void = {}

    private let cardWidth: CGFloat = 193
    private let cardHeight: CGFloat = 270

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundImage
            gradientOverlay
            cardContent
        }
        .frame(width: cardWidth, height: cardHeight)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusLg))
    }

    // MARK: - Background

    private static let fallbackColors: [Color] = [
        Color(hex: "1A6B8A"), Color(hex: "8B4513"), Color(hex: "2E5045"),
        Color(hex: "6B3FA0"), Color(hex: "B85C3A"),
    ]

    @ViewBuilder
    private var backgroundImage: some View {
        if UIImage(named: destination.imageName) != nil {
            Image(destination.imageName)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: cardWidth, height: cardHeight)
                .clipped()
        } else {
            let colorIndex = abs(destination.id.hashValue) % Self.fallbackColors.count
            Self.fallbackColors[colorIndex]
                .frame(width: cardWidth, height: cardHeight)
        }
    }

    private var gradientOverlay: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0.15),
                .init(color: Color.black.opacity(0.5), location: 0.87)
            ],
            startPoint: .topTrailing,
            endPoint: .bottomLeading
        )
    }

    // MARK: - Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.sm) {
            destinationInfo
            actionButtons
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.bottom, IndiGoSpacing.md)
    }

    private var destinationInfo: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            Text(destination.name)
                .font(IndiGoFonts.subHeading3())
                .foregroundStyle(.white)
                .tracking(-0.4)

            Text(destination.dateRange)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(.white)

            priceRow
        }
    }

    private var priceRow: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            Text(destination.originalPrice)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.secondaryDeepGrey)
                .strikethrough()

            Text(destination.discountedPrice)
                .font(IndiGoFonts.subHeading3())
                .foregroundStyle(.white)
                .tracking(-0.4)
        }
    }

    private var actionButtons: some View {
        HStack(spacing: IndiGoSpacing.md) {
            Button(action: onExplore) {
                Text("Explore")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
            }
            .background(Color.white.opacity(0.2))
            .clipShape(Capsule())
            .overlay(Capsule().stroke(Color.white, lineWidth: 1))

            Button(action: onBook) {
                Text("Book")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 32)
            }
            .background(IndiGoColors.indigoBlue)
            .clipShape(Capsule())
        }
    }
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        OneClickAwayCard(
            destination: MockDestinations.international[0]
        )
    }
}
