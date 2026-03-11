//
//  OneClickAwaySection.swift
//  IndiGoPrototype
//
//  Molecule – "One Click Away" section with origin selector,
//  International / Domestic filter chips, and horizontal carousel
//  of destination cards.
//  Figma node: 85:6087
//

import SwiftUI

struct OneClickAwaySection: View {
    let destinations: [Destination]

    @State private var selectedCategory: DestinationCategory? = nil
    @State private var selectedOrigin: String = "Visakhapatnam"
    @State private var showOriginPicker = false
    @State private var visibleIDs: Set<String> = []
    @Namespace private var cardNamespace

    private let origins = [
        "Visakhapatnam", "New Delhi", "Mumbai", "Bengaluru",
        "Chennai", "Hyderabad", "Kolkata", "Pune", "Goa"
    ]

    private var filteredDestinations: [Destination] {
        guard let category = selectedCategory else { return destinations }
        return destinations.filter { $0.category == category }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.md) {
            sectionHeader
            controlsRow
            carousel
        }
        .padding(.vertical, IndiGoSpacing.md)
        .background(IndiGoColors.oneClickBg)
        .confirmationDialog("Select Origin", isPresented: $showOriginPicker, titleVisibility: .visible) {
            ForEach(origins, id: \.self) { origin in
                Button(origin) { selectedOrigin = origin }
            }
        }
    }

    // MARK: - Header

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("One Click")
                .font(IndiGoFonts.displaySmall())
                .foregroundStyle(IndiGoColors.accentGreen)
                .tracking(-0.6)
            + Text(" Away")
                .font(IndiGoFonts.displaySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .tracking(-0.6)

            Text("find flights at lowest fare")
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
        }
        .padding(.horizontal, IndiGoSpacing.lg)
    }

    // MARK: - Controls (From selector + filter chips)

    private var controlsRow: some View {
        HStack(spacing: IndiGoSpacing.xs) {
            fromSelector
            filterChips
        }
        .padding(.horizontal, IndiGoSpacing.lg)
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
        HStack(spacing: IndiGoSpacing.xxs) {
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
                HStack(spacing: IndiGoSpacing.xl) {
                    ForEach(Array(filteredDestinations.enumerated()), id: \.element.id) { index, destination in
                        let isVisible = visibleIDs.contains(destination.id)
                        OneClickAwayCard(destination: destination)
                            .scaleEffect(isVisible ? 1 : 0.85)
                            .opacity(isVisible ? 1 : 0)
                            .offset(y: isVisible ? 0 : 20)
                            .id(destination.id)
                    }
                }
                .padding(.horizontal, IndiGoSpacing.lg)
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
}

// MARK: - Preview

#Preview {
    ScrollView {
        OneClickAwaySection(destinations: MockDestinations.all)
    }
    .background(Color(hex: "F5F5F5"))
}
