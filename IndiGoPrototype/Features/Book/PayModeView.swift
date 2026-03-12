//
//  PayModeView.swift
//  IndiGoPrototype
//
//  Book step 4 – Pay mode selection.
//  Figma: node 3:8354 (full page), 3:8367 (From/To), 3:8404 (When),
//         3:8414 (Who), 3:8422 (Pay With card), 3:8424 (bottom sticky).
//

import SwiftUI

struct PayModeView: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var paymentMethod: BookingState.PaymentMethod = .cash
    @State private var useBluChipBalance = false
    @State private var selectedCurrency = "INR"
    @State private var showCurrencyPicker = false

    @State private var summaryAppeared = false
    @State private var payCardAppeared = false
    @State private var navigateToSRP = false
    @State private var editLocation = false
    @State private var editDate = false
    @State private var editPassengers = false
    @State private var radioHighlight = false

    private let currencies = ["INR", "USD", "EUR", "GBP", "AED", "SGD"]

    private var currencySymbol: String { symbolFor(selectedCurrency) }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundGradient

            VStack(spacing: 0) {
                stickyHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 8) {
                        Button { editLocation = true } label: {
                            fromToCard
                        }
                        .buttonStyle(.plain)
                        .opacity(summaryAppeared ? 1 : 0)
                        .offset(y: summaryAppeared ? 0 : 20)

                        Button { editDate = true } label: {
                            whenCard
                        }
                        .buttonStyle(.plain)
                        .opacity(summaryAppeared ? 1 : 0)
                        .offset(y: summaryAppeared ? 0 : 20)

                        Button { editPassengers = true } label: {
                            whoCard
                        }
                        .buttonStyle(.plain)
                        .opacity(summaryAppeared ? 1 : 0)
                        .offset(y: summaryAppeared ? 0 : 20)

                        payWithCard
                            .opacity(payCardAppeared ? 1 : 0)
                            .offset(y: payCardAppeared ? 0 : 30)
                    }
                    .padding(.top, 12)
                    .padding(.bottom, 100)
                }
            }

            VStack {
                Spacer()
                bottomStickyBar
            }
        }
        .navigationDestination(isPresented: $navigateToSRP) {
            SRPView()
                .environmentObject(bookingState)
        }
        .navigationDestination(isPresented: $editLocation) {
            BookLocationView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editDate) {
            BookDateView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editPassengers) {
            BookPassengerView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .ignoresSafeArea(.container, edges: [.top, .bottom])
        .navigationBarHidden(true)
        .onAppear {
            paymentMethod = bookingState.paymentMethod
            useBluChipBalance = bookingState.useBluChipBalance
            selectedCurrency = bookingState.selectedCurrency

            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.05)) {
                summaryAppeared = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85).delay(0.2)) {
                payCardAppeared = true
            }
        }
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

    // MARK: - Section 1: From/To Card (Figma node 3:8367)

    private var fromToCard: some View {
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

    // MARK: - Shared icon-label leading column
    // Figma: When (3:8405), Who (3:8415), Pay With (3221:28666) all use
    // w-94px containers with gap-8, icon size ~16-17px.

    private func iconLabelLeading(systemIcon: String, label: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: systemIcon)
                .font(.system(size: 14))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .frame(width: 17, height: 17, alignment: .center)

            Text(label)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
        .frame(width: 94, alignment: .leading)
    }

    // MARK: - Section 2: When Card (Figma node 3:8404)

    private var whenCard: some View {
        HStack {
            iconLabelLeading(systemIcon: "calendar", label: "When")

            Spacer()

            HStack(spacing: 6) {
                if let dep = bookingState.selectedDate {
                    Text(shortDateString(dep))
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                }

                if let ret = bookingState.returnDate {
                    Text("-")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(IndiGoColors.primaryMain)

                    Text(shortDateString(ret))
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    // MARK: - Section 3: Who Card (Figma node 3:8414)

    private var whoCard: some View {
        HStack {
            iconLabelLeading(systemIcon: "person.crop.circle", label: "Who")

            Spacer()

            Text(passengerSummary)
                .font(IndiGoFonts.bodySmallMedium())
                .foregroundStyle(IndiGoColors.primaryMain)
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    // MARK: - Section 4: Pay With Card (Figma node 3:8422)

    private var payWithCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 12) {
                payWithHeader

                bluChipBalanceBanner

                currencyRow
            }
            .padding(.vertical, 12)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .strokeBorder(IndiGoColors.secondaryBright, lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)

            if showCurrencyPicker {
                currencyDropdown
                    .zIndex(10)
            }
        }
        .padding(.horizontal, 15)
    }

    private var payWithHeader: some View {
        HStack {
            iconLabelLeading(systemIcon: "indianrupeesign", label: "Pay With")

            Spacer()

            HStack(spacing: 7) {
                ForEach(BookingState.PaymentMethod.allCases, id: \.self) { method in
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            paymentMethod = method
                            bookingState.paymentMethod = method
                            if method == .bluChip {
                                useBluChipBalance = true
                                bookingState.useBluChipBalance = true
                            } else {
                                useBluChipBalance = false
                                bookingState.useBluChipBalance = false
                            }
                        }
                    }) {
                        HStack(spacing: 2) {
                            ZStack {
                                Circle()
                                    .strokeBorder(
                                        paymentMethod == method
                                            ? IndiGoColors.primaryMain
                                            : Color(hex: "9BA4B8"),
                                        lineWidth: 1.5
                                    )
                                    .frame(width: 20, height: 20)

                                if paymentMethod == method {
                                    Circle()
                                        .fill(IndiGoColors.primaryMain)
                                        .frame(width: 10, height: 10)
                                        .transition(.scale.combined(with: .opacity))
                                }
                            }
                            .frame(width: 32, height: 32)

                            Text(method.rawValue)
                                .font(IndiGoFonts.bodySmallMedium())
                                .foregroundStyle(IndiGoColors.primaryMain)
                        }
                        .padding(.vertical, 4)
                        .padding(.horizontal, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(method == .bluChip && radioHighlight
                                      ? IndiGoColors.secondaryBright.opacity(0.15)
                                      : .clear)
                        )
                        .scaleEffect(method == .bluChip && radioHighlight ? 1.08 : 1.0)
                        .animation(.easeInOut(duration: 0.25), value: radioHighlight)
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .padding(.horizontal, 16)
    }

    private var bluChipBalanceBanner: some View {
        HStack {
            HStack(spacing: 6) {
                Image("IBC-coin")
                    .renderingMode(.original)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 22, height: 22)

                HStack(spacing: 2) {
                    Text("Use IndiGo BluChip balance:")
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(Color(hex: "EAF8FF"))
                        .lineLimit(1)

                    Text(formattedBalance)
                        .font(.custom("Poppins-SemiBold", size: 11))
                        .foregroundStyle(Color(hex: "D1EFFF"))
                }
            }

            Spacer()

            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    useBluChipBalance.toggle()
                    bookingState.useBluChipBalance = useBluChipBalance

                    if useBluChipBalance && paymentMethod != .bluChip {
                        paymentMethod = .bluChip
                        bookingState.paymentMethod = .bluChip
                        radioHighlight = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                            withAnimation(.easeOut(duration: 0.3)) {
                                radioHighlight = false
                            }
                        }
                    }
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(useBluChipBalance ? IndiGoColors.secondaryBright : .clear)
                        .frame(width: 22, height: 22)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .strokeBorder(
                                    useBluChipBalance ? IndiGoColors.secondaryBright : Color(hex: "9BA4B8"),
                                    lineWidth: 1.5
                                )
                        )

                    if useBluChipBalance {
                        Image(systemName: "checkmark")
                            .font(.system(size: 12, weight: .bold))
                            .foregroundStyle(.white)
                    }
                }
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "2B3548"), Color(hex: "020203")]),
                startPoint: .leading,
                endPoint: .trailing
            )
        )
    }

    private var currencyRow: some View {
        HStack {
            Spacer()

            Text("Currency : ")
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    showCurrencyPicker.toggle()
                }
            }) {
                HStack(spacing: 2) {
                    Text(currencySymbol)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .contentTransition(.numericText())
                        .animation(.easeInOut(duration: 0.25), value: selectedCurrency)

                    Text(selectedCurrency)
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)

                    Image(systemName: "chevron.down")
                        .font(.system(size: 10, weight: .medium))
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .rotationEffect(.degrees(showCurrencyPicker ? 180 : 0))
                }
                .padding(.horizontal, 8)
                .frame(height: 32)
            }
            .buttonStyle(.plain)
        }
        .padding(.trailing, 8)
    }

    private func symbolFor(_ code: String) -> String {
        switch code {
        case "INR": return "₹"
        case "USD": return "$"
        case "EUR": return "€"
        case "GBP": return "£"
        case "AED": return "د.إ"
        case "SGD": return "S$"
        default: return code
        }
    }

    private var currencyDropdown: some View {
        VStack(spacing: 0) {
            ForEach(currencies, id: \.self) { currency in
                Button(action: {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedCurrency = currency
                        bookingState.selectedCurrency = currency
                        showCurrencyPicker = false
                    }
                }) {
                    HStack(spacing: 8) {
                        Text(symbolFor(currency))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(
                                currency == selectedCurrency
                                    ? IndiGoColors.primaryMain
                                    : IndiGoColors.forYouTextSecondary
                            )
                            .frame(width: 24, alignment: .center)

                        Text(currency)
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(
                                currency == selectedCurrency
                                    ? IndiGoColors.primaryMain
                                    : IndiGoColors.forYouTextPrimary
                            )

                        Spacer()

                        if currency == selectedCurrency {
                            Image(systemName: "checkmark")
                                .font(.system(size: 11, weight: .bold))
                                .foregroundStyle(IndiGoColors.primaryMain)
                        }
                    }
                    .padding(.horizontal, 14)
                    .frame(height: 44)
                    .contentShape(Rectangle())
                }
                .buttonStyle(.plain)

                if currency != currencies.last {
                    Divider()
                        .padding(.horizontal, 10)
                }
            }
        }
        .padding(.vertical, 4)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
        .frame(width: 150)
        .offset(x: -16, y: 110)
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topTrailing)).combined(with: .opacity))
    }

    // MARK: - Section 5: Bottom Sticky Bar (Figma node 3:8424)
    // Figma: justify-center, gap 18, pr 46, pt 16, pb 36, backdrop-blur 12

    private var bottomStickyBar: some View {
        HStack(spacing: 18) {
            Button(action: { clearAll() }) {
                Text("Clear all")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .underline()
            }
            .buttonStyle(.plain)
            .frame(width: 95, height: 36)

            Button(action: { handleSearchFlight() }) {
                Text("Search Flight")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .padding(.horizontal, 24)
                    .padding(.vertical, 8)
                    .background(IndiGoColors.primaryMain)
                    .clipShape(RoundedRectangle(cornerRadius: 18))
                    .overlay(
                        RoundedRectangle(cornerRadius: 18)
                            .strokeBorder(.white, lineWidth: 1)
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.top, 16)
        .padding(.bottom, 36)
        .frame(maxWidth: .infinity)
        .background(
            .white
                .shadow(.drop(color: Color(hex: "4C5D9E").opacity(0.08), radius: 12, x: 0, y: -12))
        )
    }

    // MARK: - Actions

    private func clearAll() {
        withAnimation(.easeInOut(duration: 0.2)) {
            paymentMethod = .cash
            useBluChipBalance = false
            selectedCurrency = "INR"
            bookingState.paymentMethod = .cash
            bookingState.useBluChipBalance = false
            bookingState.selectedCurrency = "INR"
        }
    }

    private func handleSearchFlight() {
        bookingState.paymentMethod = paymentMethod
        bookingState.useBluChipBalance = useBluChipBalance
        bookingState.selectedCurrency = selectedCurrency
        navigateToSRP = true
    }

    // MARK: - Helpers

    private var passengerSummary: String {
        let total = bookingState.travellers.totalPassengers
        if total == 0 && !bookingState.selectedTravellerIDs.isEmpty {
            let count = bookingState.selectedTravellerIDs.count
            return count == 1 ? "1 Traveller" : "\(count) Travellers"
        }
        let adults = bookingState.travellers.adults
        if adults > 0 && bookingState.travellers.totalPassengers == adults {
            return adults == 1 ? "1 Adult" : "\(adults) Adults"
        }
        if total > 0 {
            return total == 1 ? "1 Passenger" : "\(total) Passengers"
        }
        return "2 Adults"
    }

    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: bookingState.bluChipBalance)) ?? "67,440"
    }

    private func shortDateString(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEE, dd MMM"
        return formatter.string(from: date)
    }
}

#Preview {
    let state = BookingState()
    state.origin = IndiGoAirports.domestic.first { $0.code == "DEL" }
    state.destination = IndiGoAirports.domestic.first { $0.code == "BOM" }
    state.selectedDate = Date()
    state.returnDate = Calendar.current.date(byAdding: .day, value: 4, to: Date())
    state.travellers = TravellerCount(adults: 2, seniorCitizens: 0, children: 0, infants: 0)
    return NavigationStack {
        PayModeView()
            .environmentObject(state)
    }
}
