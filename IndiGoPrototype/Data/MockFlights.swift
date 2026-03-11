//
//  MockFlights.swift
//  IndiGoPrototype
//
//  Mock flight/fare data for SRP.
//

import Foundation

struct MockFlight: Identifiable {
    let id: String
    let originCode: String
    let destinationCode: String
    let departureTime: String
    let arrivalTime: String
    let price: Int
    let bluChips: Int
}

enum MockFlights {
    static let sample: [MockFlight] = (1...8).map { i in
        MockFlight(
            id: "f\(i)",
            originCode: "DEL",
            destinationCode: "BOM",
            departureTime: "\(6 + i):\(i % 2 == 0 ? "30" : "00")",
            arrivalTime: "\(8 + i):\(i % 2 == 0 ? "45" : "15")",
            price: 5200 + i * 200,
            bluChips: 6000 + i * 100
        )
    }
}
