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
    #if UT_VARIANT
    @StateObject private var tracker = UTTrackingService.shared
    #endif

    var body: some Scene {
        WindowGroup {
            #if UT_VARIANT
            UTRootView()
                .environmentObject(bookingState)
                .environmentObject(tracker)
            #else
            ContentView()
                .environmentObject(bookingState)
            #endif
        }
    }
}

#if UT_VARIANT
/// Wrapper that gates on announcement → demographics → main app (UT build only).
struct UTRootView: View {
    @EnvironmentObject private var tracker: UTTrackingService

    enum Phase { case announcement, demographics, session, complete }
    @State private var phase: Phase = .announcement

    var body: some View {
        switch phase {
        case .announcement:
            UTAnnouncementView {
                withAnimation { phase = .demographics }
            }

        case .demographics:
            UTDemographicsView { demographics in
                tracker.startSession(demographics: demographics)
                withAnimation { phase = .session }
            }

        case .session:
            ContentView()
                .onReceive(tracker.$sessionEnded) { ended in
                    if ended { withAnimation { phase = .complete } }
                }

        case .complete:
            UTSessionCompleteView()
        }
    }
}
#endif
