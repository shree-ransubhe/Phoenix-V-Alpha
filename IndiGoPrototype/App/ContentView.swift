//
//  ContentView.swift
//  IndiGoPrototype
//
//  Root container – NavigationStack, tab state, bottom nav.
//

import SwiftUI

struct ContentView: View {
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

            BottomNavBar(selectedTab: $selectedTab)
        }
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
