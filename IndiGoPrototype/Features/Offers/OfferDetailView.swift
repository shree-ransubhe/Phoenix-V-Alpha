//
//  OfferDetailView.swift
//  IndiGoPrototype
//
//  Placeholder landing page for individual offer details.
//

import SwiftUI

struct OfferDetailView: View {
    @Environment(\.dismiss) private var dismiss
    let offerTitle: String

    var body: some View {
        VStack(spacing: IndiGoSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(IndiGoColors.secondaryLight)
                    .frame(width: 80, height: 80)

                Image(systemName: "tag.fill")
                    .font(.system(size: 32))
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
            }

            VStack(spacing: IndiGoSpacing.xs) {
                Text(offerTitle)
                    .font(IndiGoFonts.heading2())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .multilineTextAlignment(.center)

                Text("Offer details coming soon")
                    .font(IndiGoFonts.body())
                    .foregroundStyle(IndiGoColors.textSecondary)
            }

            Spacer()
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(IndiGoColors.background)
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: { dismiss() }) {
                    Image(systemName: "chevron.left")
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)
                }
            }

            ToolbarItem(placement: .principal) {
                Text("Offer Details")
                    .font(IndiGoFonts.bodySemiBold())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        OfferDetailView(offerTitle: "Upto 10% off on HDFC cards")
    }
}
