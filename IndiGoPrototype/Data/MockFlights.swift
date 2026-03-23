import Foundation

enum CabinClass: String, CaseIterable, Identifiable {
    case stretch = "Stretch"
    case economy = "Economy"
    case business = "Business"
    case firstClass = "First Class"

    var id: String { rawValue }
}

enum FareFamily: String, Identifiable {
    case superSaver = "Super Saver"
    case saver = "Saver"
    case flexi = "Flexi"
    case upfront = "Upfront"
    case stretchRegular = "Stretch"
    case stretchPlus = "Stetch +"
    case premiumBusiness = "Premium Business"

    var id: String { rawValue }

    var subtitle: String {
        switch self {
        case .superSaver: return "Lowest fare"
        case .saver: return "Save more"
        case .flexi: return "Popular fare"
        case .upfront: return "Bundle with care"
        case .stretchRegular: return "Extra Leg Room"
        case .stretchPlus: return "Premium Business"
        case .premiumBusiness: return "Premium Business"
        }
    }

    var cabinBag: String {
        switch self {
        case .superSaver, .saver, .flexi: return "7 kg"
        case .upfront: return "7 kg"
        case .stretchRegular: return "12 kg"
        case .stretchPlus, .premiumBusiness: return "12 kg"
        }
    }

    var checkinBag: String {
        switch self {
        case .superSaver: return "15 kg"
        case .saver: return "15 kg"
        case .flexi: return "15 kg"
        case .upfront: return "15 kg"
        case .stretchRegular: return "30 kg"
        case .stretchPlus, .premiumBusiness: return "40 kg"
        }
    }

    var perks: [String] {
        switch self {
        case .superSaver:
            return ["Free Standard Seat", "Standard Cancellation"]
        case .saver:
            return ["Free Standard Seat", "Standard Cancellation"]
        case .flexi:
            return ["Free Meal", "Free Standard Seat", "Free Date Change", "Free Cancellation"]
        case .upfront:
            return ["Fast forward", "Free Meal", "Upfront Seat", "Free Plan Change"]
        case .stretchRegular:
            return ["Fast Forward", "Standard Cancellation", "Free Veg Meal", "Free Premium Seat"]
        case .stretchPlus, .premiumBusiness:
            return ["Fast Forward", "Free Veg Meal", "Free Premium Seat", "Free Plan Change"]
        }
    }
}

struct FareOption: Identifiable {
    let id = UUID()
    let fareFamily: FareFamily
    let price: Int
    let bluChips: Int
}

struct MockFlight: Identifiable {
    let id: String
    let flightNumber: String
    let originCode: String
    let originTerminal: String
    let destinationCode: String
    let destinationTerminal: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let stops: Int
    let stretchPrice: Int
    let economyPrice: Int
    let stretchBluChips: Int
    let economyBluChips: Int
    let cabinClass: CabinClass

    var stopsLabel: String { stops == 0 ? "Non-stop" : "\(stops) Stop" }

    var stretchFares: [FareOption] {
        [
            FareOption(fareFamily: .stretchRegular, price: stretchPrice, bluChips: stretchBluChips),
            FareOption(fareFamily: .stretchPlus, price: stretchPrice + 503, bluChips: stretchBluChips + 200),
        ]
    }

    var economyFares: [FareOption] {
        [
            FareOption(fareFamily: .saver, price: economyPrice, bluChips: economyBluChips),
            FareOption(fareFamily: .flexi, price: economyPrice + 1710, bluChips: economyBluChips + 200),
            FareOption(fareFamily: .upfront, price: economyPrice + 4388, bluChips: economyBluChips + 400),
        ]
    }
}

struct CalendarDate: Identifiable {
    let id = UUID()
    let dayLabel: String
    let dateLabel: String
    let price: Int?
    let isCheapest: Bool
    let isSelected: Bool
}

/// Flight schedule template: times & pricing that get combined with the user's chosen route.
private struct FlightTemplate {
    let index: Int
    let flightNumberSuffix: String
    let originTerminal: String
    let destinationTerminal: String
    let departureTime: String
    let arrivalTime: String
    let duration: String
    let stops: Int
    let stretchPrice: Int
    let economyPrice: Int
    let stretchBluChips: Int
    let economyBluChips: Int
    let cabinClass: CabinClass
}

private let flightTemplates: [FlightTemplate] = [
    FlightTemplate(index: 0, flightNumberSuffix: "12347", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "05:00", arrivalTime: "08:10", duration: "3h 10m", stops: 0,
                   stretchPrice: 28500, economyPrice: 3500, stretchBluChips: 7000, economyBluChips: 7000, cabinClass: .stretch),
    FlightTemplate(index: 1, flightNumberSuffix: "12348", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "06:30", arrivalTime: "09:20", duration: "3h 10m", stops: 0,
                   stretchPrice: 27000, economyPrice: 3000, stretchBluChips: 5500, economyBluChips: 6500, cabinClass: .economy),
    FlightTemplate(index: 2, flightNumberSuffix: "12349", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "07:15", arrivalTime: "10:45", duration: "3h 10m", stops: 0,
                   stretchPrice: 29000, economyPrice: 4200, stretchBluChips: 7500, economyBluChips: 7500, cabinClass: .stretch),
    FlightTemplate(index: 3, flightNumberSuffix: "12350", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "08:00", arrivalTime: "11:00", duration: "3h 10m", stops: 0,
                   stretchPrice: 30500, economyPrice: 4500, stretchBluChips: 8000, economyBluChips: 8000, cabinClass: .economy),
    FlightTemplate(index: 4, flightNumberSuffix: "12351", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "09:30", arrivalTime: "13:20", duration: "3h 10m", stops: 0,
                   stretchPrice: 31000, economyPrice: 4800, stretchBluChips: 8500, economyBluChips: 8500, cabinClass: .stretch),
    FlightTemplate(index: 5, flightNumberSuffix: "12352", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "10:15", arrivalTime: "12:55", duration: "3h 10m", stops: 0,
                   stretchPrice: 26000, economyPrice: 3800, stretchBluChips: 5000, economyBluChips: 6000, cabinClass: .economy),
    FlightTemplate(index: 6, flightNumberSuffix: "12353", originTerminal: "T3", destinationTerminal: "T2",
                   departureTime: "11:00", arrivalTime: "14:20", duration: "3h 10m", stops: 0,
                   stretchPrice: 28000, economyPrice: 3600, stretchBluChips: 7000, economyBluChips: 7000, cabinClass: .stretch),
]

enum MockFlights {
    static let calendarDates: [CalendarDate] = [
        CalendarDate(dayLabel: "Sat", dateLabel: "22 Jan", price: 4200, isCheapest: false, isSelected: true),
        CalendarDate(dayLabel: "Sun", dateLabel: "23 Jan", price: 3900, isCheapest: true, isSelected: false),
        CalendarDate(dayLabel: "Mon", dateLabel: "24 Jan", price: 10400, isCheapest: false, isSelected: false),
        CalendarDate(dayLabel: "Tue", dateLabel: "25 Jan", price: nil, isCheapest: false, isSelected: false),
    ]

    /// Generate flights dynamically from the user's selected origin/destination.
    /// Falls back to DEL→BOM if booking state has no selection.
    static func flights(
        originCode: String,
        originTerminal: String? = nil,
        destinationCode: String,
        destinationTerminal: String? = nil
    ) -> [MockFlight] {
        flightTemplates.map { t in
            MockFlight(
                id: "f\(t.index)",
                flightNumber: "6E \(t.flightNumberSuffix)",
                originCode: originCode,
                originTerminal: originTerminal ?? t.originTerminal,
                destinationCode: destinationCode,
                destinationTerminal: destinationTerminal ?? t.destinationTerminal,
                departureTime: t.departureTime,
                arrivalTime: t.arrivalTime,
                duration: t.duration,
                stops: t.stops,
                stretchPrice: t.stretchPrice,
                economyPrice: t.economyPrice,
                stretchBluChips: t.stretchBluChips,
                economyBluChips: t.economyBluChips,
                cabinClass: t.cabinClass
            )
        }
    }

    /// Legacy static accessor for previews and places that don't have BookingState.
    static let sample: [MockFlight] = flights(
        originCode: "DEL", destinationCode: "BOM"
    )

    static let quickFilters = ["Non-stop only", "Stretch", "Economy", "Morning flights"]
}
