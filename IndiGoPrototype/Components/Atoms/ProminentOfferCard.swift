//
//  ProminentOfferCard.swift
//  IndiGoPrototype
//
//  Atom – full-bleed image promo card shown at the bottom of the
//  Best Offers section in Alpha 5.0.
//  The PNG already contains headline, subtitle, promo pill, and
//  bank logo — we just display the image with rounded corners.
//  Figma node: 2481:36812
//

import SwiftUI

struct ProminentOffer: Identifiable {
    let id = UUID()
    let imageName: String
}

struct ProminentOfferCard: View {
    let offer: ProminentOffer
    let cornerRadius: CGFloat

    var body: some View {
        Image(offer.imageName)
            .resizable()
            .scaledToFit()
            .frame(maxWidth: .infinity)
            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
    }
}

#Preview {
    ProminentOfferCard(
        offer: ProminentOffer(imageName: "offer-prominent-icici"),
        cornerRadius: 8
    )
    .padding(.horizontal, 16)
}
