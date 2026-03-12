//
//  MockCities.swift
//  IndiGoPrototype
//
//  Legacy shim – delegates to IndiGoAirports for backward compatibility.
//

import Foundation

enum MockCities {
    static let all: [City] = IndiGoAirports.popularDomestic
}
