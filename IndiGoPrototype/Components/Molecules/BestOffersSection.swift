//
//  BestOffersSection.swift
//  IndiGoPrototype
//
//  Molecule – "Best Offers" section on the Explore page.
//  Figma node: 85:5939
//
//  Sub-sections:
//  1. OfferHighlighterCard (static hero promo)
//  2–4. OfferListItem rows (HDFC, Cab, Hotels)
//  5. "View all Offers" footer link
//

import SwiftUI

struct BestOffersSection: View {
    let highlight: OfferHighlight
    let offerItems: [OfferItem]
    let onBookNow: () -> Void
    let onOfferTap: (OfferItem) -> Void
    let onViewAllOffers: () -> Void

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            sectionLabel

            offerCard
        }
        .padding(.horizontal, IndiGoSpacing.lg)
        .padding(.vertical, IndiGoSpacing.xs)
    }

    // MARK: - Section label

    private var sectionLabel: some View {
        Text("BEST OFFERS")
            .font(IndiGoFonts.bodyExtraSmall())
            .foregroundStyle(IndiGoColors.forYouTextSecondary)
    }

    // MARK: - Main card container

    private var offerCard: some View {
        VStack(spacing: 0) {
            heroCard
            offersList
            viewAllFooter
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusLg))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusLg)
                .stroke(IndiGoColors.secondaryDeepGrey, lineWidth: 1)
        )
        .shadow(color: IndiGoColors.cardSoftShadow, radius: 12)
    }

    // MARK: - Hero promo card

    private var heroCard: some View {
        OfferHighlighterCard(
            offer: highlight,
            onBookNow: onBookNow
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: IndiGoSpacing.radiusLg,
                topTrailingRadius: IndiGoSpacing.radiusLg
            )
        )
    }

    // MARK: - Offer list items

    private var offersList: some View {
        VStack(spacing: IndiGoSpacing.sm) {
            ForEach(Array(offerItems.enumerated()), id: \.element.id) { index, item in
                OfferListItem(
                    offer: item,
                    showDivider: index < offerItems.count - 1,
                    onTap: { onOfferTap(item) }
                )
            }
        }
        .padding(.horizontal, IndiGoSpacing.sm)
        .padding(.top, IndiGoSpacing.md)
        .padding(.bottom, IndiGoSpacing.md)
    }

    // MARK: - "View all Offers" footer

    private var viewAllFooter: some View {
        Button(action: onViewAllOffers) {
            HStack(spacing: IndiGoSpacing.xs) {
                Text("VIEW ALL OFFERS")
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
                    .underline()

                Image("icon-accordion-right")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
            }
            .frame(maxWidth: .infinity)
            .padding(.vertical, IndiGoSpacing.sm)
            .overlay(alignment: .top) {
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
                                IndiGoColors.disabledBorder,
                                style: StrokeStyle(lineWidth: 1, dash: [4, 3])
                            )
                        }
                    )
            }
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        BestOffersSection(
            highlight: OfferHighlight(headline: "10% off on Flights", promoCode: "EXCLUSIVE", ctaLabel: "Book Now"),
            offerItems: [
                OfferItem(title: "Upto 10% off", subtitle: "Only on HDFC credit cards", promoCode: "HDFC10", imageName: "offer-hdfc-bank"),
                OfferItem(title: "10% off up to ₹200", subtitle: "on cab Booking", promoCode: nil, imageName: "offer-cab-booking"),
                OfferItem(title: "17% off up to ₹1,900", subtitle: "on Domestic Hotels", promoCode: nil, imageName: "offer-domestic-hotels"),
            ],
            onBookNow: {},
            onOfferTap: { _ in },
            onViewAllOffers: {}
        )
    }
    .background(Color(hex: "F5F5F5"))
}
