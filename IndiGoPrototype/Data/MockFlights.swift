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

enum MockFlights {
    static let calendarDates: [CalendarDate] = [
        CalendarDate(dayLabel: "Fri", dateLabel: "2 Jan", price: 7400, isCheapest: false, isSelected: false),
        CalendarDate(dayLabel: "Sat", dateLabel: "22 Jan", price: 4200, isCheapest: false, isSelected: true),
        CalendarDate(dayLabel: "Sun", dateLabel: "23 Jan", price: 3900, isCheapest: true, isSelected: false),
        CalendarDate(dayLabel: "Mon", dateLabel: "24 Jan", price: 10400, isCheapest: false, isSelected: false),
        CalendarDate(dayLabel: "Tue", dateLabel: "25 Jan", price: nil, isCheapest: false, isSelected: false),
        CalendarDate(dayLabel: "Wed", dateLabel: "7 Feb", price: nil, isCheapest: false, isSelected: false),
    ]

    static let sample: [MockFlight] = [
        MockFlight(
            id: "f1", flightNumber: "6E 12347",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "05:00", arrivalTime: "08:10",
            duration: "3h 10m", stops: 0,
            stretchPrice: 28500, economyPrice: 3500,
            stretchBluChips: 7000, economyBluChips: 7000,
            cabinClass: .stretch
        ),
        MockFlight(
            id: "f2", flightNumber: "6E 12347",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "05:00", arrivalTime: "08:10",
            duration: "3h 10m", stops: 0,
            stretchPrice: 28500, economyPrice: 3500,
            stretchBluChips: 7000, economyBluChips: 7000,
            cabinClass: .economy
        ),
        MockFlight(
            id: "f3", flightNumber: "6E 12347",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "05:00", arrivalTime: "08:10",
            duration: "3h 10m", stops: 0,
            stretchPrice: 28500, economyPrice: 3500,
            stretchBluChips: 7000, economyBluChips: 7000,
            cabinClass: .stretch
        ),
        MockFlight(
            id: "f4", flightNumber: "6E 12347",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "05:00", arrivalTime: "08:10",
            duration: "3h 10m", stops: 0,
            stretchPrice: 28500, economyPrice: 3500,
            stretchBluChips: 7000, economyBluChips: 7000,
            cabinClass: .economy
        ),
        MockFlight(
            id: "f5", flightNumber: "6E 12349",
            originCode: "DEL", originTerminal: "T1",
            destinationCode: "BLR", destinationTerminal: "T3",
            departureTime: "06:30", arrivalTime: "08:25",
            duration: "1h 55m", stops: 0,
            stretchPrice: 26000, economyPrice: 5800,
            stretchBluChips: 7500, economyBluChips: 7500,
            cabinClass: .business
        ),
        MockFlight(
            id: "f6", flightNumber: "6E 12350",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "09:15", arrivalTime: "12:20",
            duration: "3h 05m", stops: 0,
            stretchPrice: 24000, economyPrice: 4200,
            stretchBluChips: 6500, economyBluChips: 6500,
            cabinClass: .economy
        ),
        MockFlight(
            id: "f7", flightNumber: "6E 12351",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "14:30", arrivalTime: "17:35",
            duration: "3h 05m", stops: 1,
            stretchPrice: 19500, economyPrice: 2800,
            stretchBluChips: 5500, economyBluChips: 5500,
            cabinClass: .stretch
        ),
        MockFlight(
            id: "f8", flightNumber: "6E 12352",
            originCode: "DEL", originTerminal: "T3",
            destinationCode: "BOM", destinationTerminal: "T2",
            departureTime: "20:00", arrivalTime: "23:10",
            duration: "3h 10m", stops: 0,
            stretchPrice: 30000, economyPrice: 5100,
            stretchBluChips: 8000, economyBluChips: 8000,
            cabinClass: .economy
        ),
    ]

    static let quickFilters = ["Non-stop only", "Stretch", "Economy", "Morning flights"]
}
