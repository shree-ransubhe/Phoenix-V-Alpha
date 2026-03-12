//
//  IndiGoColors.swift
//  IndiGoPrototype
//
//  Design tokens – colors. Values to be aligned with Figma Dev Mode.
//

import SwiftUI

enum IndiGoColors {
    // Primary
    static let primary = Color(hex: "E31937")
    static let primaryDark = Color(hex: "B8142C")
    static let indigoBlue = Color(hex: "000099")

    // Backgrounds
    static let background = Color(hex: "FFFFFF")
    static let backgroundSecondary = Color(hex: "F5F5F5")
    static let surface = Color(hex: "FFFFFF")
    static let backgroundBase = Color(hex: "25304B")

    // Text
    static let textPrimary = Color(hex: "1A1A1A")
    static let textSecondary = Color(hex: "6B6B6B")
    static let textTertiary = Color(hex: "9E9E9E")
    static let textIndigoBlue = Color(hex: "000099")
    static let textDarkGrey = Color(hex: "4B5772")

    // Borders & dividers
    static let border = Color(hex: "E0E0E0")
    static let divider = Color(hex: "EEEEEE")

    // Nav-specific
    static let navBarBlur = Color.white.opacity(0.8)
    static let stickyFooterBg = Color.white.opacity(0.12)

    // Search widget
    static let searchBarGlass = Color.black.opacity(0.5)
    static let searchBarGlassLight = Color(hex: "EBECEE").opacity(0.1)
    static let searchBarBorder = Color.white
    static let searchAccentBar = Color(hex: "EAF8FF")
    static let searchPlaceholder = Color.white

    // Header banner overlays
    static let headerOverlayBase = Color.black.opacity(0.6)
    static let headerOverlayBlue = Color(hex: "001B94").opacity(0.3)

    // 6E Pick
    static let sixEPickGreen = Color(hex: "209326")

    // For You cards (Figma: secondary/light, secondary/medium, text tokens)
    static let secondaryLight = Color(hex: "EAF8FF")
    static let secondaryMedium = Color(hex: "D1EFFF")
    static let secondaryDeepGrey = Color(hex: "E2EBF2")
    static let forYouTextPrimary = Color(hex: "25304B")
    static let forYouTextSecondary = Color(hex: "4B5772")
    static let forYouTextTertiary = Color(hex: "7A85A0")

    // Best Offers section
    static let cardSoftShadow = Color(hex: "4C5D9E").opacity(0.12)
    static let cardSubtleShadow = Color(hex: "4C5D9E").opacity(0.08)
    static let disabledBorder = Color(hex: "CDD1DB")
    static let offerPromoBlue = Color(hex: "000099")
    static let offerButtonDark = Color(hex: "1D1D1D")

    // One Click Away section
    static let oneClickBg = Color(hex: "EAF8FF").opacity(0.5)
    static let activeBlue = Color(hex: "9CD9FF")
    static let accentGreen = Color(hex: "209326")
    static let chipBorder = Color(hex: "E2EBF2")
    static let chipSelectedBg = Color(hex: "000099")

    // Footer / "India by IndiGo" section
    static let footerBlue = Color(hex: "0032A6")
    static let footerStatsBg = Color(hex: "EAF8FF")
    static let footerStatBorder = Color(hex: "D1EFFF")
    static let footerStatLabel = Color(hex: "7A85A0")

    // Booking / Location selection (from Figma node 3:7894)
    static let secondaryBright = Color(hex: "00AEE5")
    static let secondaryMain = Color(hex: "AFE4FF")
    static let primaryMain = Color(hex: "000099")
    static let textTertiaryFull = Color(hex: "7A85A0")

    // SRP (Search Results Page)
    static let stretchGold = Color(hex: "A97D0E")
    static let stretchGoldLight = Color(hex: "FFF8E5")
    static let economyBlueLight = Color(hex: "EAF8FF")
    static let economyBlueBadge = Color(hex: "D5F0FF")
    static let economyBlueBadgeBorder = Color(hex: "B0E5FF").opacity(0.4)
    static let successGreen = Color(hex: "218946")
    static let accentDark = Color(hex: "209326")
    static let actionDisabled = Color(hex: "9BA4B8")
    static let semiWhite = Color(hex: "F8F8F8")
    static let businessGreen = Color(hex: "CBF1CA")
    static let businessGreenBorder = Color(hex: "CDF1CC")
    static let srpCardShadow = Color(hex: "4C5D9E").opacity(0.15)
    static let srpCardBorder = Color(hex: "E2EBF2")
    static let calendarSelected = Color(hex: "AFE4FF")
    static let calendarDefault = Color(hex: "EAF8FF")
}

// MARK: - Color+Hex

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (255, 0, 0, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue: Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}
