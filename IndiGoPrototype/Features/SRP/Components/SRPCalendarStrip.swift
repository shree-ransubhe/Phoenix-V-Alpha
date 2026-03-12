import SwiftUI

/// Horizontal date switcher showing fare prices per day.
/// The cheapest date shows a green dot indicator. Tapping a date selects it.
struct SRPCalendarStrip: View {
    @Binding var dates: [CalendarDate]
    var onSelect: (Int) -> Void = { _ in }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: IndiGoSpacing.xs) {
                ForEach(Array(dates.enumerated()), id: \.element.id) { index, date in
                    CalendarDateCell(date: date)
                        .onTapGesture {
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectDate(at: index)
                                onSelect(index)
                            }
                        }
                }
            }
            .padding(.horizontal, IndiGoSpacing.md)
        }
        .frame(height: 54)
    }

    private func selectDate(at selectedIndex: Int) {
        dates = dates.enumerated().map { index, date in
            CalendarDate(
                dayLabel: date.dayLabel,
                dateLabel: date.dateLabel,
                price: date.price,
                isCheapest: date.isCheapest,
                isSelected: index == selectedIndex
            )
        }
    }
}

private struct CalendarDateCell: View {
    let date: CalendarDate

    var body: some View {
        VStack(spacing: IndiGoSpacing.xs) {
            VStack(spacing: 0) {
                if date.isCheapest {
                    HStack {
                        Spacer()
                        Circle()
                            .fill(IndiGoColors.successGreen)
                            .frame(width: 4, height: 4)
                    }
                } else {
                    Spacer().frame(height: 4)
                }

                Text("\(date.dayLabel), \(date.dateLabel)")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(dateColor)

                if let price = date.price {
                    Text("₹\(price.formatted())")
                        .font(IndiGoFonts.bodyExtraSmallMedium())
                        .foregroundStyle(priceColor)
                } else {
                    Text("--")
                        .font(IndiGoFonts.bodyExtraSmallMedium())
                        .foregroundStyle(IndiGoColors.actionDisabled)
                }
            }
            .padding(.horizontal, IndiGoSpacing.xs)
            .padding(.vertical, IndiGoSpacing.xxs)

            if date.isCheapest {
                RoundedRectangle(cornerRadius: 2)
                    .fill(IndiGoColors.successGreen)
                    .frame(width: 32, height: 2)
            } else {
                Spacer().frame(height: 2)
            }
        }
        .frame(width: 64, height: 50)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
        .scaleEffect(date.isSelected ? 1.05 : 1.0)
        .animation(.spring(response: 0.25, dampingFraction: 0.7), value: date.isSelected)
    }

    private var backgroundColor: Color {
        date.isSelected ? IndiGoColors.calendarSelected : IndiGoColors.calendarDefault
    }

    private var priceColor: Color {
        if date.price == nil { return IndiGoColors.actionDisabled }
        return date.isSelected ? IndiGoColors.forYouTextPrimary : IndiGoColors.forYouTextSecondary
    }

    private var dateColor: Color {
        if date.price == nil { return IndiGoColors.actionDisabled }
        return date.isSelected ? IndiGoColors.forYouTextSecondary : IndiGoColors.forYouTextTertiary
    }
}

#Preview {
    SRPCalendarStrip(dates: .constant(MockFlights.calendarDates))
        .background(Color(hex: "EAF8FF"))
}
