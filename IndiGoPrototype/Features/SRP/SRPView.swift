//
//  SRPView.swift
//  IndiGoPrototype
//
//  Search Results Page – list of fare cards. Compose FareCardRowView.
//

import SwiftUI

struct SRPView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        VStack(spacing: 0) {
            HeaderBarView(title: "Flights", onBack: { dismiss() })
            Spacer()
        }
        .background(IndiGoColors.background)
    }
}

#Preview {
    SRPView()
}
