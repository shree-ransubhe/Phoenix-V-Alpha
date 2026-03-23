//
//  SearchWidgetView.swift
//  IndiGoPrototype
//
//  Molecule – Search widget pill with blinking cursor.
//
//  Two scroll-driven modes:
//    .expanded – full-width pill, white glass, rounded-12, indigo gradient border (Figma 2440:44284)
//    .inline  – narrower pill + 6Eskai + profile in one row, rounded-12, gap-12 (Figma 917:11177)
//
//  Pill specs: h 60, border 2 indigo-blue, rounded 12, shadow 0 4 8 rgba(0,0,0,0.2), p 16
//  Glass: white, mix-blend hard-light
//  Cursor bar: IndiGo blue #000099, 3x32, rounded 8
//  Placeholder: Poppins Regular 14/20, #4B5772
//  Search icon: 24x24
//

import SwiftUI

enum SearchWidgetMode: Equatable {
    case expanded
    case inline
}

struct SearchWidgetView: View {
    let mode: SearchWidgetMode
    var onTap: () -> Void = {}

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
        Button(action: onTap) {
            pillContent
        }
        .buttonStyle(.plain)
    }

    // MARK: - Inline row: search(flex) + 6Eskai(32) + profile(32), gap 12

    private var inlineRow: some View {
        HStack(spacing: 12) {
            Button(action: onTap) {
                pillContent
            }
            .buttonStyle(.plain)

            sixEskaiButton
            avatarButton
        }
    }

    // MARK: - Pill content (white glass, rounded-12, indigo gradient border)

    private var pillContent: some View {
        HStack(spacing: IndiGoSpacing.md) {
            HStack(spacing: IndiGoSpacing.xs) {
                blinkingCursor

                Text("Start your booking here...")
                    .font(.custom("Poppins-Regular", size: 14))
                    .foregroundStyle(Color(hex: "4B5772"))
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer(minLength: 0)

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

    // MARK: - Glass background (white, hard-light)

    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12).fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: 12).fill(Color.white).blendMode(.hardLight)
        }
    }

    // MARK: - Blinking cursor (IndiGo blue, 3x32, rounded 8)

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

    // MARK: - Search icon (24x24)

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
        Button(action: {}) {
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
