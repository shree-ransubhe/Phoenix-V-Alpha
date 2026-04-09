//
//  FlightsView.swift
//  IndiGoPrototype
//
//  Flights tab – single-page search widget for Alpha 6.1.
//  Figma: 5658-60439 (full page), 5658-60440 (header), 5658-61110 (tabs),
//         5658-61298 (core form), 5658-61299 (location), 5658-61311 (dates),
//         5658-61323 (passenger), 5658-61445 (pay with), 5658-61472 (promo).
//
//  5-click journey:
//    1. Tap Flights tab
//    2. Tap destination → opens BookLocationView(isEditMode: true)
//    3. Tap date → opens BookDateView(isEditMode: true)
//    4. Tap passenger → opens BookPassengerView(isEditMode: true)
//    5. Tap "Search Flight" → SRPView
//

import SwiftUI

struct FlightsView: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.alphaTheme) private var theme

    @State private var navigateToSRP = false
    @State private var editLocation = false
    @State private var editDate = false
    @State private var editPassengers = false

    @State private var paymentMethod: BookingState.PaymentMethod = .cash
    @State private var useBluChipBalance = false
    @State private var selectedCurrency = "INR"
    @State private var showCurrencyPicker = false
    @State private var promoCode = ""

    @State private var formAppeared = false

    private let currencies = ["INR", "USD", "EUR", "GBP", "AED", "SGD"]

    private let indigo12 = Color(hex: "000099").opacity(0.12)
    private let indigo24 = Color(hex: "000099").opacity(0.24)
    private let cardShadow = Color(hex: "000099").opacity(0.12)
    private let textBase = Color(hex: "25304B")
    private let textDarkGray = Color(hex: "4B5772")
    private let textDisabled = Color(hex: "9BA4B8")
    private let borderDeep = Color(hex: "E2EBF2")

    var body: some View {
        ZStack(alignment: .top) {
            theme.pageBackgroundColor.ignoresSafeArea()

            VStack(spacing: 0) {
                stickyHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 16) {
                        fromToCard
                        dateCard
                        passengerCard
                        payWithCard
                        promoCodeCard
                        searchButton
                    }
                    .padding(.horizontal, 16)
                    .padding(.top, 16)
                    .padding(.bottom, 40)
                    .opacity(formAppeared ? 1 : 0)
                    .offset(y: formAppeared ? 0 : 20)
                }
            }
        }
        .navigationDestination(isPresented: $navigateToSRP) {
            SRPView()
                .environmentObject(bookingState)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editLocation) {
            FlightsLocationPicker()
                .environmentObject(bookingState)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editDate) {
            BookDateView(isEditMode: true)
                .environmentObject(bookingState)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editPassengers) {
            FlightsPassengerPicker()
                .environmentObject(bookingState)
                .navigationBarBackButtonHidden()
        }
        .onAppear(perform: initializeDefaults)
        .onChange(of: editLocation) { _, active in
            bookingState.isInBookingFlow = active
        }
        .onChange(of: editDate) { _, active in
            bookingState.isInBookingFlow = active
        }
        .onChange(of: editPassengers) { _, active in
            bookingState.isInBookingFlow = active
        }
        .onChange(of: navigateToSRP) { _, active in
            bookingState.isInBookingFlow = active
        }
    }

    // MARK: - Initialization

    private func initializeDefaults() {
        if bookingState.origin == nil {
            bookingState.origin = IndiGoAirports.domestic.first { $0.code == "DEL" }
        }
        if bookingState.selectedDate == nil {
            bookingState.selectedDate = Date()
        }
        if bookingState.travellers.totalPassengers == 0 && bookingState.selectedTravellerIDs.isEmpty {
            bookingState.travellers = TravellerCount(adults: 1, seniorCitizens: 0, children: 0, infants: 0)
        }

        paymentMethod = bookingState.paymentMethod
        useBluChipBalance = bookingState.useBluChipBalance
        selectedCurrency = bookingState.selectedCurrency

        withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.05)) {
            formAppeared = true
        }
    }

    // MARK: - Sticky Header (Figma 5658-60440)

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 54)

            HStack(spacing: 12) {
                Color.clear.frame(width: 53, height: 20)

                Spacer()

                Text("Flights")
                    .font(.custom("BauhausStd-Medium", size: 20))
                    .foregroundStyle(textBase)

                Spacer()

                SixEskaiButton()
                    .frame(width: 53, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 12)

            tripTypeSelector
        }
        .background(.ultraThinMaterial)
        .background(Color.white.opacity(0.12))
    }

    // MARK: - Trip Type Selector (Figma 5658-61110)

    private var tripTypeSelector: some View {
        HStack(spacing: 0) {
            tripTab("One way", type: .oneWay)
            tripTab("Round Trip", type: .returnTrip)
        }
    }

    private func tripTab(_ label: String, type: BookingState.TripType) -> some View {
        let isSelected = bookingState.tripType == type

        return Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                bookingState.tripType = type
                if type == .oneWay {
                    bookingState.returnDate = nil
                }
            }
        } label: {
            VStack(spacing: 0) {
                Text(label)
                    .font(.custom("Poppins-Medium", size: 14))
                    .foregroundStyle(isSelected ? textBase : IndiGoColors.textIndigoBlue)
                    .frame(maxWidth: .infinity)
                    .frame(height: 44)

                Rectangle()
                    .fill(isSelected ? textBase : indigo12)
                    .frame(height: isSelected ? 2 : 1)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - From/To Card (Figma 5658-61299)

    private var fromToCard: some View {
        Button { editLocation = true } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("From")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(textDarkGray)

                    Text(bookingState.origin?.code ?? "DEL")
                        .font(.custom("BauhausStd-Medium", size: 36))
                        .foregroundStyle(IndiGoColors.textIndigoBlue)

                    Text(bookingState.origin?.name ?? "Delhi")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(textDarkGray)
                }

                VStack(spacing: 4) {
                    borderDeep
                        .frame(width: 1.5)
                        .clipShape(Capsule())

                    Button {
                        HapticManager.selection()
                        swapOriginDestination()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .font(.system(size: 14, weight: .medium))
                            .foregroundStyle(IndiGoColors.secondaryBright)
                            .rotationEffect(.degrees(90))
                            .frame(width: 24, height: 24)
                    }
                    .buttonStyle(.plain)

                    borderDeep
                        .frame(width: 1.5)
                        .clipShape(Capsule())
                }
                .frame(height: 70)

                VStack(alignment: .trailing, spacing: 0) {
                    Text("Where")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(textDarkGray)

                    if let dest = bookingState.destination {
                        Text(dest.code)
                            .font(.custom("BauhausStd-Medium", size: 36))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)

                        Text(dest.name)
                            .font(.custom("Poppins-Regular", size: 10))
                            .foregroundStyle(textDarkGray)
                    } else {
                        Text("Select")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundStyle(textDisabled)
                        Text("Destination")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundStyle(textDisabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(indigo12, lineWidth: 1)
            )
            .shadow(color: cardShadow, radius: 5, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Date Card (Figma 5658-61311)

    private var dateCard: some View {
        Button { editDate = true } label: {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundStyle(textBase)
                        Text("Departure")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundStyle(textBase)
                    }

                    if let date = bookingState.selectedDate {
                        Text(formatDate(date))
                            .font(.custom("BauhausStd-Medium", size: 16))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)
                    } else {
                        Text("Select Date")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundStyle(textDisabled)
                    }
                }

                borderDeep.frame(width: 1.5)
                    .clipShape(Capsule())

                VStack(alignment: .trailing, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "calendar")
                            .font(.system(size: 12))
                            .foregroundStyle(textBase)
                        Text(bookingState.returnDate != nil ? "Return journey" : "Return")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundStyle(textBase)
                    }

                    if let date = bookingState.returnDate {
                        Text(formatDate(date))
                            .font(.custom("BauhausStd-Medium", size: 16))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)
                    } else {
                        Text("Select Date")
                            .font(.custom("Poppins-Medium", size: 14))
                            .foregroundStyle(textDisabled)
                    }
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(indigo12, lineWidth: 1)
            )
            .shadow(color: cardShadow, radius: 5, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Passenger Card (Figma 5658-61323)

    private var passengerCard: some View {
        Button { editPassengers = true } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "person.circle")
                            .font(.system(size: 12))
                            .foregroundStyle(textBase)
                        Text("Passenger + Special Fare")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundStyle(textBase)
                    }

                    Text(passengerSummary)
                        .font(.custom("BauhausStd-Medium", size: 16))
                        .foregroundStyle(IndiGoColors.textIndigoBlue)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(IndiGoColors.textIndigoBlue)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(indigo12, lineWidth: 1)
            )
            .shadow(color: cardShadow, radius: 5, x: 0, y: 0)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Pay With Card (Figma 5658-61445)

    private var payWithCard: some View {
        ZStack(alignment: .topTrailing) {
            VStack(spacing: 0) {
                payWithHeader

                Divider()
                    .background(indigo12)

                cashRow

                Divider()
                    .background(indigo12)

                bluChipRow
            }
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(indigo12, lineWidth: 1)
            )
            .shadow(color: cardShadow, radius: 5, x: 0, y: 0)

            if showCurrencyPicker {
                currencyDropdown
                    .zIndex(10)
            }
        }
    }

    private var payWithHeader: some View {
        HStack {
            HStack(spacing: 0) {
                Image(systemName: "indianrupeesign")
                    .font(.system(size: 12))
                    .foregroundStyle(textBase)
                Text(" Pay With")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(textBase)
            }

            Spacer()

            HStack(spacing: 0) {
                Text("Currency : ")
                    .font(.custom("Poppins-Regular", size: 12))
                    .foregroundStyle(textBase)

                Button {
                    withAnimation(.easeInOut(duration: 0.2)) {
                        showCurrencyPicker.toggle()
                    }
                } label: {
                    HStack(spacing: 4) {
                        Image(systemName: "indianrupeesign")
                            .font(.system(size: 11))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)
                        Text(selectedCurrency)
                            .font(.custom("Poppins-Medium", size: 12))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)
                        Image(systemName: "chevron.down")
                            .font(.system(size: 9, weight: .medium))
                            .foregroundStyle(IndiGoColors.textIndigoBlue)
                            .rotationEffect(.degrees(showCurrencyPicker ? 180 : 0))
                    }
                }
                .buttonStyle(.plain)
            }
        }
        .padding(16)
    }

    private var cashRow: some View {
        Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                paymentMethod = .cash
                useBluChipBalance = false
                bookingState.paymentMethod = .cash
                bookingState.useBluChipBalance = false
            }
        } label: {
            HStack(spacing: 8) {
                radioCircle(isSelected: paymentMethod == .cash && !useBluChipBalance)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Cash")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(IndiGoColors.textIndigoBlue)
                    Text("UPI, Credit Cards, Debit Cards, Net banking")
                        .font(.custom("Poppins-Regular", size: 10))
                        .foregroundStyle(textBase)
                }
            }
            .padding(16)
        }
        .buttonStyle(.plain)
    }

    private var bluChipRow: some View {
        Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                paymentMethod = .bluChip
                useBluChipBalance = true
                bookingState.paymentMethod = .bluChip
                bookingState.useBluChipBalance = true
            }
        } label: {
            HStack(spacing: 8) {
                radioCircle(isSelected: useBluChipBalance, isDark: true)

                VStack(alignment: .leading, spacing: 0) {
                    Text("Use IndiGo BluChip + Cash ")
                        .font(.custom("Poppins-Regular", size: 12))
                        .foregroundStyle(Color(hex: "EAF8FF"))

                    HStack(spacing: 4) {
                        Text("IndiGo BluChip balance:")
                            .font(.custom("Poppins-Regular", size: 12))
                            .foregroundStyle(Color(hex: "EAF8FF"))
                        Text(formattedBalance)
                            .font(.custom("Poppins-SemiBold", size: 12))
                            .foregroundStyle(Color(hex: "9CD9FF"))
                    }
                }

                Spacer()

                Image("IBC-coin")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 36, height: 36)
                    .clipShape(RoundedRectangle(cornerRadius: 6))
                    .saturation(0)
                    .opacity(0.7)
            }
            .padding(16)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(.black)
        }
        .buttonStyle(.plain)
    }

    private func radioCircle(isSelected: Bool, isDark: Bool = false) -> some View {
        ZStack {
            Circle()
                .strokeBorder(
                    isDark ? .white : (isSelected ? IndiGoColors.textIndigoBlue : textDisabled),
                    lineWidth: 2
                )
                .frame(width: 20, height: 20)
                .background(isDark ? Color.black : .white)
                .clipShape(Circle())

            if isSelected {
                Circle()
                    .fill(isDark ? .white : IndiGoColors.textIndigoBlue)
                    .frame(width: 8, height: 8)
            }
        }
    }

    private var currencyDropdown: some View {
        VStack(spacing: 0) {
            ForEach(currencies, id: \.self) { currency in
                Button {
                    HapticManager.selection()
                    withAnimation(.easeInOut(duration: 0.2)) {
                        selectedCurrency = currency
                        bookingState.selectedCurrency = currency
                        showCurrencyPicker = false
                    }
                } label: {
                    HStack(spacing: 8) {
                        Text(symbolFor(currency))
                            .font(.system(size: 13, weight: .medium))
                            .foregroundStyle(
                                currency == selectedCurrency ? IndiGoColors.primaryMain : IndiGoColors.forYouTextSecondary
                            )
                            .frame(width: 24, alignment: .center)

                        Text(currency)
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(
                                currency == selectedCurrency ? IndiGoColors.primaryMain : IndiGoColors.forYouTextPrimary
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
                    Divider().padding(.horizontal, 10)
                }
            }
        }
        .padding(.vertical, 4)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .shadow(color: .black.opacity(0.15), radius: 12, x: 0, y: 6)
        .frame(width: 150)
        .offset(x: -16, y: 48)
        .transition(.opacity.combined(with: .scale(scale: 0.95, anchor: .topTrailing)))
    }

    // MARK: - Promo Code (Figma 5658-61472)

    private var promoCodeCard: some View {
        HStack(spacing: 0) {
            TextField("Add promo code", text: $promoCode)
                .font(.custom("Poppins-Regular", size: 12))
                .foregroundStyle(textBase)
                .padding(.leading, 16)
                .frame(maxWidth: .infinity)

            Rectangle()
                .fill(indigo12)
                .frame(width: 1)

            Button {
                HapticManager.selection()
            } label: {
                Text("Apply")
                    .font(.custom("Poppins-Medium", size: 12))
                    .foregroundStyle(IndiGoColors.textIndigoBlue)
                    .frame(width: 64, height: 32)
            }
            .buttonStyle(.plain)
        }
        .frame(height: 40)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .overlay(
            RoundedRectangle(cornerRadius: 8)
                .strokeBorder(indigo24, lineWidth: 1)
        )
    }

    // MARK: - Search Button

    private var searchButton: some View {
        Button(action: handleSearch) {
            Text("Search Flight")
                .font(.custom("Poppins-SemiBold", size: 14))
                .foregroundStyle(.white)
                .frame(width: 125, height: 40)
                .background(IndiGoColors.textIndigoBlue)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
        .buttonStyle(.plain)
        .padding(.top, 8)
    }

    // MARK: - Actions

    private func swapOriginDestination() {
        let temp = bookingState.origin
        bookingState.origin = bookingState.destination
        bookingState.destination = temp
    }

    private func handleSearch() {
        HapticManager.heavyImpact()
        bookingState.paymentMethod = paymentMethod
        bookingState.useBluChipBalance = useBluChipBalance
        bookingState.selectedCurrency = selectedCurrency
        #if UT_VARIANT
        UTTrackingService.shared.markJourneyComplete()
        #endif
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
        if adults > 0 && total == adults {
            return adults == 1 ? "1 Adult" : "\(adults) Adults"
        }
        if total > 0 {
            return total == 1 ? "1 Passenger" : "\(total) Passengers"
        }
        return "1 Adult"
    }

    private var formattedBalance: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 0
        return formatter.string(from: NSNumber(value: bookingState.bluChipBalance)) ?? "67,440"
    }

    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd MMMM"
        return formatter.string(from: date)
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
}

// MARK: - Preview

#Preview {
    let state = BookingState()
    state.origin = IndiGoAirports.domestic.first { $0.code == "DEL" }
    return NavigationStack {
        FlightsView()
            .environmentObject(state)
            .alphaTheme(Alpha61Theme())
    }
}
