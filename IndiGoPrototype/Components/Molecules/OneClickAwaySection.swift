//
//  OneClickAwaySection.swift
//  IndiGoPrototype
//
//  Molecule – "One Click Away" section. Reads from AlphaTheme to
//  render either the 4.1 layout (From selector, filter chips, tinted bg)
//  or the 5.0 layout (View all CTA, no controls, card shadow, last card).
//  Figma nodes: 85:6087 (4.1), 2463:31104 (5.0)
//

import SwiftUI

struct OneClickAwaySection: View {
    let destinations: [Destination]
    @Environment(\.alphaTheme) private var theme

    @State private var selectedCategory: DestinationCategory? = nil
    @State private var selectedOrigin: String = "Visakhapatnam"
    @State private var showOriginPicker = false
    @State private var visibleIDs: Set<String> = []

    private let origins = [
        "Visakhapatnam", "New Delhi", "Mumbai", "Bengaluru",
        "Chennai", "Hyderabad", "Kolkata", "Pune", "Goa"
    ]

    private var filteredDestinations: [Destination] {
        guard let category = selectedCategory else { return destinations }
        return destinations.filter { $0.category == category }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: theme.oneClickSectionSpacing) {
            sectionHeader

            if theme.oneClickShowsFromSelector || theme.oneClickShowsFilterChips {
                controlsRow
            }

            carousel
        }
        .padding(.vertical, theme.oneClickVerticalPadding)
        .background(theme.oneClickShowsSectionBg ? IndiGoColors.oneClickBg : Color.clear)
        .confirmationDialog("Select Origin", isPresented: $showOriginPicker, titleVisibility: .visible) {
            ForEach(origins, id: \.self) { origin in
                Button(origin) { selectedOrigin = origin }
            }
        }
    }

    // MARK: - Header

    private var sectionHeader: some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                if theme.oneClickTitleUsesGreenSplit {
                    Text("One Click")
                        .font(theme.oneClickTitleFont)
                        .foregroundStyle(IndiGoColors.accentGreen)
                        .tracking(-0.6)
                    + Text(" Away")
                        .font(theme.oneClickTitleFont)
                        .foregroundStyle(theme.oneClickTitleColor)
                        .tracking(-0.6)
                } else {
                    Text("One Click Away")
                        .font(theme.oneClickTitleFont)
                        .foregroundStyle(theme.oneClickTitleColor)
                }

                Text("find flights at lowest fare")
                    .font(theme.oneClickSubtitleFont)
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Spacer()

            if theme.oneClickShowsViewAll {
                viewAllButton
            }
        }
        .padding(.horizontal, theme.oneClickHorizontalPadding)
    }

    private var viewAllButton: some View {
        Button {} label: {
            HStack(spacing: IndiGoSpacing.xxs) {
                Text("View all")
                    .font(IndiGoFonts.bodySmallMedium())
                    .foregroundStyle(IndiGoColors.indigoBlue)

                Image("icon-clickable-link")
                    .resizable()
                    .renderingMode(.template)
                    .foregroundStyle(IndiGoColors.indigoBlue)
                    .frame(width: 16, height: 16)
            }
            .frame(height: 32)
            .padding(.horizontal, IndiGoSpacing.sm)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Controls (From selector + filter chips) — 4.1 only

    private var controlsRow: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            if theme.oneClickShowsFromSelector {
                fromSelector
            }
            if theme.oneClickShowsFilterChips {
                filterChips
            }
        }
        .padding(.horizontal, theme.oneClickHorizontalPadding)
    }

    private var fromSelector: some View {
        Button { showOriginPicker = true } label: {
            ZStack(alignment: .topLeading) {
                HStack(spacing: IndiGoSpacing.sm) {
                    Text(selectedOrigin)
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)
                        .lineLimit(1)

                    Image("icon-dropdown-chevron")
                        .resizable()
                        .renderingMode(.original)
                        .frame(width: 20, height: 20)
                }
                .padding(.horizontal, IndiGoSpacing.sm)
                .frame(height: 40)
                .background(Color.white)
                .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
                .overlay(
                    RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm)
                        .stroke(IndiGoColors.activeBlue, lineWidth: 1)
                )

                Text("From")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .padding(.horizontal, IndiGoSpacing.xxs)
                    .background(Color.white)
                    .offset(x: 7, y: -8)
            }
        }
        .buttonStyle(.plain)
    }

    private var filterChips: some View {
        HStack(spacing: theme.oneClickChipSpacing) {
            ForEach(DestinationCategory.allCases, id: \.self) { category in
                filterChip(for: category)
            }
        }
    }

    private func filterChip(for category: DestinationCategory) -> some View {
        let isSelected = selectedCategory == category
        return Button {
            let newCategory: DestinationCategory? = isSelected ? nil : category
            visibleIDs = []

            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedCategory = newCategory
            }

            let upcoming = {
                guard let cat = newCategory else { return destinations }
                return destinations.filter { $0.category == cat }
            }()
            for (i, dest) in upcoming.enumerated() {
                withAnimation(
                    .spring(response: 0.4, dampingFraction: 0.75)
                    .delay(Double(i) * 0.06)
                ) {
                    visibleIDs.insert(dest.id)
                }
            }
        } label: {
            Text(category.rawValue)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(isSelected ? .white : IndiGoColors.forYouTextSecondary)
                .padding(.horizontal, IndiGoSpacing.sm)
                .padding(.vertical, IndiGoSpacing.xs)
                .background(isSelected ? IndiGoColors.chipSelectedBg : Color.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule().stroke(
                        isSelected ? Color.clear : IndiGoColors.chipBorder,
                        lineWidth: 1
                    )
                )
                .animation(.easeInOut(duration: 0.2), value: isSelected)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Carousel

    private var carousel: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: theme.oneClickCarouselSpacing) {
                    ForEach(Array(filteredDestinations.enumerated()), id: \.element.id) { _, destination in
                        let isVisible = visibleIDs.contains(destination.id)
                        OneClickAwayCard(destination: destination)
                            .scaleEffect(isVisible ? 1 : 0.85)
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 20)
                            .id(destination.id)
                    }

                    if theme.oneClickShowsViewAllCard {
                        viewAllCard
                    }
                }
                .padding(.horizontal, theme.oneClickHorizontalPadding)
                .padding(.vertical, IndiGoSpacing.xs)
            }
            .onChange(of: selectedCategory) { _ in
                if let firstID = filteredDestinations.first?.id {
                    withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                        proxy.scrollTo(firstID, anchor: .leading)
                    }
                }
            }
        }
        .onAppear {
            for (i, dest) in filteredDestinations.enumerated() {
                withAnimation(
                    .spring(response: 0.4, dampingFraction: 0.75)
                    .delay(Double(i) * 0.06)
                ) {
                    visibleIDs.insert(dest.id)
                }
            }
        }
    }

    // MARK: - "View all +200 destinations" last card (5.0)

    private var viewAllCard: some View {
        ZStack(alignment: .bottom) {
            if let lastDest = filteredDestinations.last,
               UIImage(named: lastDest.imageName) != nil {
                Image(lastDest.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: theme.oneClickCardWidth, height: theme.oneClickCardHeight)
                    .clipped()
            } else {
                Color(hex: "25304B")
            }

            Color.black.opacity(0.7)

            VStack(alignment: .leading, spacing: theme.oneClickCardDateFirst ? IndiGoSpacing.xl : IndiGoSpacing.sm) {
                Spacer()

                Text("View all +200 destinations")
                    .font(theme.oneClickCardNameFont)
                    .foregroundStyle(.white)

                Button {} label: {
                    HStack(spacing: IndiGoSpacing.xxs) {
                        Text("Explore more")
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(.white)

                        Image("icon-clickable-link")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundStyle(.white)
                            .frame(width: 20, height: 20)
                    }
                    .frame(height: 36)
                    .padding(.horizontal, IndiGoSpacing.sm)
                }
                .background(Color.white.opacity(0.12))
                .clipShape(RoundedRectangle(cornerRadius: theme.oneClickCardButtonCornerRadius))
                .overlay(
                    RoundedRectangle(cornerRadius: theme.oneClickCardButtonCornerRadius)
                        .stroke(Color.white, lineWidth: 1)
                )
            }
            .padding(IndiGoSpacing.md)
            .frame(maxWidth: .infinity, alignment: .leading)
        }
        .frame(width: theme.oneClickCardWidth, height: theme.oneClickCardHeight)
        .clipShape(RoundedRectangle(cornerRadius: theme.oneClickCardCornerRadius))
        .shadow(
            color: theme.oneClickCardShadowColor,
            radius: theme.oneClickCardShadowRadius
        )
    }
}

// MARK: - Preview

#Preview("Alpha 4.1") {
    ScrollView {
        OneClickAwaySection(destinations: MockDestinations.all)
            .alphaTheme(Alpha41Theme())
    }
    .background(Color(hex: "F5F5F5"))
}

#Preview("Alpha 5.0") {
    ScrollView {
        OneClickAwaySection(destinations: MockDestinations.all)
            .alphaTheme(Alpha50Theme())
    }
    .background(Color(hex: "F5F5F5"))
}
