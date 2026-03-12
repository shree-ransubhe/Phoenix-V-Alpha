//
//  FromToView.swift
//  IndiGoPrototype
//
//  Book step 1 – redirects to BookLocationView (the full location selection experience).
//

import SwiftUI

struct FromToView: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        BookLocationView()
            .environmentObject(bookingState)
    }
}

#Preview {
    NavigationStack {
        FromToView()
            .environmentObject(BookingState())
    }
}
