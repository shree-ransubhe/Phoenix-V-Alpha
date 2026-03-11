//
//  IndiGoFonts.swift
//  IndiGoPrototype
//
//  Design tokens – typography.
//
//  Font families (from Figma / Assets/fonts):
//    Display:        BauhausStd-Medium  (L, M, S, XS)
//    Body/Label:     Poppins-Regular    (regular weight)
//    Heading/Bold:   Poppins-SemiBold   (semi-bold weight)
//

import SwiftUI

enum IndiGoFonts {

    // MARK: - Font family names (must match the PostScript name in the .ttf)

    private static let poppinsLight    = "Poppins-Light"
    private static let poppinsRegular  = "Poppins-Regular"
    private static let poppinsMedium   = "Poppins-Medium"
    private static let poppinsSemiBold = "Poppins-SemiBold"
    private static let bauhausDisplay  = "BauhausStd-Medium"

    // MARK: - Display (BauhausStd)

    static func displayHero() -> Font { .custom(bauhausDisplay, size: 44) }
    static func displayLarge() -> Font { .custom(bauhausDisplay, size: 32) }
    static func displayMedium() -> Font { .custom(bauhausDisplay, size: 28) }
    static func displaySmall() -> Font { .custom(bauhausDisplay, size: 24) }
    static func displayXS() -> Font { .custom(bauhausDisplay, size: 20) }

    // MARK: - Headings (Poppins SemiBold)

    static func heading1() -> Font { .custom(poppinsSemiBold, size: 24) }
    static func heading2() -> Font { .custom(poppinsSemiBold, size: 20) }
    static func heading3() -> Font { .custom(poppinsSemiBold, size: 18) }

    // MARK: - Body (Poppins Regular / SemiBold)

    static func bodyLarge() -> Font { .custom(poppinsRegular, size: 16) }
    static func body() -> Font { .custom(poppinsRegular, size: 14) }
    static func bodySemiBold() -> Font { .custom(poppinsSemiBold, size: 14) }
    static func bodySmall() -> Font { .custom(poppinsRegular, size: 12) }

    // MARK: - Labels & captions (Poppins)

    static func caption() -> Font { .custom(poppinsRegular, size: 12) }
    static func captionBold() -> Font { .custom(poppinsSemiBold, size: 12) }
    static func label() -> Font { .custom(poppinsRegular, size: 11) }
    static func labelSemiBold() -> Font { .custom(poppinsSemiBold, size: 11) }

    // MARK: - Placeholder / Light weight

    static func placeholder() -> Font { .custom(poppinsLight, size: 14) }
    static func buttonWeb() -> Font { .custom(poppinsMedium, size: 16) }

    // MARK: - Sub Headings (Bauhaus / Poppins)

    static func subHeading3() -> Font { .custom(bauhausDisplay, size: 16) }
    static func subHeading6() -> Font { .custom(poppinsSemiBold, size: 14) }

    // MARK: - Extra-small body (Poppins 10pt)

    static func bodyExtraSmall() -> Font { .custom(poppinsRegular, size: 10) }
    static func bodyExtraSmallBold() -> Font { .custom(poppinsSemiBold, size: 10) }

    // MARK: - Nav label (Poppins Regular 10pt / lineHeight 16)

    static func navLabel() -> Font { .custom(poppinsRegular, size: 10) }

    // MARK: - Medium weight (Poppins Medium)

    static func bodyMedium() -> Font { .custom(poppinsMedium, size: 14) }
    static func bodyExtraSmallMedium() -> Font { .custom(poppinsMedium, size: 10) }

    // Buttons (Poppins Medium 14pt – Figma: Buttons/Mobile/Primary and Secondary)
    static func buttonMobile() -> Font { .custom(poppinsMedium, size: 14) }

    // Body Medium 12pt
    static func bodySmallMedium() -> Font { .custom(poppinsMedium, size: 12) }
}
