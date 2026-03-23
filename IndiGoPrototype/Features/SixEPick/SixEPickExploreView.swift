//
//  SixEPickExploreView.swift
//  IndiGoPrototype
//
//  Full-screen "6EPick Explore" page (Figma 2440:41915).
//  Revealed from the "Explore N more services" row in
//  SixEPickSection. Contains:
//    - Sticky header with centered title + close (X) button
//    - Description block ("Explore a world of BluChip")
//    - 2-column grid of all services (reuses SixEPickRow)
//    - Full-width service rows for additional items
//    - Disclaimer footer
//

import SwiftUI

struct SixEPickExploreView: View {
    @Environment(\.dismiss) private var dismiss
    @Environment(\.alphaTheme) private var theme

    @State private var appeared = false

    static let allItems: [SixEPickItem] = [
        SixEPickItem(title: "Hotels", iconName: "icon-6epick-hotel", badge: "20% off"),
        SixEPickItem(title: "Sightseeing", iconName: "icon-6epick-sightseeing", badge: "20% off"),
        SixEPickItem(title: "Cabs", iconName: "icon-6epick-cabs", badge: "New"),
        SixEPickItem(title: "Experiences", iconName: "icon-6epick-experience", badge: "20% off"),
        SixEPickItem(title: "Brand Gift Vouchers", iconName: "icon-6epick-voucher", badge: "New",
                     subtitle: "Purchase and use gift cards from stores"),
        SixEPickItem(title: "IndiGo Gift Vouchers", iconName: "icon-6epick-air-voucher"),
        SixEPickItem(title: "Private Transfers", iconName: "icon-6epick-private-transfer"),
    ]

    private let gridItems: [SixEPickItem] = Array(allItems.prefix(4))
    private let listItems: [SixEPickItem] = Array(allItems.dropFirst(4))

    var body: some View {
        ZStack(alignment: .top) {
            scrollContent
            stickyHeader
        }
        .background(Color.white)
        .navigationBarHidden(true)
        .onAppear {
            withAnimation(.easeOut(duration: 0.45).delay(0.1)) {
                appeared = true
            }
        }
    }

    // MARK: - Sticky Header

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            HStack {
                Color.clear.frame(width: 32, height: 20)

                Spacer()

                Text("6EPick")
                    .font(IndiGoFonts.displayXS())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Spacer()

                Button(action: { dismiss() }) {
                    Image("icon-cancel")
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
                .buttonStyle(.plain)
                .frame(width: 32, height: 20)
            }
            .padding(.horizontal, IndiGoSpacing.lg)
            .padding(.vertical, IndiGoSpacing.sm)
        }
        .background(
            .ultraThinMaterial
                .shadow(.drop(color: Color(hex: "000099").opacity(0.04), radius: 14, y: 0))
        )
    }

    // MARK: - Scroll Content

    private var scrollContent: some View {
        ScrollView(.vertical, showsIndicators: false) {
            VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
                Color.clear.frame(height: 52)

                descriptionBlock

                serviceGrid

                disclaimerBlock
            }
            .padding(IndiGoSpacing.md)
        }
    }

    // MARK: - Description

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
        .padding(.bottom, IndiGoSpacing.sm)
        .opacity(appeared ? 1 : 0)
        .offset(y: appeared ? 0 : 8)
    }

    // MARK: - Service Grid (2-col + full-width rows)

    private var serviceGrid: some View {
        VStack(spacing: IndiGoSpacing.xs) {
            twoColumnGrid
            fullWidthRows
        }
    }

    private var twoColumnGrid: some View {
        let columns = 2
        let rowCount = (gridItems.count + columns - 1) / columns
        return VStack(spacing: IndiGoSpacing.xs) {
            ForEach(0..<rowCount, id: \.self) { row in
                HStack(spacing: IndiGoSpacing.xs) {
                    ForEach(0..<columns, id: \.self) { col in
                        let index = row * columns + col
                        if index < gridItems.count {
                            rowAppearance(index: index) {
                                SixEPickRow(item: gridItems[index])
                            }
                        } else {
                            Color.clear.frame(maxWidth: .infinity)
                        }
                    }
                }
            }
        }
    }

    private var fullWidthRows: some View {
        ForEach(Array(listItems.enumerated()), id: \.element.id) { offset, item in
            rowAppearance(index: gridItems.count + offset) {
                SixEPickRow(item: item)
            }
        }
    }

    // MARK: - Row Entrance Animation

    private func rowAppearance<Content: View>(index: Int, @ViewBuilder content: () -> Content) -> some View {
        let delay = Double(index) * 0.06
        return content()
            .opacity(appeared ? 1 : 0)
            .offset(y: appeared ? 0 : 16)
            .animation(.spring(response: 0.5, dampingFraction: 0.8).delay(delay), value: appeared)
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
