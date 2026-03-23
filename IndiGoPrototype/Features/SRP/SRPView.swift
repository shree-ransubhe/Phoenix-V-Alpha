import SwiftUI

struct SRPView: View {
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var bookingState: BookingState

    @State private var selectedFilters: Set<String> = []
    @State private var showCompareFares = false
    @State private var selectedFlightForStretch: MockFlight?
    @State private var selectedFlightForEconomy: MockFlight?
    @State private var calendarDates: [CalendarDate] = MockFlights.calendarDates

    // Animation states
    @State private var headerAppeared = false
    @State private var calendarAppeared = false
    @State private var filtersAppeared = false
    @State private var compareAppeared = false
    @State private var cardsAppeared = false
    @State private var shimmerActive = true
    @State private var fareWasSelected = false
    @State private var showJourneyComplete = false

    private var originCode: String {
        bookingState.origin?.code ?? "DEL"
    }

    private var destinationCode: String {
        bookingState.destination?.code ?? "BOM"
    }

    private var flights: [MockFlight] {
        MockFlights.flights(
            originCode: originCode,
            destinationCode: destinationCode
        )
    }

    private var originName: String {
        bookingState.origin?.name ?? "Delhi"
    }

    private var destinationName: String {
        bookingState.destination?.name ?? "Mumbai"
    }

    private var tripLabel: String {
        bookingState.tripType == .returnTrip ? "Return" : "One Way"
    }

    private var dateLabel: String {
        guard let date = bookingState.selectedDate else { return "22-22 Jan" }
        let fmt = DateFormatter()
        fmt.dateFormat = "dd MMM"
        let start = fmt.string(from: date)
        if let ret = bookingState.returnDate {
            return "\(start)-\(fmt.string(from: ret))"
        }
        return start
    }

    private var paxCount: Int {
        let count = bookingState.travellers.totalPassengers
        return count > 0 ? count : 3
    }

    var body: some View {
        ZStack {
            srpBackground

            VStack(spacing: 0) {
                // MARK: - Sticky Header (z-elevated, never scrolls)
                stickyHeader
                    .zIndex(10)

                // MARK: - Scrollable Content (cards scroll beneath sticky header)
                ScrollView(.vertical, showsIndicators: false) {
                    VStack(spacing: IndiGoSpacing.xs) {
                        SRPCompareClassesCTA {
                            showCompareFares = true
                        }
                        .opacity(compareAppeared ? 1 : 0)
                        .scaleEffect(compareAppeared ? 1 : 0.95)

                        if shimmerActive {
                            shimmerPlaceholders
                        } else {
                            flightResultsList
                                .opacity(cardsAppeared ? 1 : 0)
                        }

                    }
                    .padding(.bottom, IndiGoSpacing.md)
                }
            }

            #if UT_VARIANT
            if showJourneyComplete {
                UTJourneyCompleteOverlay()
                    .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            #endif
        }
        #if UT_VARIANT
        .utInstrumented(screenId: "SRPView")
        #endif
        .navigationBarBackButtonHidden(true)
        .onAppear { runEntranceAnimations() }
        .sheet(isPresented: $showCompareFares) {
            CompareFaresBottomSheet(isPresented: $showCompareFares)
                .presentationDetents([.height(440)])
                .presentationDragIndicator(.hidden)
                .presentationCornerRadius(23)
                .presentationBackgroundInteraction(.enabled(upThrough: .height(440)))
        }
        .overlay {
            if let flight = selectedFlightForStretch {
                FareFamilyOverlay(
                    flight: flight,
                    fareType: .stretch,
                    onDismiss: { selectedFlightForStretch = nil },
                    onFareSelected: {
                        selectedFlightForStretch = nil
                        fareWasSelected = true
                    }
                )
            }
        }
        .overlay {
            if let flight = selectedFlightForEconomy {
                FareFamilyOverlay(
                    flight: flight,
                    fareType: .economy,
                    onDismiss: { selectedFlightForEconomy = nil },
                    onFareSelected: {
                        selectedFlightForEconomy = nil
                        fareWasSelected = true
                    }
                )
            }
        }
        .onChange(of: fareWasSelected) { _, selected in
            if selected {
                #if UT_VARIANT
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    withAnimation(.spring(response: 0.5, dampingFraction: 0.85)) {
                        showJourneyComplete = true
                    }
                }
                #endif
            }
        }
    }

    // MARK: - Sticky Header

    /// Reference card + calendar strip + quick filters — always pinned at top.
    /// Flight cards scroll underneath this section.
    private var stickyHeader: some View {
        VStack(spacing: IndiGoSpacing.xs) {
            SRPReferenceCard(
                origin: originName,
                destination: destinationName,
                tripType: tripLabel,
                dates: dateLabel,
                paxCount: paxCount,
                currency: bookingState.selectedCurrency,
                onBack: { dismiss() },
                onEdit: { dismiss() }
            )
            .padding(.horizontal, IndiGoSpacing.md)
            .opacity(headerAppeared ? 1 : 0)
            .offset(y: headerAppeared ? 0 : -20)

            SRPCalendarStrip(dates: $calendarDates)
                .opacity(calendarAppeared ? 1 : 0)
                .offset(y: calendarAppeared ? 0 : 15)

            SRPQuickFilters(
                filters: MockFlights.quickFilters,
                selectedFilters: $selectedFilters
            )
            .opacity(filtersAppeared ? 1 : 0)
            .offset(y: filtersAppeared ? 0 : 15)
        }
        .padding(.top, IndiGoSpacing.xs)
        .padding(.bottom, IndiGoSpacing.xxs)
        .background(
            ZStack {
                LinearGradient(
                    colors: [Color(hex: "D1EFFF"), Color(hex: "E8F6FF")],
                    startPoint: .top,
                    endPoint: .bottom
                )

                Color.white
                    .opacity(0.6)
                    .blendMode(.softLight)
            }
        )
        .clipped()
        .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 4)
    }

    // MARK: - Entrance Animations

    private func runEntranceAnimations() {
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.05)) {
            headerAppeared = true
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.15)) {
            calendarAppeared = true
        }
        withAnimation(.spring(response: 0.45, dampingFraction: 0.8).delay(0.25)) {
            filtersAppeared = true
        }
        withAnimation(.spring(response: 0.4, dampingFraction: 0.85).delay(0.35)) {
            compareAppeared = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            withAnimation(.easeOut(duration: 0.3)) {
                shimmerActive = false
            }
            withAnimation(.spring(response: 0.5, dampingFraction: 0.8).delay(0.1)) {
                cardsAppeared = true
            }
        }
    }

    // MARK: - Shimmer Placeholders

    private var shimmerPlaceholders: some View {
        VStack(spacing: IndiGoSpacing.md) {
            ForEach(0..<3, id: \.self) { _ in
                ShimmerCardPlaceholder()
            }
        }
        .padding(.horizontal, IndiGoSpacing.sm)
    }

    // MARK: - Background

    private var srpBackground: some View {
        ZStack {
            LinearGradient(
                colors: [Color(hex: "D1EFFF"), .white],
                startPoint: .top,
                endPoint: .bottom
            )

            Color.white
                .opacity(0.7)
                .blendMode(.softLight)
        }
        .ignoresSafeArea()
    }

    // MARK: - Flight Results (lazy loaded)

    private var flightResultsList: some View {
        LazyVStack(spacing: IndiGoSpacing.md) {
            ForEach(Array(filteredFlights.enumerated()), id: \.element.id) { index, flight in
                FlightResultCard(
                    flight: flight,
                    onStretchTap: {
                        selectedFlightForStretch = flight
                    },
                    onEconomyTap: {
                        selectedFlightForEconomy = flight
                    }
                )
                .transition(.asymmetric(
                    insertion: .move(edge: .bottom).combined(with: .opacity),
                    removal: .opacity
                ))
            }
        }
        .padding(.horizontal, IndiGoSpacing.sm)
    }

    private var filteredFlights: [MockFlight] {
        var result = flights
        if selectedFilters.contains("Non-stop only") {
            result = result.filter { $0.stops == 0 }
        }
        if selectedFilters.contains("Stretch") {
            result = result.filter { $0.cabinClass == .stretch || $0.cabinClass == .business }
        }
        if selectedFilters.contains("Economy") {
            result = result.filter { $0.cabinClass == .economy }
        }
        if selectedFilters.contains("Morning flights") {
            result = result.filter {
                guard let hour = Int($0.departureTime.components(separatedBy: ":").first ?? "0") else { return false }
                return hour >= 5 && hour < 12
            }
        }
        return result
    }
}

// MARK: - Shimmer Loading Placeholder

private struct ShimmerCardPlaceholder: View {
    @State private var shimmerOffset: CGFloat = -200

    var body: some View {
        VStack(alignment: .leading, spacing: IndiGoSpacing.sm) {
            shimmerRect(width: 60, height: 10)
            HStack {
                shimmerRect(width: 50, height: 20)
                Spacer()
                shimmerRect(width: 60, height: 14)
                Spacer()
                shimmerRect(width: 50, height: 20)
            }
            HStack {
                shimmerRect(width: nil, height: 50)
                shimmerRect(width: nil, height: 50)
            }
        }
        .padding(IndiGoSpacing.sm)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd)
                .stroke(IndiGoColors.srpCardBorder, lineWidth: 1)
        )
        .overlay(
            shimmerGradient
                .offset(x: shimmerOffset)
                .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
        )
        .onAppear {
            withAnimation(.linear(duration: 1.2).repeatForever(autoreverses: false)) {
                shimmerOffset = 400
            }
        }
    }

    private func shimmerRect(width: CGFloat?, height: CGFloat) -> some View {
        RoundedRectangle(cornerRadius: 4)
            .fill(Color(hex: "E2EBF2").opacity(0.6))
            .frame(maxWidth: width ?? .infinity)
            .frame(height: height)
    }

    private var shimmerGradient: some View {
        LinearGradient(
            colors: [
                .clear,
                .white.opacity(0.4),
                .clear,
            ],
            startPoint: .leading,
            endPoint: .trailing
        )
        .frame(width: 150)
    }

}

// MARK: - Fare Family Overlay (translucent scrim + slide-up sheet)

private struct FareFamilyOverlay: View {
    let flight: MockFlight
    let fareType: FareFamilyBottomSheet.FareSheetType
    let onDismiss: () -> Void
    let onFareSelected: () -> Void

    @State private var appeared = false
    @State private var dragOffset: CGFloat = 0

    private let sheetHeight: CGFloat = 560

    var body: some View {
        ZStack(alignment: .bottom) {
            Color.black
                .opacity(appeared ? 0.35 : 0)
                .ignoresSafeArea()
                .onTapGesture { dismissWithAnimation() }

            VStack(spacing: 0) {
                FareFamilyBottomSheet(
                    flight: flight,
                    initialFareType: fareType,
                    isPresented: .init(
                        get: { appeared },
                        set: { if !$0 { dismissWithAnimation() } }
                    ),
                    onFareSelected: onFareSelected
                )
                .frame(height: sheetHeight)
            }
            .frame(maxWidth: .infinity)
            .background(.white)
            .clipShape(
                UnevenRoundedRectangle(
                    topLeadingRadius: 23,
                    bottomLeadingRadius: 0,
                    bottomTrailingRadius: 0,
                    topTrailingRadius: 23,
                    style: .continuous
                )
            )
            .ignoresSafeArea(.all, edges: .bottom)
            .offset(y: appeared ? dragOffset : sheetHeight + 60)
            .gesture(
                DragGesture()
                    .onChanged { value in
                        if value.translation.height > 0 {
                            dragOffset = value.translation.height
                        }
                    }
                    .onEnded { value in
                        if value.translation.height > 120 || value.predictedEndTranslation.height > 300 {
                            dismissWithAnimation()
                        } else {
                            withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
                                dragOffset = 0
                            }
                        }
                    }
            )
            .transition(.move(edge: .bottom))
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.85), value: appeared)
        .onAppear {
            appeared = true
        }
    }

    private func dismissWithAnimation() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.85)) {
            appeared = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.35) {
            onDismiss()
        }
    }
}

#Preview {
    NavigationStack {
        SRPView()
    }
    .environmentObject(BookingState())
}
