//
//  CommunitySection.swift
//  IndiGoPrototype
//
//  Molecule – Community carousel section with expand/collapse card transitions.
//  Figma node: 85:6085 (4.1), 2463:31397 (5.0)
//
//  Always exactly 2 cards visible — one expanded, one collapsed strip.
//  All items live in a single ForEach so SwiftUI animates width changes.
//
//  Companion placement follows user's travel direction:
//    – Going forward  → collapsed companion on RHS (peek next).
//                        On last card it flips to LHS (peek previous).
//    – Going backward → collapsed companion on LHS (peek previous).
//                        On first card it flips to RHS (peek next).
//
//  Alpha 5.0 changes:
//    – Section title "What's new" + subtitle "Explore our communities"
//    – NoFilter logo removed from expanded overlay
//    – Expanded card radius 8pt, collapsed card radius 24pt
//    – Heading font 16pt (was 20pt), badge font Poppins 8pt
//    – Collapsed card gets 40% black overlay
//

import SwiftUI

// MARK: - Data model

struct CommunityItem: Identifiable {
    let id = UUID()
    let imageName: String
    let heading: String
}

// MARK: - Section

struct CommunitySection: View {
    let items: [CommunityItem]
    @Environment(\.alphaTheme) private var theme

    @State private var currentIndex: Int = 0
    @State private var movingForward: Bool = true

    private var collapsedWidth: CGFloat { theme.communityCollapsedWidth }
    private var cardHeight: CGFloat { theme.communityCardHeight }
    private var cardSpacing: CGFloat { theme.communityCardSpacing }
    private var hPad: CGFloat { theme.communityHorizontalPadding }

    private var isFirstItem: Bool { currentIndex == 0 }
    private var isLastItem: Bool { currentIndex >= items.count - 1 }

    private var companionIndex: Int {
        if movingForward {
            return isLastItem
                ? max(currentIndex - 1, 0)
                : min(currentIndex + 1, items.count - 1)
        } else {
            return isFirstItem
                ? min(currentIndex + 1, items.count - 1)
                : max(currentIndex - 1, 0)
        }
    }

    private func advance(to newIndex: Int) {
        movingForward = newIndex > currentIndex
        currentIndex = newIndex
    }

    private func expandedWidth(in totalWidth: CGFloat) -> CGFloat {
        totalWidth - collapsedWidth - cardSpacing
    }

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.xs) {
            if theme.communityShowsTitle {
                sectionHeader
                    .padding(.horizontal, hPad)
            }
            carouselContainer
        }
    }

    // MARK: - Section header (Alpha 5.0)

    private var sectionHeader: some View {
        VStack(alignment: .leading, spacing: 0) {
            Text("What's new")
                .font(IndiGoFonts.displayXS())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Text("Explore our communities")
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
    }

    // MARK: - Carousel

    private var carouselContainer: some View {
        GeometryReader { geo in
            let availableWidth = geo.size.width - hPad * 2
            let expWidth = expandedWidth(in: availableWidth)

            HStack(spacing: cardSpacing) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    let role = cardRole(at: index)
                    let isExpanded = role == .expanded

                    communityCard(item: item, index: index, isExpanded: isExpanded)
                        .frame(
                            width: role.width(
                                expanded: expWidth,
                                collapsed: collapsedWidth
                            ),
                            height: cardHeight
                        )
                        .clipShape(
                            RoundedRectangle(
                                cornerRadius: isExpanded
                                    ? theme.communityCornerRadius
                                    : theme.communityCollapsedCornerRadius
                            )
                        )
                        .shadow(
                            color: role != .hidden
                                ? Color(hex: "4C5D9E").opacity(0.08)
                                : .clear,
                            radius: 6
                        )
                        .opacity(role != .hidden ? 1 : 0)
                        .allowsHitTesting(role == .collapsed)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            guard role == .collapsed else { return }
                            withAnimation(.easeInOut(duration: 0.35)) {
                                advance(to: index)
                            }
                        }
                }
            }
            .frame(width: availableWidth, alignment: .leading)
            .padding(.horizontal, hPad)
            .gesture(
                DragGesture(minimumDistance: 20)
                    .onEnded { value in
                        let threshold: CGFloat = 40
                        withAnimation(.easeInOut(duration: 0.35)) {
                            if value.translation.width < -threshold,
                               currentIndex < items.count - 1 {
                                advance(to: currentIndex + 1)
                            } else if value.translation.width > threshold,
                                      currentIndex > 0 {
                                advance(to: currentIndex - 1)
                            }
                        }
                    }
            )
            .animation(.easeInOut(duration: 0.35), value: currentIndex)
        }
        .frame(height: cardHeight)
    }

    // MARK: - Card roles

    private enum CardRole {
        case expanded, collapsed, hidden

        func width(expanded: CGFloat, collapsed: CGFloat) -> CGFloat {
            switch self {
            case .expanded: return expanded
            case .collapsed: return collapsed
            case .hidden: return 0
            }
        }
    }

    private func cardRole(at index: Int) -> CardRole {
        if index == currentIndex { return .expanded }
        if index == companionIndex { return .collapsed }
        return .hidden
    }

    // MARK: - Single card

    @ViewBuilder
    private func communityCard(
        item: CommunityItem,
        index: Int,
        isExpanded: Bool
    ) -> some View {
        GeometryReader { geo in
            ZStack(alignment: .topLeading) {
                cardImage(item: item, size: geo.size)

                if isExpanded {
                    expandedOverlay(item: item, index: index)
                        .transition(.opacity)
                } else if theme.communityShowsCollapsedOverlay {
                    Color.black.opacity(0.4)
                }
            }
        }
    }

    private func cardImage(item: CommunityItem, size: CGSize) -> some View {
        Image(item.imageName)
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(width: size.width, height: size.height)
            .clipped()
    }

    // MARK: - Expanded state overlay

    private func expandedOverlay(item: CommunityItem, index: Int) -> some View {
        ZStack(alignment: .topLeading) {
            bottomGradient

            VStack(alignment: .leading, spacing: 0) {
                paginationBadge(index: index)
                    .padding(.top, 16)
                    .padding(.leading, 16)

                Spacer()

                textContent(item: item)
                    .padding(.leading, 16)
                    .padding(.bottom, 16)
                    .padding(.trailing, 16)
            }
        }
    }

    private var bottomGradient: some View {
        LinearGradient(
            stops: [
                .init(color: .clear, location: 0.25),
                .init(color: Color.black.opacity(0.5), location: 0.72)
            ],
            startPoint: .top,
            endPoint: .bottom
        )
    }

    private func textContent(item: CommunityItem) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            if theme.communityShowsNoFilterLogo {
                Image("nofilter-logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 100, height: 20)
            }

            Text(item.heading)
                .font(theme.communityHeadingFont)
                .foregroundStyle(.white)
                .lineSpacing(4)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Pagination badge

    private func paginationBadge(index: Int) -> some View {
        Text("\(index + 1)/\(items.count)")
            .font(theme.communityBadgeFont)
            .foregroundStyle(.white)
            .padding(.horizontal, 8)
            .frame(height: 16)
            .background(
                RoundedRectangle(cornerRadius: theme.communityBadgeRadius)
                    .fill(.ultraThinMaterial)
                    .overlay(
                        RoundedRectangle(cornerRadius: theme.communityBadgeRadius)
                            .fill(
                                LinearGradient(
                                    colors: [
                                        Color(red: 160/255, green: 200/255, blue: 209/255)
                                            .opacity(0.6),
                                        Color(red: 118/255, green: 108/255, blue: 99/255)
                                            .opacity(0.6)
                                    ],
                                    startPoint: .top,
                                    endPoint: .bottom
                                )
                            )
                    )
            )
    }
}

// MARK: - Preview

#Preview {
    ScrollView {
        CommunitySection(items: [
            CommunityItem(
                imageName: "img-nofilter",
                heading: "Explore the World through the\nlens of our Community"
            ),
            CommunityItem(
                imageName: "img-community2",
                heading: "Discover Hidden Gems through\nthe Eyes of Fellow Travelers"
            ),
            CommunityItem(
                imageName: "img-community3",
                heading: "Journey Beyond Borders with\nStories from our Community"
            ),
        ])
    }
    .background(Color(hex: "F5F5F5"))
}
