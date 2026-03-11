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
}

struct TravellerCount {
    var adults: Int
    var children: Int
    var infants: Int

    static let `default` = TravellerCount(adults: 1, children: 0, infants: 0)
}

@MainActor
final class BookingState: ObservableObject {
    @Published var origin: City?
    @Published var destination: City?
    @Published var selectedDate: Date?
    @Published var tripType: TripType = .oneWay
    @Published var travellers: TravellerCount = .default

    enum TripType: String, CaseIterable {
        case oneWay = "One-way"
        case returnTrip = "Return"
    }

    var isSearchReady: Bool {
        origin != nil && destination != nil && selectedDate != nil
    }

    func reset() {
        origin = nil
        destination = nil
        selectedDate = nil
        travellers = .default
    }
}
