//
//  IconButton.swift
//  IndiGoPrototype
//
//  Atom – icon-only button; use design tokens.
//

import SwiftUI

struct IconButton: View {
    let iconName: String
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.lightImpact()
            action()
        }) {
            Image(systemName: iconName)
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(IndiGoColors.textPrimary)
                .frame(width: 44, height: 44)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    IconButton(iconName: "arrow.left", action: {})
}
