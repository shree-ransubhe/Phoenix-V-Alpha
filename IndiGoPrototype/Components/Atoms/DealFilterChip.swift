//
//  DealFilterChip.swift
//  IndiGoPrototype
//
//  Atom – pill-shaped filter chip for the Deals page.
//  Figma node: 5658:60383
//

import SwiftUI

struct DealFilterChip: View {
    let label: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(label)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .lineLimit(1)
        }
        .buttonStyle(.plain)
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.xxs)
        .frame(minWidth: 48, minHeight: 28)
        .background(isSelected ? IndiGoColors.dealChipSelectedBg : Color.white)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .stroke(
                    isSelected ? IndiGoColors.dealChipSelectedBorder : IndiGoColors.dealChipDefaultBorder,
                    lineWidth: 1
                )
        )
    }
}

#Preview {
    HStack(spacing: 8) {
        DealFilterChip(label: "All", isSelected: true, action: {})
        DealFilterChip(label: "Flights", isSelected: false, action: {})
        DealFilterChip(label: "Hotel", isSelected: false, action: {})
    }
    .padding()
}
