//
//  IndiGoPrototypeApp.swift
//  IndiGoPrototype
//
//  IndiGo Mobile App 2026 – Usability testing prototype.
//

import SwiftUI

@main
struct IndiGoPrototypeApp: App {
    @StateObject private var bookingState = BookingState()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(bookingState)
        }
    }
}
