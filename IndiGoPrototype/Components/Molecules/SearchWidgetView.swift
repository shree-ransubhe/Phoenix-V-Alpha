//
//  SearchWidgetView.swift
//  IndiGoPrototype
//
//  Molecule – Search widget pill with blinking cursor.
//
//  Two scroll-driven modes:
//    .expanded – full-width pill, dark glass, rounded-16 (Figma 804:10305 / 957:10684)
//    .inline  – narrower pill + 6Eskai + profile in one row, rounded-16, gap-12 (Figma 917:11177)
//
//  Pill specs: h 60, border 2 white, rounded 16, shadow 0 4 16.8 rgba(0,0,0,0.25), p 16
//  Glass: rgba(0,0,0,0.5) backdrop-blur-8 mix-blend-hard-light
//  Cursor bar: #EAF8FF, 3x32, rounded 20
//  Placeholder: Poppins Light 14/20, white
//  Voice icon: 24x24, white
//

import SwiftUI

enum SearchWidgetMode: Equatable {
    case expanded
    case inline
}

struct SearchWidgetView: View {
    let mode: SearchWidgetMode
    var onTap: () -> Void = {}
    var onVoiceTap: () -> Void = {}

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

    // MARK: - Pill content (shared, always rounded-16 dark glass)

    private var pillContent: some View {
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
        .background(glassBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16))
        .overlay(RoundedRectangle(cornerRadius: 16).strokeBorder(.white, lineWidth: 2))
        .shadow(color: .black.opacity(0.25), radius: 8.4, x: 0, y: 4)
    }

    // MARK: - Glass background (dark, always)

    private var glassBackground: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 16).fill(.ultraThinMaterial)
            RoundedRectangle(cornerRadius: 16).fill(Color.black.opacity(0.5))
        }
    }

    // MARK: - Blinking cursor (#EAF8FF, 3x32, rounded 20)

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

    private var sixEskaiButton: some View {
        Button(action: {}) {
            Image("6eskai-entry")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)
        }
        .buttonStyle(.plain)
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

#Preview("Expanded") {
    ZStack {
        Image("light-header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 120)
            SearchWidgetView(mode: .expanded).padding(.horizontal, 20)
            Spacer()
        }
    }
}

#Preview("Inline") {
    ZStack {
        Image("light-header-bg").resizable().aspectRatio(contentMode: .fill).ignoresSafeArea()
        VStack {
            Spacer().frame(height: 40)
            SearchWidgetView(mode: .inline).padding(.horizontal, 20)
            Spacer()
        }
    }
}
