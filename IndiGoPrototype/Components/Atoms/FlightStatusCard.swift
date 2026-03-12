//
//  FlightStatusCard.swift
//  IndiGoPrototype
//
//  Atom – "Flight Status" quick-action card.
//  Figma node: 765:8859
//

import SwiftUI

struct FlightStatusCard: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            statusIcon

            VStack(alignment: .leading, spacing: 0) {
                Text("Flight Status")
                    .font(IndiGoFonts.subHeading3())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .tracking(-0.4)

                Text("Check your flight status")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
        }
        .padding(.horizontal, 14)
        .padding(.vertical, IndiGoSpacing.md)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.secondaryBright, lineWidth: 1)
        )
    }

    private var statusIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm)
                .fill(IndiGoColors.secondaryMedium)
                .frame(width: 36, height: 36)

            Image("icon-flight-status")
                .renderingMode(.original)
                .frame(width: 20, height: 20)
        }
    }
}

#Preview {
    FlightStatusCard()
        .padding()
}
