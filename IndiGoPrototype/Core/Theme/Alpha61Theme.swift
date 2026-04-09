//
//  Alpha61Theme.swift
//  IndiGoPrototype
//
//  Alpha 6.1 theme — extends Alpha 5.0 with targeted overrides.
//  Properties that remain the same as 5.0 delegate to `base`.
//  Override individual properties here as 6.1 Figma designs are finalized.
//

import SwiftUI

struct Alpha61Theme: AlphaTheme {

    private let base = Alpha50Theme()

    // -- Global Page Layout ------------------------------------------------

    var pageBackgroundColor: Color { Color(hex: "F5F8FC") }     // 6.1: light blue-gray
    var pageHorizontalPadding: CGFloat { base.pageHorizontalPadding }
    var sectionToSectionSpacing: CGFloat { base.sectionToSectionSpacing }
    var titleToContentSpacing: CGFloat { base.titleToContentSpacing }
    var sectionInternalPadding: CGFloat { base.sectionInternalPadding }
    var defaultCardCornerRadius: CGFloat { base.defaultCardCornerRadius }
    var defaultCardShadowColor: Color { base.defaultCardShadowColor }
    var carouselCardSpacing: CGFloat { base.carouselCardSpacing }
    var dividerSpacing: CGFloat { base.dividerSpacing }

    // -- Header (Figma 5602:84907 / 5602:84926 / 5656:57938) ---------------
    // StatusBar bumped to 53 (+20% from 44) for Dynamic Island clearance.
    // Expanded = StatusBar(53) + HeaderRow(48) + LOBTabs(44) + gap(16) + SearchBar(56) + gap(16) = 233
    // Inline   = StatusBar(53) + gap(12) + SearchRow(56) + gap(12) = 133

    var headerExpandedHeight: CGFloat { 233 }
    var headerInlineHeight: CGFloat { 133 }
    var headerStatusBarHeight: CGFloat { 53 }
    var headerGreetingRowHeight: CGFloat { 48 }
    var headerTopGap: CGFloat { 0 }
    var headerBottomPadding: CGFloat { 16 }
    var headerHorizontalPadding: CGFloat { 16 }
    var headerSearchHorizontalPadding: CGFloat { 16 }
    var headerShadowRadius: CGFloat { base.headerShadowRadius }
    var headerShadowY: CGFloat { base.headerShadowY }

    // -- Search Widget (6.1: From/To card + LOB tabs) ----------------------

    var searchUsesFromToMode: Bool { true }
    var searchShowsLOBTabs: Bool { true }
    var searchBarHeight: CGFloat { 56 }
    var searchBarCornerRadius: CGFloat { 8 }
    var searchMicButtonWidth: CGFloat { 56 }
    var searchMicButtonHeight: CGFloat { 40 }

    // -- For You -----------------------------------------------------------

    var forYouSectionSpacing: CGFloat { base.forYouSectionSpacing }
    var forYouColumnSpacing: CGFloat { base.forYouColumnSpacing }
    var forYouBookingsCardWidth: CGFloat { base.forYouBookingsCardWidth }
    var forYouRightColumnSpacing: CGFloat { base.forYouRightColumnSpacing }
    var forYouHorizontalPadding: CGFloat { base.forYouHorizontalPadding }
    var forYouVerticalPadding: CGFloat { base.forYouVerticalPadding }
    var forYouShowsRecentSearch: Bool { base.forYouShowsRecentSearch }
    var forYouRecentSearchCardWidth: CGFloat { 160 }               // 6.1: 160×160 square cards
    var forYouRecentSearchCardHeight: CGFloat { 160 }              // 6.1: 160×160 square cards
    var forYouRecentSearchCardSpacing: CGFloat { 8 }               // 6.1: spacing/height/8

    var forYouRecentSearchUsesSquareCards: Bool { true }           // 6.1: bordered square cards
    var forYouRecentSearchCardBorderColor: Color {                 // 6.1: indigo 12%
        Color(hex: "000099").opacity(0.12)
    }
    var forYouRecentSearchCardCornerRadius: CGFloat { 8 }          // 6.1: radius/s = 8px
    var forYouRecentSearchCardPadding: CGFloat { 16 }              // 6.1: spacing/height/16
    var forYouRecentSearchShowsHideCta: Bool { true }              // 6.1: Hide/Reveal CTA
    var forYouRecentSearchTitleFont: Font { IndiGoFonts.bodySmall() } // 6.1: Poppins Regular 12pt
    var forYouRecentSearchTitleColor: Color { Color(hex: "25304B") }  // 6.1: text/base
    var forYouRecentSearchTopPadding: CGFloat { -5 }               // 6.1: reduce top gap by ~30%
    var forYouRecentSearchBottomPadding: CGFloat { -16 }           // 6.1: reduce bottom gap by ~50%

    // -- 6E Pick -----------------------------------------------------------

    var sixEPickSectionSpacing: CGFloat { base.sixEPickSectionSpacing }
    var sixEPickCardSpacing: CGFloat { base.sixEPickCardSpacing }
    var sixEPickVerticalPadding: CGFloat { base.sixEPickVerticalPadding }
    var sixEPickChevronSize: CGFloat { base.sixEPickChevronSize }
    var sixEPickUsesGridLayout: Bool { base.sixEPickUsesGridLayout }
    var sixEPickShowsSubtitle: Bool { base.sixEPickShowsSubtitle }
    var sixEPickRowCornerRadius: CGFloat { base.sixEPickRowCornerRadius }
    var sixEPickRowPadding: CGFloat { base.sixEPickRowPadding }
    var sixEPickIconSize: CGFloat { base.sixEPickIconSize }
    var sixEPickIconBgSize: CGFloat { base.sixEPickIconBgSize }
    var sixEPickIconBgCornerRadius: CGFloat { base.sixEPickIconBgCornerRadius }
    var sixEPickGridSpacing: CGFloat { base.sixEPickGridSpacing }
    var sixEPickShowsExploreMore: Bool { base.sixEPickShowsExploreMore }
    var sixEPickHorizontalPadding: CGFloat { base.sixEPickHorizontalPadding }

    // -- Best Offers -------------------------------------------------------

    // -- Best Offers (6.1: full-image banner carousel) ----------------------

    var bestOffersCornerRadius: CGFloat { base.bestOffersCornerRadius }
    var bestOffersShadowRadius: CGFloat { 0 }                 // 6.1: no card shadow
    var bestOffersListHorizontalPadding: CGFloat { base.bestOffersListHorizontalPadding }
    var bestOffersListVerticalPadding: CGFloat { base.bestOffersListVerticalPadding }
    var bestOffersListSpacing: CGFloat { base.bestOffersListSpacing }
    var bestOffersSectionSpacing: CGFloat { 16 }              // 6.1: banner→CTA gap = 16px
    var bestOffersHorizontalPadding: CGFloat { 16 }           // 6.1: px = 16px
    var bestOffersVerticalPadding: CGFloat { 24 }             // 6.1: pb = 24px (75% of original 32)
    var bestOffersTopPadding: CGFloat { -20 }                // 6.1: tighten gap with BluChip above
    var bestOffersTitleUsesGreenSplit: Bool { false }         // 6.1: no section title at all
    var bestOffersShowsHeroCard: Bool { false }               // 6.1: no old hero card
    var bestOffersShowsViewAll: Bool { false }                // 6.1: CTA is in-section
    var bestOffersShowsProminentOffer: Bool { false }         // 6.1: no prominent offer
    var bestOffersChevronSize: CGFloat { base.bestOffersChevronSize }
    var bestOffersProminentCornerRadius: CGFloat { base.bestOffersProminentCornerRadius }

    var bestOffersUsesBannerCarousel: Bool { true }           // 6.1: full-image banner carousel
    var bestOffersBannerWidth: CGFloat { 343 }                // 6.1: card width from Figma
    var bestOffersBannerHeight: CGFloat { 194 }               // 6.1: card height from Figma
    var bestOffersBannerSpacing: CGFloat { 7 }                // 6.1: gap between cards = 7px
    var bestOffersBannerCornerRadius: CGFloat { 8 }           // 6.1: radius/s = 8px
    var bestOffersBottomBorderColor: Color {                   // 6.1: bottom border
        Color(hex: "000099").opacity(0.12)
    }
    var bestOffersCtaIconName: String { "icon-right-arrow" }  // 6.1: new arrow icon
    var bestOffersCtaIconSize: CGFloat { 24 }                 // 6.1: 24×24

    // -- BluChip (6.1: dark card with tier/ID row, Figma 5602:85032) ------

    var bluChipCardPadding: CGFloat { 16 }                   // 6.1: 16px internal padding
    var bluChipCornerRadius: CGFloat { 8 }                   // 6.1: radius/s = 8px
    var bluChipShadowRadius: CGFloat { 0 }                   // 6.1: no shadow on dark card
    var bluChipIconSize: CGFloat { base.bluChipIconSize }
    var bluChipIconBgSize: CGFloat { base.bluChipIconBgSize }
    var bluChipProgressBarHeight: CGFloat { base.bluChipProgressBarHeight }
    var bluChipHorizontalPadding: CGFloat { 16 }             // 6.1: 16px page padding
    var bluChipBottomPadding: CGFloat { base.bluChipBottomPadding }

    var bluChipUsesDarkCard: Bool { true }                   // 6.1: black card
    var bluChipDarkCardSpacing: CGFloat { 16 }               // 6.1: spacing/height/16
    var bluChipLogoSize: CGFloat { 64 }                      // 6.1: 64×64 logo
    var bluChipBalanceFontSize: CGFloat { 48 }               // 6.1: Bauhaus 48pt display
    var bluChipDividerColor: Color {                          // 6.1: white 24% divider
        Color.white.opacity(0.24)
    }
    var bluChipTierColor: Color { Color(hex: "9CD9FF") }     // 6.1: active-blue
    var bluChipIdColor: Color { Color(hex: "EAF8FF") }       // 6.1: light-blue
    var bluChipLabelColor: Color { Color(hex: "EAF8FF") }    // 6.1: light-blue
    var bluChipBalanceColor: Color { Color(hex: "AFE4FF") }  // 6.1: powder-blue
    var bluChipInfoTextColor: Color { .white }               // 6.1: base-white
    var bluChipCtaColor: Color { Color(hex: "AFE4FF") }      // 6.1: powder-blue

    // -- Community (6.1: Figma 5602:85153) --------------------------------

    var communityExpandedWidth: CGFloat { base.communityExpandedWidth }
    var communityCollapsedWidth: CGFloat { base.communityCollapsedWidth }
    var communityCardHeight: CGFloat { base.communityCardHeight }
    var communityCardSpacing: CGFloat { base.communityCardSpacing }
    var communityCornerRadius: CGFloat { base.communityCornerRadius }
    var communityCollapsedCornerRadius: CGFloat { 8 }            // 6.1: radius/s = 8px (was 24px pill)
    var communityHorizontalPadding: CGFloat { base.communityHorizontalPadding }
    var communityBottomPadding: CGFloat { 40 }                         // 6.1: 2.5× base (16 × 2.5 = 40)
    var communityShowsTitle: Bool { base.communityShowsTitle }
    var communityShowsSectionHeading: Bool { false }             // 6.1: "What's new" heading removed
    var communitySubtitleFont: Font { IndiGoFonts.bodySmall() }  // 6.1: Poppins Regular 12pt (was 10pt)
    var communityShowsNoFilterLogo: Bool { base.communityShowsNoFilterLogo }
    var communityShowsCollapsedOverlay: Bool { base.communityShowsCollapsedOverlay }
    var communityHeadingFont: Font { base.communityHeadingFont }
    var communityBadgeFont: Font { IndiGoFonts.bodyExtraSmall() }  // 6.1: label/m = Poppins Regular 10pt (was 8pt)
    var communityBadgeRadius: CGFloat { base.communityBadgeRadius }

    // -- One Click Away (6.1: light cards, "Trending destinations") ----------

    var oneClickSectionSpacing: CGFloat { 8 }
    var oneClickCarouselSpacing: CGFloat { 8 }
    var oneClickChipSpacing: CGFloat { base.oneClickChipSpacing }
    var oneClickVerticalPadding: CGFloat { 0 }
    var oneClickHorizontalPadding: CGFloat { 16 }
    var oneClickCardWidth: CGFloat { 167.5 }
    var oneClickCardHeight: CGFloat { 0 }                                // auto-height (ignored for light cards)
    var oneClickCardCornerRadius: CGFloat { 8 }
    var oneClickCardShadowRadius: CGFloat { 0 }
    var oneClickCardShadowColor: Color { .clear }
    var oneClickTitleFont: Font { IndiGoFonts.bodySmall() }              // Poppins Regular 12pt
    var oneClickTitleColor: Color { Color(hex: "25304B") }
    var oneClickTitleUsesGreenSplit: Bool { false }
    var oneClickSubtitleFont: Font { base.oneClickSubtitleFont }
    var oneClickShowsFromSelector: Bool { false }
    var oneClickShowsFilterChips: Bool { false }
    var oneClickShowsViewAll: Bool { false }
    var oneClickShowsSectionBg: Bool { false }
    var oneClickCardNameFont: Font { IndiGoFonts.displayXS() }           // BauhausStd 20pt
    var oneClickCardPriceFont: Font { .custom("Poppins-Medium", size: 16) }
    var oneClickCardShowsOriginalPrice: Bool { false }
    var oneClickCardShowsBookButton: Bool { false }
    var oneClickCardDateFirst: Bool { false }
    var oneClickCardGradientBaseColor: Color { .clear }
    var oneClickCardGradientBaseOpacity: Double { 0 }
    var oneClickCardButtonCornerRadius: CGFloat { 8 }
    var oneClickShowsViewAllCard: Bool { true }

    var oneClickUsesLightCards: Bool { true }
    var oneClickLightCardBorderColor: Color { Color(hex: "000099").opacity(0.1) }
    var oneClickCtaCircleSize: CGFloat { 32 }
    var oneClickCtaIconName: String { "icon-direction-ne-circle" }
    var oneClickCtaIconSize: CGFloat { 16 }
    var oneClickSectionLabel: String { "Trending destinations" }
    var oneClickShowsSubtitle: Bool { false }
    var oneClickViewAllCircleSize: CGFloat { 48 }
    var oneClickViewAllIconSize: CGFloat { 28 }

    // -- Flight Offers Footer (6.1: WWYIT headline, centered stat cards) ---

    var footerStatsGridSpacing: CGFloat { base.footerStatsGridSpacing }
    var footerStatsHorizontalPadding: CGFloat { base.footerStatsHorizontalPadding }
    var footerBottomPadding: CGFloat { base.footerBottomPadding }
    var footerStatCornerRadius: CGFloat { base.footerStatCornerRadius }
    var footerNegatesInterSectionGap: Bool { base.footerNegatesInterSectionGap }

    var footerMapImageName: String { "globe-map" }                              // 6.1: higher-fidelity globe map
    var footerUsesWWYITHeadline: Bool { true }                                  // 6.1: "Where will you IndiGo today?" logo
    var footerStatCardLayout: FooterStatCardLayout { .verticalCentered }        // 6.1: centered VStack layout
    var footerStatBorderColor: Color { Color(hex: "000099").opacity(0.24) }     // 6.1: indigo 24%
    var footerStatLabelColor: Color { Color(hex: "25304B") }                    // 6.1: text/base
    var footerStatLabelFont: Font { .custom("Poppins-Regular", size: 10) }      // 6.1: label/m = 10pt
    var footerStatValueFont: Font { IndiGoFonts.displaySmall() }                // 6.1: display/m = 24pt Bauhaus
    var footerStatCardPadding: CGFloat { 16 }                                   // 6.1: spacing/height/16
    var footerDailyFlightsValueFont: Font { IndiGoFonts.displaySmall() }        // 6.1: display/m = 24pt
    var footerDailyFlightsLabelFont: Font { IndiGoFonts.subHeading3() }         // 6.1: display/xs = 16pt Bauhaus

    // -- Bottom Nav Bar (6.1: flat active, semi-bold label, filled icon) --

    var navShowsLiquidGlass: Bool { false }
    var navActiveExploreIconAsset: String { "nav-explore-active" }
    var navActiveFlightsIconAsset: String { "nav-flights-active" }
    var navActiveLabelFont: Font { IndiGoFonts.navLabelSemiBold() }
    var navInactiveLabelFont: Font { IndiGoFonts.navLabel() }
    var navActiveTextColor: Color { Color(hex: "25304B") }
    var navInactiveTextColor: Color { IndiGoColors.textIndigoBlue }
    var navActiveShadowColor: Color { Color(hex: "000099").opacity(0.16) }
    var navActiveShadowRadius: CGFloat { 6 }
    var navSixEPickBgColor: Color { Color.white.opacity(0.8) }
    var navSixEPickFgColor: Color { IndiGoColors.textIndigoBlue }
    var navFourthTabLabel: String { "My trips" }
    var navFourthTabIcon: String { "nav-mytrips" }
    var navFourthTabIconIsOriginal: Bool { true }

    // -- Section ordering --------------------------------------------------

    var homeSectionOrder: [HomeSection] {
        [.forYou, .bluChip, .bestOffers, .oneClickAway, .community, .flightOffersFooter]
    }
}
