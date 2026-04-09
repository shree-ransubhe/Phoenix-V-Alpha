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

    let pageBackgroundColor: Color = IndiGoColors.background  // white
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

    // -- Search Widget (defaults: text-pill mode) ----------------------

    let searchUsesFromToMode: Bool = false
    let searchShowsLOBTabs: Bool = false
    let searchBarHeight: CGFloat = 60
    let searchBarCornerRadius: CGFloat = 12
    let searchMicButtonWidth: CGFloat = 56
    let searchMicButtonHeight: CGFloat = 40

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

    let forYouRecentSearchUsesSquareCards: Bool = false
    let forYouRecentSearchCardBorderColor: Color = .clear
    let forYouRecentSearchCardCornerRadius: CGFloat = 8
    let forYouRecentSearchCardPadding: CGFloat = 16
    let forYouRecentSearchShowsHideCta: Bool = false
    var forYouRecentSearchTitleFont: Font { IndiGoFonts.displayXS() }
    let forYouRecentSearchTitleColor: Color = Color(hex: "25304B")
    let forYouRecentSearchTopPadding: CGFloat = 0
    let forYouRecentSearchBottomPadding: CGFloat = 0

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
    let bestOffersTopPadding: CGFloat = 8                // same as vertical

    let bestOffersTitleUsesGreenSplit: Bool = false
    let bestOffersShowsHeroCard: Bool = true
    let bestOffersShowsViewAll: Bool = false
    let bestOffersShowsProminentOffer: Bool = false
    let bestOffersChevronSize: CGFloat = 32
    let bestOffersProminentCornerRadius: CGFloat = 16

    let bestOffersUsesBannerCarousel: Bool = false
    let bestOffersBannerWidth: CGFloat = 343
    let bestOffersBannerHeight: CGFloat = 194
    let bestOffersBannerSpacing: CGFloat = 7
    let bestOffersBannerCornerRadius: CGFloat = 8
    let bestOffersBottomBorderColor: Color = .clear
    let bestOffersCtaIconName: String = "icon-accordion-right"
    let bestOffersCtaIconSize: CGFloat = 16

    // -- BluChip -------------------------------------------------------

    let bluChipCardPadding: CGFloat = 12
    let bluChipCornerRadius: CGFloat = 16
    let bluChipShadowRadius: CGFloat = 12
    let bluChipIconSize: CGFloat = 20
    let bluChipIconBgSize: CGFloat = 36
    let bluChipProgressBarHeight: CGFloat = 12
    let bluChipHorizontalPadding: CGFloat = 20  // IndiGoSpacing.lg
    let bluChipBottomPadding: CGFloat = 16      // IndiGoSpacing.md

    let bluChipUsesDarkCard: Bool = false
    let bluChipDarkCardSpacing: CGFloat = 16
    let bluChipLogoSize: CGFloat = 64
    let bluChipBalanceFontSize: CGFloat = 48
    let bluChipDividerColor: Color = Color.white.opacity(0.24)
    let bluChipTierColor: Color = Color(hex: "9CD9FF")
    let bluChipIdColor: Color = Color(hex: "EAF8FF")
    let bluChipLabelColor: Color = Color(hex: "EAF8FF")
    let bluChipBalanceColor: Color = Color(hex: "AFE4FF")
    let bluChipInfoTextColor: Color = .white
    let bluChipCtaColor: Color = Color(hex: "AFE4FF")

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
    let communityShowsSectionHeading: Bool = false
    var communitySubtitleFont: Font { IndiGoFonts.bodyExtraSmall() }
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

    let oneClickUsesLightCards: Bool = false
    let oneClickLightCardBorderColor: Color = .clear
    let oneClickCtaCircleSize: CGFloat = 32
    let oneClickCtaIconName: String = "icon-direction-ne-circle"
    let oneClickCtaIconSize: CGFloat = 16
    let oneClickSectionLabel: String = "One Click Away"
    let oneClickShowsSubtitle: Bool = true
    let oneClickViewAllCircleSize: CGFloat = 48
    let oneClickViewAllIconSize: CGFloat = 28

    // -- Flight Offers Footer ------------------------------------------

    let footerStatsGridSpacing: CGFloat = 12    // IndiGoSpacing.sm
    let footerStatsHorizontalPadding: CGFloat = 16  // IndiGoSpacing.md
    let footerBottomPadding: CGFloat = 120
    let footerStatCornerRadius: CGFloat = 12    // IndiGoSpacing.radiusMd
    let footerNegatesInterSectionGap: Bool = false

    let footerMapImageName: String = "world-map-dotted"
    let footerUsesWWYITHeadline: Bool = false
    let footerStatCardLayout: FooterStatCardLayout = .horizontalLeading
    var footerStatBorderColor: Color { IndiGoColors.footerStatBorder }
    var footerStatLabelColor: Color { IndiGoColors.footerStatLabel }
    var footerStatLabelFont: Font { .custom("Poppins-Regular", size: 9) }
    var footerStatValueFont: Font { IndiGoFonts.displaySmall() }
    let footerStatCardPadding: CGFloat = 8
    var footerDailyFlightsValueFont: Font { IndiGoFonts.displaySmall() }
    var footerDailyFlightsLabelFont: Font { IndiGoFonts.bodyMedium() }

    // -- Bottom Nav Bar ------------------------------------------------

    let navShowsLiquidGlass: Bool = true
    let navActiveExploreIconAsset: String = "nav-explore"
    let navActiveFlightsIconAsset: String = "nav-flights"
    var navActiveLabelFont: Font { IndiGoFonts.navLabel() }
    var navInactiveLabelFont: Font { IndiGoFonts.navLabel() }
    var navActiveTextColor: Color { IndiGoColors.textIndigoBlue }
    var navInactiveTextColor: Color { IndiGoColors.textDarkGrey }
    var navActiveShadowColor: Color { .clear }
    let navActiveShadowRadius: CGFloat = 0
    var navSixEPickBgColor: Color { IndiGoColors.backgroundBase }
    var navSixEPickFgColor: Color { .white }
    let navFourthTabLabel: String = "Check-in"
    let navFourthTabIcon: String = "nav-checkin"
    let navFourthTabIconIsOriginal: Bool = false

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
