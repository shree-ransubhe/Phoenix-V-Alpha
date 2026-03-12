//
//  HeaderBarView.swift
//  IndiGoPrototype
//
//  Molecule – sticky header (back + title + optional trailing view) for Book / SRP.
//

import SwiftUI

struct HeaderBarView<Trailing: View>: View {
    let title: String
    let titleFont: Font
    let titleTracking: CGFloat
    let onBack: () -> Void
    @ViewBuilder var trailing: () -> Trailing

    init(
        title: String,
        titleFont: Font = IndiGoFonts.heading3(),
        titleTracking: CGFloat = 0,
        onBack: @escaping () -> Void,
        @ViewBuilder trailing: @escaping () -> Trailing = { EmptyView() }
    ) {
        self.title = title
        self.titleFont = titleFont
        self.titleTracking = titleTracking
        self.onBack = onBack
        self.trailing = trailing
    }

    var body: some View {
        HStack(spacing: IndiGoSpacing.sm) {
            IconButton(iconName: "chevron.left", action: onBack)

            Spacer()

            Text(title)
                .font(titleFont)
                .tracking(titleTracking)
                .foregroundStyle(IndiGoColors.textPrimary)

            Spacer()

            trailing()
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.xs)
        .background(IndiGoColors.surface)
    }
}

#Preview("Default") {
    HeaderBarView(title: "Book", onBack: {})
}

#Preview("With trailing") {
    HeaderBarView(
        title: "Book Flights",
        titleFont: .custom("BauhausStd-Medium", size: 22),
        titleTracking: 0.44,
        onBack: {}
    ) {
        SixEskaiButton()
    }
}
