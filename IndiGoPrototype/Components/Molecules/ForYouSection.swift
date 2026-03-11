//
//  ForYouSection.swift
//  IndiGoPrototype
//
//  Molecule – "For You" section on Explore page.
//  Layout: left = My Bookings, right column = Location Promo (top) + Flight Status (bottom).
//  Figma node: 85:5693
//

import SwiftUI

struct ForYouSection: View {
    let bookings: [BookingItem]
    let promoCity: String
    let promoPrice: String

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            Text("FOR YOU")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)

            HStack(alignment: .top, spacing: IndiGoSpacing.md) {
                MyBookingsCard(bookings: bookings)
                    .frame(width: 159)
                    .frame(maxHeight: .infinity, alignment: .top)

                rightColumn
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, IndiGoSpacing.lg)
        .padding(.vertical, IndiGoSpacing.xs)
    }

    private var rightColumn: some View {
        VStack(spacing: IndiGoSpacing.sm) {
            LocationPromoCard(city: promoCity, price: promoPrice)

            FlightStatusCard()
        }
    }
}

#Preview {
    ForYouSection(
        bookings: [
            BookingItem(date: "24 JAN 2026", from: "DEL", to: "BOM"),
            BookingItem(date: "24 JAN 2026", from: "HYD", to: "BOM")
        ],
        promoCity: "Dubai",
        promoPrice: "₹24,999"
    )
}
