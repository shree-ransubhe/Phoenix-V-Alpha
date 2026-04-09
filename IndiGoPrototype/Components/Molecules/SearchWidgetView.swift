//
//  SearchWidgetView.swift
//  IndiGoPrototype
//
//  Molecule – Search widget with two variant styles driven by AlphaTheme:
//
//  Alpha 4.1 / 5.0 (text pill):
//    .expanded – full-width pill, white glass, rounded-12, indigo gradient border
//    .inline  – narrower pill + 6Eskai + profile in one row
//
//  Alpha 6.1+ (From/To card):
//    .expanded – From/To card (56h, rounded-8) + mic pill (56×40)
//    .inline  – same From/To card squeezed + 6Eskai + avatar
//
//  Figma: 2440:44284 (5.0 pill), 5602:89120 (6.1 expanded), 5656:57938 (6.1 inline)
//

import SwiftUI

enum SearchWidgetMode: Equatable {
    case expanded
    case inline
}

struct SearchWidgetView: View {
    let mode: SearchWidgetMode
    var onTap: () -> Void = {}
    var onProfileTap: () -> Void = {}
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        if theme.searchUsesFromToMode {
            fromToBody
        } else {
            pillBody
        }
    }

    // MARK: - Alpha 6.1+ From/To layout

    @ViewBuilder
    private var fromToBody: some View {
        switch mode {
        case .expanded:
            fromToExpanded
        case .inline:
            fromToInline
        }
    }

    private var fromToExpanded: some View {
        HStack(spacing: 8) {
            fromToCard
            micButton
        }
    }

    private var fromToInline: some View {
        HStack(spacing: 16) {
            fromToCard

            HStack(spacing: 16) {
                SixEskaiButton()
                alpha61Avatar
            }
        }
    }

    // MARK: - From/To card

    private var fromToCard: some View {
        Button(action: {
            HapticManager.lightImpact()
            onTap()
        }) {
            HStack(spacing: 8) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("From")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(Color(hex: "4B5772"))
                    Text("Delhi")
                        .font(IndiGoFonts.displaySmall())
                        .foregroundStyle(IndiGoColors.indigoBlue)
                }
                .frame(maxWidth: .infinity, alignment: .leading)

                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.indigoBlue)
                    .frame(width: 24, height: 24)

                VStack(alignment: .trailing, spacing: 0) {
                    Text("Where")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(Color(hex: "4B5772"))
                    Text("Select")
                        .font(IndiGoFonts.displaySmall())
                        .foregroundStyle(Color(hex: "25304B").opacity(0.25))
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 8)
            .frame(height: theme.searchBarHeight)
            .background(fromToGlass)
            .clipShape(RoundedRectangle(cornerRadius: theme.searchBarCornerRadius))
            .overlay(
                RoundedRectangle(cornerRadius: theme.searchBarCornerRadius)
                    .strokeBorder(IndiGoColors.indigoBlue.opacity(0.4), lineWidth: 1)
            )
            .shadow(color: IndiGoColors.indigoBlue.opacity(0.12), radius: 5, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }

    private var fromToGlass: some View {
        ZStack {
            RoundedRectangle(cornerRadius: theme.searchBarCornerRadius).fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: theme.searchBarCornerRadius).fill(Color.white).blendMode(.hardLight)
        }
    }

    // MARK: - Mic button (6.1): circle, white bg, indigo 40% border

    private var micButton: some View {
        Button(action: {}) {
            Image(systemName: "mic")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(IndiGoColors.indigoBlue)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
        .frame(width: theme.searchMicButtonWidth, height: theme.searchMicButtonWidth)
        .background(Color.white)
        .clipShape(Circle())
        .overlay(
            Circle().strokeBorder(IndiGoColors.indigoBlue.opacity(0.4), lineWidth: 1)
        )
        .shadow(color: IndiGoColors.indigoBlue.opacity(0.08), radius: 6, x: 0, y: 0)
    }

    // MARK: - Alpha 6.1 avatar (Figma 5602:84920 / 5656:58109)

    private var alpha61Avatar: some View {
        Button(action: {
            HapticManager.lightImpact()
            onProfileTap()
        }) {
            Image("icon-avatar-person")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Alpha 4.1/5.0 pill layout

    @ViewBuilder
    private var pillBody: some View {
        switch mode {
        case .expanded:
            fullWidthPill
        case .inline:
            inlineRow
        }
    }

    private var fullWidthPill: some View {
        Button(action: {
            HapticManager.lightImpact()
            onTap()
        }) {
            pillContent
        }
        .buttonStyle(.plain)
    }

    private var inlineRow: some View {
        HStack(spacing: 12) {
            Button(action: {
                HapticManager.lightImpact()
                onTap()
            }) {
                pillContent
            }
            .buttonStyle(.plain)

            SixEskaiButton()
            pillAvatar
        }
    }

    private var pillContent: some View {
        HStack(spacing: IndiGoSpacing.md) {
            blinkingCursor

            AnimatedPlaceholder()
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()

            Image(systemName: "mic")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(IndiGoColors.indigoBlue)
                .frame(width: 24, height: 24)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .frame(height: 60)
        .frame(maxWidth: .infinity)
        .background(pillGlass)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(AnimatedGradientBorder(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }

    private var pillGlass: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: 12).fill(Color.white).blendMode(.hardLight)
        }
    }

    private var blinkingCursor: some View {
        TimelineView(.periodic(from: .now, by: 0.6)) { timeline in
            let phase = Int(timeline.date.timeIntervalSinceReferenceDate / 0.6)
            RoundedRectangle(cornerRadius: 8)
                .fill(IndiGoColors.indigoBlue)
                .frame(width: 3, height: 32)
                .opacity(phase.isMultiple(of: 2) ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: phase)
        }
    }

    private var pillAvatar: some View {
        Button(action: {
            HapticManager.lightImpact()
            onProfileTap()
        }) {
            Image("profile-avatar")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Animated placeholder (departure icon takeoff + typewriter text)

private struct AnimatedPlaceholder: View {
    private let placeholderText = "Start your booking here..."
    private let textColor = Color(hex: "4B5772")

    private let iconFlyDuration: Double = 0.6
    private let typeSpeed: Double = 0.04
    private let holdDuration: Double = 2.5
    private let erasePause: Double = 0.3
    private let eraseSpeed: Double = 0.02

    @State private var iconOffset: CGFloat = -30
    @State private var iconLift: CGFloat = 12
    @State private var iconOpacity: Double = 0
    @State private var iconRotation: Double = -15
    @State private var visibleChars: Int = 0
    @State private var animTask: Task<Void, Never>?

    var body: some View {
        HStack(spacing: 4) {
            DepartureIconShape()
                .fill(textColor)
                .frame(width: 20, height: 20)
                .offset(x: iconOffset, y: -iconLift)
                .rotationEffect(.degrees(iconRotation))
                .opacity(iconOpacity)

            Text(String(placeholderText.prefix(visibleChars)))
                .font(.custom("Poppins-Regular", size: 14))
                .foregroundStyle(textColor)
                .lineLimit(1)
        }
        .onAppear { startLoop() }
        .onDisappear { animTask?.cancel() }
    }

    private func startLoop() {
        animTask?.cancel()
        animTask = Task { @MainActor in
            while !Task.isCancelled {
                iconOffset = -30; iconLift = 12; iconOpacity = 0; iconRotation = -15; visibleChars = 0

                try? await Task.sleep(for: .milliseconds(300))
                if Task.isCancelled { return }

                withAnimation(.easeOut(duration: iconFlyDuration)) {
                    iconOffset = 0; iconLift = 0; iconOpacity = 1; iconRotation = 0
                }
                try? await Task.sleep(for: .milliseconds(Int(iconFlyDuration * 1000) + 100))
                if Task.isCancelled { return }

                for i in 1...placeholderText.count {
                    if Task.isCancelled { return }
                    withAnimation(.easeOut(duration: 0.05)) { visibleChars = i }
                    try? await Task.sleep(for: .milliseconds(Int(typeSpeed * 1000)))
                }

                try? await Task.sleep(for: .milliseconds(Int(holdDuration * 1000)))
                if Task.isCancelled { return }

                for i in stride(from: placeholderText.count, through: 0, by: -1) {
                    if Task.isCancelled { return }
                    withAnimation(.easeIn(duration: 0.03)) { visibleChars = i }
                    try? await Task.sleep(for: .milliseconds(Int(eraseSpeed * 1000)))
                }

                try? await Task.sleep(for: .milliseconds(Int(erasePause * 1000)))
                if Task.isCancelled { return }

                withAnimation(.easeIn(duration: 0.4)) {
                    iconOffset = 30; iconLift = 14; iconOpacity = 0; iconRotation = 15
                }
                try? await Task.sleep(for: .milliseconds(600))
            }
        }
    }
}

// MARK: - Animated gradient border (4.1/5.0 pill only)

private struct AnimatedGradientBorder: View {
    let cornerRadius: CGFloat
    @State private var rotationAngle: Double = 0

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: [
                        Color(hex: "00AEE5"), Color(hex: "005EC2"),
                        IndiGoColors.indigoBlue, Color(hex: "00AEE5"),
                    ]),
                    center: .center,
                    angle: .degrees(rotationAngle)
                ),
                lineWidth: 2
            )
            .onAppear {
                withAnimation(.linear(duration: 3).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
    }
}

// MARK: - Departure icon from SVG

private struct DepartureIconShape: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width; let h = rect.height
        var p = Path()

        p.move(to: pt(2, 20.2495, w, h))
        p.addLine(to: pt(2, 19.4995, w, h)); p.addLine(to: pt(2.75, 19.4995, w, h))
        p.addLine(to: pt(21.25, 19.4995, w, h)); p.addLine(to: pt(22, 19.4995, w, h))
        p.addLine(to: pt(22, 20.2495, w, h)); p.addLine(to: pt(22, 20.9995, w, h))
        p.addLine(to: pt(21.25, 20.9995, w, h)); p.addLine(to: pt(2.75, 20.9995, w, h))
        p.addLine(to: pt(2, 20.9995, w, h)); p.closeSubpath()

        p.move(to: pt(5.53876, 4.05025, w, h))
        p.addCurve(to: pt(6.03086, 3.6016, w, h), control1: pt(5.62377, 3.83209, w, h), control2: pt(5.80579, 3.66614, w, h))
        p.addLine(to: pt(8.0071, 3.03493, w, h))
        p.addCurve(to: pt(8.71735, 3.20003, w, h), control1: pt(8.25647, 2.96342, w, h), control2: pt(8.52509, 3.02586, w, h))
        p.addLine(to: pt(14.9089, 8.80878, w, h)); p.addLine(to: pt(19.0779, 7.61334, w, h))
        p.addCurve(to: pt(22.0717, 9.27282, w, h), control1: pt(20.3629, 7.24488, w, h), control2: pt(21.7033, 7.98785, w, h))
        p.addCurve(to: pt(20.4122, 12.2666, w, h), control1: pt(22.4402, 10.5578, w, h), control2: pt(21.6972, 11.8982, w, h))
        p.addLine(to: pt(5.71392, 16.4813, w, h))
        p.addCurve(to: pt(4.87078, 16.1572, w, h), control1: pt(5.39203, 16.5736, w, h), control2: pt(5.04795, 16.4413, w, h))
        p.addLine(to: pt(1.90106, 11.3946, w, h))
        p.addCurve(to: pt(1.83742, 10.7286, w, h), control1: pt(1.77654, 11.1949, w, h), control2: pt(1.75298, 10.9483, w, h))
        p.addCurve(to: pt(2.33075, 10.2768, w, h), control1: pt(1.92186, 10.5089, w, h), control2: pt(2.10452, 10.3416, w, h))
        p.addLine(to: pt(4.30699, 9.71009, w, h))
        p.addCurve(to: pt(5.0661, 9.92372, w, h), control1: pt(4.58007, 9.63179, w, h), control2: pt(4.87394, 9.71449, w, h))
        p.addLine(to: pt(6.30736, 11.2752, w, h)); p.addLine(to: pt(9.11455, 10.4703, w, h))
        p.addLine(to: pt(5.59757, 4.71356, w, h))
        p.addCurve(to: pt(5.53876, 4.05025, w, h), control1: pt(5.47551, 4.51375, w, h), control2: pt(5.45375, 4.26841, w, h))
        p.closeSubpath()

        p.move(to: pt(7.39107, 4.77202, w, h)); p.addLine(to: pt(10.908, 10.5287, w, h))
        p.addCurve(to: pt(10.9669, 11.1921, w, h), control1: pt(11.0301, 10.7285, w, h), control2: pt(11.0519, 10.9739, w, h))
        p.addCurve(to: pt(10.4748, 11.6407, w, h), control1: pt(10.8818, 11.4102, w, h), control2: pt(10.6998, 11.5762, w, h))
        p.addLine(to: pt(6.27525, 12.8449, w, h))
        p.addCurve(to: pt(5.51614, 12.6313, w, h), control1: pt(6.00217, 12.9232, w, h), control2: pt(5.7083, 12.8405, w, h))
        p.addLine(to: pt(4.27488, 11.2798, w, h)); p.addLine(to: pt(3.69999, 11.4446, w, h))
        p.addLine(to: pt(5.84427, 14.8835, w, h)); p.addLine(to: pt(19.9988, 10.8247, w, h))
        p.addCurve(to: pt(20.6298, 9.68628, w, h), control1: pt(20.4874, 10.6846, w, h), control2: pt(20.7699, 10.1749, w, h))
        p.addCurve(to: pt(19.4914, 9.05523, w, h), control1: pt(20.4897, 9.19765, w, h), control2: pt(19.98, 8.91511, w, h))
        p.addLine(to: pt(14.9213, 10.3657, w, h))
        p.addCurve(to: pt(14.2111, 10.2006, w, h), control1: pt(14.6719, 10.4372, w, h), control2: pt(14.4033, 10.3747, w, h))
        p.addLine(to: pt(8.01951, 4.59182, w, h)); p.addLine(to: pt(7.39107, 4.77202, w, h))
        p.closeSubpath()

        return p
    }

    private func pt(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGPoint {
        CGPoint(x: x / 24 * w, y: y / 24 * h)
    }
}

#Preview("Expanded – Pill") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 120)
            SearchWidgetView(mode: .expanded).padding(.horizontal, 20)
            Spacer()
        }
    }
}

#Preview("Expanded – From/To") {
    VStack {
        Spacer().frame(height: 60)
        SearchWidgetView(mode: .expanded)
            .padding(.horizontal, 16)
            .environment(\.alphaTheme, Alpha61Theme())
        Spacer()
    }
    .background(Color(hex: "F5F8FC"))
}

#Preview("Inline – From/To") {
    VStack {
        Spacer().frame(height: 20)
        SearchWidgetView(mode: .inline)
            .padding(.horizontal, 16)
            .environment(\.alphaTheme, Alpha61Theme())
        Spacer()
    }
    .background(Color(hex: "F5F8FC"))
}
