//
//  FareSelectionView.swift
//  IndiGoPrototype
//
//  Fare summary and confirm – end of flow.
//

import SwiftUI

struct FareSelectionView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(title: "Fare", onBack: { dismiss() })
            Spacer()
        }
        .background(IndiGoColors.background)
    }
}

#Preview {
    FareSelectionView()
}
