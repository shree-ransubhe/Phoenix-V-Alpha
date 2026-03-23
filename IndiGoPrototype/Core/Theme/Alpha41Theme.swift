//
//  Alpha41Theme.swift
//  IndiGoPrototype
//
//  Alpha 4.1 theme — preserves every hardcoded value from the original views.
//  This is the baseline. All values here match the pre-theme codebase exactly.
//

import SwiftUI

struct Alpha41Theme: AlphaTheme {

    // -- Global Page Layout --------------------------------------------

    let pageHorizontalPadding: CGFloat = 20     // IndiGoSpacing.lg
    let sectionToSectionSpacing: CGFloat = 8    // IndiGoSpacing.xs (original HomeView VStack spacing)
    let titleToContentSpacing: CGFloat = 8      // IndiGoSpacing.xs
    let sectionInternalPadding: CGFloat = 8     // IndiGoSpacing.xs (original .padding(.top, .xs))
    let defaultCardCornerRadius: CGFloat = 16   // IndiGoSpacing.radiusLg
    let defaultCardShadowColor: Color = .clear
    let carouselCardSpacing: CGFloat = 8        // IndiGoSpacing.xs
    let dividerSpacing: CGFloat = 8             // IndiGoSpacing.xs

    // -- Header --------------------------------------------------------

    let headerExpandedHeight: CGFloat = 207
    let headerInlineHeight: CGFloat = 139
    let headerStatusBarHeight: CGFloat = 44
    let headerGreetingRowHeight: CGFloat = 44
    let headerTopGap: CGFloat = 24
    let headerBottomPadding: CGFloat = 16
    let headerHorizontalPadding: CGFloat = 24
    let headerSearchHorizontalPadding: CGFloat = 20
    let headerShadowRadius: CGFloat = 8
    let headerShadowY: CGFloat = 4

    // -- For You -------------------------------------------------------

    let forYouSectionSpacing: CGFloat = 8   // IndiGoSpacing.xs
    let forYouColumnSpacing: CGFloat = 16   // IndiGoSpacing.md
    let forYouBookingsCardWidth: CGFloat = 159
    let forYouRightColumnSpacing: CGFloat = 12  // IndiGoSpacing.sm
    let forYouHorizontalPadding: CGFloat = 20   // IndiGoSpacing.lg
    let forYouVerticalPadding: CGFloat = 8      // IndiGoSpacing.xs
    let forYouShowsRecentSearch: Bool = false
    let forYouRecentSearchCardWidth: CGFloat = 200
    let forYouRecentSearchCardHeight: CGFloat = 84
    let forYouRecentSearchCardSpacing: CGFloat = 8

    // -- 6E Pick -------------------------------------------------------

    let sixEPickSectionSpacing: CGFloat = 16    // IndiGoSpacing.md
    let sixEPickCardSpacing: CGFloat = 8        // IndiGoSpacing.xs
    let sixEPickVerticalPadding: CGFloat = 16   // IndiGoSpacing.md
    let sixEPickChevronSize: CGFloat = 32
    let sixEPickUsesGridLayout: Bool = false
    let sixEPickShowsSubtitle: Bool = false
    let sixEPickRowCornerRadius: CGFloat = 8
    let sixEPickRowPadding: CGFloat = 16
    let sixEPickIconSize: CGFloat = 16
    let sixEPickIconBgSize: CGFloat = 32
    let sixEPickIconBgCornerRadius: CGFloat = 8
    let sixEPickGridSpacing: CGFloat = 8
    let sixEPickShowsExploreMore: Bool = false
    let sixEPickHorizontalPadding: CGFloat = 20

    // -- Best Offers ---------------------------------------------------

    let bestOffersCornerRadius: CGFloat = 16    // IndiGoSpacing.radiusLg
    let bestOffersShadowRadius: CGFloat = 12
    let bestOffersListHorizontalPadding: CGFloat = 12   // IndiGoSpacing.sm
    let bestOffersListVerticalPadding: CGFloat = 16      // IndiGoSpacing.md
    let bestOffersListSpacing: CGFloat = 12              // IndiGoSpacing.sm
    let bestOffersSectionSpacing: CGFloat = 8            // IndiGoSpacing.xs
    let bestOffersHorizontalPadding: CGFloat = 20        // IndiGoSpacing.lg
    let bestOffersVerticalPadding: CGFloat = 8           // IndiGoSpacing.xs

    let bestOffersTitleUsesGreenSplit: Bool = false
    let bestOffersShowsHeroCard: Bool = true
    let bestOffersShowsViewAll: Bool = false
    let bestOffersShowsProminentOffer: Bool = false
    let bestOffersChevronSize: CGFloat = 32
    let bestOffersProminentCornerRadius: CGFloat = 16

    // -- BluChip -------------------------------------------------------

    let bluChipCardPadding: CGFloat = 12
    let bluChipCornerRadius: CGFloat = 16
    let bluChipShadowRadius: CGFloat = 12
    let bluChipIconSize: CGFloat = 20
    let bluChipIconBgSize: CGFloat = 36
    let bluChipProgressBarHeight: CGFloat = 12
    let bluChipHorizontalPadding: CGFloat = 20  // IndiGoSpacing.lg
    let bluChipBottomPadding: CGFloat = 16      // IndiGoSpacing.md

    // -- Community -----------------------------------------------------

    let communityExpandedWidth: CGFloat = 300
    let communityCollapsedWidth: CGFloat = 36
    let communityCardHeight: CGFloat = 213
    let communityCardSpacing: CGFloat = 7
    let communityCornerRadius: CGFloat = 12
    let communityCollapsedCornerRadius: CGFloat = 12
    let communityHorizontalPadding: CGFloat = 20    // IndiGoSpacing.lg
    let communityBottomPadding: CGFloat = 20        // IndiGoSpacing.lg
    let communityShowsTitle: Bool = false
    let communityShowsNoFilterLogo: Bool = true
    let communityShowsCollapsedOverlay: Bool = false
    var communityHeadingFont: Font { IndiGoFonts.displayXS() }
    var communityBadgeFont: Font { .custom("BauhausStd-Medium", size: 12) }
    let communityBadgeRadius: CGFloat = 500         // capsule

    // -- One Click Away ------------------------------------------------

    let oneClickSectionSpacing: CGFloat = 16    // IndiGoSpacing.md
    let oneClickCarouselSpacing: CGFloat = 24   // IndiGoSpacing.xl
    let oneClickChipSpacing: CGFloat = 4        // IndiGoSpacing.xxs
    let oneClickVerticalPadding: CGFloat = 16   // IndiGoSpacing.md
    let oneClickHorizontalPadding: CGFloat = 20 // IndiGoSpacing.lg

    let oneClickCardWidth: CGFloat = 193
    let oneClickCardHeight: CGFloat = 270
    let oneClickCardCornerRadius: CGFloat = 16  // IndiGoSpacing.radiusLg
    let oneClickCardShadowRadius: CGFloat = 0
    let oneClickCardShadowColor: Color = .clear

    var oneClickTitleFont: Font { IndiGoFonts.displaySmall() }        // 24pt
    let oneClickTitleColor: Color = Color(hex: "25304B")
    let oneClickTitleUsesGreenSplit: Bool = true
    var oneClickSubtitleFont: Font { IndiGoFonts.bodySmall() }        // 12pt

    let oneClickShowsFromSelector: Bool = true
    let oneClickShowsFilterChips: Bool = true
    let oneClickShowsViewAll: Bool = false
    let oneClickShowsSectionBg: Bool = true

    var oneClickCardNameFont: Font { IndiGoFonts.subHeading3() }      // 16pt
    var oneClickCardPriceFont: Font { IndiGoFonts.subHeading3() }     // 16pt
    let oneClickCardShowsOriginalPrice: Bool = true
    let oneClickCardShowsBookButton: Bool = true
    let oneClickCardDateFirst: Bool = false
    let oneClickCardGradientBaseColor: Color = .black
    let oneClickCardGradientBaseOpacity: Double = 0.5
    let oneClickCardButtonCornerRadius: CGFloat = 500   // capsule
    let oneClickShowsViewAllCard: Bool = false

    // -- Flight Offers Footer ------------------------------------------

    let footerStatsGridSpacing: CGFloat = 12    // IndiGoSpacing.sm
    let footerStatsHorizontalPadding: CGFloat = 16  // IndiGoSpacing.md
    let footerBottomPadding: CGFloat = 120
    let footerStatCornerRadius: CGFloat = 12    // IndiGoSpacing.radiusMd
    let footerNegatesInterSectionGap: Bool = false

    // -- Section ordering (original order) -----------------------------

    let homeSectionOrder: [HomeSection] = [
        .forYou,
        .sixEPick,
        .bestOffers,
        .bluChip,
        .community,
        .oneClickAway,
        .flightOffersFooter
    ]
}
