//
//  MockDestinations.swift
//  IndiGoPrototype
//
//  Mock destination data for the "One Click Away" carousel.
//  Figma node: 85:6087
//

import Foundation

struct Destination: Identifiable {
    let id: String
    let name: String
    let imageName: String
    let dateRange: String
    let originalPrice: String
    let discountedPrice: String
    let category: DestinationCategory

    let computedDeparture: Date?
    let computedReturn: Date?

    init(id: String, name: String, imageName: String, dateRange: String,
         originalPrice: String, discountedPrice: String, category: DestinationCategory,
         departureDaysFromNow: Int = 0, tripDuration: Int = 0) {
        self.id = id
        self.name = name
        self.imageName = imageName
        self.originalPrice = originalPrice
        self.discountedPrice = discountedPrice
        self.category = category

        let cal = Calendar.current
        let today = Date()
        let dep = cal.date(byAdding: .day, value: departureDaysFromNow, to: today)!
        let ret = cal.date(byAdding: .day, value: departureDaysFromNow + tripDuration, to: today)!
        self.computedDeparture = dep
        self.computedReturn = ret
        self.dateRange = Self.formatRange(from: dep, to: ret)
    }

    private static let displayFormatter: DateFormatter = {
        let f = DateFormatter()
        f.locale = Locale(identifier: "en_US_POSIX")
        f.dateFormat = "dd MMM''yy"
        return f
    }()

    private static func formatRange(from dep: Date, to ret: Date) -> String {
        "\(displayFormatter.string(from: dep)) – \(displayFormatter.string(from: ret))"
    }
}

enum DestinationCategory: String, CaseIterable {
    case international = "International"
    case domestic = "Domestic"
}

extension Destination {

    private static let cityMap: [String: String] = [
        "dubai": "dxb", "singapore": "sin", "bali": "dps", "bangkok": "bkk",
        "jaipur": "jai", "mumbai": "bom",
    ]

    var city: City? {
        guard let airportId = Self.cityMap[id] else { return nil }
        return IndiGoAirports.all.first { $0.id == airportId }
    }

    var departureDate: Date? { computedDeparture }
    var returnDate: Date? { computedReturn }
}

enum MockDestinations {
    static let international: [Destination] = [
        Destination(
            id: "dubai", name: "Dubai", imageName: "dest-dubai", dateRange: "",
            originalPrice: "₹24,999", discountedPrice: "₹20,199",
            category: .international, departureDaysFromNow: 21, tripDuration: 15
        ),
        Destination(
            id: "bali", name: "Bali", imageName: "dest-bali", dateRange: "",
            originalPrice: "₹24,999", discountedPrice: "₹20,199",
            category: .international, departureDaysFromNow: 30, tripDuration: 8
        ),
        Destination(
            id: "bangkok", name: "Bangkok", imageName: "dest-bangkok", dateRange: "",
            originalPrice: "₹24,999", discountedPrice: "₹20,199",
            category: .international, departureDaysFromNow: 35, tripDuration: 8
        ),
        Destination(
            id: "singapore", name: "Singapore", imageName: "dest-singapore", dateRange: "",
            originalPrice: "₹24,999", discountedPrice: "₹20,199",
            category: .international, departureDaysFromNow: 45, tripDuration: 10
        ),
    ]

    static let domestic: [Destination] = [
        Destination(
            id: "jaipur", name: "Jaipur", imageName: "dest-jaipur", dateRange: "",
            originalPrice: "₹7,499", discountedPrice: "₹4,899",
            category: .domestic, departureDaysFromNow: 14, tripDuration: 5
        ),
        Destination(
            id: "mumbai", name: "Mumbai", imageName: "dest-mumbai", dateRange: "",
            originalPrice: "₹5,999", discountedPrice: "₹3,799",
            category: .domestic, departureDaysFromNow: 28, tripDuration: 4
        ),
    ]

    static let all: [Destination] = {
        var mixed: [Destination] = []
        let maxLen = max(international.count, domestic.count)
        for i in 0..<maxLen {
            if i < international.count { mixed.append(international[i]) }
            if i < domestic.count { mixed.append(domestic[i]) }
        }
        return mixed
    }()
}
