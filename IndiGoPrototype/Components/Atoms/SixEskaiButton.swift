//
//  SixEskaiButton.swift
//  IndiGoPrototype
//
//  Atom – 6eSkai assistant entry point button (30x30 gradient circle).
//  Reused across HomeHeader, SearchWidget (inline), and BookingHeader.
//

import SwiftUI

struct SixEskaiButton: View {
    var size: CGFloat = 32
    var action: () -> Void = {}

    var body: some View {
        Button(action: action) {
            Image("6eskai-entry")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: size, height: size)
                .clipShape(Circle())
                .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SixEskaiButton()
}
