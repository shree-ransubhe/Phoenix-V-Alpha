//
//  MyBookingsCard.swift
//  IndiGoPrototype
//
//  Atom – "My Bookings" card showing upcoming flights.
//  Figma node: 765:8828
//

import SwiftUI

struct BookingItem: Identifiable {
    let id = UUID()
    let date: String
    let from: String
    let to: String
}

struct MyBookingsCard: View {
    let bookings: [BookingItem]

    var body: some View {
        VStack(alignment: .leading, spacing: 7) {
            Text("My\nBookings")
                .font(IndiGoFonts.subHeading3())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .tracking(-0.4)
                .lineSpacing(0)
                .fixedSize(horizontal: false, vertical: true)
                .frame(width: 75, alignment: .leading)
                .padding(.horizontal, IndiGoSpacing.xs)

            ForEach(bookings) { booking in
                bookingRow(booking)
            }
        }
        .padding(.top, 21)
        .padding(.bottom, IndiGoSpacing.xs)
        .padding(.horizontal, IndiGoSpacing.xxs)
        .background(IndiGoColors.secondaryLight)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.secondaryBright, lineWidth: 1)
        )
    }

    private func bookingRow(_ booking: BookingItem) -> some View {
        HStack(spacing: IndiGoSpacing.xs) {
            flightIcon

            VStack(alignment: .leading, spacing: 5) {
                Text(booking.date)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)

                HStack(spacing: 5) {
                    Text(booking.from)
                        .font(IndiGoFonts.subHeading6())
                    Text("–")
                        .font(IndiGoFonts.subHeading6())
                    Text(booking.to)
                        .font(IndiGoFonts.subHeading6())
                }
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }

            Spacer()
        }
        .padding(IndiGoSpacing.xxs)
        .background(Color.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
    }

    private var flightIcon: some View {
        ZStack {
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm)
                .fill(IndiGoColors.secondaryMedium)
                .frame(width: 32, height: 32)

            Image("icon-clickable-link")
                .renderingMode(.original)
                .frame(width: 16, height: 16)
        }
    }
}

#Preview {
    MyBookingsCard(bookings: [
        BookingItem(date: "24 JAN 2026", from: "DEL", to: "BOM"),
        BookingItem(date: "24 JAN 2026", from: "HYD", to: "BOM")
    ])
    .frame(width: 159)
    .padding()
}
