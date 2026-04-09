//
//  OfferBannerCard.swift
//  IndiGoPrototype
//
//  Atom – full-image offer banner card for Alpha 6.1 carousel.
//  Figma node: 5617:92537 (Offer Banner children)
//
//  Each card is a 343×194 rounded rectangle displaying a full promotional
//  image (e.g. "Student special", "Book hotels with IndiGo").
//

import SwiftUI

struct OfferBanner: Identifiable {
    let id = UUID()
    let imageName: String
}

struct OfferBannerCard: View {
    let banner: OfferBanner
    let width: CGFloat
    let height: CGFloat
    let cornerRadius: CGFloat
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            Image(banner.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: width, height: height)
                .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    OfferBannerCard(
        banner: OfferBanner(imageName: "offer-banner-student"),
        width: 343,
        height: 194,
        cornerRadius: 8,
        onTap: {}
    )
    .padding()
}
