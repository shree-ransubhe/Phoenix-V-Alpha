//
//  FlightsPassengerPicker.swift
//  IndiGoPrototype
//
//  Passenger + special fare picker for the Flights tab search widget.
//  Reuses counter/discount logic from BookPassengerView but dismisses
//  back to FlightsView after confirmation.
//
//  Figma: 5658-61323 (passenger section)
//

import SwiftUI

struct FlightsPassengerPicker: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var adults = 1
    @State private var seniorCitizens = 0
    @State private var children = 0
    @State private var infants = 0
    @State private var selectedTravellerIDs: Set<String> = []
    @State private var selectedDiscounts: Set<DiscountCategory> = []

    @State private var cardAppeared = false

    private var hasPassengers: Bool {
        adults + seniorCitizens + children + infants > 0 || !selectedTravellerIDs.isEmpty
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "D1EFFF"), .white]),
                startPoint: .top, endPoint: .center
            ).ignoresSafeArea()

            VStack(spacing: 0) {
                stickyHeader

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 12) {
                        whoCard
                            .opacity(cardAppeared ? 1 : 0)
                            .offset(y: cardAppeared ? 0 : 20)
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
        .navigationBarHidden(true)
        .onAppear {
            syncFromBookingState()
            withAnimation(.spring(response: 0.5, dampingFraction: 0.85).delay(0.05)) {
                cardAppeared = true
            }
        }
    }

    private func syncFromBookingState() {
        adults = max(bookingState.travellers.adults, 1)
        seniorCitizens = bookingState.travellers.seniorCitizens
        children = bookingState.travellers.children
        infants = bookingState.travellers.infants
        selectedTravellerIDs = bookingState.selectedTravellerIDs
        selectedDiscounts = bookingState.selectedDiscountCategories
    }

    // MARK: - Header

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 54)
            HeaderBarView(
                title: "Passengers",
                titleFont: .custom("BauhausStd-Medium", size: 20),
                onBack: { dismiss() }
            ) {
                SixEskaiButton()
            }
        }
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    // MARK: - Who Card

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

    // MARK: - Saved Travellers

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
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 10, bottomLeadingRadius: 10))
    }

    private func travellerCard(_ traveller: SavedTraveller) -> some View {
        let isSelected = selectedTravellerIDs.contains(traveller.id)
        return Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                if isSelected { selectedTravellerIDs.remove(traveller.id) }
                else { selectedTravellerIDs.insert(traveller.id) }
                bookingState.selectedTravellerIDs = selectedTravellerIDs
            }
        } label: {
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
                        .strokeBorder(isSelected ? IndiGoColors.primaryMain : Color(hex: "9BA4B8"), lineWidth: 1.5)
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
                    .strokeBorder(isSelected ? IndiGoColors.secondaryBright : IndiGoColors.secondaryMedium, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
    }

    // MARK: - Counters

    private var passengerCounters: some View {
        VStack(spacing: 0) {
            counterRow(title: "Adult", subtitle: "(12 years - 59 years)", count: $adults)
            counterRow(title: "Senior Citizen", subtitle: "(60+ years)", count: $seniorCitizens)
            counterRow(title: "Children", subtitle: "(2 years - 12 years)", count: $children)
            counterRow(title: "Infant", subtitle: "(3 days - 2 years)", count: $infants)
        }
    }

    private func counterRow(title: String, subtitle: String, count: Binding<Int>) -> some View {
        let hasValue = count.wrappedValue > 0
        return HStack {
            VStack(alignment: .leading, spacing: 0) {
                Text(title)
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                Text(subtitle)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
            }
            Spacer()
            HStack(spacing: 0) {
                Button {
                    HapticManager.softImpact(intensity: 0.4)
                    withAnimation(.easeInOut(duration: 0.15)) {
                        if count.wrappedValue > 0 { count.wrappedValue -= 1 }
                        syncToBookingState()
                    }
                } label: {
                    Image(systemName: "minus.circle")
                        .font(.system(size: 18))
                        .foregroundStyle(count.wrappedValue > 0 ? IndiGoColors.primaryMain : Color(hex: "9BA4B8"))
                }
                .buttonStyle(.plain)
                .disabled(count.wrappedValue == 0)

                Text("\(count.wrappedValue)")
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .frame(width: 32)
                    .multilineTextAlignment(.center)

                Button {
                    HapticManager.softImpact(intensity: 0.6)
                    withAnimation(.easeInOut(duration: 0.15)) {
                        count.wrappedValue += 1
                        syncToBookingState()
                    }
                } label: {
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
            .overlay(Capsule().strokeBorder(IndiGoColors.secondaryMain, lineWidth: 1))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 12)
        .overlay(alignment: .bottom) {
            Rectangle().fill(IndiGoColors.secondaryMedium).frame(height: 1)
        }
    }

    // MARK: - Discount Chips

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
        return Button {
            HapticManager.selection()
            withAnimation(.easeInOut(duration: 0.2)) {
                if isSelected { selectedDiscounts.remove(category) }
                else { selectedDiscounts.insert(category) }
                bookingState.selectedDiscountCategories = selectedDiscounts
            }
        } label: {
            Text(category.rawValue)
                .font(IndiGoFonts.bodyExtraSmallMedium())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? IndiGoColors.secondaryLight : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule().strokeBorder(
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
            Button {
                HapticManager.lightImpact()
                withAnimation(.easeInOut(duration: 0.2)) {
                    adults = 1; seniorCitizens = 0; children = 0; infants = 0
                    selectedTravellerIDs = []; selectedDiscounts = []
                    syncToBookingState()
                    bookingState.selectedTravellerIDs = []
                    bookingState.selectedDiscountCategories = []
                }
            } label: {
                Text("Clear all")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .underline()
                    .frame(width: 94, height: 36)
            }
            .buttonStyle(.plain)

            Button {
                guard hasPassengers else { return }
                HapticManager.mediumImpact()
                syncToBookingState()
                bookingState.selectedTravellerIDs = selectedTravellerIDs
                bookingState.selectedDiscountCategories = selectedDiscounts
                dismiss()
            } label: {
                Text("Done")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(hasPassengers ? .white : Color(hex: "9BA4B8"))
                    .frame(width: 94, height: 36)
                    .background(hasPassengers ? IndiGoColors.primaryMain : Color(hex: "BCC2CF"))
                    .clipShape(RoundedRectangle(cornerRadius: 18))
            }
            .buttonStyle(.plain)
            .disabled(!hasPassengers)
        }
        .padding(.top, 16)
        .padding(.bottom, 36)
        .padding(.horizontal, 46)
        .frame(maxWidth: .infinity)
        .background(
            .white.shadow(.drop(color: Color(hex: "4C5D9E").opacity(0.08), radius: 12, x: 0, y: -12))
        )
    }

    // MARK: - Sync

    private func syncToBookingState() {
        bookingState.travellers = TravellerCount(
            adults: adults, seniorCitizens: seniorCitizens,
            children: children, infants: infants
        )
    }
}
