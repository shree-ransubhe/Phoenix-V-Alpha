//
//  AllOffersView.swift
//  IndiGoPrototype
//
//  Placeholder landing page for "View all Offers".
//

import SwiftUI

struct AllOffersView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: IndiGoSpacing.xl) {
            Spacer()

            ZStack {
                Circle()
                    .fill(IndiGoColors.secondaryLight)
                    .frame(width: 80, height: 80)

                Image(systemName: "percent")
                    .font(.system(size: 32, weight: .semibold))
                    .foregroundStyle(IndiGoColors.offerPromoBlue)
            }

            VStack(spacing: IndiGoSpacing.xs) {
                Text("All Offers")
                    .font(IndiGoFonts.heading2())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text("Browse all available offers and deals")
                    .font(IndiGoFonts.body())
                    .foregroundStyle(IndiGoColors.textSecondary)
                    .multilineTextAlignment(.center)
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
                Text("All Offers")
                    .font(IndiGoFonts.bodySemiBold())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AllOffersView()
    }
}
