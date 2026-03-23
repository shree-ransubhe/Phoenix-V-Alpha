//
//  BestOffersSection.swift
//  IndiGoPrototype
//
//  Molecule – "Best Offers" / "Find exciting offers here" section.
//  Figma node: 85:5939 (Alpha 4.1), 2279:25606 (Alpha 5.0)
//
//  Alpha 4.1 layout:
//    1. "BEST OFFERS" label
//    2. Card with hero promo (OfferHighlighterCard) + offer list + "View all" footer
//
//  Alpha 5.0 layout:
//    1. "Find exciting [offers here]" title + "View all ↗" button
//    2. White card with offer list rows (no hero card)
//    3. Prominent gradient promo card (e.g. ICICI)
//

import SwiftUI

struct BestOffersSection: View {
    let highlight: OfferHighlight
    let offerItems: [OfferItem]
    let prominentOffer: ProminentOffer?
    let onBookNow: () -> Void
    let onOfferTap: (OfferItem) -> Void
    let onViewAllOffers: () -> Void
    @Environment(\.alphaTheme) private var theme

    init(
        highlight: OfferHighlight,
        offerItems: [OfferItem],
        prominentOffer: ProminentOffer? = nil,
        onBookNow: @escaping () -> Void,
        onOfferTap: @escaping (OfferItem) -> Void,
        onViewAllOffers: @escaping () -> Void
    ) {
        self.highlight = highlight
        self.offerItems = offerItems
        self.prominentOffer = prominentOffer
        self.onBookNow = onBookNow
        self.onOfferTap = onOfferTap
        self.onViewAllOffers = onViewAllOffers
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.bestOffersSectionSpacing) {
            sectionHeader

            if theme.bestOffersTitleUsesGreenSplit {
                alpha50Card
            } else {
                alpha41Card
            }

            if theme.bestOffersShowsProminentOffer, let prominent = prominentOffer {
                ProminentOfferCard(
                    offer: prominent,
                    cornerRadius: theme.bestOffersProminentCornerRadius
                )
            }
        }
        .padding(.horizontal, theme.bestOffersHorizontalPadding)
        .padding(.vertical, theme.bestOffersVerticalPadding)
    }

    // MARK: - Section header

    @ViewBuilder
    private var sectionHeader: some View {
        if theme.bestOffersTitleUsesGreenSplit {
            alpha50Title
        } else {
            Text("BEST OFFERS")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
        }
    }

    // MARK: - Alpha 5.0 title: "Find exciting [offers here]" + "View all"

    private var alpha50Title: some View {
        HStack(alignment: .center) {
            (
                Text("Find exciting ")
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                +
                Text("offers here")
                    .foregroundStyle(IndiGoColors.sixEPickGreen)
            )
            .font(IndiGoFonts.displayXS())

            Spacer()

            if theme.bestOffersShowsViewAll {
                Button(action: onViewAllOffers) {
                    HStack(spacing: IndiGoSpacing.xxs) {
                        Text("View all")
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(IndiGoColors.offerPromoBlue)

                        Image("icon-clickable-link")
                            .renderingMode(.template)
                            .resizable()
                            .frame(width: 16, height: 16)
                            .foregroundStyle(IndiGoColors.offerPromoBlue)
                    }
                    .padding(.horizontal, IndiGoSpacing.sm)
                    .padding(.vertical, IndiGoSpacing.md)
                    .frame(height: 32)
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Alpha 5.0 card: offer list only (no hero, no footer link)

    private var alpha50Card: some View {
        VStack(spacing: 0) {
            offersList
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius))
        .shadow(color: Color(hex: "000099").opacity(0.16), radius: theme.bestOffersShadowRadius)
    }

    // MARK: - Alpha 4.1 card: hero + list + view-all footer

    private var alpha41Card: some View {
        VStack(spacing: 0) {
            if theme.bestOffersShowsHeroCard {
                heroCard
            }
            offersList
            viewAllFooter
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius)
                .stroke(IndiGoColors.secondaryDeepGrey, lineWidth: 1)
        )
        .shadow(color: IndiGoColors.cardSoftShadow, radius: theme.bestOffersShadowRadius)
    }

    // MARK: - Hero promo card (4.1 only)

    private var heroCard: some View {
        OfferHighlighterCard(
            offer: highlight,
            onBookNow: onBookNow
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: theme.bestOffersCornerRadius,
                topTrailingRadius: theme.bestOffersCornerRadius
            )
        )
    }

    // MARK: - Offer list items

    private var offersList: some View {
        VStack(spacing: theme.bestOffersListSpacing) {
            ForEach(Array(offerItems.enumerated()), id: \.element.id) { index, item in
                OfferListItem(
                    offer: item,
                    showDivider: index < offerItems.count - 1,
                    onTap: { onOfferTap(item) }
                )
            }
        }
        .padding(.horizontal, theme.bestOffersListHorizontalPadding)
        .padding(.top, theme.bestOffersListVerticalPadding)
        .padding(.bottom, theme.bestOffersListVerticalPadding)
    }

    // MARK: - "View all Offers" footer (4.1 only)

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

#Preview("Alpha 5.0") {
    ScrollView {
        BestOffersSection(
            highlight: OfferHighlight(headline: "10% off on Flights", promoCode: "EXCLUSIVE", ctaLabel: "Book Now"),
            offerItems: [
                OfferItem(title: "Upto 10% off", subtitle: "For Sightseeing using HDFC credit cards", promoCode: "HDFC10", imageName: "offer-hdfc-bank"),
                OfferItem(title: "10% off up to ₹200", subtitle: "on cab Booking", promoCode: nil, imageName: "offer-cab-booking"),
                OfferItem(title: "17% off up to ₹1,900", subtitle: "on Domestic Hotels", promoCode: nil, imageName: "offer-domestic-hotels"),
            ],
            prominentOffer: ProminentOffer(imageName: "offer-prominent-icici"),
            onBookNow: {},
            onOfferTap: { _ in },
            onViewAllOffers: {}
        )
    }
    .background(Color(hex: "F5F5F5"))
}

#Preview("Alpha 4.1") {
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
