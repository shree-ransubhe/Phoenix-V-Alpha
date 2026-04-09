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
    @State private var show6EPickExplore = false

    var body: some View {
        ZStack(alignment: .bottom) {
            NavigationStack {
                Group {
                    switch selectedTab {
                    case .explore:
                        HomeView()
                    case .flights:
                        FlightsView()
                    case .hello6E:
                        PlaceholderTabView(title: "Hello 6E")
                    case .fourthTab:
                        PlaceholderTabView(title: selectedTab.label(theme: ThemeProvider.current))
                    }
                }
                .navigationDestination(isPresented: $show6EPickExplore) {
                    SixEPickExploreView()
                        .navigationBarBackButtonHidden()
                }
            }

            if !bookingState.isInBookingFlow {
                BottomNavBar(selectedTab: $selectedTab, on6EPickTap: {
                    show6EPickExplore = true
                })
                .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: show6EPickExplore) { _, isActive in
            bookingState.isInBookingFlow = isActive
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
