//
//  BestOffersSection.swift
//  IndiGoPrototype
//
//  Molecule – "Best Offers" section on the Explore page.
//  Figma nodes: 85:5939 (4.1), 2279:25606 (5.0), 5602:85075 (6.1)
//
//  Alpha 4.1: "BEST OFFERS" label → hero card + offer list + "VIEW ALL OFFERS"
//  Alpha 5.0: "Find exciting offers here" + "View all" → offer list card + prominent card
//  Alpha 6.1: Full-image banner carousel → "View all offers" + right-arrow
//

import SwiftUI

struct BestOffersSection: View {
    let highlight: OfferHighlight
    let offerItems: [OfferItem]
    let offerBanners: [OfferBanner]
    let prominentOffer: ProminentOffer?
    let onBookNow: () -> Void
    let onOfferTap: (OfferItem) -> Void
    let onBannerTap: (OfferBanner) -> Void
    let onViewAllOffers: () -> Void
    @Environment(\.alphaTheme) private var theme

    init(
        highlight: OfferHighlight,
        offerItems: [OfferItem],
        offerBanners: [OfferBanner] = [],
        prominentOffer: ProminentOffer? = nil,
        onBookNow: @escaping () -> Void,
        onOfferTap: @escaping (OfferItem) -> Void,
        onBannerTap: @escaping (OfferBanner) -> Void = { _ in },
        onViewAllOffers: @escaping () -> Void
    ) {
        self.highlight = highlight
        self.offerItems = offerItems
        self.offerBanners = offerBanners
        self.prominentOffer = prominentOffer
        self.onBookNow = onBookNow
        self.onOfferTap = onOfferTap
        self.onBannerTap = onBannerTap
        self.onViewAllOffers = onViewAllOffers
    }

    var body: some View {
        if theme.bestOffersUsesBannerCarousel {
            alpha61Layout
        } else {
            legacyLayout
        }
    }

    // MARK: - Alpha 6.1 layout: banner carousel + bottom CTA

    private var alpha61Layout: some View {
        VStack(alignment: .leading, spacing: theme.bestOffersSectionSpacing) {
            bannerCarousel
            viewAllOffersRow
        }
        .padding(.horizontal, theme.bestOffersHorizontalPadding)
        .padding(.top, theme.bestOffersTopPadding)
        .padding(.bottom, theme.bestOffersVerticalPadding)
        .overlay(alignment: .bottom) {
            theme.bestOffersBottomBorderColor
                .frame(height: 1)
        }
    }

    // MARK: - Banner carousel (6.1)

    private var bannerCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.bestOffersBannerSpacing) {
                ForEach(offerBanners) { banner in
                    OfferBannerCard(
                        banner: banner,
                        width: theme.bestOffersBannerWidth,
                        height: theme.bestOffersBannerHeight,
                        cornerRadius: theme.bestOffersBannerCornerRadius,
                        onTap: { onBannerTap(banner) }
                    )
                }
            }
        }
    }

    // MARK: - "View all offers" CTA row (6.1)
    //  Poppins Regular 14pt, #000099, right-arrow 24×24, justify-between

    private var viewAllOffersRow: some View {
        Button(action: onViewAllOffers) {
            HStack {
                Text("View all offers")
                    .font(IndiGoFonts.body())
                    .foregroundStyle(IndiGoColors.offerPromoBlue)

                Spacer()

                Image(theme.bestOffersCtaIconName)
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: theme.bestOffersCtaIconSize, height: theme.bestOffersCtaIconSize)
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Legacy layout (4.1 / 5.0)

    private var legacyLayout: some View {
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
        .padding(.top, theme.bestOffersTopPadding)
        .padding(.bottom, theme.bestOffersVerticalPadding)
    }

    // MARK: - Section header (4.1 / 5.0)

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

    // MARK: - Alpha 5.0 title

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

    // MARK: - Alpha 5.0 card

    private var alpha50Card: some View {
        VStack(spacing: 0) {
            offersList
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius))
        .shadow(color: Color(hex: "000099").opacity(0.16), radius: theme.bestOffersShadowRadius)
    }

    // MARK: - Alpha 4.1 card

    private var alpha41Card: some View {
        VStack(spacing: 0) {
            if theme.bestOffersShowsHeroCard {
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
            offersList
            alpha41Footer
        }
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius))
        .overlay(
            RoundedRectangle(cornerRadius: theme.bestOffersCornerRadius)
                .stroke(IndiGoColors.secondaryDeepGrey, lineWidth: 1)
        )
        .shadow(color: IndiGoColors.cardSoftShadow, radius: theme.bestOffersShadowRadius)
    }

    // MARK: - Offer list items (4.1 / 5.0)

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

    // MARK: - "VIEW ALL OFFERS" footer (4.1)

    private var alpha41Footer: some View {
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

// MARK: - Previews

#Preview("Alpha 6.1") {
    ScrollView {
        BestOffersSection(
            highlight: OfferHighlight(headline: "10% off on Flights", promoCode: "EXCLUSIVE", ctaLabel: "Book Now"),
            offerItems: [],
            offerBanners: [
                OfferBanner(imageName: "offer-banner-student"),
                OfferBanner(imageName: "offer-banner-hotels"),
                OfferBanner(imageName: "offer-banner-shanghai"),
                OfferBanner(imageName: "offer-banner-bali"),
            ],
            onBookNow: {},
            onOfferTap: { _ in },
            onViewAllOffers: {}
        )
    }
    .background(Color(hex: "F5F5F5"))
}

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
