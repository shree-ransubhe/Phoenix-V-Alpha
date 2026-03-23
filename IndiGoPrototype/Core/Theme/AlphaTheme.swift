//
//  AlphaTheme.swift
//  IndiGoPrototype
//
//  Protocol defining all visual knobs that vary between Alpha versions.
//  Each Home/Explore section reads from the active theme instead of
//  hardcoding layout values. Add new properties here when a section
//  needs a version-specific tweak.
//

import SwiftUI

// MARK: - Home section identifiers (for ordering)

enum HomeSection: String, CaseIterable, Identifiable {
    case forYou
    case sixEPick
    case bestOffers
    case bluChip
    case community
    case oneClickAway
    case flightOffersFooter

    var id: String { rawValue }
}

// MARK: - Theme protocol

protocol AlphaTheme {

    // -- Global Page Layout (from Figma spacing anatomy) ---------------

    var pageHorizontalPadding: CGFloat { get }
    var sectionToSectionSpacing: CGFloat { get }
    var titleToContentSpacing: CGFloat { get }
    var sectionInternalPadding: CGFloat { get }
    var defaultCardCornerRadius: CGFloat { get }
    var defaultCardShadowColor: Color { get }
    var carouselCardSpacing: CGFloat { get }
    var dividerSpacing: CGFloat { get }

    // -- Header --------------------------------------------------------

    var headerExpandedHeight: CGFloat { get }
    var headerInlineHeight: CGFloat { get }
    var headerStatusBarHeight: CGFloat { get }
    var headerGreetingRowHeight: CGFloat { get }
    var headerTopGap: CGFloat { get }
    var headerBottomPadding: CGFloat { get }
    var headerHorizontalPadding: CGFloat { get }
    var headerSearchHorizontalPadding: CGFloat { get }
    var headerShadowRadius: CGFloat { get }
    var headerShadowY: CGFloat { get }

    // -- For You -------------------------------------------------------

    var forYouSectionSpacing: CGFloat { get }
    var forYouColumnSpacing: CGFloat { get }
    var forYouBookingsCardWidth: CGFloat { get }
    var forYouRightColumnSpacing: CGFloat { get }
    var forYouHorizontalPadding: CGFloat { get }
    var forYouVerticalPadding: CGFloat { get }
    var forYouShowsRecentSearch: Bool { get }
    var forYouRecentSearchCardWidth: CGFloat { get }
    var forYouRecentSearchCardHeight: CGFloat { get }
    var forYouRecentSearchCardSpacing: CGFloat { get }

    // -- 6E Pick -------------------------------------------------------

    var sixEPickSectionSpacing: CGFloat { get }
    var sixEPickCardSpacing: CGFloat { get }
    var sixEPickVerticalPadding: CGFloat { get }
    var sixEPickChevronSize: CGFloat { get }
    var sixEPickUsesGridLayout: Bool { get }
    var sixEPickShowsSubtitle: Bool { get }
    var sixEPickRowCornerRadius: CGFloat { get }
    var sixEPickRowPadding: CGFloat { get }
    var sixEPickIconSize: CGFloat { get }
    var sixEPickIconBgSize: CGFloat { get }
    var sixEPickIconBgCornerRadius: CGFloat { get }
    var sixEPickGridSpacing: CGFloat { get }
    var sixEPickShowsExploreMore: Bool { get }
    var sixEPickHorizontalPadding: CGFloat { get }

    // -- Best Offers ---------------------------------------------------

    var bestOffersCornerRadius: CGFloat { get }
    var bestOffersShadowRadius: CGFloat { get }
    var bestOffersListHorizontalPadding: CGFloat { get }
    var bestOffersListVerticalPadding: CGFloat { get }
    var bestOffersListSpacing: CGFloat { get }
    var bestOffersSectionSpacing: CGFloat { get }
    var bestOffersHorizontalPadding: CGFloat { get }
    var bestOffersVerticalPadding: CGFloat { get }

    var bestOffersTitleUsesGreenSplit: Bool { get }
    var bestOffersShowsHeroCard: Bool { get }
    var bestOffersShowsViewAll: Bool { get }
    var bestOffersShowsProminentOffer: Bool { get }
    var bestOffersChevronSize: CGFloat { get }
    var bestOffersProminentCornerRadius: CGFloat { get }

    // -- BluChip -------------------------------------------------------

    var bluChipCardPadding: CGFloat { get }
    var bluChipCornerRadius: CGFloat { get }
    var bluChipShadowRadius: CGFloat { get }
    var bluChipIconSize: CGFloat { get }
    var bluChipIconBgSize: CGFloat { get }
    var bluChipProgressBarHeight: CGFloat { get }
    var bluChipHorizontalPadding: CGFloat { get }
    var bluChipBottomPadding: CGFloat { get }

    // -- Community -----------------------------------------------------

    var communityExpandedWidth: CGFloat { get }
    var communityCollapsedWidth: CGFloat { get }
    var communityCardHeight: CGFloat { get }
    var communityCardSpacing: CGFloat { get }
    var communityCornerRadius: CGFloat { get }
    var communityCollapsedCornerRadius: CGFloat { get }
    var communityHorizontalPadding: CGFloat { get }
    var communityBottomPadding: CGFloat { get }
    var communityShowsTitle: Bool { get }
    var communityShowsNoFilterLogo: Bool { get }
    var communityShowsCollapsedOverlay: Bool { get }
    var communityHeadingFont: Font { get }
    var communityBadgeFont: Font { get }
    var communityBadgeRadius: CGFloat { get }

    // -- One Click Away ------------------------------------------------

    var oneClickSectionSpacing: CGFloat { get }
    var oneClickCarouselSpacing: CGFloat { get }
    var oneClickChipSpacing: CGFloat { get }
    var oneClickVerticalPadding: CGFloat { get }
    var oneClickHorizontalPadding: CGFloat { get }

    var oneClickCardWidth: CGFloat { get }
    var oneClickCardHeight: CGFloat { get }
    var oneClickCardCornerRadius: CGFloat { get }
    var oneClickCardShadowRadius: CGFloat { get }
    var oneClickCardShadowColor: Color { get }

    var oneClickTitleFont: Font { get }
    var oneClickTitleColor: Color { get }
    var oneClickTitleUsesGreenSplit: Bool { get }
    var oneClickSubtitleFont: Font { get }

    var oneClickShowsFromSelector: Bool { get }
    var oneClickShowsFilterChips: Bool { get }
    var oneClickShowsViewAll: Bool { get }
    var oneClickShowsSectionBg: Bool { get }

    var oneClickCardNameFont: Font { get }
    var oneClickCardPriceFont: Font { get }
    var oneClickCardShowsOriginalPrice: Bool { get }
    var oneClickCardShowsBookButton: Bool { get }
    var oneClickCardDateFirst: Bool { get }
    var oneClickCardGradientBaseColor: Color { get }
    var oneClickCardGradientBaseOpacity: Double { get }
    var oneClickCardButtonCornerRadius: CGFloat { get }
    var oneClickShowsViewAllCard: Bool { get }

    // -- Flight Offers Footer ------------------------------------------

    var footerStatsGridSpacing: CGFloat { get }
    var footerStatsHorizontalPadding: CGFloat { get }
    var footerBottomPadding: CGFloat { get }
    var footerStatCornerRadius: CGFloat { get }
    var footerNegatesInterSectionGap: Bool { get }

    // -- Section ordering ----------------------------------------------

    var homeSectionOrder: [HomeSection] { get }
}

// MARK: - Derived helpers

extension AlphaTheme {
    var headerCollapseRange: CGFloat {
        headerExpandedHeight - headerInlineHeight
    }
}
