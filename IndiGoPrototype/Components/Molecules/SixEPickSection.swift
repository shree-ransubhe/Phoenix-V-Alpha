//
//  SixEPickSection.swift
//  IndiGoPrototype
//
//  Molecule – "Beyond Flights explore 6EPick" section.
//
//  Alpha 4.1 (Figma 260:10026): Horizontal scroll carousel of image cards.
//  Alpha 5.0 (Figma 2453:26526): 2-column grid of icon rows with badges
//    + "Explore N more services" footer row.
//

import SwiftUI

struct SixEPickSection: View {
    let items: [SixEPickItem]
    var moreCount: Int = 5
    var onExploreMore: (() -> Void)?
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        if theme.sixEPickUsesGridLayout {
            VStack(alignment: .leading, spacing: theme.sixEPickSectionSpacing) {
                headerBlock
                gridLayout
            }
            .padding(.horizontal, theme.sixEPickHorizontalPadding)
            .padding(.bottom, theme.sixEPickVerticalPadding)
        } else {
            VStack(alignment: .leading, spacing: theme.sixEPickSectionSpacing) {
                headerBlock
                cardCarousel
            }
            .padding(.vertical, theme.sixEPickVerticalPadding)
        }
    }

    // MARK: - Header (title + optional subtitle)

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 0) {
            if theme.sixEPickUsesGridLayout {
                titleTextOnly
            } else {
                HStack(alignment: .bottom) {
                    titleTextOnly
                    Spacer()
                    chevronButton
                }
            }

            if theme.sixEPickShowsSubtitle {
                Text("An ecosystem for a seamless journey, from doorstep to destination")
                    .font(IndiGoFonts.navLabel())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
        }
        .padding(.horizontal, theme.sixEPickUsesGridLayout ? 0 : theme.sixEPickHorizontalPadding)
    }

    private var titleTextOnly: some View {
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
                    .frame(width: theme.sixEPickChevronSize, height: theme.sixEPickChevronSize)

                Image("icon-accordion-right")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 20, height: 20)
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Alpha 5.0: 2-column grid + explore-more footer

    private var gridLayout: some View {
        VStack(spacing: theme.sixEPickGridSpacing) {
            gridRows
            if theme.sixEPickShowsExploreMore {
                exploreMoreRow
            }
        }
    }

    private var gridRows: some View {
        let columns = 2
        let rowCount = (items.count + columns - 1) / columns
        return VStack(spacing: theme.sixEPickGridSpacing) {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: theme.sixEPickGridSpacing) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < items.count {
                            SixEPickRow(item: items[index])
                        } else {
                            Color.clear.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }

    private var exploreMoreRow: some View {
        Button(action: { onExploreMore?() }) {
            HStack(spacing: 7) {
                ZStack {
                    RoundedRectangle(cornerRadius: theme.sixEPickIconBgCornerRadius)
                        .fill(Color.white)
                        .frame(width: theme.sixEPickIconBgSize, height: theme.sixEPickIconBgSize)

                    Image("icon-6epick-more-grid")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: theme.sixEPickIconSize, height: theme.sixEPickIconSize)
                        .foregroundStyle(IndiGoColors.indigoBlue)
                }

                Text("Explore \(moreCount) more services")
                    .font(IndiGoFonts.caption())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Spacer()

                Image("icon-clickable-link")
                    .renderingMode(.template)
                    .resizable()
                    .frame(width: 16, height: 16)
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
            .padding(theme.sixEPickRowPadding)
            .background(IndiGoColors.sixEPickRowBg)
            .clipShape(RoundedRectangle(cornerRadius: theme.sixEPickRowCornerRadius))
        }
        .buttonStyle(.plain)
    }

    // MARK: - Alpha 4.1: Horizontal carousel

    private var cardCarousel: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: theme.sixEPickCardSpacing) {
                ForEach(items) { item in
                    SixEPickCard(item: item)
                }
            }
            .padding(.horizontal, theme.sixEPickHorizontalPadding)
            .padding(.top, IndiGoSpacing.xxs)
            .padding(.bottom, theme.sixEPickVerticalPadding)
        }
    }
}

// MARK: - Previews

#Preview("Alpha 5.0 Grid") {
    SixEPickSection(
        items: [
            SixEPickItem(title: "Hotels", iconName: "icon-6epick-hotel", badge: "20% off"),
            SixEPickItem(title: "Sightseeing", iconName: "icon-6epick-sightseeing", badge: "20% off"),
            SixEPickItem(title: "Cabs", iconName: "icon-6epick-cabs", badge: "New"),
            SixEPickItem(title: "Experiences", iconName: "icon-6epick-experience", badge: "20% off"),
        ],
        moreCount: 5
    )
    .background(Color.white)
}

#Preview("Alpha 4.1 Carousel") {
    SixEPickSection(items: [
        SixEPickItem(title: "Hotels", imageName: "6epick-hotels"),
        SixEPickItem(title: "Sight Seeing", imageName: "6epick-sightseeing"),
        SixEPickItem(title: "Cabs", imageName: "6epick-cabs"),
        SixEPickItem(title: "Experience", imageName: "6epick-experience"),
        SixEPickItem(title: "Shop", imageName: "6epick-shop"),
    ])
    .background(Color.gray.opacity(0.05))
}
