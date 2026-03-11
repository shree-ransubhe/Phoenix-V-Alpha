//
//  SixEPickSection.swift
//  IndiGoPrototype
//
//  Molecule – "Beyond Flights explore 6EPick" horizontally scrolling card section.
//  Figma node: 260:10026
//

import SwiftUI

struct SixEPickSection: View {
    let items: [SixEPickItem]

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.md) {
            headerRow
            cardCarousel
        }
        .padding(.vertical, IndiGoSpacing.md)
    }

    // MARK: - Header

    private var headerRow: some View {
        HStack(alignment: .bottom) {
            titleText

            Spacer()

            chevronButton
        }
        .padding(.horizontal, IndiGoSpacing.lg)
    }

    private var titleText: some View {
        (
            Text("Beyond Flights explore ")
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
            +
            Text("6EPick")
                .foregroundStyle(IndiGoColors.sixEPickGreen)
        )
        .font(IndiGoFonts.displayXS())
        .tracking(-0.6)
    }

    private var chevronButton: some View {
        Button(action: {}) {
            ZStack {
                Circle()
                    .fill(Color.white)
                    .frame(width: 32, height: 32)

                Image("icon-accordion-right")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Horizontal carousel

    private var cardCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: IndiGoSpacing.xs) {
                ForEach(items) { item in
                    SixEPickCard(item: item)
                }
            }
            .padding(.horizontal, IndiGoSpacing.lg)
            .padding(.top, IndiGoSpacing.xxs)
            .padding(.bottom, IndiGoSpacing.md)
        }
    }
}

// MARK: - Preview

#Preview {
    SixEPickSection(items: [
        SixEPickItem(title: "Hotels", imageName: "6epick-hotels"),
        SixEPickItem(title: "Sight Seeing", imageName: "6epick-sightseeing"),
        SixEPickItem(title: "Cabs", imageName: "6epick-cabs"),
        SixEPickItem(title: "Experience", imageName: "6epick-experience"),
        SixEPickItem(title: "Shop", imageName: "6epick-shop"),
    ])
    .background(Color.gray.opacity(0.05))
}
