//
//  CommunitySection.swift
//  IndiGoPrototype
//
//  Molecule – Community carousel section with expand/collapse card transitions.
//  Figma node: 85:6085
//
//  Always exactly 2 cards visible — one expanded (300pt), one collapsed strip (36pt).
//  Every card lives in a single ForEach; widths animate between expanded ↔ collapsed.
//
//  Companion placement follows the user's travel direction:
//    – Going forward  → collapsed companion on RHS (peek next).
//                        On the last card it flips to LHS (peek previous).
//    – Going backward → collapsed companion on LHS (peek previous).
//                        On the first card it flips to RHS (peek next).
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

    @State private var currentIndex: Int = 0
    @State private var movingForward: Bool = true

    private let expandedWidth: CGFloat = 300
    private let collapsedWidth: CGFloat = 36
    private let cardHeight: CGFloat = 213
    private let cardSpacing: CGFloat = 7
    private let cornerRadius: CGFloat = 12

    private var totalWidth: CGFloat {
        expandedWidth + cardSpacing + collapsedWidth
    }

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

    var body: some View {
        carousel
            .padding(.horizontal, IndiGoSpacing.lg)
            .padding(.bottom, IndiGoSpacing.lg)
    }

    // MARK: - Carousel

    private var carousel: some View {
        HStack(spacing: cardSpacing) {
            ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                let role = cardRole(at: index)

                communityCard(item: item, index: index, isExpanded: role == .expanded)
                    .frame(
                        width: role.width(
                            expanded: expandedWidth,
                            collapsed: collapsedWidth
                        ),
                        height: cardHeight
                    )
                    .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
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
        .frame(width: totalWidth, alignment: .leading)
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
                    .padding(.top, 12)
                    .padding(.leading, 12)

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
        VStack(alignment: .leading, spacing: 12) {
            Image("nofilter-logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 100, height: 20)

            Text(item.heading)
                .font(IndiGoFonts.displayXS())
                .tracking(-0.6)
                .lineSpacing(4)
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    // MARK: - Pagination badge

    private func paginationBadge(index: Int) -> some View {
        HStack(spacing: 0) {
            Text("\(index + 1)")
                .tracking(0.72)
            Text("/")
                .tracking(1.92)
            Text("\(items.count)")
                .tracking(0.72)
        }
        .font(.custom("BauhausStd-Medium", size: 12))
        .foregroundStyle(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            Capsule()
                .fill(.ultraThinMaterial)
                .overlay(
                    Capsule()
                        .fill(
                            LinearGradient(
                                colors: [
                                    Color(red: 160/255, green: 200/255, blue: 209/255)
                                        .opacity(0.69),
                                    Color(red: 118/255, green: 108/255, blue: 99/255)
                                        .opacity(0.69)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                )
        )
        .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 12, y: -12)
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
