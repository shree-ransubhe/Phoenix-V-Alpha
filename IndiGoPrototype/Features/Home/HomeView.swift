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
    @State private var scrollOffset: CGFloat = 0
    @State private var showSearchJourney = false
    @State private var showAllOffers = false
    @State private var selectedOfferTitle: String?

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

                // Header pinned to top via offset
                HomeHeaderView(
                    scrollOffset: clampedOffset,
                    onSearchTap: { showSearchJourney = true }
                )
                .offset(y: clampedOffset)
                .zIndex(1)

                Color.clear
                    .frame(height: max(0, HomeHeaderView.expandedHeight - currentHeaderHeight))

                pageContent
                    .offset(y: contentCompensation)
            }
            .background(alignment: .top) {
                // BG image pinned to the top of the scroll content
                bgImageLayer
                    .frame(height: HomeHeaderView.expandedHeight)
            }
        }
        .background(IndiGoColors.background)
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
        .onChange(of: showSearchJourney) { _, isActive in
            if !isActive {
                bookingState.isInBookingFlow = false
            }
        }
    }

    // MARK: - BG Image layer (light-BG with gradient overlays)

    private var bgImageLayer: some View {
        ZStack {
            Image("light-header-bg")
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
        VStack(spacing: IndiGoSpacing.xs) {
            ForYouSection(
                bookings: [
                    BookingItem(date: "24 JAN 2026", from: "DEL", to: "BOM"),
                    BookingItem(date: "24 JAN 2026", from: "HYD", to: "BOM")
                ],
                promoCity: "Dubai",
                promoPrice: "₹24,999"
            )

            SixEPickSection(items: [
                SixEPickItem(title: "Hotels", imageName: "6epick-hotels"),
                SixEPickItem(title: "Sight Seeing", imageName: "6epick-sightseeing"),
                SixEPickItem(title: "Cabs", imageName: "6epick-cabs"),
                SixEPickItem(title: "Experience", imageName: "6epick-experience"),
                SixEPickItem(title: "Shop", imageName: "6epick-shop"),
            ])

            BestOffersSection(
                highlight: OfferHighlight(headline: "10% off on Flights", promoCode: "EXCLUSIVE", ctaLabel: "Book Now"),
                offerItems: [
                    OfferItem(title: "Upto 10% off", subtitle: "Only on HDFC credit cards", promoCode: "HDFC10", imageName: "offer-hdfc-bank"),
                    OfferItem(title: "10% off up to ₹200", subtitle: "on cab Booking", promoCode: nil, imageName: "offer-cab-booking"),
                    OfferItem(title: "17% off up to ₹1,900", subtitle: "on Domestic Hotels", promoCode: nil, imageName: "offer-domestic-hotels"),
                ],
                onBookNow: { showSearchJourney = true },
                onOfferTap: { offer in selectedOfferTitle = offer.title },
                onViewAllOffers: { showAllOffers = true }
            )

            BluChipBalanceCard(
                balance: "67,440",
                tierName: "Blu 3",
                progressFraction: 0.63,
                maxPoints: "100,000",
                unlockMessage: "Only 200 points away to unlock",
                unlockHighlight: "20 passes"
            )
            .padding(.horizontal, IndiGoSpacing.lg)
            .padding(.bottom, IndiGoSpacing.md)

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

            OneClickAwaySection(destinations: MockDestinations.all)

            FlightOffersFooterSection()
        }
        .padding(.top, IndiGoSpacing.xs)
    }
}

#Preview {
    NavigationStack {
        HomeView()
    }
    .environmentObject(BookingState())
}
