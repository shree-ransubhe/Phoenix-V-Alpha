//
//  OfferHighlighterCard.swift
//  IndiGoPrototype
//
//  Atom – hero promo card for the Best Offers section.
//  Figma node: 85:6023 (Sample Offer cards - No image)
//
//  Layout from Figma (absolute positions within 335×94 blue card):
//    Concentric circles: left 225, top -14, 206×206
//    Sparkle stars:      right 12, top 63, 62×31
//    Small star:         right 361 (offscreen left), top -6, 17×38
//    Headline:           left 20, top 28, width 195
//    Promo code:         left 20, top 63 (center-Y → ~57)
//    Book Now button:    left 242, top 35
//

import SwiftUI

struct OfferHighlight: Identifiable {
    let id = UUID()
    let headline: String
    let promoCode: String
    let ctaLabel: String
}

struct OfferHighlighterCard: View {
    let offer: OfferHighlight
    let onBookNow: () -> Void

    private let cardHeight: CGFloat = 94

    var body: some View {
        ZStack(alignment: .topLeading) {
            IndiGoColors.offerPromoBlue

            concentricCircles
            sparkleStars
            headline
            promoCodeLabel
            bookNowButton
        }
        .frame(maxWidth: .infinity)
        .frame(height: cardHeight)
        .clipped()
    }

    // MARK: - Concentric circles (Figma: left 225, top -14, 206×206)

    private var concentricCircles: some View {
        Image("offer-hero-deco")
            .resizable()
            .renderingMode(.template)
            .foregroundStyle(.white)
            .frame(width: 206, height: 206)
            .position(x: 225 + 103, y: -14 + 103)
    }

    // MARK: - Sparkle stars (Figma: right 12 → left ~261, top 63, 62×31)

    private var sparkleStars: some View {
        Image("offer-hero-gift")
            .resizable()
            .frame(width: 62, height: 31)
            .position(x: 335 - 12 - 31, y: 63 + 15.5)
    }

    // MARK: - Headline (Figma: left 20, top 28, w 195)

    private var headline: some View {
        Text(offer.headline)
            .font(IndiGoFonts.displayXS())
            .tracking(-0.6)
            .foregroundStyle(.white)
            .shadow(color: .black.opacity(0.25), radius: 13.55, y: 4)
            .frame(width: 195, alignment: .leading)
            .lineLimit(2)
            .position(x: 20 + 97.5, y: 28 + 12)
    }

    // MARK: - Promo code (Figma: left 20, top 63, vertically centered)

    private var promoCodeLabel: some View {
        Text("Use code: \(offer.promoCode)")
            .font(IndiGoFonts.bodyExtraSmall())
            .foregroundStyle(.white)
            .position(x: 20 + 60, y: 63 + 6)
    }

    // MARK: - Book Now CTA (Figma: left 242, top 35, px 12, py 4, rounded 18)

    private var bookNowButton: some View {
        Button(action: onBookNow) {
            Text(offer.ctaLabel)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.offerButtonDark)
                .padding(.horizontal, IndiGoSpacing.sm)
                .padding(.vertical, IndiGoSpacing.xxs)
                .background(Color.white)
                .clipShape(Capsule())
        }
        .buttonStyle(.plain)
        .position(x: 242 + 35, y: 35 + 12)
    }
}

#Preview {
    VStack {
        OfferHighlighterCard(
            offer: OfferHighlight(
                headline: "10% off on Flights",
                promoCode: "EXCLUSIVE",
                ctaLabel: "Book Now"
            ),
            onBookNow: {}
        )
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 16,
                topTrailingRadius: 16
            )
        )
    }
    .padding(.horizontal, 20)
    .background(Color.gray.opacity(0.1))
}
