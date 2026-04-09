//
//  SixEPickExploreView.swift
//  IndiGoPrototype
//
//  Full-screen "6E Pick Explore" landing page.
//
//  Alpha 6.1 (Figma 5657:57630): Full-width LOB list with dividers,
//    24px icons, Bauhaus Display titles in indigo, light-blue badge
//    pills, accordion-right chevrons, #F5F8FC background.
//
//  Alpha 5.0 (Figma 2440:41915): 2-column grid reusing SixEPickRow.
//

import SwiftUI

struct SixEPickExploreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.alphaTheme) private var theme

    @State private var appeared = false

    static let allItems: [SixEPickItem] = [
        SixEPickItem(title: "Hotels", iconName: "icon-6epick-hotel-lg", badge: "20% off"),
        SixEPickItem(title: "Cabs", iconName: "icon-6epick-cabs-lg", badge: "New"),
        SixEPickItem(title: "Sightseeing", iconName: "icon-6epick-sightseeing-lg", badge: "20% off"),
        SixEPickItem(title: "Experiences", iconName: "icon-6epick-experience-lg", badge: "20% off"),
        SixEPickItem(title: "Brand Gift Vouchers", iconName: "icon-6epick-brand-gv", badge: "20% off",
                     subtitle: "Purchase and use gift cards from stores"),
        SixEPickItem(title: "IndiGo Gift Vouchers", iconName: "icon-6epick-indigo-gv",
                     subtitle: "Purchase and use gift cards from stores"),
        SixEPickItem(title: "Private Transfers", iconName: "icon-6epick-private-transfer-lg"),
    ]

    var body: some View {
        ZStack(alignment: .top) {
            scrollContent
            stickyHeader
        }
        .background(IndiGoColors.sixEPickExploreBg)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Sticky Header (Figma 5658:58408)

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            HStack(spacing: IndiGoSpacing.sm) {
                Button(action: { dismiss() }) {
                    Image("icon-cancel")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
                .buttonStyle(.plain)
                .frame(width: 53, height: 20, alignment: .leading)

                Spacer()

                Text("6E Pick")
                    .font(IndiGoFonts.displayXS())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Spacer()

                Color.clear.frame(width: 53, height: 32)
            }
            .padding(.horizontal, IndiGoSpacing.md)
            .padding(.vertical, IndiGoSpacing.sm)
        }
        .background(
            .ultraThinMaterial
        )
    }

    // MARK: - Scroll Content

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: IndiGoSpacing.md) {
                Color.clear.frame(height: 52)

                descriptionBlock

                lobList

                disclaimerBlock
            }
            .padding(.horizontal, IndiGoSpacing.md)
            .padding(.vertical, IndiGoSpacing.xs)
        }
    }

    // MARK: - Description (Figma 5657:57632)

    private var descriptionBlock: some View {
        VStack(alignment: .center, spacing: 0) {
            (
                Text("Explore a world of ")
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                +
                Text("BluChip")
                    .foregroundStyle(IndiGoColors.sixEPickGreen)
            )
            .font(.custom("Poppins-Medium", size: 12))
            .frame(maxWidth: .infinity)

            Text("An ecosystem for a seamless journey, from doorstep to destination")
                .font(IndiGoFonts.navLabel())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .frame(maxWidth: .infinity, alignment: .leading)
        }
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 8)
    }

    // MARK: - LOB List (Figma 5657:57635)

    private var lobList: some View {
        VStack(spacing: IndiGoSpacing.xs) {
            IndiGoColors.sixEPickLobDivider.frame(height: 1)

            ForEach(Array(Self.allItems.enumerated()), id: \.element.id) { index, item in
                lobRow(item: item, index: index)
            }
        }
    }

    // MARK: - Single LOB Row

    private func lobRow(item: SixEPickItem, index: Int) -> some View {
        let delay = Double(index) * 0.06
        return Button(action: {}) {
            VStack(spacing: 0) {
                HStack(spacing: IndiGoSpacing.xs) {
                    Image(item.iconName)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(IndiGoColors.indigoBlue)

                    VStack(alignment: .leading, spacing: 0) {
                        HStack(spacing: IndiGoSpacing.xs) {
                            Text(item.title)
                                .font(IndiGoFonts.displayXS())
                                .foregroundStyle(IndiGoColors.indigoBlue)
                                .lineLimit(1)

                            if let badge = item.badge {
                                lobBadge(badge)
                            }
                        }

                        if let subtitle = item.subtitle {
                            Text(subtitle)
                                .font(IndiGoFonts.navLabel())
                                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                                .lineLimit(1)
                        }
                    }

                    Spacer()

                    Image("icon-accordion-right")
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
                .padding(.horizontal, IndiGoSpacing.md)
                .padding(.top, IndiGoSpacing.md)
                .padding(.bottom, IndiGoSpacing.xl)

                IndiGoColors.sixEPickLobDivider.frame(height: 1)
            }
        }
        .buttonStyle(.plain)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 16)
        .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: appeared)
    }

    // MARK: - Badge (Figma 5657:57640) — light-blue bg, 24px pill, 10pt label

    private func lobBadge(_ text: String) -> some View {
        Text(text)
            .font(IndiGoFonts.navLabel())
            .foregroundStyle(IndiGoColors.forYouTextPrimary)
            .padding(.horizontal, IndiGoSpacing.xs)
            .frame(height: 16)
            .background(IndiGoColors.sixEPickLobBadgeBg)
            .clipShape(Capsule())
    }

    // MARK: - Disclaimer

    private var disclaimerBlock: some View {
        Text("Powered by our trusted partners")
            .font(IndiGoFonts.navLabel())
            .foregroundStyle(IndiGoColors.forYouTextSecondary)
            .frame(maxWidth: .infinity)
            .padding(.top, IndiGoSpacing.md)
            .opacity(appeared ? 1 : 0)
            .animation(.easeOut(duration: 0.5).delay(0.5), value: appeared)
    }
}

#Preview {
    NavigationStack {
        SixEPickExploreView()
    }
}
