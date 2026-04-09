//
//  HomeView.swift
//  IndiGoPrototype
//
//  Home screen with scroll-driven sticky collapsing header.
//
//  Architecture:
//    - BG image (light-BG) sits at the top of scroll content as a static layer
//    - HomeHeaderView is a transparent overlay that pins to top via .offset(y:)
//    - Page content (For You, etc.) starts overlapping the BG image area
//    - As user scrolls, header collapses 207→139pt and shadow appears
//
//  Uses UIScrollView KVO observer for reliable scroll offset tracking.
//

import SwiftUI

// MARK: - Reliable scroll offset reader via UIKit KVO

private struct ScrollOffsetReader: UIViewRepresentable {
    @Binding var offset: CGFloat

    func makeUIView(context: Context) -> UIView {
        let view = UIView(frame: .zero)
        view.isUserInteractionEnabled = false
        view.backgroundColor = .clear
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        DispatchQueue.main.async {
            guard let scrollView = uiView.findEnclosingScrollView() else { return }
            if context.coordinator.observation == nil {
                context.coordinator.startObserving(scrollView)
            }
        }
    }

    func makeCoordinator() -> Coordinator { Coordinator(offset: $offset) }

    final class Coordinator: NSObject {
        @Binding var offset: CGFloat
        var observation: NSKeyValueObservation?
        private var initialY: CGFloat?

        init(offset: Binding<CGFloat>) { _offset = offset }

        func startObserving(_ scrollView: UIScrollView) {
            initialY = scrollView.contentOffset.y
            observation = scrollView.observe(\.contentOffset, options: .new) { [weak self] _, change in
                guard let self, let pt = change.newValue else { return }
                self.offset = pt.y - (self.initialY ?? 0)
            }
        }
    }
}

private extension UIView {
    func findEnclosingScrollView() -> UIScrollView? {
        var current: UIView? = superview
        while let view = current {
            if let sv = view as? UIScrollView { return sv }
            current = view.superview
        }
        return nil
    }
}

// MARK: - HomeView

struct HomeView: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.alphaTheme) private var theme
    @State private var scrollOffset: CGFloat = 0
    @State private var showSearchJourney = false
    @State private var showAllOffers = false
    @State private var selectedOfferTitle: String?
    @State private var showSixEPickExplore = false
    @State private var showProfile = false
    @State private var showOneClickPassenger = false

    private var clampedOffset: CGFloat { max(0, scrollOffset) }

    private var currentHeaderHeight: CGFloat {
        HomeHeaderView.headerHeight(for: clampedOffset)
    }

    private var contentCompensation: CGFloat {
        let cappedScroll = min(clampedOffset, HomeHeaderView.collapseRange)
        return currentHeaderHeight - HomeHeaderView.expandedHeight + cappedScroll
    }

    var body: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(spacing: 0) {
                ScrollOffsetReader(offset: $scrollOffset)
                    .frame(height: 0)

                HomeHeaderView(
                    scrollOffset: clampedOffset,
                    onSearchTap: { showSearchJourney = true },
                    onProfileTap: { showProfile = true },
                    onMoreTap: { showSixEPickExplore = true }
                )
                .offset(y: clampedOffset)
                .zIndex(1)

                Color.clear
                    .frame(height: max(0, HomeHeaderView.expandedHeight - currentHeaderHeight))

                pageContent
                    .offset(y: contentCompensation)
            }
            .background(alignment: .top) {
                if !theme.searchUsesFromToMode {
                    bgImageLayer
                        .frame(height: HomeHeaderView.expandedHeight)
                }
            }
        }
        .background(theme.pageBackgroundColor)
        #if UT_VARIANT
        .utInstrumented(screenId: "HomeView")
        #endif
        .ignoresSafeArea(edges: .top)
        .navigationDestination(isPresented: $showSearchJourney) {
            FromToView()
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $showAllOffers) {
            AllOffersView()
        }
        .navigationDestination(item: $selectedOfferTitle) { title in
            OfferDetailView(offerTitle: title)
        }
        .navigationDestination(isPresented: $showSixEPickExplore) {
            SixEPickExploreView()
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $showProfile) {
            ProfileView()
        }
        .navigationDestination(isPresented: $showOneClickPassenger) {
            BookPassengerView()
                .navigationBarBackButtonHidden()
        }
        .onChange(of: showSearchJourney) { _, isActive in
            bookingState.isInBookingFlow = isActive
        }
        .onChange(of: showOneClickPassenger) { _, isActive in
            bookingState.isInBookingFlow = isActive
        }
        .onChange(of: showProfile) { _, isActive in
            bookingState.isInBookingFlow = isActive
        }
        .onChange(of: showSixEPickExplore) { _, isActive in
            bookingState.isInBookingFlow = isActive
        }
        .onChange(of: showAllOffers) { _, isActive in
            bookingState.isInBookingFlow = isActive
        }
        .onChange(of: selectedOfferTitle) { _, value in
            bookingState.isInBookingFlow = value != nil
        }
    }

    // MARK: - BG Image layer (light-BG with gradient overlays)

    private var bgImageLayer: some View {
        ZStack {
            Image("header-bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .clipped()

            LinearGradient(
                stops: [
                    .init(color: .white.opacity(0.1), location: 0.655),
                    .init(color: Color(hex: "666666").opacity(0.0), location: 0.873)
                ],
                startPoint: .bottomLeading,
                endPoint: .topTrailing
            )

            LinearGradient(
                stops: [
                    .init(color: .white.opacity(0.0), location: 0.393),
                    .init(color: .white.opacity(0.9), location: 0.746)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    // MARK: - Page content

    private var pageContent: some View {
        VStack(spacing: theme.sectionToSectionSpacing) {
            ForEach(theme.homeSectionOrder) { section in
                sectionView(for: section)
            }
        }
        .padding(.top, theme.sectionInternalPadding)
    }

    // MARK: - Section factory (maps HomeSection → concrete View)

    @ViewBuilder
    private func sectionView(for section: HomeSection) -> some View {
        switch section {
        case .forYou:
            ForYouSection(
                bookings: [
                    BookingItem(date: "24 JAN 2026", from: "DEL", to: "BOM"),
                    BookingItem(date: "24 JAN 2026", from: "HYD", to: "BOM")
                ],
                promoCity: "Dubai",
                promoPrice: "₹24,999",
                recentSearches: [
                    RecentSearchItem(
                        from: "DEL", to: "BLR", subtitle: "Afternoon flight",
                        typeLabel: "Flight",
                        detailLine1Icon: "icon-rs-calendar",
                        detailLine1Text: "May 23",
                        detailLine2Icon: "icon-rs-pax",
                        detailLine2Text: "2 PAX"
                    ),
                    RecentSearchItem(
                        from: "Food Walk", to: "", subtitle: "Sightseeing",
                        typeLabel: "Sightseeing",
                        detailLine1Icon: "icon-rs-calendar",
                        detailLine1Text: "July 23 - Delhi",
                        detailLine2Icon: "icon-rs-pax",
                        detailLine2Text: "1 PAX"
                    ),
                    RecentSearchItem(
                        from: "BOM - T2", to: "", subtitle: "Cab booking",
                        typeLabel: "Cab",
                        detailLine1Icon: "icon-rs-calendar",
                        detailLine1Text: "Aug 25",
                        detailLine2Icon: "icon-rs-car",
                        detailLine2Text: "Sedan - 4 seater"
                    )
                ]
            )

        case .sixEPick:
            SixEPickSection(
                items: [
                    SixEPickItem(title: "Hotels", iconName: "icon-6epick-hotel", badge: "20% off", imageName: "6epick-hotels"),
                    SixEPickItem(title: "Sightseeing", iconName: "icon-6epick-sightseeing", badge: "20% off", imageName: "6epick-sightseeing"),
                    SixEPickItem(title: "Cabs", iconName: "icon-6epick-cabs", badge: "New", imageName: "6epick-cabs"),
                    SixEPickItem(title: "Experiences", iconName: "icon-6epick-experience", badge: "20% off", imageName: "6epick-experience"),
                ],
                moreCount: 5,
                onExploreMore: { showSixEPickExplore = true }
            )

        case .bestOffers:
            BestOffersSection(
                highlight: OfferHighlight(headline: "10% off on Flights", promoCode: "EXCLUSIVE", ctaLabel: "Book Now"),
                offerItems: [
                    OfferItem(title: "Upto 10% off", subtitle: "For Sightseeing using HDFC credit cards", promoCode: "HDFC10", imageName: "offer-hdfc-bank"),
                    OfferItem(title: "10% off up to ₹200", subtitle: "on cab Booking", promoCode: nil, imageName: "offer-cab-booking"),
                    OfferItem(title: "17% off up to ₹1,900", subtitle: "on Domestic Hotels", promoCode: nil, imageName: "offer-domestic-hotels"),
                ],
                offerBanners: [
                    OfferBanner(imageName: "offer-banner-student"),
                    OfferBanner(imageName: "offer-banner-hotels"),
                    OfferBanner(imageName: "offer-banner-shanghai"),
                    OfferBanner(imageName: "offer-banner-bali"),
                ],
                prominentOffer: ProminentOffer(imageName: "offer-prominent-icici"),
                onBookNow: { showSearchJourney = true },
                onOfferTap: { offer in selectedOfferTitle = offer.title },
                onBannerTap: { _ in showAllOffers = true },
                onViewAllOffers: { showAllOffers = true }
            )

        case .bluChip:
            BluChipBalanceCard(
                balance: "67,440",
                tierName: "Blu 3",
                loyaltyId: "2582447",
                progressFraction: 0.63,
                maxPoints: "100,000",
                unlockMessage: "Only 200 points away to unlock",
                unlockHighlight: "20 passes",
                infoMessage: "You're 550 IndiGo BluChips away from a free flight to Goa!"
            )
            .padding(.horizontal, theme.bluChipHorizontalPadding)
            .padding(.bottom, theme.bluChipBottomPadding)

        case .community:
            CommunitySection(items: [
                CommunityItem(
                    imageName: "img-nofilter",
                    heading: "Explore the World through the\nlens of our Community"
                ),
                CommunityItem(
                    imageName: "img-community2",
                    heading: "Discover Hidden Gems through\nthe Eyes of Fellow Travelers"
                ),
                CommunityItem(
                    imageName: "img-community3",
                    heading: "Journey Beyond Borders with\nStories from our Community"
                ),
            ])

        case .oneClickAway:
            OneClickAwaySection(
                destinations: MockDestinations.all,
                onDestinationTap: { destination in
                    initiateOneClickBooking(for: destination)
                }
            )

        case .flightOffersFooter:
            FlightOffersFooterSection()
        }
    }

    // MARK: - One-click booking (skip From/To & When, go straight to Who)

    private func initiateOneClickBooking(for destination: Destination) {
        guard let destCity = destination.city else { return }

        bookingState.reset()

        let defaultOrigin = IndiGoAirports.domestic.first { $0.code == "DEL" }
        bookingState.origin = defaultOrigin
        bookingState.destination = destCity

        let fallbackDepart = Calendar.current.date(byAdding: .day, value: 14, to: Date())!
        bookingState.selectedDate = destination.departureDate ?? fallbackDepart

        if let retDate = destination.returnDate {
            bookingState.tripType = .returnTrip
            bookingState.returnDate = retDate
        } else {
            bookingState.tripType = .oneWay
        }

        HapticManager.lightImpact()
        showOneClickPassenger = true
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(BookingState())
}
