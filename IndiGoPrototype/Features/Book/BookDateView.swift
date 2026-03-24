//
//  BookDateView.swift
//  IndiGoPrototype
//
//  Book step 2 – Date selection with From/To summary card.
//  Figma: node 3:7896 (full page), 3:7909 (From/To summary card).
//

import SwiftUI

struct BookDateView: View {
    var isEditMode = false

    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var departureDate: Date?
    @State private var returnDate: Date?
    @State private var tripType: BookingState.TripType = .oneWay
    @State private var cardAppeared = false
    @State private var calendarAppeared = false
    @State private var navigateToPassengers = false
    @State private var editLocation = false

    /// Tracks which date the user is picking: departure first, then return (for round trip).
    @State private var isSelectingReturn = false

    private let calendar = Calendar.current
    @State private var displayedMonth = Date()

    var body: some View {
        ZStack(alignment: .top) {
            backgroundGradient

            VStack(spacing: 0) {
                stickyHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        Button { editLocation = true } label: {
                            fromToSummaryCard
                        }
                        .buttonStyle(.plain)
                        .opacity(cardAppeared ? 1 : 0)
                        .offset(y: cardAppeared ? 0 : 20)

                        tripTypeSelector
                            .opacity(cardAppeared ? 1 : 0)

                        calendarCard
                            .opacity(calendarAppeared ? 1 : 0)
                            .offset(y: calendarAppeared ? 0 : 30)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }

            VStack {
                Spacer()
                bottomBar
            }
        }
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        #if UT_VARIANT
        .utInstrumented(screenId: "BookDateView")
        #endif
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToPassengers) {
            BookPassengerView()
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editLocation) {
            BookLocationView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            tripType = bookingState.tripType

            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.05)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85).delay(0.2)) {
                calendarAppeared = true
            }
        }
    }

    // MARK: - Readiness check

    /// Whether the user has met the date criteria for the current trip type.
    private var isDateCriteriaMet: Bool {
        guard departureDate != nil else { return false }
        if tripType == .returnTrip { return returnDate != nil }
        return true
    }

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "D1EFFF"), .white]),
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
    }

    // MARK: - Sticky Header

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 54)

            HeaderBarView(
                title: "Book Flights",
                titleFont: .custom("BauhausStd-Medium", size: 22),
                titleTracking: 0.44,
                onBack: { dismiss() }
            ) {
                SixEskaiButton()
            }
        }
        .clipShape(
            UnevenRoundedRectangle(
                bottomLeadingRadius: 16,
                bottomTrailingRadius: 16
            )
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    // MARK: - From/To Summary Card (Figma node 3:7909)

    private var fromToSummaryCard: some View {
        HStack(spacing: 16) {
            VStack(alignment: .leading, spacing: 2) {
                Text("From")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)

                Text(bookingState.origin?.code ?? "---")
                    .font(.custom("BauhausStd-Medium", size: 20))
                    .tracking(-0.6)
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text(bookingState.origin?.name ?? "")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Spacer()

            Image(systemName: "arrow.left.arrow.right")
                .font(.system(size: 16, weight: .medium))
                .foregroundStyle(IndiGoColors.secondaryBright)

            Spacer()

            VStack(alignment: .trailing, spacing: 2) {
                Text("To")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)

                Text(bookingState.destination?.code ?? "---")
                    .font(.custom("BauhausStd-Medium", size: 20))
                    .tracking(-0.6)
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text(bookingState.destination?.name ?? "")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    // MARK: - Trip Type Selector (Figma node 3:7948)

    private var tripTypeSelector: some View {
        HStack(spacing: 24) {
            ForEach(BookingState.TripType.allCases, id: \.self) { type in
                Button(action: {
                    HapticManager.selection()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        tripType = type
                        bookingState.tripType = type
                        if type == .oneWay {
                            returnDate = nil
                            bookingState.returnDate = nil
                            isSelectingReturn = false
                        }
                    }
                }) {
                    HStack(spacing: 8) {
                        ZStack {
                            Circle()
                                .strokeBorder(
                                    tripType == type
                                        ? IndiGoColors.primaryMain
                                        : Color(hex: "9BA4B8"),
                                    lineWidth: 1.5
                                )
                                .frame(width: 20, height: 20)

                            if tripType == type {
                                Circle()
                                    .fill(IndiGoColors.primaryMain)
                                    .frame(width: 10, height: 10)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }

                        Text(type.rawValue)
                            .font(IndiGoFonts.bodySmall())
                            .foregroundStyle(
                                tripType == type
                                    ? IndiGoColors.forYouTextPrimary
                                    : IndiGoColors.forYouTextSecondary
                            )
                    }
                }
                .buttonStyle(.plain)
            }
        }
    }

    // MARK: - Calendar Card (Figma node 3:7951, 3:8082)

    private var calendarTitle: String {
        if tripType == .returnTrip && isSelectingReturn {
            return "When are you returning?"
        }
        return "When are you going?"
    }

    private var calendarCard: some View {
        VStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text(calendarTitle)
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
            .frame(maxWidth: .infinity)

            calendarGrid
        }
        .padding(16)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(IndiGoColors.secondaryBright, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    private var calendarGrid: some View {
        VStack(spacing: 8) {
            monthHeader

            weekdayRow

            let days = daysInMonth()
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 0), count: 7), spacing: 4) {
                ForEach(days, id: \.self) { day in
                    dayCell(day)
                }
            }

            HStack(spacing: 6) {
                Circle()
                    .fill(Color(hex: "218946"))
                    .frame(width: 6, height: 6)
                Text("Holiday")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                Spacer()
            }
            .padding(.top, 4)
        }
    }

    private var monthHeader: some View {
        HStack {
            Button(action: { changeMonth(by: -1) }) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)

            Spacer()

            Text(monthYearString())
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Spacer()

            Button(action: { changeMonth(by: 1) }) {
                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)
        }
    }

    private var weekdayRow: some View {
        HStack(spacing: 0) {
            ForEach(["Sun", "Mon", "Tue", "Wed", "Thu", "Fri", "Sat"], id: \.self) { day in
                Text(day)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .frame(maxWidth: .infinity)
            }
        }
    }

    @ViewBuilder
    private func dayCell(_ day: Int) -> some View {
        if day == 0 {
            Color.clear.frame(height: 44)
        } else {
            let date = dateFor(day: day)
            let isDeparture = isSameDay(date, departureDate)
            let isReturn = isSameDay(date, returnDate)
            let isInRange = isDateInRange(date)
            let isToday = isDayToday(day)
            let isPast = isDayPast(day)
            let isBeforeDeparture = isSelectingReturn && !isPast && isBeforeDepartureDate(date)
            let isSelected = isDeparture || isReturn

            Button(action: { selectDay(day) }) {
                VStack(spacing: 1) {
                    Text("\(day)")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(
                            isPast || isBeforeDeparture ? Color(hex: "9BA4B8") :
                            isSelected ? .white :
                            IndiGoColors.forYouTextPrimary
                        )

                    Text(isPast ? "-" : samplePrice(for: day))
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(
                            isPast || isBeforeDeparture ? Color(hex: "9BA4B8") :
                            isSelected ? .white.opacity(0.8) :
                            priceColor(for: day)
                        )
                }
                .frame(maxWidth: .infinity)
                .frame(height: 44)
                .background(
                    isSelected
                        ? IndiGoColors.primaryMain
                        : isInRange
                            ? IndiGoColors.secondaryLight.opacity(0.5)
                            : isToday
                                ? IndiGoColors.secondaryLight
                                : .clear
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .buttonStyle(.plain)
            .disabled(isPast || isBeforeDeparture)
        }
    }

    // MARK: - Bottom Bar (Figma node 3:8029)

    private var bottomBar: some View {
        HStack(spacing: 40) {
            Button(action: { clearAll() }) {
                Text("Clear all")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .underline()
                    .frame(width: 94, height: 36)
            }
            .buttonStyle(.plain)

            Button(action: { handleNext() }) {
                Text(isEditMode ? "Done" : "Next")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(isDateCriteriaMet ? .white : Color(hex: "9BA4B8"))
                    .frame(width: 94, height: 36)
                    .background(
                        isDateCriteriaMet
                            ? IndiGoColors.primaryMain
                            : Color(hex: "BCC2CF")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .disabled(!isDateCriteriaMet)
            .animation(.easeInOut(duration: 0.2), value: isDateCriteriaMet)
        }
        .padding(.top, 16)
        .padding(.bottom, 36)
        .padding(.horizontal, 46)
        .frame(maxWidth: .infinity)
        .background(
            .white
                .shadow(.drop(color: Color(hex: "4C5D9E").opacity(0.08), radius: 12, x: 0, y: -12))
        )
    }

    // MARK: - Actions

    private func handleNext() {
        guard isDateCriteriaMet else { return }
        HapticManager.mediumImpact()
        bookingState.selectedDate = departureDate
        bookingState.returnDate = returnDate
        if isEditMode {
            dismiss()
        } else {
            navigateToPassengers = true
        }
    }

    // MARK: - Calendar Helpers

    private func monthYearString() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM yyyy"
        return formatter.string(from: displayedMonth)
    }

    private func changeMonth(by value: Int) {
        HapticManager.lightImpact()
        withAnimation(.easeInOut(duration: 0.25)) {
            if let newDate = calendar.date(byAdding: .month, value: value, to: displayedMonth) {
                displayedMonth = newDate
            }
        }
    }

    private func daysInMonth() -> [Int] {
        let components = calendar.dateComponents([.year, .month], from: displayedMonth)
        guard let firstOfMonth = calendar.date(from: components),
              let range = calendar.range(of: .day, in: .month, for: firstOfMonth) else {
            return []
        }
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let padding = weekday - 1
        return Array(repeating: 0, count: padding) + Array(range)
    }

    private func dateFor(day: Int) -> Date? {
        var comp = calendar.dateComponents([.year, .month], from: displayedMonth)
        comp.day = day
        return calendar.date(from: comp)
    }

    private func isSameDay(_ a: Date?, _ b: Date?) -> Bool {
        guard let a, let b else { return false }
        return calendar.isDate(a, inSameDayAs: b)
    }

    private func isDateInRange(_ date: Date?) -> Bool {
        guard tripType == .returnTrip,
              let dep = departureDate, let ret = returnDate, let date else { return false }
        return date > dep && date < ret
    }

    private func isBeforeDepartureDate(_ date: Date?) -> Bool {
        guard let date, let dep = departureDate else { return false }
        return date < calendar.startOfDay(for: dep)
    }

    private func isDayToday(_ day: Int) -> Bool {
        let comp = calendar.dateComponents([.year, .month], from: displayedMonth)
        let todayComp = calendar.dateComponents([.year, .month, .day], from: Date())
        return comp.year == todayComp.year && comp.month == todayComp.month && todayComp.day == day
    }

    private func isDayPast(_ day: Int) -> Bool {
        var comp = calendar.dateComponents([.year, .month], from: displayedMonth)
        comp.day = day
        guard let date = calendar.date(from: comp) else { return false }
        return date < calendar.startOfDay(for: Date())
    }

    private func selectDay(_ day: Int) {
        var comp = calendar.dateComponents([.year, .month], from: displayedMonth)
        comp.day = day
        guard let date = calendar.date(from: comp) else { return }

        HapticManager.selection()

        withAnimation(.easeInOut(duration: 0.2)) {
            if tripType == .oneWay {
                departureDate = date
                bookingState.selectedDate = date
            } else {
                if isSelectingReturn {
                    returnDate = date
                    bookingState.returnDate = date
                } else {
                    departureDate = date
                    bookingState.selectedDate = date
                    if let ret = returnDate, date >= ret {
                        returnDate = nil
                        bookingState.returnDate = nil
                    }
                    isSelectingReturn = true
                }
            }
        }
    }

    private func clearAll() {
        HapticManager.lightImpact()
        withAnimation(.easeInOut(duration: 0.2)) {
            departureDate = nil
            returnDate = nil
            isSelectingReturn = false
            bookingState.selectedDate = nil
            bookingState.returnDate = nil
        }
    }

    private func samplePrice(for day: Int) -> String {
        let prices = ["₹3,600", "₹4,000", "₹5,600", "₹6,400", "₹7,200"]
        return prices[day % prices.count]
    }

    private func priceColor(for day: Int) -> Color {
        let colors: [Color] = [
            Color(hex: "218946"),
            Color(hex: "FFBD12"),
            IndiGoColors.forYouTextSecondary,
            Color(hex: "C3272E"),
            IndiGoColors.forYouTextSecondary
        ]
        return colors[day % colors.count]
    }
}

#Preview {
    let state = BookingState()
    state.origin = IndiGoAirports.domestic.first { $0.code == "DEL" }
    state.destination = IndiGoAirports.domestic.first { $0.code == "BOM" }
    return NavigationStack {
        BookDateView()
            .environmentObject(state)
    }
}
