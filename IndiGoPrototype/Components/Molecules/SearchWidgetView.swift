//
//  SearchWidgetView.swift
//  IndiGoPrototype
//
//  Molecule – Search widget pill with blinking cursor.
//  Three scroll-driven modes:
//    .expanded  – full-width pill, dark glass (Figma: bg rgba(0,0,0,0.5) mix-blend-hard-light)
//    .compact   – full-width pill, light glass (Figma: bg rgba(235,236,238,0.1) mix-blend-plus-lighter)
//    .inline    – narrower pill sharing row with 6Eskai + avatar
//
//  Figma search node: 3:9911 / 3:6853 / 3:7852
//  Pill specs: h 60, border 2 white, rounded 500, shadow 0 4 16.8 rgba(0,0,0,0.25), p 16
//  Cursor bar: #EAF8FF, 3x32, rounded 20
//  Placeholder: Poppins Light 14/20, white
//  Voice icon: 24x24, white
//

import SwiftUI

// MARK: - Search widget display mode

enum SearchWidgetMode: Equatable {
    case expanded
    case compact
    case inline
}

// MARK: - SearchWidgetView

struct SearchWidgetView: View {
    let mode: SearchWidgetMode
    var onTap: () -> Void = {}
    var onVoiceTap: () -> Void = {}

    private let pillHeight: CGFloat = 60

    var body: some View {
        switch mode {
        case .expanded:
            fullWidthPill(glassStyle: .dark)
        case .compact:
            fullWidthPill(glassStyle: .light)
        case .inline:
            inlineRow
        }
    }

    // MARK: - Full-width pill (states 1 & 2) – px 20

    private func fullWidthPill(glassStyle: GlassStyle) -> some View {
        Button(action: onTap) {
            pillContent(glassStyle: glassStyle)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Inline row (state 3) – gap 10, pill(flex-1) + 6Eskai(30) + avatar(36)

    private var inlineRow: some View {
        HStack(spacing: 10) {
            Button(action: onTap) {
                pillContent(glassStyle: .light)
            }
            .buttonStyle(.plain)

            sixEskaiButton

            avatarButton
        }
    }

    // MARK: - Pill content (shared across all modes)

    private func pillContent(glassStyle: GlassStyle) -> some View {
        HStack(spacing: IndiGoSpacing.md) {
            HStack(spacing: IndiGoSpacing.xs) {
                blinkingCursor

                Text("Where will you IndiGo Today?")
                    .font(IndiGoFonts.placeholder())
                    .foregroundStyle(.white)
                    .lineLimit(1)
                    .truncationMode(.tail)
            }

            Spacer(minLength: 0)

            voiceIcon
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .frame(height: pillHeight)
        .frame(maxWidth: .infinity)
        .background(glassBackground(style: glassStyle))
        .clipShape(Capsule())
        .overlay(Capsule().strokeBorder(.white, lineWidth: 2))
        .shadow(color: .black.opacity(0.25), radius: 8.4, x: 0, y: 4)
    }

    // MARK: - Glass background

    private enum GlassStyle { case dark, light }

    @ViewBuilder
    private func glassBackground(style: GlassStyle) -> some View {
        ZStack {
            Capsule().fill(.ultraThinMaterial)
            switch style {
            case .dark:
                Capsule().fill(Color.black.opacity(0.5))
            case .light:
                Capsule().fill(Color(hex: "EBECEE").opacity(0.1))
            }
        }
    }

    // MARK: - Blinking cursor (Figma: #EAF8FF, 3x32, rounded 20)

    private var blinkingCursor: some View {
        TimelineView(.periodic(from: .now, by: 0.6)) { timeline in
            let phase = Int(timeline.date.timeIntervalSinceReferenceDate / 0.6)
            RoundedRectangle(cornerRadius: IndiGoSpacing.lg)
                .fill(IndiGoColors.searchAccentBar)
                .frame(width: 3, height: 32)
                .opacity(phase.isMultiple(of: 2) ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: phase)
        }
    }

    // MARK: - Voice icon (24x24)

    private var voiceIcon: some View {
        Button(action: onVoiceTap) {
            Image(systemName: "mic")
                .font(.system(size: 18, weight: .medium))
                .foregroundStyle(.white)
                .frame(width: 24, height: 24)
        }
        .buttonStyle(.plain)
    }

    // MARK: - 6Eskai button (inline mode, 30x30)

    private var sixEskaiButton: some View {
        Button(action: {}) {
            Image("6eskai-entry")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 30, height: 30)
                .clipShape(Circle())
                .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Avatar button (inline mode, 36x36)

    private var avatarButton: some View {
        Button(action: {}) {
            Image("profile-avatar")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 36, height: 36)
                .clipShape(Circle())
                .overlay(Circle().strokeBorder(.white, lineWidth: 1))
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Previews

#Preview("Expanded – dark glass") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 120)
            SearchWidgetView(mode: .expanded).padding(.horizontal, 20)
            Spacer()
        }
    }
}

#Preview("Compact – light glass") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 40)
            SearchWidgetView(mode: .compact).padding(.horizontal, 20)
            Spacer()
        }
    }
}

#Preview("Inline – with 6Eskai + avatar") {
    ZStack {
        Image("header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 40)
            SearchWidgetView(mode: .inline).padding(.horizontal, 20)
            Spacer()
        }
    }
}
