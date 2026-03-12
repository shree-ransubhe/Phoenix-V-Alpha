//
//  BookingState.swift
//  IndiGoPrototype
//
//  Single source of truth for the booking flow (From/To, date, travellers).
//

import Foundation

struct City: Identifiable, Hashable {
    let id: String
    let code: String
    let name: String
    let airportName: String
    let country: String
    let isDomestic: Bool

    init(id: String, code: String, name: String, airportName: String = "", country: String = "India", isDomestic: Bool = true) {
        self.id = id
        self.code = code
        self.name = name
        self.airportName = airportName
        self.country = country
        self.isDomestic = isDomestic
    }
}

struct TravellerCount {
    var adults: Int
    var seniorCitizens: Int
    var children: Int
    var infants: Int

    var totalPassengers: Int { adults + seniorCitizens + children + infants }

    static let `default` = TravellerCount(adults: 0, seniorCitizens: 0, children: 0, infants: 0)
}

struct SavedTraveller: Identifiable, Hashable {
    let id: String
    let name: String
    let category: String

    static let sampleData: [SavedTraveller] = [
        SavedTraveller(id: "1", name: "Ragini Shah", category: "Adult - Single Seat"),
        SavedTraveller(id: "2", name: "Smriti Shah", category: "Adult - Single Seat"),
        SavedTraveller(id: "3", name: "Sarala Sachdeva", category: "Adult - Single Seat"),
        SavedTraveller(id: "4", name: "Akhil Shah", category: "Child - Single Seat"),
    ]
}

enum DiscountCategory: String, CaseIterable, Identifiable {
    case sixEExclusive = "6E Exclusive"
    case seniorCitizen = "Senior Citizen"
    case armedForces = "Armed Forces"
    case doctorNurses = "Doctor & Nurses"
    case unaccompaniedMinors = "Unaccompanied Minors"

    var id: String { rawValue }
}

@MainActor
final class BookingState: ObservableObject {
    @Published var origin: City?
    @Published var destination: City?
    @Published var selectedDate: Date?
    @Published var returnDate: Date?
    @Published var tripType: TripType = .oneWay
    @Published var travellers: TravellerCount = .default
    @Published var selectedTravellerIDs: Set<String> = []
    @Published var selectedDiscountCategories: Set<DiscountCategory> = []

    // Pay mode
    @Published var paymentMethod: PaymentMethod = .cash
    @Published var useBluChipBalance = false
    @Published var selectedCurrency: String = "INR"
    @Published var bluChipBalance: Double = 67_440

    /// True while the user is inside the booking journey (hides bottom nav).
    @Published var isInBookingFlow = false

    enum TripType: String, CaseIterable {
        case oneWay = "One Way"
        case returnTrip = "Round Trip"
    }

    enum PaymentMethod: String, CaseIterable {
        case cash = "Cash"
        case bluChip = "IndiGo BluChip"
    }

    var isSearchReady: Bool {
        guard origin != nil, destination != nil, selectedDate != nil else { return false }
        if tripType == .returnTrip { return returnDate != nil }
        return true
    }

    var hasPassengers: Bool {
        travellers.totalPassengers > 0 || !selectedTravellerIDs.isEmpty
    }

    func reset() {
        origin = nil
        destination = nil
        selectedDate = nil
        returnDate = nil
        travellers = .default
        selectedTravellerIDs = []
        selectedDiscountCategories = []
    }
}
