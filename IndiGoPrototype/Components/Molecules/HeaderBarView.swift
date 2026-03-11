//
//  HeaderBarView.swift
//  IndiGoPrototype
//
//  Molecule – sticky header (back + title) for Book / SRP.
//

import SwiftUI

struct HeaderBarView: View {
    let title: String
    let onBack: () -> Void

    var body: some View {
        HStack(spacing: IndiGoSpacing.sm) {
            IconButton(iconName: "chevron.left", action: onBack)
            Text(title)
                .font(IndiGoFonts.heading3())
                .foregroundStyle(IndiGoColors.textPrimary)
            Spacer()
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.xs)
        .background(IndiGoColors.surface)
    }
}

#Preview {
    HeaderBarView(title: "Book", onBack: {})
}
