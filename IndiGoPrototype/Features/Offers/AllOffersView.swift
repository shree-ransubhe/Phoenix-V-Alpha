//
//  AllOffersView.swift
//  IndiGoPrototype
//
//  Full "Best deals and Offers" listing page.
//  Figma node: 5658:60380
//

import SwiftUI

struct AllOffersView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var selectedFilter = "All"

    private let filters = ["All", "Flights", "Cab", "Hotel", "Sightseeing"]

    private let allOffers: [DealOffer] = [
        DealOffer(
            badge: .success("Special Offer"),
            headline: "Save up to ₹1,500 on flight booking",
            subtitle: "Only on HDFC credit cards",
            promoCode: "HDFC15",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Flights"
        ),
        DealOffer(
            badge: .error("Limited Offer"),
            headline: "Save up to ₹2,500 on flight booking",
            subtitle: "Only on ICICI credit/debit cards",
            promoCode: "ICICI25",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Flights"
        ),
        DealOffer(
            badge: .success("Exclusive Promo"),
            headline: "Get ₹1,000 off on domestic flights",
            subtitle: "Applicable on SBI credit cards",
            promoCode: "SBI10",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Flights"
        ),
        DealOffer(
            badge: .error("Seasonal Discount"),
            headline: "Enjoy ₹2,000 off on international flights",
            subtitle: "Valid for Axis Bank customers",
            promoCode: "AXIS20",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Flights"
        ),
        DealOffer(
            badge: .success("Flash Sale"),
            headline: "Flat ₹3,000 off on premium flight bookings",
            subtitle: "Only with Citibank cards",
            promoCode: "CITI30",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Flights"
        ),
        DealOffer(
            badge: .success("Cab Deals"),
            headline: "Get 20% off on airport cab bookings",
            subtitle: "Pay using HDFC credit card",
            promoCode: "CABHDFC",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Cab"
        ),
        DealOffer(
            badge: .error("Hot Deal"),
            headline: "Flat ₹300 off on cab rides",
            subtitle: "ICICI debit card users only",
            promoCode: "ICICAB",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Cab"
        ),
        DealOffer(
            badge: .success("Stay & Save"),
            headline: "Up to 30% off on domestic hotels",
            subtitle: "Book with HDFC credit cards",
            promoCode: "STAY30",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Hotel"
        ),
        DealOffer(
            badge: .error("Weekend Getaway"),
            headline: "Flat ₹2,000 off on hotel bookings",
            subtitle: "ICICI Bank customers exclusive",
            promoCode: "WKND20",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Hotel"
        ),
        DealOffer(
            badge: .success("Explore More"),
            headline: "₹500 off on sightseeing packages",
            subtitle: "Pay with any HDFC card",
            promoCode: "SIGHT5",
            bankLogoName: "bank-logo-hdfc",
            style: .blue,
            category: "Sightseeing"
        ),
        DealOffer(
            badge: .error("City Tours"),
            headline: "Get 15% off on guided city tours",
            subtitle: "ICICI credit card offer",
            promoCode: "TOUR15",
            bankLogoName: "bank-logo-icici",
            style: .orange,
            category: "Sightseeing"
        ),
    ]

    private var filteredOffers: [DealOffer] {
        if selectedFilter == "All" { return allOffers }
        return allOffers.filter { $0.category == selectedFilter }
    }

    var body: some View {
        VStack(spacing: 0) {
            headerBar
            scrollableContent
        }
        .background(IndiGoColors.dealsBg)
        .navigationBarBackButtonHidden()
    }

    // MARK: - Header

    private var headerBar: some View {
        HStack(spacing: IndiGoSpacing.sm) {
            Button(action: { dismiss() }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 20, height: 20)
            }
            .frame(width: 53, alignment: .leading)

            Spacer()

            Text("Best deals and Offers")
                .font(IndiGoFonts.displayXS())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Spacer()

            HStack {
                Spacer()
                SixEskaiButton()
            }
            .frame(width: 53)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.sm)
        .background(.ultraThinMaterial)
    }

    // MARK: - Content

    private var scrollableContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: IndiGoSpacing.md) {
                filterChips
                offersList
            }
            .padding(IndiGoSpacing.md)
        }
    }

    // MARK: - Filter chips

    private var filterChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: IndiGoSpacing.xs) {
                ForEach(filters, id: \.self) { filter in
                    DealFilterChip(
                        label: filter,
                        isSelected: selectedFilter == filter,
                        action: {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectedFilter = filter
                            }
                        }
                    )
                }
            }
        }
    }

    // MARK: - Offers list

    private var offersList: some View {
        LazyVStack(spacing: IndiGoSpacing.xs) {
            ForEach(filteredOffers) { offer in
                DealOfferCard(offer: offer)
            }
        }
    }
}

#Preview {
    NavigationStack {
        AllOffersView()
    }
}
