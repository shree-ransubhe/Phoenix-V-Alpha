//
//  FlightOffersFooterSection.swift
//  IndiGoPrototype
//
//  Molecule – "India by IndiGo" corporate footer section.
//  Shows a dotted world map, the headline, daily-flight count,
//  and a 2×2 grid of stat cards.
//  Figma node: 85:6323
//

import SwiftUI

// MARK: - Visibility trigger (fires when view scrolls into viewport)

private struct VisibilityTrigger: View {
    var onVisible: () -> Void

    var body: some View {
        GeometryReader { geo in
            Color.clear
                .preference(
                    key: VisibilityKey.self,
                    value: geo.frame(in: .global).minY
                )
        }
        .frame(height: 0)
        .onPreferenceChange(VisibilityKey.self) { minY in
            let screenHeight = UIScreen.main.bounds.height
            if minY < screenHeight + 100 {
                onVisible()
            }
        }
    }

    private struct VisibilityKey: PreferenceKey {
        static var defaultValue: CGFloat = .infinity
        static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
            value = min(value, nextValue())
        }
    }
}

// MARK: - Stat model

struct FooterStat: Identifiable {
    let id = UUID()
    let value: String
    let suffix: String?
    let label: String

    init(_ value: String, suffix: String? = nil, label: String) {
        self.value = value
        self.suffix = suffix
        self.label = label
    }
}

// MARK: - Animated number counter

private struct AnimatedCounter: View {
    let target: Int
    let suffix: String
    let suffixSmall: String?
    let duration: Double

    @State private var displayValue: Int = 0

    var body: some View {
        Group {
            if let small = suffixSmall {
                (
                    Text("\(displayValue)\(suffix)")
                        .font(IndiGoFonts.displaySmall())
                        .tracking(-0.6)
                    + Text(small)
                        .font(IndiGoFonts.subHeading3())
                        .tracking(-0.4)
                )
            } else {
                Text("\(displayValue)\(suffix)")
                    .font(IndiGoFonts.displaySmall())
                    .tracking(-0.6)
            }
        }
        .foregroundStyle(IndiGoColors.footerBlue)
        .onAppear { startCounting() }
    }

    private func startCounting() {
        guard displayValue == 0 else { return }
        let steps = min(target, 30)
        let interval = duration / Double(steps)
        for step in 1...steps {
            DispatchQueue.main.asyncAfter(deadline: .now() + interval * Double(step)) {
                withAnimation(.linear(duration: interval * 0.5)) {
                    displayValue = Int(Double(target) * Double(step) / Double(steps))
                }
            }
        }
    }
}

// MARK: - Section

struct FlightOffersFooterSection: View {

    @State private var triggered = false
    @State private var mapRevealed = false
    @State private var headlineRevealed = false
    @State private var dailyFlightsRevealed = false
    @State private var statCardAppeared: Set<Int> = []
    @State private var countersStarted = false

    private let stats: [FooterStat] = [
        FooterStat("96", label: "Domestic\nDestinations"),
        FooterStat("850", suffix: " Mn+", label: "Happy\nCustomers"),
        FooterStat("45", label: "International\nDestinations"),
        FooterStat("400+", label: "Fleet\nStrong"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            Color.white

            VStack(spacing: 0) {
                VisibilityTrigger { triggerDelightSequence() }

                worldMap
                headlineBlock
                    .padding(.top, -40)
                statsGrid
                    .padding(.top, IndiGoSpacing.md)
                    .padding(.bottom, 120)
            }
        }
        .clipped()
    }

    // MARK: - World map

    private var worldMap: some View {
        Image("world-map-dotted")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(maxWidth: .infinity)
            .opacity(mapRevealed ? 0.6 : 0)
            .scaleEffect(mapRevealed ? 1 : 1.15)
            .blur(radius: mapRevealed ? 0 : 6)
    }

    // MARK: - Headline

    private var headlineBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("India")
                    .font(IndiGoFonts.displayHero())
                    .tracking(-0.8)
                Text("by")
                    .font(IndiGoFonts.displaySmall())
                    .tracking(-0.4)
                Text("IndiGo")
                    .font(IndiGoFonts.displayHero())
                    .tracking(-0.8)
            }
            .foregroundStyle(IndiGoColors.footerBlue)

            HStack(alignment: .lastTextBaseline, spacing: 4) {
                Text("2,200+")
                    .font(IndiGoFonts.displaySmall())
                    .tracking(-0.6)
                Text("Daily Flights")
                    .font(IndiGoFonts.bodyMedium())
            }
            .foregroundStyle(IndiGoColors.footerBlue)
            .opacity(dailyFlightsRevealed ? 1 : 0)
            .offset(x: dailyFlightsRevealed ? 0 : -30)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .offset(y: headlineRevealed ? 0 : 40)
        .opacity(headlineRevealed ? 1 : 0)
    }

    // MARK: - Stats grid (2×2)

    private var statsGrid: some View {
        LazyVGrid(
            columns: [
                GridItem(.flexible(), spacing: IndiGoSpacing.sm),
                GridItem(.flexible(), spacing: IndiGoSpacing.sm)
            ],
            spacing: IndiGoSpacing.sm
        ) {
            ForEach(Array(stats.enumerated()), id: \.element.id) { index, stat in
                statCard(stat, index: index)
            }
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.xs)
        .background(IndiGoColors.footerStatsBg)
    }

    // MARK: - Single stat card

    private func statCard(_ stat: FooterStat, index: Int) -> some View {
        let revealed = statCardAppeared.contains(index)
        let comesFromLeft = index % 2 == 0

        return HStack(spacing: IndiGoSpacing.sm) {
            if countersStarted {
                let numericValue = Int(stat.value.replacingOccurrences(of: "+", with: "")) ?? 0
                let hasPlusSuffix = stat.value.contains("+")
                AnimatedCounter(
                    target: numericValue,
                    suffix: hasPlusSuffix ? "+" : "",
                    suffixSmall: stat.suffix,
                    duration: 0.8
                )
            } else {
                Text(" ")
                    .font(IndiGoFonts.displaySmall())
            }

            Text(stat.label)
                .font(.custom("Poppins-Regular", size: 9))
                .foregroundStyle(IndiGoColors.footerStatLabel)
                .lineSpacing(2)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, IndiGoSpacing.sm)
        .padding(.vertical, IndiGoSpacing.xs)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.footerStatBorder, lineWidth: 1)
        )
        .shadow(color: Color.black.opacity(0.1), radius: 1, x: 0, y: 0)
        .scaleEffect(revealed ? 1 : 0.7)
        .opacity(revealed ? 1 : 0)
        .offset(x: revealed ? 0 : (comesFromLeft ? -40 : 40))
        .rotation3DEffect(
            .degrees(revealed ? 0 : (comesFromLeft ? -15 : 15)),
            axis: (x: 0, y: 1, z: 0)
        )
    }

    // MARK: - Delight animation sequence

    private func triggerDelightSequence() {
        guard !triggered else { return }
        triggered = true

        withAnimation(.easeOut(duration: 0.9)) {
            mapRevealed = true
        }

        withAnimation(.spring(response: 0.6, dampingFraction: 0.75).delay(0.3)) {
            headlineRevealed = true
        }

        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.6)) {
            dailyFlightsRevealed = true
        }

        for i in stats.indices {
            let stagger = 0.8 + Double(i) * 0.12
            withAnimation(
                .spring(response: 0.55, dampingFraction: 0.7)
                .delay(stagger)
            ) {
                statCardAppeared.insert(i)
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.9) {
            countersStarted = true
        }
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        Color.clear.frame(height: 800)
        FlightOffersFooterSection()
    }
    .background(Color(hex: "F5F5F5"))
}
