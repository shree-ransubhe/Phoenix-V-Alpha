//
//  DealOfferCard.swift
//  IndiGoPrototype
//
//  Atom – gradient offer card for the "Best deals and Offers" listing page.
//  Figma node: 5658:60392 (blue variant), 5658:60401 (orange variant)
//

import SwiftUI

// MARK: - Data model

enum DealCardStyle {
    case blue
    case orange
}

enum DealBadgeType {
    case success(String)
    case error(String)
}

struct DealOffer: Identifiable {
    let id = UUID()
    let badge: DealBadgeType
    let headline: String
    let subtitle: String
    let promoCode: String
    let bankLogoName: String
    let style: DealCardStyle
    let category: String
}

// MARK: - Card view

struct DealOfferCard: View {
    let offer: DealOffer

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xl) {
            topSection
            bottomSection
        }
        .padding(IndiGoSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(cardGradient)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
    }

    // MARK: - Top: badge + headline + subtitle

    private var topSection: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            badgePill
            VStack(alignment: .leading, spacing: 0) {
                Text(offer.headline)
                    .font(.custom("Poppins-Medium", size: 16))
                    .foregroundStyle(.white)
                    .lineSpacing(8)

                Text(offer.subtitle)
                    .font(IndiGoFonts.body())
                    .foregroundStyle(.white)
            }
        }
    }

    // MARK: - Bottom: promo code pill + bank logo

    private var bottomSection: some View {
        HStack {
            promoCodePill
            Spacer()
            bankLogo
        }
    }

    // MARK: - Badge pill

    private var badgePill: some View {
        let (bgColor, textColor, label) = badgeProperties
        return HStack(spacing: 5.5) {
            Image(systemName: "arrow.up.right.square")
                .font(.system(size: 12))
                .foregroundStyle(textColor)

            Text(label)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundStyle(textColor)
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .frame(height: 22)
        .background(bgColor)
        .clipShape(Capsule())
    }

    private var badgeProperties: (Color, Color, String) {
        switch offer.badge {
        case .success(let label):
            return (IndiGoColors.dealBadgeSuccessBg, IndiGoColors.dealBadgeSuccessText, label)
        case .error(let label):
            return (IndiGoColors.dealBadgeErrorBg, IndiGoColors.dealBadgeErrorText, label)
        }
    }

    // MARK: - Promo code pill

    private var promoCodePill: some View {
        HStack(spacing: 5.5) {
            Image(systemName: "tag")
                .font(.system(size: 12))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Text(offer.promoCode)
                .font(.custom("Poppins-Regular", size: 16))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .padding(.vertical, IndiGoSpacing.xxs)
        .background(Color.white)
        .clipShape(Capsule())
    }

    // MARK: - Bank logo

    private var bankLogo: some View {
        Image(offer.bankLogoName)
            .resizable()
            .scaledToFit()
            .frame(height: 33)
    }

    // MARK: - Gradient

    private var cardGradient: LinearGradient {
        switch offer.style {
        case .blue:
            return LinearGradient(
                colors: [IndiGoColors.dealBluGradientTop, IndiGoColors.dealBluGradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
        case .orange:
            return LinearGradient(
                colors: [IndiGoColors.dealOrangeGradientTop, IndiGoColors.dealOrangeGradientBottom],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }
}

#Preview {
    VStack(spacing: 8) {
        DealOfferCard(offer: DealOffer(
            badge: .success("Special Offer"),
            headline: "Save up to ₹1,500 on flight booking",
            subtitle: "Only on HDFC credit cards",
            promoCode: "HDFC15",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Flights"
        ))
        DealOfferCard(offer: DealOffer(
            badge: .error("Limited Offer"),
            headline: "Save up to ₹2,500 on flight booking",
            subtitle: "Only on ICICI credit/debit cards",
            promoCode: "ICICI25",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Flights"
        ))
    }
    .padding(16)
    .background(Color(hex: "F5F8FC"))
}
