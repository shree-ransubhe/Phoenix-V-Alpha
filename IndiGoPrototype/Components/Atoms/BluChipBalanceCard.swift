//
//  BluChipBalanceCard.swift
//  IndiGoPrototype
//
//  Atom – IndiGo BluChip loyalty balance card.
//  Figma nodes: 1033:10441 (4.1/5.0), 5602:85032 (6.1)
//

import SwiftUI

struct BluChipBalanceCard: View {
    let balance: String
    let tierName: String
    let loyaltyId: String
    let progressFraction: CGFloat
    let maxPoints: String
    let unlockMessage: String
    let unlockHighlight: String
    let infoMessage: String
    @Environment(\.alphaTheme) private var theme

    @State private var starRotation: Double = 0
    @State private var animatedProgress: CGFloat = 0
    @State private var hasAppeared = false

    var body: some View {
        if theme.bluChipUsesDarkCard {
            alpha61Card
        } else {
            alpha41Card
        }
    }

    // MARK: - Alpha 6.1 Dark Card (Figma 5602:85032)

    private var alpha61Card: some View {
        VStack(alignment: .leading, spacing: theme.bluChipDarkCardSpacing) {
            alpha61TierRow
            alpha61Divider
            alpha61InfoSection
            alpha61Divider
            alpha61SeeActivityCTA
        }
        .padding(theme.bluChipCardPadding)
        .background(Color.black)
        .clipShape(RoundedRectangle(cornerRadius: theme.bluChipCornerRadius))
    }

    // Figma 5602:92398 — Tier stage + Loyalty ID
    private var alpha61TierRow: some View {
        HStack {
            Text(tierName)
                .font(.custom("Poppins-Medium", size: 12))
                .foregroundStyle(theme.bluChipTierColor)
                .frame(height: 24)

            Spacer()

            HStack(spacing: 4) {
                Text("ID: \(loyaltyId)")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundStyle(theme.bluChipIdColor)

                Button(action: {
                    UIPasteboard.general.string = loyaltyId
                }) {
                    Image("icon-bluchip-copy")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(.white)
                }
                .buttonStyle(.plain)
            }
        }
    }

    private var alpha61Divider: some View {
        Rectangle()
            .fill(theme.bluChipDividerColor)
            .frame(height: 1)
    }

    // Figma 5602:92404 — Balance + info message + logo
    private var alpha61InfoSection: some View {
        HStack(alignment: .top, spacing: theme.bluChipDarkCardSpacing) {
            VStack(alignment: .leading, spacing: theme.bluChipDarkCardSpacing) {
                VStack(alignment: .leading, spacing: 4) {
                    Text("IndiGo BluChip balance")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(theme.bluChipLabelColor)

                    Text(balance)
                        .font(.custom("BauhausStd-Medium", size: theme.bluChipBalanceFontSize))
                        .foregroundStyle(theme.bluChipBalanceColor)
                        .lineLimit(1)
                        .minimumScaleFactor(0.6)
                }

                HStack(alignment: .top, spacing: 4) {
                    Image("icon-bluchip-info")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(.white)

                    Text(infoMessage)
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(theme.bluChipInfoTextColor)
                        .lineSpacing(4)
                        .fixedSize(horizontal: false, vertical: true)
                }
            }

            Spacer(minLength: 0)

            Image("bluchip-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: theme.bluChipLogoSize, height: theme.bluChipLogoSize)
                .clipped()
        }
    }

    // Figma 5602:92412 — See activity CTA
    private var alpha61SeeActivityCTA: some View {
        Button(action: {}) {
            HStack(spacing: 4) {
                Text("See activity")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundStyle(theme.bluChipCtaColor)

                Image("icon-bluchip-arrow-ne")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(theme.bluChipCtaColor)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Alpha 4.1 / 5.0 Light Card (Figma 1033:10441)

    private var alpha41Card: some View {
        VStack(alignment: .leading, spacing: 8) {
            topRow
            titleAndBalance
            progressSection
            unlockBanner
        }
        .padding(theme.bluChipCardPadding)
        .background(Color.white)
        .overlay(
            RoundedRectangle(cornerRadius: theme.bluChipCornerRadius)
                .strokeBorder(IndiGoColors.secondaryBright, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: theme.bluChipCornerRadius))
        .shadow(color: Color(hex: "4C5D9E").opacity(0.12), radius: theme.bluChipShadowRadius, x: 0, y: 0)
        .onGeometryChange(for: Bool.self) { proxy in
            let frame = proxy.frame(in: .global)
            return frame.maxY > 0 && frame.minY < UIScreen.main.bounds.height
        } action: { isVisible in
            guard isVisible, !hasAppeared else { return }
            hasAppeared = true
            withAnimation(.easeOut(duration: 1.2).delay(0.2)) {
                animatedProgress = progressFraction
            }
        }
    }

    // MARK: - Top row: BluChip icon + "See activity" CTA

    private var topRow: some View {
        HStack(alignment: .top) {
            RoundedRectangle(cornerRadius: 8)
                .fill(IndiGoColors.secondaryMedium)
                .frame(width: theme.bluChipIconBgSize, height: theme.bluChipIconBgSize)
                .overlay(bluChipIcon)

            Spacer()

            Button(action: {}) {
                HStack {
                    Text("See activity")
                        .font(IndiGoFonts.bodyMedium())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)
                        .lineLimit(1)

                    Spacer().frame(width: 8)

                    seeActivityArrow
                }
            }
            .buttonStyle(.plain)
        }
    }

    private var seeActivityArrow: some View {
        ZStack {
            Circle()
                .stroke(IndiGoColors.secondaryDeepGrey, lineWidth: 1)
                .frame(width: 24, height: 24)

            Image("icon-dotted-arrow-ne")
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
    }

    // MARK: - Title + balance + tier badge

    private var titleAndBalance: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Your IndiGo BluChip Balance")
                .font(IndiGoFonts.subHeading3())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .tracking(-0.4)

            HStack(spacing: 8) {
                Text(balance)
                    .font(IndiGoFonts.displayMedium())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text(tierName)
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .padding(.horizontal, 8)
                    .frame(height: 22)
                    .background(IndiGoColors.secondaryLight)
                    .clipShape(Capsule())
            }
        }
    }

    // MARK: - Progress bar (Figma 1033:10450)

    private let tickCount = 8
    private let dotSize: CGFloat = 3.68
    private var barHeight: CGFloat { theme.bluChipProgressBarHeight }

    private var progressSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            GeometryReader { geo in
                let w = geo.size.width
                let filledWidth = w * animatedProgress
                let filledTicks = Int(progressFraction * CGFloat(tickCount))

                ZStack {
                    Capsule()
                        .fill(Color(hex: "202020").opacity(0.08))
                        .frame(height: barHeight)

                    Capsule()
                        .fill(IndiGoColors.indigoBlue)
                        .frame(width: filledWidth, height: barHeight)
                        .frame(maxWidth: .infinity, alignment: .leading)

                    HStack(spacing: 33) {
                        ForEach(0..<tickCount, id: \.self) { i in
                            Circle()
                                .fill(i < filledTicks
                                      ? Color.white.opacity(0.6)
                                      : Color(hex: "CCCCCC"))
                                .frame(width: dotSize, height: dotSize)
                        }
                    }
                }
            }
            .frame(height: barHeight)

            HStack {
                Text("0")
                    .font(.custom("Poppins-Regular", size: 10))
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)
                Spacer()
                Text(maxPoints)
                    .font(.custom("Poppins-Regular", size: 10))
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)
            }
        }
    }

    // MARK: - Unlock banner with rotating star

    private var unlockBanner: some View {
        HStack(spacing: 4) {
            sparkleIcon
                .rotationEffect(.degrees(starRotation))
                .onAppear {
                    withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                        starRotation = 360
                    }
                }

            (Text("Only 200 points away to unlock ")
                .font(.custom("Poppins-Regular", size: 10))
                .foregroundColor(IndiGoColors.forYouTextSecondary)
             +
             Text(unlockHighlight)
                .font(.custom("Poppins-SemiBold", size: 10))
                .foregroundColor(IndiGoColors.forYouTextPrimary))
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(IndiGoColors.secondaryMedium)
        .clipShape(Capsule())
    }

    // MARK: - Icons

    private var bluChipIcon: some View {
        BluChipDiamondShape()
            .fill(IndiGoColors.secondaryBright, style: FillStyle(eoFill: true))
            .frame(width: theme.bluChipIconSize, height: theme.bluChipIconSize)
    }

    private var sparkleIcon: some View {
        SparkleShape()
            .fill(IndiGoColors.secondaryBright)
            .frame(width: 12, height: 12)
    }
}

// MARK: - BluChip diamond icon (SVG paths scaled to 0…1)

private struct BluChipDiamondShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Inner circle with arrow motif (path 1, even-odd)
        p.move(to: pt(10.0005, 5.83342, w, h))
        p.addCurve(to: pt(14.1665, 10.0004, w, h),
                    control1: pt(12.3014, 5.83366, w, h),
                    control2: pt(14.1665, 7.69938, w, h))
        p.addCurve(to: pt(10.0005, 14.1664, w, h),
                    control1: pt(14.1662, 12.3013, w, h),
                    control2: pt(12.3013, 14.1662, w, h))
        p.addCurve(to: pt(5.83346, 10.0004, w, h),
                    control1: pt(7.6994, 14.1664, w, h),
                    control2: pt(5.83368, 12.3014, w, h))
        p.addCurve(to: pt(10.0005, 5.83342, w, h),
                    control1: pt(5.83346, 7.69923, w, h),
                    control2: pt(7.69927, 5.83342, w, h))
        p.closeSubpath()

        // Arrow inside circle
        p.move(to: pt(12.1704, 7.83049, w, h))
        p.addCurve(to: pt(11.6176, 7.83049, w, h),
                    control1: pt(12.0178, 7.67797, w, h),
                    control2: pt(11.7701, 7.67792, w, h))
        p.addLine(to: pt(11.0229, 8.42522, w, h))
        p.addLine(to: pt(9.05319, 8.42522, w, h))
        p.addCurve(to: pt(8.66256, 8.81585, w, h),
                    control1: pt(8.83755, 8.42522, w, h),
                    control2: pt(8.66261, 8.60013, w, h))
        p.addCurve(to: pt(9.05319, 9.20647, w, h),
                    control1: pt(8.66256, 9.0316, w, h),
                    control2: pt(8.83752, 9.20647, w, h))
        p.addLine(to: pt(10.2417, 9.20647, w, h))
        p.addLine(to: pt(9.12838, 10.3198, w, h))
        p.addLine(to: pt(8.10592, 10.3198, w, h))
        p.addCurve(to: pt(7.7153, 10.7104, w, h),
                    control1: pt(7.89029, 10.3199, w, h),
                    control2: pt(7.71535, 10.4947, w, h))
        p.addCurve(to: pt(8.10592, 11.101, w, h),
                    control1: pt(7.71528, 10.9261, w, h),
                    control2: pt(7.89024, 11.1009, w, h))
        p.addLine(to: pt(8.89987, 11.101, w, h))
        p.addLine(to: pt(8.89889, 11.894, w, h))
        p.addCurve(to: pt(9.28951, 12.2846, w, h),
                    control1: pt(8.89875, 12.1097, w, h),
                    control2: pt(9.07386, 12.2845, w, h))
        p.addCurve(to: pt(9.68014, 11.894, w, h),
                    control1: pt(9.50526, 12.2848, w, h),
                    control2: pt(9.67997, 12.1097, w, h))
        p.addLine(to: pt(9.68112, 10.8725, w, h))
        p.addLine(to: pt(10.7934, 9.76018, w, h))
        p.addLine(to: pt(10.7934, 10.9467, w, h))
        p.addCurve(to: pt(11.184, 11.3373, w, h),
                    control1: pt(10.7935, 11.1624, w, h),
                    control2: pt(10.9683, 11.3373, w, h))
        p.addCurve(to: pt(11.5747, 10.9467, w, h),
                    control1: pt(11.3996, 11.3372, w, h),
                    control2: pt(11.5746, 11.1623, w, h))
        p.addLine(to: pt(11.5747, 8.97893, w, h))
        p.addLine(to: pt(12.1704, 8.38225, w, h))
        p.addCurve(to: pt(12.1704, 7.83049, w, h),
                    control1: pt(12.3227, 8.22982, w, h),
                    control2: pt(12.3225, 7.98299, w, h))
        p.closeSubpath()

        // Outer diamond border (path 2, even-odd)
        p.move(to: pt(7.34811, 1.81878, w, h))
        p.addCurve(to: pt(12.6518, 1.81878, w, h),
                    control1: pt(8.81255, 0.354313, w, h),
                    control2: pt(11.1874, 0.354313, w, h))
        p.addLine(to: pt(17.9546, 7.12151, w, h))
        p.addCurve(to: pt(17.9546, 12.4252, w, h),
                    control1: pt(19.419, 8.58602, w, h),
                    control2: pt(19.419, 10.9607, w, h))
        p.addLine(to: pt(12.6518, 17.728, w, h))
        p.addCurve(to: pt(7.34811, 17.728, w, h),
                    control1: pt(11.1874, 19.1925, w, h),
                    control2: pt(8.81255, 19.1925, w, h))
        p.addLine(to: pt(2.04537, 12.4252, w, h))
        p.addCurve(to: pt(2.04537, 7.12151, w, h),
                    control1: pt(0.580904, 10.9607, w, h),
                    control2: pt(0.580905, 8.58602, w, h))
        p.closeSubpath()

        // Inner diamond cutout
        p.move(to: pt(11.768, 2.70257, w, h))
        p.addCurve(to: pt(8.2319, 2.70257, w, h),
                    control1: pt(10.7917, 1.72626, w, h),
                    control2: pt(9.20821, 1.72626, w, h))
        p.addLine(to: pt(2.92916, 8.0053, w, h))
        p.addCurve(to: pt(2.92916, 11.5414, w, h),
                    control1: pt(1.95285, 8.98159, w, h),
                    control2: pt(1.95285, 10.5651, w, h))
        p.addLine(to: pt(8.2319, 16.8442, w, h))
        p.addCurve(to: pt(11.768, 16.8442, w, h),
                    control1: pt(9.20821, 17.8204, w, h),
                    control2: pt(10.7917, 17.8204, w, h))
        p.addLine(to: pt(17.0708, 11.5414, w, h))
        p.addCurve(to: pt(17.0708, 8.0053, w, h),
                    control1: pt(18.0471, 10.5651, w, h),
                    control2: pt(18.0471, 8.98159, w, h))
        p.closeSubpath()

        return p
    }

    private func pt(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGPoint {
        CGPoint(x: x / 20 * w, y: y / 20 * h)
    }
}

// MARK: - Sparkle star shape from SVG path

private struct SparkleShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        var p = Path()
        p.move(to: CGPoint(x: w * 0.4740, y: h))
        p.addCurve(
            to: CGPoint(x: w * 0.2240, y: h * 0.6344),
            control1: CGPoint(x: w * 0.4644, y: h * 0.9436),
            control2: CGPoint(x: w * 0.3577, y: h * 0.7517)
        )
        p.addCurve(
            to: CGPoint(x: 0, y: h * 0.5260),
            control1: CGPoint(x: w * 0.1493, y: h * 0.5769),
            control2: CGPoint(x: w * 0.0746, y: h * 0.5417)
        )
        p.addLine(to: CGPoint(x: 0, y: h * 0.4714))
        p.addCurve(
            to: CGPoint(x: w * 0.3840, y: h * 0.2083),
            control1: CGPoint(x: w * 0.0738, y: h * 0.4540),
            control2: CGPoint(x: w * 0.2886, y: h * 0.3273)
        )
        p.addCurve(
            to: CGPoint(x: w * 0.4740, y: 0),
            control1: CGPoint(x: w * 0.4310, y: h * 0.1345),
            control2: CGPoint(x: w * 0.4609, y: h * 0.0669)
        )
        p.addLine(to: CGPoint(x: w * 0.5286, y: 0))
        p.addCurve(
            to: CGPoint(x: w * 0.7904, y: h * 0.2641),
            control1: CGPoint(x: w * 0.5365, y: h * 0.0434),
            control2: CGPoint(x: w * 0.6289, y: h * 0.1536)
        )
        p.addCurve(
            to: CGPoint(x: w, y: h * 0.4714),
            control1: CGPoint(x: w * 0.8586, y: h * 0.3403),
            control2: CGPoint(x: w * 0.9289, y: h * 0.4224)
        )
        p.addLine(to: CGPoint(x: w, y: h * 0.5260))
        p.addCurve(
            to: CGPoint(x: w * 0.7109, y: h * 0.6901),
            control1: CGPoint(x: w * 0.9522, y: h * 0.5356),
            control2: CGPoint(x: w * 0.8012, y: h * 0.6329)
        )
        p.addCurve(
            to: CGPoint(x: w * 0.5286, y: h),
            control1: CGPoint(x: w * 0.6338, y: h * 0.7383),
            control2: CGPoint(x: w * 0.5715, y: h * 0.8598)
        )
        p.closeSubpath()
        return p
    }
}

// MARK: - Preview

#Preview("Alpha 4.1 / 5.0") {
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
    .padding(20)
}

#Preview("Alpha 6.1 Dark Card") {
    BluChipBalanceCard(
        balance: "17,440",
        tierName: "Blu 3",
        loyaltyId: "2582447",
        progressFraction: 0.63,
        maxPoints: "100,000",
        unlockMessage: "Only 200 points away to unlock",
        unlockHighlight: "20 passes",
        infoMessage: "You're 550 IndiGo BluChips away from a free flight to Goa!"
    )
    .padding(16)
    .background(Color(hex: "F5F8FC"))
    .environment(\.alphaTheme, Alpha61Theme())
}
