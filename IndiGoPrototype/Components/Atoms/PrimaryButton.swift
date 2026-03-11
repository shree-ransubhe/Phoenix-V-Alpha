//
//  PrimaryButton.swift
//  IndiGoPrototype
//
//  Atom – primary CTA button; use design tokens.
//

import SwiftUI

struct PrimaryButton: View {
    let title: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(IndiGoFonts.body())
                .fontWeight(.semibold)
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, IndiGoSpacing.md)
                .background(IndiGoColors.primary)
                .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    PrimaryButton(title: "Search", action: {})
        .padding()
}
