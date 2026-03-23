//
//  OneClickAwayCard.swift
//  IndiGoPrototype
//
//  Atom – destination card for the "One Click Away" carousel.
//  Reads all visual knobs from AlphaTheme so 4.1 and 5.0 render
//  different layouts from the same view code.
//  Figma nodes: 826:9866 (4.1), 2440:40859 (5.0)
//

import SwiftUI

struct OneClickAwayCard: View {
    let destination: Destination
    var onExplore: () -> Void = {}
    var onBook: () -> Void = {}

    @Environment(\.alphaTheme) private var theme

    private var w: CGFloat { theme.oneClickCardWidth }
    private var h: CGFloat { theme.oneClickCardHeight }

    var body: some View {
        ZStack(alignment: .bottom) {
            backgroundImage
            gradientOverlay
            cardContent
        }
        .frame(width: w, height: h)
        .clipShape(RoundedRectangle(cornerRadius: theme.oneClickCardCornerRadius))
        .shadow(
            color: theme.oneClickCardShadowColor,
            radius: theme.oneClickCardShadowRadius
        )
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
                .frame(width: w, height: h)
                .clipped()
        } else {
            let colorIndex = abs(destination.id.hashValue) % Self.fallbackColors.count
            Self.fallbackColors[colorIndex]
                .frame(width: w, height: h)
        }
    }

    private var gradientOverlay: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: theme.oneClickCardDateFirst ? 0.03 : 0.15),
                .init(
                    color: theme.oneClickCardGradientBaseColor
                        .opacity(theme.oneClickCardGradientBaseOpacity),
                    location: theme.oneClickCardDateFirst ? 0.95 : 0.87
                )
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    // MARK: - Content

    private var cardContent: some View {
        VStack(alignment: .leading, spacing: theme.oneClickCardDateFirst ? IndiGoSpacing.xl : IndiGoSpacing.sm) {
            destinationInfo
            actionButtons
        }
        .padding(IndiGoSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    @ViewBuilder
    private var destinationInfo: some View {
        if theme.oneClickCardDateFirst {
            VStack(alignment: .leading, spacing: IndiGoSpacing.xxs) {
                Text(destination.dateRange)
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(.white)
                    .padding(.vertical, IndiGoSpacing.xxs)

                Text(destination.name)
                    .font(theme.oneClickCardNameFont)
                    .foregroundStyle(.white)

                Text(destination.discountedPrice)
                    .font(theme.oneClickCardPriceFont)
                    .foregroundStyle(.white)
            }
        } else {
            VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
                Text(destination.name)
                    .font(theme.oneClickCardNameFont)
                    .foregroundStyle(.white)
                    .tracking(-0.4)

                Text(destination.dateRange)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(.white)

                priceRow
            }
        }
    }

    private var priceRow: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            if theme.oneClickCardShowsOriginalPrice {
                Text(destination.originalPrice)
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.secondaryDeepGrey)
                    .strikethrough()
            }

            Text(destination.discountedPrice)
                .font(theme.oneClickCardPriceFont)
                .foregroundStyle(.white)
                .tracking(-0.4)
        }
    }

    @ViewBuilder
    private var actionButtons: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            Button(action: onExplore) {
                HStack(spacing: IndiGoSpacing.xs) {
                    Text("Explore")
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(.white)
                    if !theme.oneClickCardShowsBookButton {
                        Image("icon-clickable-link")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 16, height: 16)
                    }
                }
                .frame(maxWidth: theme.oneClickCardShowsBookButton ? .infinity : nil)
                .frame(height: 32)
                .padding(.horizontal, IndiGoSpacing.sm)
            }
            .background(Color.white.opacity(0.12))
            .clipShape(RoundedRectangle(cornerRadius: theme.oneClickCardButtonCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: theme.oneClickCardButtonCornerRadius)
                    .stroke(Color.white, lineWidth: 1)
            )

            if theme.oneClickCardShowsBookButton {
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
}

#Preview {
    ZStack {
        Color.black.ignoresSafeArea()
        OneClickAwayCard(
            destination: MockDestinations.international[0]
        )
    }
}
