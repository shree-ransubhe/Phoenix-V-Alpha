//
//  BookLocationView.swift
//  IndiGoPrototype
//
//  Book step 1 – Location selection with From/To fields, search, and suggestions.
//  Figma: node 3:7880 (book), 3:7894 (component 1844), 3:7883 (sticky header).
//

import SwiftUI

struct BookLocationView: View {
    var isEditMode = false

    @EnvironmentObject private var bookingState: BookingState
    @Environment(\.dismiss) private var dismiss

    @State private var fromText = ""
    @State private var toText = ""
    @State private var activeField: LocationField = .to
    @State private var selectedFrom: City?
    @State private var selectedTo: City?
    @State private var showMultiCity = false

    // Animation states
    @State private var cardAppeared = false
    @State private var headerAppeared = false
    @State private var rowsRevealed = false
    @State private var navigateToDate = false
    @State private var destinationConfirmed = false

    @FocusState private var toFieldFocused: Bool
    @FocusState private var fromFieldFocused: Bool

    enum LocationField {
        case from, to
    }

    // Hardcoded for prototype; replace with CLLocationManager-based lookup in production
    private static let defaultOrigin = IndiGoAirports.domestic.first { $0.code == "DEL" }!

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
            backgroundGradient

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
        #if UT_VARIANT
        .utInstrumented(screenId: "BookLocationView")
        #endif
        .navigationBarHidden(true)
        .navigationDestination(isPresented: $navigateToDate) {
            BookDateView()
                .navigationBarBackButtonHidden()
        }
        .onAppear {
            bookingState.isInBookingFlow = true
            playEntranceAnimation()
        }
    }

    private func playEntranceAnimation() {
        let origin = bookingState.origin ?? Self.defaultOrigin
        selectedFrom = origin
        fromText = "\(origin.name),\(origin.code)"
        bookingState.origin = origin
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

    // MARK: - Background

    private var backgroundGradient: some View {
        LinearGradient(
            gradient: Gradient(colors: [Color(hex: "D1EFFF"), .white]),
            startPoint: .top,
            endPoint: .center
        )
        .ignoresSafeArea()
    }

    // MARK: - Sticky Header (Figma node 3:7883)

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

    // MARK: - Location Card (Figma node 3:7894)

    private var locationCard: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 12) {
                headerRow
                fromToSection
                suggestedLocationsList
            }
            .padding(12)
        }
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .strokeBorder(
                    destinationConfirmed
                        ? IndiGoColors.primaryMain.opacity(0.6)
                        : IndiGoColors.secondaryBright,
                    lineWidth: destinationConfirmed ? 2 : 1
                )
        )
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
        .padding(.horizontal, 15)
    }

    // MARK: - "Where will you IndiGo Today?"

    private var headerRow: some View {
        HStack(spacing: 8) {
            Image(systemName: "airplane.departure")
                .font(.system(size: 12))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
                .frame(width: 16, height: 16)

            Text("Where will you IndiGo Today?")
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)
        }
    }

    // MARK: - From/To Section with route indicator

    private var fromToSection: some View {
        HStack(alignment: .bottom, spacing: 4) {
            routeIndicator
            inputFields
            addStopButton
        }
    }

    private var routeIndicator: some View {
        VStack(spacing: 3) {
            Circle()
                .fill(IndiGoColors.secondaryMain)
                .frame(width: 6, height: 6)

            Rectangle()
                .fill(IndiGoColors.secondaryMain)
                .frame(width: 1, height: 44)

            Rectangle()
                .fill(IndiGoColors.primaryMain)
                .frame(width: 6, height: 6)
        }
        .frame(width: 18, height: 95)
        .opacity(0.95)
    }

    private var inputFields: some View {
        VStack(spacing: 0) {
            fromField
            toField
        }
        .frame(maxWidth: .infinity)
    }

    // MARK: - From Field

    private var fromField: some View {
        let isActive = activeField == .from && selectedFrom == nil
        let isFilled = selectedFrom != nil

        return VStack(alignment: .leading, spacing: 0) {
            if let city = selectedFrom {
                Text("\(city.name),\(city.code)")
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .lineLimit(1)

                Text(city.airportName)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            } else {
                HStack(spacing: 0) {
                    TextField("From", text: $fromText)
                        .font(IndiGoFonts.bodyMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .tint(IndiGoColors.primaryMain)
                        .focused($fromFieldFocused)
                        .onChange(of: fromFieldFocused) { _, focused in
                            if focused { activeField = .from }
                        }

                    if isActive && !fromText.isEmpty {
                        blinkingCursor
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 48, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isActive ? IndiGoColors.secondaryLight : .white)
        .clipShape(UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8))
        .overlay(
            UnevenRoundedRectangle(topLeadingRadius: 8, topTrailingRadius: 8)
                .strokeBorder(
                    isActive ? IndiGoColors.secondaryMain : IndiGoColors.secondaryMedium,
                    lineWidth: 1
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if isFilled {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedFrom = nil
                    fromText = ""
                    activeField = .from
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    fromFieldFocused = true
                }
            }
        }
    }

    // MARK: - To Field

    private var toField: some View {
        let isActive = activeField == .to && selectedTo == nil
        let isFilled = selectedTo != nil

        return VStack(alignment: .leading, spacing: 0) {
            if let city = selectedTo {
                Text("\(city.name),\(city.code)")
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .lineLimit(1)

                Text(city.airportName)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .lineLimit(1)
                    .truncationMode(.tail)
            } else {
                HStack(spacing: 0) {
                    TextField("To", text: $toText)
                        .font(IndiGoFonts.bodyMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .tint(IndiGoColors.primaryMain)
                        .focused($toFieldFocused)
                        .onChange(of: toFieldFocused) { _, focused in
                            if focused { activeField = .to }
                        }

                    if isActive && !toText.isEmpty {
                        blinkingCursor
                    }
                }
            }
        }
        .padding(.horizontal, 10)
        .frame(height: 48, alignment: .leading)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(isActive ? IndiGoColors.secondaryLight : .white)
        .clipShape(UnevenRoundedRectangle(bottomLeadingRadius: 8, bottomTrailingRadius: 8))
        .overlay(
            UnevenRoundedRectangle(bottomLeadingRadius: 8, bottomTrailingRadius: 8)
                .strokeBorder(
                    isActive ? IndiGoColors.secondaryMain : IndiGoColors.secondaryMedium,
                    lineWidth: 1
                )
        )
        .contentShape(Rectangle())
        .onTapGesture {
            if isFilled {
                withAnimation(.easeInOut(duration: 0.25)) {
                    selectedTo = nil
                    toText = ""
                    activeField = .to
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    toFieldFocused = true
                }
            }
        }
    }

    private var blinkingCursor: some View {
        TimelineView(.periodic(from: .now, by: 0.6)) { timeline in
            let phase = Int(timeline.date.timeIntervalSinceReferenceDate / 0.6)
            Rectangle()
                .fill(IndiGoColors.primaryMain)
                .frame(width: 1.5, height: 15)
                .opacity(phase.isMultiple(of: 2) ? 1 : 0)
                .animation(.easeInOut(duration: 0.3), value: phase)
        }
    }

    // MARK: - Add Stop Button

    private var addStopButton: some View {
        Button(action: {
            HapticManager.lightImpact()
            showMultiCity.toggle()
        }) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(IndiGoColors.secondaryLight)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(IndiGoColors.secondaryMedium, lineWidth: 1)
                    )

                Image(systemName: "plus")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundStyle(IndiGoColors.primaryMain)
            }
            .frame(width: 32, height: 32)
        }
        .buttonStyle(.plain)
    }

    // MARK: - Suggested Locations List

    private var suggestedLocationsList: some View {
        VStack(alignment: .leading, spacing: 8) {
            Rectangle()
                .fill(IndiGoColors.secondaryMain)
                .frame(height: 0.5)

            Text(filteredCities.isEmpty ? "NO RESULTS" : "SUGGESTED LOCATIONS")
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.textTertiaryFull)
                .textCase(.uppercase)
                .frame(height: 24, alignment: .leading)

            ScrollView(.vertical, showsIndicators: false) {
                LazyVStack(spacing: 0) {
                    ForEach(Array(filteredCities.enumerated()), id: \.element.id) { index, city in
                        destinationRow(city: city)
                            .opacity(rowsRevealed ? 1 : 0)
                            .offset(y: rowsRevealed ? 0 : 12)
                            .animation(
                                .spring(response: 0.4, dampingFraction: 0.8)
                                    .delay(Double(index) * 0.04),
                                value: rowsRevealed
                            )
                    }
                }
            }
            .frame(maxHeight: 362)
        }
    }

    // MARK: - Destination Row

    private func destinationRow(city: City) -> some View {
        Button(action: { selectCity(city) }) {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: "airplane.departure")
                    .font(.system(size: 11))
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .frame(width: 16, height: 16)
                    .padding(.top, 2)

                VStack(alignment: .leading, spacing: 2) {
                    HStack {
                        Text(city.name)
                            .font(IndiGoFonts.bodySmall())
                            .foregroundStyle(IndiGoColors.forYouTextPrimary)
                            .lineLimit(1)

                        Spacer()

                        Text(city.code)
                            .font(IndiGoFonts.bodySmall())
                            .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    }

                    Text(city.airportName)
                        .font(IndiGoFonts.bodyExtraSmall())
                        .foregroundStyle(IndiGoColors.forYouTextSecondary)
                        .lineLimit(1)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 12)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }

    // MARK: - Selection Logic

    private func selectCity(_ city: City) {
        switch activeField {
        case .from:
            HapticManager.selection()
            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedFrom = city
                fromText = "\(city.name),\(city.code)"
                bookingState.origin = city
            }
            if selectedTo == nil {
                activeField = .to
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
                    toFieldFocused = true
                }
            }

        case .to:
            HapticManager.success()
            toFieldFocused = false
            fromFieldFocused = false

            withAnimation(.spring(response: 0.35, dampingFraction: 0.8)) {
                selectedTo = city
                toText = "\(city.name),\(city.code)"
                bookingState.destination = city
            }

            withAnimation(.easeInOut(duration: 0.3).delay(0.15)) {
                destinationConfirmed = true
            }

            DispatchQueue.main.asyncAfter(deadline: .now() + 0.7) {
                if isEditMode {
                    dismiss()
                } else {
                    navigateToDate = true
                }
            }
        }
    }
}

#Preview {
    NavigationStack {
        BookLocationView()
            .environmentObject(BookingState())
    }
}
