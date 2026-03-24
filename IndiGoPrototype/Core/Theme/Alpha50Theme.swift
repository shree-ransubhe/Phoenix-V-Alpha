//
//  Alpha50Theme.swift
//  IndiGoPrototype
//
//  Alpha 5.0 theme — overrides Alpha 4.1 with new Figma guidelines.
//  Source: Figma node 2204-14952 (Spacing anatomy frame).
//
//  KEY CHANGES from 4.1:
//    - Page horizontal padding: 16px (was 20px)
//    - Inter-section gap: 32px (was 8px)
//    - Title → content: 8px
//    - Card carousel gap: 8px
//    - Default card corner radius: 8px (was 16px)
//    - Shadow: IndiGo blue #000099 at 16% opacity
//    - Divider spacing: 8px
//
//  Properties that differ from 4.1 have inline values.
//  Properties that remain the same delegate to `base`.
//

import SwiftUI

struct Alpha50Theme: AlphaTheme {

    private let base = Alpha41Theme()

    // -- Global Page Layout (Figma 2204-14952) -------------------------

    var pageHorizontalPadding: CGFloat { 16 }
    var sectionToSectionSpacing: CGFloat { 32 }
    var titleToContentSpacing: CGFloat { 8 }
    var sectionInternalPadding: CGFloat { 16 }
    var defaultCardCornerRadius: CGFloat { 8 }
    var defaultCardShadowColor: Color { Color(hex: "000099").opacity(0.16) }
    var carouselCardSpacing: CGFloat { 8 }
    var dividerSpacing: CGFloat { 8 }

    // -- Header --------------------------------------------------------

    var headerExpandedHeight: CGFloat { base.headerExpandedHeight }
    var headerInlineHeight: CGFloat { base.headerInlineHeight }
    var headerStatusBarHeight: CGFloat { base.headerStatusBarHeight }
    var headerGreetingRowHeight: CGFloat { base.headerGreetingRowHeight }
    var headerTopGap: CGFloat { 16 }                        // 5.0: 16px (was 24)
    var headerBottomPadding: CGFloat { 16 }                 // 5.0: 16px (same but explicit)
    var headerHorizontalPadding: CGFloat { 16 }             // 5.0: 16px (was 24)
    var headerSearchHorizontalPadding: CGFloat { 16 }       // 5.0: 16px (was 20)
    var headerShadowRadius: CGFloat { base.headerShadowRadius }
    var headerShadowY: CGFloat { base.headerShadowY }

    // -- For You -------------------------------------------------------

    var forYouSectionSpacing: CGFloat { 8 }                 // 5.0: title→content = 8px
    var forYouColumnSpacing: CGFloat { 8 }                  // 5.0: card gap = 8px (was 16)
    var forYouBookingsCardWidth: CGFloat { 167.5 }          // 5.0: from Figma (was 159)
    var forYouRightColumnSpacing: CGFloat { 8 }             // 5.0: 8px (was 12)
    var forYouHorizontalPadding: CGFloat { 16 }             // 5.0: 16px (was 20)
    var forYouVerticalPadding: CGFloat { 16 }               // 5.0: 16px (was 8)
    var forYouShowsRecentSearch: Bool { true }
    var forYouRecentSearchCardWidth: CGFloat { base.forYouRecentSearchCardWidth }
    var forYouRecentSearchCardHeight: CGFloat { base.forYouRecentSearchCardHeight }
    var forYouRecentSearchCardSpacing: CGFloat { base.forYouRecentSearchCardSpacing }

    // -- 6E Pick -------------------------------------------------------

    var sixEPickSectionSpacing: CGFloat { 8 }               // 5.0: title→content = 8px (was 16)
    var sixEPickCardSpacing: CGFloat { 8 }                  // 5.0: carousel gap = 8px (same)
    var sixEPickVerticalPadding: CGFloat { 16 }             // 5.0: section padding = 16px (same)
    var sixEPickChevronSize: CGFloat { 36 }                 // 5.0: from Figma (was 32)
    var sixEPickUsesGridLayout: Bool { true }               // 5.0: 2-col grid (was h-scroll carousel)
    var sixEPickShowsSubtitle: Bool { true }                // 5.0: shows subtitle text
    var sixEPickRowCornerRadius: CGFloat { 8 }              // 5.0: row corner radius
    var sixEPickRowPadding: CGFloat { 16 }                  // 5.0: row internal padding
    var sixEPickIconSize: CGFloat { 16 }                    // 5.0: icon size inside avatar
    var sixEPickIconBgSize: CGFloat { 32 }                  // 5.0: avatar container size
    var sixEPickIconBgCornerRadius: CGFloat { 8 }           // 5.0: avatar corner radius
    var sixEPickGridSpacing: CGFloat { 8 }                  // 5.0: gap between grid rows/cols
    var sixEPickShowsExploreMore: Bool { true }             // 5.0: "Explore 5 more" footer row
    var sixEPickHorizontalPadding: CGFloat { 16 }           // 5.0: 16px (was 20)

    // -- Best Offers ---------------------------------------------------

    var bestOffersCornerRadius: CGFloat { 8 }               // 5.0: 8px (was 16)
    var bestOffersShadowRadius: CGFloat { 12 }
    var bestOffersListHorizontalPadding: CGFloat { 16 }     // 5.0: 16px (was 12)
    var bestOffersListVerticalPadding: CGFloat { 16 }
    var bestOffersListSpacing: CGFloat { 8 }                // 5.0: divider spacing = 8px (was 12)
    var bestOffersSectionSpacing: CGFloat { 8 }             // 5.0: title→content = 8px (same)
    var bestOffersHorizontalPadding: CGFloat { 16 }         // 5.0: 16px (was 20)
    var bestOffersVerticalPadding: CGFloat { 16 }           // 5.0: 16px (was 8)
    var bestOffersTopPadding: CGFloat { 0 }                 // 5.0: 0px — inter-section gap handles top space

    var bestOffersTitleUsesGreenSplit: Bool { true }        // 5.0: "Find exciting [offers here]"
    var bestOffersShowsHeroCard: Bool { false }             // 5.0: hero card removed
    var bestOffersShowsViewAll: Bool { true }               // 5.0: "View all" button
    var bestOffersShowsProminentOffer: Bool { true }        // 5.0: gradient promo card at bottom
    var bestOffersChevronSize: CGFloat { 36 }               // 5.0: 36px (was 32)
    var bestOffersProminentCornerRadius: CGFloat { 8 }      // 5.0: 8px

    // -- BluChip -------------------------------------------------------

    var bluChipCardPadding: CGFloat { base.bluChipCardPadding }
    var bluChipCornerRadius: CGFloat { base.bluChipCornerRadius }
    var bluChipShadowRadius: CGFloat { base.bluChipShadowRadius }
    var bluChipIconSize: CGFloat { base.bluChipIconSize }
    var bluChipIconBgSize: CGFloat { base.bluChipIconBgSize }
    var bluChipProgressBarHeight: CGFloat { base.bluChipProgressBarHeight }
    var bluChipHorizontalPadding: CGFloat { 16 }            // 5.0: 16px (was 20)
    var bluChipBottomPadding: CGFloat { 16 }

    // -- Community -----------------------------------------------------

    var communityExpandedWidth: CGFloat { 299 }             // 5.0: from Figma (was 300)
    var communityCollapsedWidth: CGFloat { 36 }
    var communityCardHeight: CGFloat { 200 }                // 5.0: from Figma (was 213)
    var communityCardSpacing: CGFloat { 8 }                 // 5.0: 8px (was 7)
    var communityCornerRadius: CGFloat { 8 }                // 5.0: 8px expanded (was 12)
    var communityCollapsedCornerRadius: CGFloat { 24 }      // 5.0: 24px collapsed (was 12)
    var communityHorizontalPadding: CGFloat { 16 }          // 5.0: 16px (was 20)
    var communityBottomPadding: CGFloat { 16 }              // 5.0: 16px (was 20)
    var communityShowsTitle: Bool { true }                   // 5.0: title + subtitle
    var communityShowsNoFilterLogo: Bool { false }           // 5.0: removed
    var communityShowsCollapsedOverlay: Bool { true }        // 5.0: 40% black overlay
    var communityHeadingFont: Font { .custom("BauhausStd-Medium", size: 16) }  // 5.0: 16pt (was 20)
    var communityBadgeFont: Font { IndiGoFonts.bodyExtraExtraSmall() }          // 5.0: Poppins 8pt (was Bauhaus 12)
    var communityBadgeRadius: CGFloat { 24 }                // 5.0: 24px pill (was capsule)

    // -- One Click Away ------------------------------------------------

    var oneClickSectionSpacing: CGFloat { 8 }
    var oneClickCarouselSpacing: CGFloat { 8 }
    var oneClickChipSpacing: CGFloat { 8 }                  // 5.0: 8px (was 4)
    var oneClickVerticalPadding: CGFloat { 16 }             // 5.0: 16px (same)
    var oneClickHorizontalPadding: CGFloat { 16 }           // 5.0: 16px (was 20)

    var oneClickCardWidth: CGFloat { 200 }                  // 5.0: from Figma
    var oneClickCardHeight: CGFloat { 260 }                 // 5.0: from Figma
    var oneClickCardCornerRadius: CGFloat { 8 }
    var oneClickCardShadowRadius: CGFloat { 12 }
    var oneClickCardShadowColor: Color { Color(hex: "000099").opacity(0.16) }

    var oneClickTitleFont: Font { IndiGoFonts.displayXS() }
    var oneClickTitleColor: Color { Color(hex: "25304B") }
    var oneClickTitleUsesGreenSplit: Bool { false }
    var oneClickSubtitleFont: Font { IndiGoFonts.navLabel() }

    var oneClickShowsFromSelector: Bool { false }
    var oneClickShowsFilterChips: Bool { false }
    var oneClickShowsViewAll: Bool { true }
    var oneClickShowsSectionBg: Bool { false }

    var oneClickCardNameFont: Font { IndiGoFonts.displayXS() }
    var oneClickCardPriceFont: Font { .custom("Poppins-Medium", size: 16) }
    var oneClickCardShowsOriginalPrice: Bool { false }
    var oneClickCardShowsBookButton: Bool { false }
    var oneClickCardDateFirst: Bool { true }
    var oneClickCardGradientBaseColor: Color { Color(hex: "25304B") }
    var oneClickCardGradientBaseOpacity: Double { 0.8 }
    var oneClickCardButtonCornerRadius: CGFloat { 8 }
    var oneClickShowsViewAllCard: Bool { true }

    // -- Flight Offers Footer ------------------------------------------

    var footerStatsGridSpacing: CGFloat { 8 }               // 5.0: 8px (was 12)
    var footerStatsHorizontalPadding: CGFloat { 16 }        // 5.0: 16px (same)
    var footerBottomPadding: CGFloat { 100 }                // 5.0: clears BottomNavBar + safe area
    var footerStatCornerRadius: CGFloat { 8 }               // 5.0: 8px (was 12)
    var footerNegatesInterSectionGap: Bool { true }         // 5.0: footer sits flush below OneClickAway

    // -- Section ordering (same as 4.1 by default — override to reorder)

    var homeSectionOrder: [HomeSection] { base.homeSectionOrder }
}
