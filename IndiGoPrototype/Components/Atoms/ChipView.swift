//
//  ChipView.swift
//  IndiGoPrototype
//
//  Atom – chip/tag; use design tokens.
//

import SwiftUI

struct ChipView: View {
    let title: String

    var body: some View {
        Text(title)
            .font(IndiGoFonts.caption())
            .foregroundStyle(IndiGoColors.textSecondary)
            .padding(.horizontal, IndiGoSpacing.sm)
            .padding(.vertical, IndiGoSpacing.xxs)
            .background(IndiGoColors.backgroundSecondary)
            .clipShape(Capsule())
    }
}

#Preview {
    ChipView(title: "New")
}
