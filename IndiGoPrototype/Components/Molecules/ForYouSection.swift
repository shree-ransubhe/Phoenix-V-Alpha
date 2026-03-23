//
//  ForYouSection.swift
//  IndiGoPrototype
//
//  Molecule – "For You" section on Explore page.
//
//  Two variants driven by AlphaTheme:
//    - Booking context (4.1):  My Bookings (left) + Location Promo / Flight Status (right)
//    - Non-booking context (5.0): "Recent Search" with horizontal ticket-shaped cards
//
//  Figma nodes: 85:5693 (booking), 2737:18789 (recent search)
//

import SwiftUI

struct ForYouSection: View {
    var bookings: [BookingItem] = []
    var promoCity: String = ""
    var promoPrice: String = ""
    var recentSearches: [RecentSearchItem] = []

    @Environment(\.alphaTheme) private var theme

    var body: some View {
        if theme.forYouShowsRecentSearch {
            recentSearchVariant
        } else {
            bookingVariant
        }
    }

    // MARK: - Recent Search variant (non-booking context)

    private var recentSearchVariant: some View {
        VStack(alignment: .leading, spacing: theme.forYouSectionSpacing) {
            Text("Recent Search")
                .font(IndiGoFonts.displayXS())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .padding(.horizontal, theme.forYouHorizontalPadding)

            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: theme.forYouRecentSearchCardSpacing) {
                    ForEach(recentSearches) { item in
                        RecentSearchCard(item: item)
                    }
                }
                .padding(.horizontal, theme.forYouHorizontalPadding)
                .padding(.vertical, 8)
            }
        }
    }

    // MARK: - Booking variant (original layout)

    private var bookingVariant: some View {
        VStack(alignment: .leading, spacing: theme.forYouSectionSpacing) {
            Text("FOR YOU")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)

            HStack(alignment: .top, spacing: theme.forYouColumnSpacing) {
                MyBookingsCard(bookings: bookings)
                    .frame(width: theme.forYouBookingsCardWidth)
                    .frame(maxHeight: .infinity, alignment: .top)

                VStack(spacing: theme.forYouRightColumnSpacing) {
                    LocationPromoCard(city: promoCity, price: promoPrice)
                    FlightStatusCard()
                }
            }
            .fixedSize(horizontal: false, vertical: true)
        }
        .padding(.horizontal, theme.forYouHorizontalPadding)
        .padding(.vertical, theme.forYouVerticalPadding)
    }
}

// MARK: - Previews

#Preview("Recent Search (5.0)") {
    ForYouSection(
        recentSearches: [
            RecentSearchItem(from: "DEL", to: "BOM", subtitle: "Afternoon flight"),
            RecentSearchItem(from: "BHU", to: "DEL", subtitle: "Morning flight")
        ]
    )
    .alphaTheme(Alpha50Theme())
}

#Preview("Bookings (4.1)") {
    ForYouSection(
        bookings: [
            BookingItem(date: "24 JAN 2026", from: "DEL", to: "BOM"),
            BookingItem(date: "24 JAN 2026", from: "HYD", to: "BOM")
        ],
        promoCity: "Dubai",
        promoPrice: "₹24,999"
    )
    .alphaTheme(Alpha41Theme())
}
