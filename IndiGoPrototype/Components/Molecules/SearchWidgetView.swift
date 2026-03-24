//
//  SearchWidgetView.swift
//  IndiGoPrototype
//
//  Molecule – Search widget pill with blinking cursor and
//  departure-icon + typewriter micro-animation.
//
//  Two scroll-driven modes:
//    .expanded – full-width pill, white glass, rounded-12, indigo gradient border (Figma 2440:44284)
//    .inline  – narrower pill + 6Eskai + profile in one row, rounded-12, gap-12
//
//  Pill specs: h 60, border 2 indigo gradient, rounded 12, shadow 0 4 8 rgba(0,0,0,0.2), p 16
//  Glass: white, mix-blend hard-light
//  Cursor bar: IndiGo blue #000099, 3x32, rounded 8
//  Placeholder: Poppins Regular 14/20, #4B5772
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

    private let pillHeight: CGFloat = 60

    var body: some View {
        switch mode {
        case .expanded:
            fullWidthPill
        case .inline:
            inlineRow
        }
    }

    // MARK: - Full-width pill

    private var fullWidthPill: some View {
        Button(action: {
            HapticManager.lightImpact()
            onTap()
        }) {
            pillContent
        }
        .buttonStyle(.plain)
    }

    // MARK: - Inline row

    private var inlineRow: some View {
        HStack(spacing: 12) {
            Button(action: {
                HapticManager.lightImpact()
                onTap()
            }) {
                pillContent
            }
            .buttonStyle(.plain)

            sixEskaiButton
            avatarButton
        }
    }

    // MARK: - Pill content

    private var pillContent: some View {
        HStack(spacing: IndiGoSpacing.md) {
            blinkingCursor

            AnimatedPlaceholder()
                .frame(maxWidth: .infinity, alignment: .leading)
                .clipped()

            searchIcon
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .frame(height: pillHeight)
        .frame(maxWidth: .infinity)
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(AnimatedGradientBorder(cornerRadius: 12))
        .shadow(color: .black.opacity(0.2), radius: 4, x: 0, y: 4)
    }

    // MARK: - Glass background

    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: 12).fill(Color.white).blendMode(.hardLight)
        }
    }

    // MARK: - Blinking cursor

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

    // MARK: - Search icon

    private var searchIcon: some View {
        Image(systemName: "mic")
            .font(.system(size: 18, weight: .medium))
            .foregroundStyle(IndiGoColors.indigoBlue)
            .frame(width: 24, height: 24)
    }

    private var sixEskaiButton: some View {
        SixEskaiButton()
    }

    private var avatarButton: some View {
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
                // Reset
                iconOffset = -30
                iconLift = 12
                iconOpacity = 0
                iconRotation = -15
                visibleChars = 0

                try? await Task.sleep(for: .milliseconds(300))
                if Task.isCancelled { return }

                // Phase 1: Icon flies in with takeoff arc
                withAnimation(.easeOut(duration: iconFlyDuration)) {
                    iconOffset = 0
                    iconLift = 0
                    iconOpacity = 1
                    iconRotation = 0
                }
                try? await Task.sleep(for: .milliseconds(Int(iconFlyDuration * 1000) + 100))
                if Task.isCancelled { return }

                // Phase 2: Typewriter — characters appear one by one
                for i in 1...placeholderText.count {
                    if Task.isCancelled { return }
                    withAnimation(.easeOut(duration: 0.05)) {
                        visibleChars = i
                    }
                    try? await Task.sleep(for: .milliseconds(Int(typeSpeed * 1000)))
                }

                // Phase 3: Hold
                try? await Task.sleep(for: .milliseconds(Int(holdDuration * 1000)))
                if Task.isCancelled { return }

                // Phase 4: Erase characters in reverse
                for i in stride(from: placeholderText.count, through: 0, by: -1) {
                    if Task.isCancelled { return }
                    withAnimation(.easeIn(duration: 0.03)) {
                        visibleChars = i
                    }
                    try? await Task.sleep(for: .milliseconds(Int(eraseSpeed * 1000)))
                }

                try? await Task.sleep(for: .milliseconds(Int(erasePause * 1000)))
                if Task.isCancelled { return }

                // Phase 5: Icon flies out upward
                withAnimation(.easeIn(duration: 0.4)) {
                    iconOffset = 30
                    iconLift = 14
                    iconOpacity = 0
                    iconRotation = 15
                }
                try? await Task.sleep(for: .milliseconds(600))
            }
        }
    }
}

// MARK: - Animated gradient border

private struct AnimatedGradientBorder: View {
    let cornerRadius: CGFloat

    @State private var rotationAngle: Double = 0

    private let gradientColors: [Color] = [
        Color(hex: "00AEE5"),
        Color(hex: "005EC2"),
        IndiGoColors.indigoBlue,
        Color(hex: "00AEE5"),
    ]

    var body: some View {
        RoundedRectangle(cornerRadius: cornerRadius)
            .strokeBorder(
                AngularGradient(
                    gradient: Gradient(colors: gradientColors),
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
        let w = rect.width
        let h = rect.height
        var p = Path()

        // Runway line
        p.move(to: pt(2, 20.2495, w, h))
        p.addLine(to: pt(2, 19.4995, w, h))
        p.addLine(to: pt(2.75, 19.4995, w, h))
        p.addLine(to: pt(21.25, 19.4995, w, h))
        p.addLine(to: pt(22, 19.4995, w, h))
        p.addLine(to: pt(22, 20.2495, w, h))
        p.addLine(to: pt(22, 20.9995, w, h))
        p.addLine(to: pt(21.25, 20.9995, w, h))
        p.addLine(to: pt(2.75, 20.9995, w, h))
        p.addLine(to: pt(2, 20.9995, w, h))
        p.closeSubpath()

        // Airplane body
        p.move(to: pt(5.53876, 4.05025, w, h))
        p.addCurve(to: pt(6.03086, 3.6016, w, h),
                    control1: pt(5.62377, 3.83209, w, h),
                    control2: pt(5.80579, 3.66614, w, h))
        p.addLine(to: pt(8.0071, 3.03493, w, h))
        p.addCurve(to: pt(8.71735, 3.20003, w, h),
                    control1: pt(8.25647, 2.96342, w, h),
                    control2: pt(8.52509, 3.02586, w, h))
        p.addLine(to: pt(14.9089, 8.80878, w, h))
        p.addLine(to: pt(19.0779, 7.61334, w, h))
        p.addCurve(to: pt(22.0717, 9.27282, w, h),
                    control1: pt(20.3629, 7.24488, w, h),
                    control2: pt(21.7033, 7.98785, w, h))
        p.addCurve(to: pt(20.4122, 12.2666, w, h),
                    control1: pt(22.4402, 10.5578, w, h),
                    control2: pt(21.6972, 11.8982, w, h))
        p.addLine(to: pt(5.71392, 16.4813, w, h))
        p.addCurve(to: pt(4.87078, 16.1572, w, h),
                    control1: pt(5.39203, 16.5736, w, h),
                    control2: pt(5.04795, 16.4413, w, h))
        p.addLine(to: pt(1.90106, 11.3946, w, h))
        p.addCurve(to: pt(1.83742, 10.7286, w, h),
                    control1: pt(1.77654, 11.1949, w, h),
                    control2: pt(1.75298, 10.9483, w, h))
        p.addCurve(to: pt(2.33075, 10.2768, w, h),
                    control1: pt(1.92186, 10.5089, w, h),
                    control2: pt(2.10452, 10.3416, w, h))
        p.addLine(to: pt(4.30699, 9.71009, w, h))
        p.addCurve(to: pt(5.0661, 9.92372, w, h),
                    control1: pt(4.58007, 9.63179, w, h),
                    control2: pt(4.87394, 9.71449, w, h))
        p.addLine(to: pt(6.30736, 11.2752, w, h))
        p.addLine(to: pt(9.11455, 10.4703, w, h))
        p.addLine(to: pt(5.59757, 4.71356, w, h))
        p.addCurve(to: pt(5.53876, 4.05025, w, h),
                    control1: pt(5.47551, 4.51375, w, h),
                    control2: pt(5.45375, 4.26841, w, h))
        p.closeSubpath()

        // Interior cutout
        p.move(to: pt(7.39107, 4.77202, w, h))
        p.addLine(to: pt(10.908, 10.5287, w, h))
        p.addCurve(to: pt(10.9669, 11.1921, w, h),
                    control1: pt(11.0301, 10.7285, w, h),
                    control2: pt(11.0519, 10.9739, w, h))
        p.addCurve(to: pt(10.4748, 11.6407, w, h),
                    control1: pt(10.8818, 11.4102, w, h),
                    control2: pt(10.6998, 11.5762, w, h))
        p.addLine(to: pt(6.27525, 12.8449, w, h))
        p.addCurve(to: pt(5.51614, 12.6313, w, h),
                    control1: pt(6.00217, 12.9232, w, h),
                    control2: pt(5.7083, 12.8405, w, h))
        p.addLine(to: pt(4.27488, 11.2798, w, h))
        p.addLine(to: pt(3.69999, 11.4446, w, h))
        p.addLine(to: pt(5.84427, 14.8835, w, h))
        p.addLine(to: pt(19.9988, 10.8247, w, h))
        p.addCurve(to: pt(20.6298, 9.68628, w, h),
                    control1: pt(20.4874, 10.6846, w, h),
                    control2: pt(20.7699, 10.1749, w, h))
        p.addCurve(to: pt(19.4914, 9.05523, w, h),
                    control1: pt(20.4897, 9.19765, w, h),
                    control2: pt(19.98, 8.91511, w, h))
        p.addLine(to: pt(14.9213, 10.3657, w, h))
        p.addCurve(to: pt(14.2111, 10.2006, w, h),
                    control1: pt(14.6719, 10.4372, w, h),
                    control2: pt(14.4033, 10.3747, w, h))
        p.addLine(to: pt(8.01951, 4.59182, w, h))
        p.addLine(to: pt(7.39107, 4.77202, w, h))
        p.closeSubpath()

        return p
    }

    private func pt(_ x: CGFloat, _ y: CGFloat, _ w: CGFloat, _ h: CGFloat) -> CGPoint {
        CGPoint(x: x / 24 * w, y: y / 24 * h)
    }
}

#Preview("Expanded") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 120)
            SearchWidgetView(mode: .expanded).padding(.horizontal, 20)
            Spacer()
        }
    }
}

#Preview("Inline") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 40)
            SearchWidgetView(mode: .inline).padding(.horizontal, 20)
            Spacer()
        }
    }
}
