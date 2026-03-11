//
//  FromToView.swift
//  IndiGoPrototype
//
//  Book step 1 – From/To city selection. Compose FromToSelectView molecule.
//

import SwiftUI

struct FromToView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(title: "Book", onBack: { dismiss() })
            Spacer()
        }
        .background(IndiGoColors.background)
    }
}

#Preview {
    FromToView()
}
