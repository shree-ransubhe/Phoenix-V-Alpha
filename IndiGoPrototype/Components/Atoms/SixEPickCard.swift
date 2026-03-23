//
//  SixEPickCard.swift
//  IndiGoPrototype
//
//  Atom – service card for the "6E Pick" section.
//
//  Alpha 4.1 (Figma 260:10168): Image-based card in horizontal carousel.
//  Alpha 5.0 (Figma 2453:26526): Icon + label row with optional badge in a 2-col grid.
//

import SwiftUI

// MARK: - Data model

struct SixEPickItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let badge: String?
    let imageName: String?
    let subtitle: String?

    init(title: String, iconName: String = "", badge: String? = nil, imageName: String? = nil, subtitle: String? = nil) {
        self.title = title
        self.iconName = iconName
        self.badge = badge
        self.imageName = imageName
        self.subtitle = subtitle
    }
}

// MARK: - Alpha 5.0 grid row variant

struct SixEPickRow: View {
    let item: SixEPickItem
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        HStack(spacing: 7) {
            iconAvatar
            label
            Spacer()
        }
        .padding(theme.sixEPickRowPadding)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(IndiGoColors.sixEPickRowBg)
        .clipShape(RoundedRectangle(cornerRadius: theme.sixEPickRowCornerRadius))
        .overlay(alignment: .topTrailing) {
            if let badge = item.badge {
                badgeView(badge)
                    .offset(x: -7.5, y: -4)
            }
        }
    }

    private var iconAvatar: some View {
        ZStack {
            RoundedRectangle(cornerRadius: theme.sixEPickIconBgCornerRadius)
                .fill(Color.white)
                .frame(width: theme.sixEPickIconBgSize, height: theme.sixEPickIconBgSize)

            Image(item.iconName)
                .renderingMode(.template)
                .resizable()
                .scaledToFit()
                .frame(width: theme.sixEPickIconSize, height: theme.sixEPickIconSize)
                .foregroundStyle(IndiGoColors.indigoBlue)
        }
    }

    private var label: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(item.title)
                .font(IndiGoFonts.caption())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .lineLimit(1)
            if let subtitle = item.subtitle {
                Text(subtitle)
                    .font(IndiGoFonts.navLabel())
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)
                    .lineLimit(1)
            }
        }
    }

    private func badgeView(_ text: String) -> some View {
        HStack(spacing: IndiGoSpacing.xxs) {
            if text.contains("%") {
                Image(systemName: "percent")
                    .resizable()
                    .frame(width: 8, height: 8)
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
            Text(text)
                .font(.custom("Poppins-Regular", size: 8))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
        .padding(.horizontal, IndiGoSpacing.xs)
        .frame(height: 16)
        .background(Color.white)
        .clipShape(Capsule())
        .overlay(Capsule().stroke(IndiGoColors.sixEPickBadgeBorder, lineWidth: 1))
    }
}

// MARK: - Alpha 4.1 image card variant

struct SixEPickCard: View {
    let item: SixEPickItem
    @Environment(\.alphaTheme) private var theme

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            imageContainer
            labelRow
        }
        .padding(IndiGoSpacing.xs)
        .frame(width: 138, height: 144)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusLg))
        .shadow(color: .black.opacity(0.1), radius: 7.5, y: 5)
        .shadow(color: .black.opacity(0.1), radius: 3)
    }

    private var imageContainer: some View {
        ZStack {
            LinearGradient(
                colors: [.white, IndiGoColors.secondaryMedium],
                startPoint: .top,
                endPoint: .bottom
            )

            if let imageName = item.imageName {
                Image(imageName)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 122, height: 96)
                    .clipped()
            }
        }
        .frame(height: 96)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
    }

    private var labelRow: some View {
        HStack {
            Text(item.title)
                .font(IndiGoFonts.bodySemiBold())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .lineLimit(1)

            Spacer()

            arrowIcon
        }
        .opacity(0.9)
    }

    private var arrowIcon: some View {
        ZStack {
            Circle()
                .stroke(IndiGoColors.secondaryDeepGrey, lineWidth: 1)
                .frame(width: 24, height: 24)

            Image("icon-dotted-arrow-ne")
                .renderingMode(.template)
                .resizable()
                .frame(width: 20, height: 20)
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
    }
}

#Preview("Alpha 5.0 Row") {
    VStack(spacing: 8) {
        SixEPickRow(item: SixEPickItem(title: "Hotels", iconName: "icon-6epick-hotel", badge: "20% off"))
        SixEPickRow(item: SixEPickItem(title: "Cabs", iconName: "icon-6epick-cabs", badge: "New"))
    }
    .padding()
}

#Preview("Alpha 4.1 Card") {
    HStack(spacing: 8) {
        SixEPickCard(item: SixEPickItem(title: "Hotels", imageName: "6epick-hotels"))
        SixEPickCard(item: SixEPickItem(title: "Sight Seeing", imageName: "6epick-sightseeing"))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
