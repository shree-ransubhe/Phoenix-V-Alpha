//
//  FlightsLocationPicker.swift
//  IndiGoPrototype
//
//  Location picker for the Flights tab search widget.
//  Reuses airport search logic from BookLocationView but dismisses back
//  to FlightsView after selection instead of navigating forward.
//
//  Figma: 5658-61299 (location selector section)
//

import SwiftUI

struct FlightsLocationPicker: View {
    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var fromText = ""
    @State private var toText = ""
    @State private var activeField: LocationField = .to
    @State private var selectedFrom: City?
    @State private var selectedTo: City?

    @State private var cardAppeared = false
    @State private var headerAppeared = false
    @State private var rowsRevealed = false

    @FocusState private var toFieldFocused: Bool
    @FocusState private var fromFieldFocused: Bool

    enum LocationField { case from, to }

    private var filteredCities: [City] {
        let query = (activeField == .from ? fromText : toText)
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .lowercased()

        let base = query.isEmpty
            ? IndiGoAirports.popularDomestic
            : IndiGoAirports.all.filter { city in
                city.name.lowercased().contains(query) ||
                city.code.lowercased().contains(query) ||
                city.airportName.lowercased().contains(query) ||
                city.country.lowercased().contains(query)
            }

        let excludeCode = activeField == .from ? selectedTo?.code : selectedFrom?.code
        guard let exclude = excludeCode else { return base }
        return base.filter { $0.code != exclude }
    }

    var body: some View {
        ZStack(alignment: .top) {
            LinearGradient(
                gradient: Gradient(colors: [Color(hex: "D1EFFF"), .white]),
                startPoint: .top, endPoint: .center
            ).ignoresSafeArea()

            VStack(spacing: 0) {
                stickyHeader
                    .opacity(headerAppeared ? 1 : 0)
                    .offset(y: headerAppeared ? 0 : -20)

                locationCard
                    .padding(.top, 8)
                    .scaleEffect(cardAppeared ? 1 : 0.92)
                    .opacity(cardAppeared ? 1 : 0)
            }
        }
        .ignoresSafeArea(.container, edges: .top)
        .navigationBarHidden(true)
        .onAppear { playEntrance() }
    }

    // MARK: - Header

    private var stickyHeader: some View {
        VStack(spacing: 0) {
            Color.clear.frame(height: 54)
            HeaderBarView(
                title: "Flights",
                titleFont: .custom("BauhausStd-Medium", size: 20),
                onBack: { dismiss() }
            ) {
                SixEskaiButton()
            }
        }
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 16, bottomTrailingRadius: 16))
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    // MARK: - Location Card

    private var locationCard: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                headerRow
                fromToSection
                suggestedList
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(IndiGoColors.secondaryBright, lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    private var headerRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "airplane")
                .font(.system(size: 14))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
            Text("Where are you going?")
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
        .frame(maxWidth: .infinity)
    }

    private var fromToSection: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 2) {
                Text("From")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)

                TextField("City or airport", text: $fromText)
                    .font(IndiGoFonts.bodySmallMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .focused($fromFieldFocused)
                    .onTapGesture { activeField = .from }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(activeField == .from ? IndiGoColors.secondaryLight : .clear)
            )

            Button {
                HapticManager.selection()
                let temp = selectedFrom
                selectedFrom = selectedTo
                selectedTo = temp
                fromText = selectedFrom.map { "\($0.name),\($0.code)" } ?? ""
                toText = selectedTo.map { "\($0.name),\($0.code)" } ?? ""
                bookingState.origin = selectedFrom
                bookingState.destination = selectedTo
            } label: {
                Image(systemName: "arrow.left.arrow.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.secondaryBright)
                    .frame(width: 32, height: 32)
            }
            .buttonStyle(.plain)

            VStack(alignment: .trailing, spacing: 2) {
                Text("To")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)

                TextField("City or airport", text: $toText)
                    .font(IndiGoFonts.bodySmallMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .multilineTextAlignment(.trailing)
                    .focused($toFieldFocused)
                    .onTapGesture { activeField = .to }
            }
            .padding(10)
            .frame(maxWidth: .infinity, alignment: .trailing)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(activeField == .to ? IndiGoColors.secondaryLight : .clear)
            )
        }
        .padding(8)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(IndiGoColors.secondaryMain, lineWidth: 1)
        )
    }

    // MARK: - Suggestions

    private var suggestedList: some View {
        VStack(alignment: .leading, spacing: 0) {
            if !rowsRevealed {
                Color.clear.frame(height: 80)
            } else {
                Text(filteredCities.isEmpty ? "No results" : "Suggested")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .padding(.bottom, 4)

                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: 0) {
                        ForEach(filteredCities.prefix(12)) { city in
                            cityRow(city)
                        }
                    }
                }
                .frame(maxHeight: 340)
            }
        }
    }

    private func cityRow(_ city: City) -> some View {
        Button {
            HapticManager.selection()
            selectCity(city)
        } label: {
            HStack(spacing: 10) {
                Image(systemName: "airplane")
                    .font(.system(size: 12))
                    .foregroundStyle(IndiGoColors.textTertiaryFull)
                    .frame(width: 24, height: 24)

                VStack(alignment: .leading, spacing: 1) {
                    HStack(spacing: 6) {
                        Text(city.name)
                            .font(IndiGoFonts.bodySmallMedium())
                            .foregroundStyle(IndiGoColors.forYouTextPrimary)
                        Text(city.code)
                            .font(IndiGoFonts.bodyExtraSmall())
                            .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    }
                    Text(city.airportName)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                        .lineLimit(1)
                }

                Spacer()

                if !city.isDomestic {
                    Text(city.country)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextTertiary)
                }
            }
            .padding(.vertical, 10)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .overlay(alignment: .bottom) {
            Rectangle()
                .fill(IndiGoColors.secondaryMedium)
                .frame(height: 0.5)
        }
    }

    // MARK: - Selection

    private func selectCity(_ city: City) {
        if activeField == .from {
            selectedFrom = city
            fromText = "\(city.name),\(city.code)"
            bookingState.origin = city
            activeField = .to
            toFieldFocused = true
        } else {
            selectedTo = city
            toText = "\(city.name),\(city.code)"
            bookingState.destination = city
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                dismiss()
            }
        }
    }

    // MARK: - Entrance

    private func playEntrance() {
        let origin = bookingState.origin ?? IndiGoAirports.domestic.first { $0.code == "DEL" }!
        selectedFrom = origin
        fromText = "\(origin.name),\(origin.code)"
        bookingState.origin = origin

        if let dest = bookingState.destination {
            selectedTo = dest
            toText = "\(dest.name),\(dest.code)"
        }

        activeField = .to

        withAnimation(.spring(response: 0.45, dampingFraction: 0.82).delay(0.05)) {
            headerAppeared = true
        }
        withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.12)) {
            cardAppeared = true
        }
        withAnimation(.easeOut(duration: 0.4).delay(0.35)) {
            rowsRevealed = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            toFieldFocused = true
        }
    }
}
