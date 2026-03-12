//
//  ContentView.swift
//  IndiGoPrototype
//
//  Root container – NavigationStack, tab state, bottom nav.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var bookingState: BookingState
    @State private var selectedTab: NavTab = .explore

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                Group {
                    switch selectedTab {
                    case .explore:
                        HomeView()
                    case .flights:
                        PlaceholderTabView(title: "Flights")
                    case .hello6E:
                        PlaceholderTabView(title: "Hello 6E")
                    case .checkIn:
                        PlaceholderTabView(title: "Check-in")
                    }
                }
            }

            if !bookingState.isInBookingFlow {
                BottomNavBar(selectedTab: $selectedTab)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.25), value: bookingState.isInBookingFlow)
        .ignoresSafeArea(.keyboard)
    }
}

struct PlaceholderTabView: View {
    let title: String
    var body: some View {
        VStack {
            Spacer()
            Text(title)
                .font(IndiGoFonts.heading2())
                .foregroundStyle(IndiGoColors.textSecondary)
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(IndiGoColors.background)
    }
}

#Preview {
    ContentView()
        .environmentObject(BookingState())
}
