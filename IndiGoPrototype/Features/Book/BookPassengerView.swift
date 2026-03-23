//
//  BookPassengerView.swift
//  IndiGoPrototype
//
//  Book step 3 – Passenger selection.
//  Figma: node 3:8168 (full page), 3:8181 (From/To), 3:8218 (When),
//         3:8228 (Who card), 969:10846 (saved travellers), 3:8268 (counters),
//         3:8343 (discount chips).
//

import SwiftUI

struct BookPassengerView: View {
    var isEditMode = false

    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var adults = 0
    @State private var seniorCitizens = 0
    @State private var children = 0
    @State private var infants = 0
    @State private var selectedTravellerIDs: Set<String> = []
    @State private var selectedDiscounts: Set<DiscountCategory> = []

    @State private var cardAppeared = false
    @State private var whoAppeared = false
    @State private var navigateToPayMode = false
    @State private var editLocation = false
    @State private var editDate = false

    private var hasPassengers: Bool {
        adults + seniorCitizens + children + infants > 0 || !selectedTravellerIDs.isEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            backgroundGradient

            VStack(spacing: 0) {
                stickyHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        Button { editLocation = true } label: {
                            fromToSummaryCard
                        }
                        .buttonStyle(.plain)
                        .opacity(cardAppeared ? 1 : 0)
                        .offset(y: cardAppeared ? 0 : 20)

                        Button { editDate = true } label: {
                            whenSummaryCard
                        }
                        .buttonStyle(.plain)
                        .opacity(cardAppeared ? 1 : 0)
                        .offset(y: cardAppeared ? 0 : 20)

                        whoCard
                            .opacity(whoAppeared ? 1 : 0)
                            .offset(y: whoAppeared ? 0 : 30)
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
        .utInstrumented(screenId: "BookPassengerView")
        #endif
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToPayMode) {
            PayModeView()
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editLocation) {
            BookLocationView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .navigationDestination(isPresented: $editDate) {
            BookDateView(isEditMode: true)
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            syncFromBookingState()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.05)) {
                cardAppeared = true
            }
            withAnimation(.spring(response: 0.55, dampingFraction: 0.85).delay(0.2)) {
                whoAppeared = true
            }
        }
    }

    private func syncFromBookingState() {
        adults = bookingState.travellers.adults
        seniorCitizens = bookingState.travellers.seniorCitizens
        children = bookingState.travellers.children
        infants = bookingState.travellers.infants
        selectedTravellerIDs = bookingState.selectedTravellerIDs
        selectedDiscounts = bookingState.selectedDiscountCategories
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

    // MARK: - From/To Summary Card (Figma node 3:8181)

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

    // MARK: - When Summary Card (Figma node 3:8218)

    private var whenSummaryCard: some View {
        HStack {
            HStack(spacing: 8) {
                Image(systemName: "calendar")
                    .font(.system(size: 14))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text("When")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }

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

    // MARK: - Who Card (Figma node 3:8228)

    private var whoCard: some View {
        VStack(spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "person.crop.circle")
                    .font(.system(size: 14))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text("Who are travelling?")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
            }
            .frame(maxWidth: .infinity)

            VStack(alignment: .leading, spacing: 16) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Existing passenger from History")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)

                    savedTravellersRow
                }

                passengerCounters

                VStack(alignment: .leading, spacing: 8) {
                    Text("Passenger Cohort Offers")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(IndiGoColors.forYouTextPrimary)

                    discountChips
                }
            }
            .padding(.horizontal, 12)
        }
        .padding(.vertical, 12)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(IndiGoColors.secondaryBright, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    // MARK: - Saved Travellers (Figma node 969:10846)

    private var savedTravellersRow: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(SavedTraveller.sampleData) { traveller in
                    travellerCard(traveller)
                }
            }
            .padding(4)
        }
        .background(IndiGoColors.secondaryLight)
        .clipShape(
            UnevenRoundedRectangle(
                topLeadingRadius: 10,
                bottomLeadingRadius: 10
            )
        )
    }

    private func travellerCard(_ traveller: SavedTraveller) -> some View {
        let isSelected = selectedTravellerIDs.contains(traveller.id)

        return Button(action: { toggleTraveller(traveller) }) {
            HStack(spacing: 4) {
                VStack(alignment: .leading, spacing: 0) {
                    Text(traveller.name)
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .lineLimit(1)

                    Text(traveller.category)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                        .lineLimit(1)
                }

                ZStack {
                    RoundedRectangle(cornerRadius: 4)
                        .strokeBorder(
                            isSelected ? IndiGoColors.primaryMain : Color(hex: "9BA4B8"),
                            lineWidth: 1.5
                        )
                        .frame(width: 20, height: 20)

                    if isSelected {
                        Image(systemName: "checkmark")
                            .font(.system(size: 11, weight: .bold))
                            .foregroundStyle(IndiGoColors.primaryMain)
                    }
                }
            }
            .padding(.horizontal, 8)
            .frame(height: 48)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(
                        isSelected ? IndiGoColors.secondaryBright : IndiGoColors.secondaryMedium,
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Passenger Counters (Figma node 3:8268)

    private var passengerCounters: some View {
        VStack(spacing: 0) {
            counterRow(
                title: "Adult",
                subtitle: "(12 years - 59 years)",
                count: $adults
            )

            counterRow(
                title: "Senior Citizen",
                subtitle: "(60+ years)",
                count: $seniorCitizens
            )

            counterRow(
                title: "Children",
                subtitle: "(2 years - 12 years)",
                count: $children
            )

            infantRow
        }
    }

    private func counterRow(title: String, subtitle: String, count: Binding<Int>) -> some View {
        HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text(subtitle)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Spacer()

            stepperControl(count: count)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(IndiGoColors.secondaryMedium)
                .frame(height: 1)
        }
    }

    private var infantRow: some View {
        HStack {
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text("Infant")
                        .font(IndiGoFonts.bodyMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)

                    Text("(3 days - 2 years)")
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                }

                Text("One adult one infant, max 4 infants allowed")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }

            Spacer()

            stepperControl(count: $infants)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(IndiGoColors.secondaryMedium)
                .frame(height: 1)
        }
    }

    private func stepperControl(count: Binding<Int>) -> some View {
        let hasValue = count.wrappedValue > 0

        return HStack(spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    if count.wrappedValue > 0 { count.wrappedValue -= 1 }
                    syncToBookingState()
                }
            }) {
                Image(systemName: "minus.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(
                        count.wrappedValue > 0
                            ? IndiGoColors.primaryMain
                            : Color(hex: "9BA4B8")
                    )
            }
            .buttonStyle(.plain)
            .disabled(count.wrappedValue == 0)

            Text("\(count.wrappedValue)")
                .font(IndiGoFonts.bodyMedium())
                .foregroundStyle(IndiGoColors.primaryMain)
                .frame(width: 32)
                .multilineTextAlignment(.center)

            Button(action: {
                withAnimation(.easeInOut(duration: 0.15)) {
                    count.wrappedValue += 1
                    syncToBookingState()
                }
            }) {
                Image(systemName: "plus.circle")
                    .font(.system(size: 18))
                    .foregroundStyle(IndiGoColors.primaryMain)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 4)
        .frame(width: 92, height: 28)
        .background(hasValue ? IndiGoColors.secondaryLight : .white)
        .clipShape(Capsule())
        .overlay(
            Capsule()
                .strokeBorder(IndiGoColors.secondaryMain, lineWidth: 1)
        )
    }

    // MARK: - Discount Chips (Figma node 3:8343)

    private var discountChips: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                ForEach(DiscountCategory.allCases) { category in
                    discountChip(category)
                }
            }
            .padding(.vertical, 4)
        }
    }

    private func discountChip(_ category: DiscountCategory) -> some View {
        let isSelected = selectedDiscounts.contains(category)

        return Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                if isSelected {
                    selectedDiscounts.remove(category)
                } else {
                    selectedDiscounts.insert(category)
                }
                bookingState.selectedDiscountCategories = selectedDiscounts
            }
        }) {
            Text(category.rawValue)
                .font(IndiGoFonts.bodyExtraSmallMedium())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? IndiGoColors.secondaryLight : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .strokeBorder(
                            isSelected ? IndiGoColors.secondaryMain : IndiGoColors.secondaryDeepGrey,
                            lineWidth: 1
                        )
                )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Bottom Bar

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
                    .foregroundStyle(hasPassengers ? .white : Color(hex: "9BA4B8"))
                    .frame(width: 94, height: 36)
                    .background(
                        hasPassengers
                            ? IndiGoColors.primaryMain
                            : Color(hex: "BCC2CF")
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .disabled(!hasPassengers)
            .animation(.easeInOut(duration: 0.2), value: hasPassengers)
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

    private func toggleTraveller(_ traveller: SavedTraveller) {
        withAnimation(.easeInOut(duration: 0.2)) {
            if selectedTravellerIDs.contains(traveller.id) {
                selectedTravellerIDs.remove(traveller.id)
            } else {
                selectedTravellerIDs.insert(traveller.id)
            }
            bookingState.selectedTravellerIDs = selectedTravellerIDs

            if traveller.category.lowercased().contains("senior") || traveller.category.lowercased().contains("child") {
                autoSelectDiscountChip(for: traveller)
            }
        }
    }

    private func autoSelectDiscountChip(for traveller: SavedTraveller) {
        if traveller.category.lowercased().contains("senior") {
            selectedDiscounts.insert(.seniorCitizen)
        }
        bookingState.selectedDiscountCategories = selectedDiscounts
    }

    private func syncToBookingState() {
        bookingState.travellers = TravellerCount(
            adults: adults,
            seniorCitizens: seniorCitizens,
            children: children,
            infants: infants
        )
    }

    private func clearAll() {
        withAnimation(.easeInOut(duration: 0.2)) {
            adults = 0
            seniorCitizens = 0
            children = 0
            infants = 0
            selectedTravellerIDs = []
            selectedDiscounts = []
            syncToBookingState()
            bookingState.selectedTravellerIDs = []
            bookingState.selectedDiscountCategories = []
        }
    }

    private func handleNext() {
        guard hasPassengers else { return }
        syncToBookingState()
        bookingState.selectedTravellerIDs = selectedTravellerIDs
        bookingState.selectedDiscountCategories = selectedDiscounts
        if isEditMode {
            dismiss()
        } else {
            navigateToPayMode = true
        }
    }

    // MARK: - Helpers

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
    return NavigationStack {
        BookPassengerView()
            .environmentObject(state)
    }
}
