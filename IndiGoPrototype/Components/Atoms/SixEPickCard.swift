//
//  SixEPickCard.swift
//  IndiGoPrototype
//
//  Atom – individual service card for the "6E Pick" horizontal carousel.
//  Figma node: 260:10168 (TaskCard)
//

import SwiftUI

struct SixEPickItem: Identifiable {
    let id = UUID()
    let title: String
    let imageName: String
}

struct SixEPickCard: View {
    let item: SixEPickItem

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

    // MARK: - Gradient image area

    private var imageContainer: some View {
        ZStack {
            LinearGradient(
                colors: [.white, IndiGoColors.secondaryMedium],
                startPoint: .top,
                endPoint: .bottom
            )

            Image(item.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 122, height: 96)
                .clipped()
        }
        .frame(height: 96)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
    }

    // MARK: - Title + arrow row

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

#Preview {
    HStack(spacing: IndiGoSpacing.xs) {
        SixEPickCard(item: SixEPickItem(title: "Hotels", imageName: "6epick-hotels"))
        SixEPickCard(item: SixEPickItem(title: "Sight Seeing", imageName: "6epick-sightseeing"))
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
