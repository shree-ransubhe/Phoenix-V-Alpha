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
                .alphaTheme(ThemeProvider.current)
            #else
            ContentView()
                .environmentObject(bookingState)
                .alphaTheme(ThemeProvider.current)
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
    #if !ALPHA_5_0
    @State private var audioConsent = true
    #endif

    var body: some View {
        switch phase {
        case .announcement:
            #if ALPHA_5_0
            UTAnnouncementView {
                withAnimation { phase = .demographics }
            }
            #else
            UTAnnouncementView { consent in
                audioConsent = consent
                withAnimation { phase = .demographics }
            }
            #endif

        case .demographics:
            UTDemographicsView { demographics in
                #if ALPHA_5_0
                tracker.startSession(demographics: demographics)
                #else
                tracker.startSession(demographics: demographics, audioConsent: audioConsent)
                #endif
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
