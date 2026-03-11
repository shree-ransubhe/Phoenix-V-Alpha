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
}

enum DestinationCategory: String, CaseIterable {
    case international = "International"
    case domestic = "Domestic"
}

enum MockDestinations {
    static let international: [Destination] = [
        Destination(
            id: "dubai",
            name: "Dubai",
            imageName: "dest-dubai",
            dateRange: "27 Dec 2025 – 15 Jan 2026",
            originalPrice: "₹24,999",
            discountedPrice: "₹20,199",
            category: .international
        ),
        Destination(
            id: "singapore",
            name: "Singapore",
            imageName: "dest-singapore",
            dateRange: "27 Dec 2025 – 15 Jan 2026",
            originalPrice: "₹24,999",
            discountedPrice: "₹20,199",
            category: .international
        ),
        Destination(
            id: "bali",
            name: "Bali",
            imageName: "dest-bali",
            dateRange: "27 Dec 2025 – 15 Jan 2026",
            originalPrice: "₹24,999",
            discountedPrice: "₹20,199",
            category: .international
        ),
        Destination(
            id: "bangkok",
            name: "Bangkok",
            imageName: "dest-bangkok",
            dateRange: "27 Dec 2025 – 15 Jan 2026",
            originalPrice: "₹24,999",
            discountedPrice: "₹20,199",
            category: .international
        ),
        Destination(
            id: "newzealand",
            name: "New Zealand",
            imageName: "dest-newzealand",
            dateRange: "27 Dec 2025 – 15 Jan 2026",
            originalPrice: "₹24,999",
            discountedPrice: "₹20,199",
            category: .international
        ),
    ]

    static let domestic: [Destination] = [
        Destination(
            id: "goa",
            name: "Goa",
            imageName: "dest-goa",
            dateRange: "15 Jan – 28 Feb 2026",
            originalPrice: "₹8,999",
            discountedPrice: "₹5,499",
            category: .domestic
        ),
        Destination(
            id: "jaipur",
            name: "Jaipur",
            imageName: "dest-jaipur",
            dateRange: "15 Jan – 28 Feb 2026",
            originalPrice: "₹7,499",
            discountedPrice: "₹4,899",
            category: .domestic
        ),
        Destination(
            id: "varanasi",
            name: "Varanasi",
            imageName: "dest-varanasi",
            dateRange: "15 Jan – 28 Feb 2026",
            originalPrice: "₹6,999",
            discountedPrice: "₹4,299",
            category: .domestic
        ),
        Destination(
            id: "mumbai",
            name: "Mumbai",
            imageName: "dest-mumbai",
            dateRange: "15 Jan – 28 Feb 2026",
            originalPrice: "₹5,999",
            discountedPrice: "₹3,799",
            category: .domestic
        ),
        Destination(
            id: "shimla",
            name: "Shimla",
            imageName: "dest-shimla",
            dateRange: "15 Jan – 28 Feb 2026",
            originalPrice: "₹9,499",
            discountedPrice: "₹6,199",
            category: .domestic
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
