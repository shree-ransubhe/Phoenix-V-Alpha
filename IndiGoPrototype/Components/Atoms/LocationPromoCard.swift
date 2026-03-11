//
//  LocationPromoCard.swift
//  IndiGoPrototype
//
//  Atom – destination promo card with city name and starting price.
//  Figma node: 765:8850
//

import SwiftUI

struct LocationPromoCard: View {
    let city: String
    let price: String

    var body: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(city)
                    .font(IndiGoFonts.subHeading3())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .tracking(-0.4)

                HStack(spacing: IndiGoSpacing.xxs) {
                    Text("Starting at")
                        .font(IndiGoFonts.bodyExtraSmall())
                    Text(price)
                        .font(IndiGoFonts.bodyExtraSmallBold())
                }
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }

            Spacer()

            arrowButton
        }
        .padding(.horizontal, 14)
        .padding(.vertical, IndiGoSpacing.xs)
        .frame(maxWidth: .infinity)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.secondaryMedium, lineWidth: 1)
        )
    }

    private var arrowButton: some View {
        ZStack {
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm)
                .fill(IndiGoColors.secondaryMedium)
                .frame(width: 28, height: 28)

            Image("icon-clickable-link")
                .renderingMode(.original)
                .frame(width: 16, height: 16)
        }
    }
}

#Preview {
    LocationPromoCard(city: "Dubai", price: "₹24,999")
        .padding()
}
