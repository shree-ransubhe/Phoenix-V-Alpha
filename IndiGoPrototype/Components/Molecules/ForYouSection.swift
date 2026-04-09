//
//  ForYouSection.swift
//  IndiGoPrototype
//
//  Molecule – "For You" section on Explore page.
//
//  Three variants driven by AlphaTheme:
//    - Booking context (4.1):  My Bookings (left) + Location Promo / Flight Status (right)
//    - Recent Search ticket (5.0): Horizontal ticket-shaped cards
//    - Recent Search square (6.1): Square bordered cards with Hide/Reveal CTA
//
//  Figma nodes: 85:5693 (booking), 2737:18789 (recent search 5.0),
//               5665:63546 (recent search 6.1), 5665:63547 (Hide CTA)
//

import SwiftUI

struct ForYouSection: View {
    var bookings: [BookingItem] = []
    var promoCity: String = ""
    var promoPrice: String = ""
    var recentSearches: [RecentSearchItem] = []

    @Environment(\.alphaTheme) private var theme
    @State private var isRecentSearchHidden = false

    var body: some View {
        if theme.forYouShowsRecentSearch {
            recentSearchVariant
        } else {
            bookingVariant
        }
    }

    // MARK: - Recent Search variant

    private var recentSearchVariant: some View {
        VStack(alignment: .leading, spacing: theme.forYouSectionSpacing) {
            recentSearchHeader
                .padding(.horizontal, theme.forYouHorizontalPadding)

            if !isRecentSearchHidden {
                recentSearchCarousel
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(.top, theme.forYouRecentSearchTopPadding)
        .padding(.bottom, theme.forYouRecentSearchBottomPadding)
    }

    // MARK: - Title row with optional Hide/Reveal CTA

    private var recentSearchHeader: some View {
        HStack {
            Text("Recent Search")
                .font(theme.forYouRecentSearchTitleFont)
                .foregroundStyle(theme.forYouRecentSearchTitleColor)

            Spacer()

            if theme.forYouRecentSearchShowsHideCta {
                Button {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        isRecentSearchHidden.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Text(isRecentSearchHidden ? "Reveal" : "Hide")
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(IndiGoColors.indigoBlue)
                            .contentTransition(.numericText())

                        Image("icon-chevron-up")
                            .renderingMode(.original)
                            .frame(width: 16, height: 16)
                            .rotationEffect(.degrees(isRecentSearchHidden ? 180 : 0))
                            .animation(.easeInOut(duration: 0.3), value: isRecentSearchHidden)
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Card carousel

    private var recentSearchCarousel: some View {
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

#Preview("Recent Search (6.1)") {
    ForYouSection(
        recentSearches: [
            RecentSearchItem(
                from: "DEL", to: "BLR", subtitle: "",
                typeLabel: "Flight",
                detailLine1Icon: "icon-rs-calendar",
                detailLine1Text: "May 23",
                detailLine2Icon: "icon-rs-pax",
                detailLine2Text: "2 PAX"
            ),
            RecentSearchItem(
                from: "Food Walk", to: "", subtitle: "",
                typeLabel: "Sightseeing",
                detailLine1Icon: "icon-rs-calendar",
                detailLine1Text: "July 23 - Delhi",
                detailLine2Icon: "icon-rs-pax",
                detailLine2Text: "1 PAX"
            ),
            RecentSearchItem(
                from: "BOM - T2", to: "", subtitle: "",
                typeLabel: "Cab",
                detailLine1Icon: "icon-rs-calendar",
                detailLine1Text: "Aug 25",
                detailLine2Icon: "icon-rs-car",
                detailLine2Text: "Sedan - 4 seater"
            )
        ]
    )
    .alphaTheme(Alpha61Theme())
    .background(Color(hex: "F5F8FC"))
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
