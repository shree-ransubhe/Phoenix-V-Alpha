import SwiftUI

/// Horizontal date switcher showing fare prices per day.
/// Figma v5.0 node 2382:40274 — 80px wide cards, IndiGo blue shadow, bright blue selected border.
struct SRPCalendarStrip: View {
    @Binding var dates: [CalendarDate]
    var onSelect: (Int) -> Void = { _ in }

    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: IndiGoSpacing.xs) {
                ForEach(Array(dates.enumerated()), id: \.element.id) { index, date in
                    CalendarDateCell(date: date)
                        .onTapGesture {
                            guard date.price != nil else { return }
                            HapticManager.selection()
                            withAnimation(.easeInOut(duration: 0.2)) {
                                selectDate(at: index)
                                onSelect(index)
                            }
                        }
                }
            }
            .padding(.horizontal, IndiGoSpacing.md)
        }
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
                    .padding(.trailing, 4)
                } else {
                    Spacer().frame(height: 4)
                }

                Text("\(date.dayLabel), \(date.dateLabel)")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(dateColor)
                    .lineLimit(1)
                    .minimumScaleFactor(0.85)

                if let price = date.price {
                    Text("₹\(price.formatted())")
                        .font(date.isSelected ? IndiGoFonts.bodyExtraSmallBold() : IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(priceColor)
                } else {
                    Text("--")
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }
            }
            .padding(.horizontal, IndiGoSpacing.xs)
            .padding(.vertical, date.isSelected ? IndiGoSpacing.sm : IndiGoSpacing.xs)

            bottomBar
        }
        .frame(width: 80)
        .background(backgroundColor)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm)
                .stroke(date.isSelected ? IndiGoColors.chipBorderBlue : .clear, lineWidth: 1)
        )
        .shadow(color: IndiGoColors.calendarShadow, radius: 3, x: 0, y: 0)
        .animation(.spring(response: 0.25, dampingFraction: 0.75), value: date.isSelected)
    }

    @ViewBuilder
    private var bottomBar: some View {
        if date.isCheapest {
            RoundedRectangle(cornerRadius: 2)
                .fill(IndiGoColors.successGreen)
                .frame(width: 32, height: 2)
                .padding(.bottom, 6)
        } else {
            Spacer().frame(height: 2)
                .padding(.bottom, 6)
        }
    }

    private var backgroundColor: Color {
        if date.price == nil { return IndiGoColors.calendarDisabled }
        return date.isSelected ? IndiGoColors.calendarSelected : IndiGoColors.calendarDefault
    }

    private var priceColor: Color {
        if date.price == nil { return IndiGoColors.forYouTextSecondary }
        if date.isCheapest { return IndiGoColors.successGreen }
        return date.isSelected ? IndiGoColors.forYouTextPrimary : IndiGoColors.forYouTextPrimary
    }

    private var dateColor: Color {
        if date.price == nil { return IndiGoColors.forYouTextSecondary }
        return IndiGoColors.forYouTextSecondary
    }
}

#Preview {
    SRPCalendarStrip(dates: .constant(MockFlights.calendarDates))
        .padding(.vertical)
        .background(Color(hex: "EAF8FF"))
}
