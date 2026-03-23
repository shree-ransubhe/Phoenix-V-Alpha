//
//  OfferListItem.swift
//  IndiGoPrototype
//
//  Atom – single offer row in the Best Offers card list.
//  Figma node: 85:6048
//

import SwiftUI

struct OfferItem: Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
    let promoCode: String?
    let imageName: String
}

struct OfferListItem: View {
    let offer: OfferItem
    let showDivider: Bool
    let onTap: () -> Void
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        Button(action: onTap) {
            VStack(spacing: 0) {
                HStack(spacing: IndiGoSpacing.xs) {
                    offerIcon
                    offerDetails
                    Spacer()
                    chevron
                }

                if showDivider {
                    dashedDivider
                        .padding(.top, theme.bestOffersListSpacing)
                }
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - 48×48 icon thumbnail (PNGs include rounded corners & backgrounds)

    private var offerIcon: some View {
        Image(offer.imageName)
            .resizable()
            .scaledToFill()
            .frame(width: 48, height: 48)
            .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
            .shadow(color: IndiGoColors.cardSubtleShadow, radius: 6)
    }

    // MARK: - Title + subtitle row

    private var offerDetails: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(offer.title)
                .font(IndiGoFonts.subHeading6())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .lineLimit(1)

            subtitleText
        }
    }

    @ViewBuilder
    private var subtitleText: some View {
        if let code = offer.promoCode {
            (
                Text("Use ")
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                +
                Text(code)
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
                +
                Text(" | \(offer.subtitle)")
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            )
            .font(IndiGoFonts.bodyExtraSmall())
            .lineLimit(1)
        } else {
            Text(offer.subtitle)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .lineLimit(1)
        }
    }

    // MARK: - Right chevron

    private var chevron: some View {
        ZStack {
            Circle()
                .fill(Color.white)
                .frame(width: theme.bestOffersChevronSize, height: theme.bestOffersChevronSize)

            Image("icon-accordion-right")
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
        }
    }

    // MARK: - Dashed divider

    private var dashedDivider: some View {
        Rectangle()
            .fill(.clear)
            .frame(height: 1)
            .overlay(
                GeometryReader { geo in
                    Path { path in
                        path.move(to: .zero)
                        path.addLine(to: CGPoint(x: geo.size.width, y: 0))
                    }
                    .stroke(
                        IndiGoColors.offerBorderDeep,
                        style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                    )
                }
            )
    }
}

#Preview {
    VStack(spacing: 16) {
        OfferListItem(
            offer: OfferItem(
                title: "Upto 10% off",
                subtitle: "Only on HDFC credit cards",
                promoCode: "HDFC10",
                imageName: "offer-hdfc-bank"
            ),
            showDivider: true,
            onTap: {}
        )

        OfferListItem(
            offer: OfferItem(
                title: "10% off up to ₹200",
                subtitle: "on cab Booking",
                promoCode: nil,
                imageName: "offer-cab-booking"
            ),
            showDivider: false,
            onTap: {}
        )
    }
    .padding()
}
