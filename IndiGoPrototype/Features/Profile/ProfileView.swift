//
//  ProfileView.swift
//  IndiGoPrototype
//
//  Feature – My Profile page with sticky header, search/filter bar, user info,
//  e-wallet, and categorized links list. Search filters links by metadata
//  keywords (aviation-contextual) in addition to title matching.
//

import SwiftUI

// MARK: - Data models

struct ProfileLinkItem: Identifiable {
    let id = UUID()
    let title: String
    let iconName: String
    let badge: String?
    let badgeColor: Color?
    let isDestructive: Bool
    let searchKeywords: [String]

    init(
        title: String,
        iconName: String,
        badge: String? = nil,
        badgeColor: Color? = nil,
        isDestructive: Bool = false,
        searchKeywords: [String] = []
    ) {
        self.title = title
        self.iconName = iconName
        self.badge = badge
        self.badgeColor = badgeColor
        self.isDestructive = isDestructive
        self.searchKeywords = searchKeywords
    }
}

struct ProfileLinkSection: Identifiable {
    let id = UUID()
    let header: String
    let items: [ProfileLinkItem]
}

// MARK: - Static link data with aviation-contextual metadata

enum ProfileLinkData {
    static let sections: [ProfileLinkSection] = [
        ProfileLinkSection(header: "YOUR INFORMATION", items: [
            ProfileLinkItem(
                title: "Upgrade to IndiGoStretch",
                iconName: "airplane.circle",
                searchKeywords: ["stretch", "upgrade", "premium", "seat", "legroom", "comfort", "fare", "cabin", "class", "flexi", "ancillary", "add-on"]
            ),
            ProfileLinkItem(
                title: "Flight Status",
                iconName: "clock.arrow.circlepath",
                searchKeywords: ["flight", "status", "tracking", "PNR", "delay", "schedule", "departure", "arrival", "gate", "terminal", "live", "real-time", "on-time", "OTP"]
            ),
            ProfileLinkItem(
                title: "My Nominee",
                iconName: "person.crop.circle",
                searchKeywords: ["nominee", "emergency", "contact", "next of kin", "passenger", "co-traveller", "family", "beneficiary", "insurance"]
            ),
            ProfileLinkItem(
                title: "My Scratch Card",
                iconName: "giftcard",
                searchKeywords: ["scratch", "card", "reward", "cashback", "voucher", "coupon", "offer", "promo", "discount", "credit", "prize", "lucky"]
            ),
        ]),

        ProfileLinkSection(header: "MY ORDER HISTORY", items: [
            ProfileLinkItem(
                title: "My Trips",
                iconName: "suitcase",
                searchKeywords: ["trips", "booking", "itinerary", "PNR", "reservation", "flight", "journey", "travel", "upcoming", "past", "history", "e-ticket", "boarding pass"]
            ),
            ProfileLinkItem(
                title: "Cabs",
                iconName: "car.side",
                searchKeywords: ["cab", "taxi", "ride", "airport transfer", "pickup", "drop", "ground transport", "chauffeur", "Uber", "Ola", "shuttle"]
            ),
            ProfileLinkItem(
                title: "Hotels",
                iconName: "building.2",
                searchKeywords: ["hotel", "stay", "accommodation", "room", "resort", "lodge", "check-in", "check-out", "hospitality", "6E Stay"]
            ),
            ProfileLinkItem(
                title: "Shop",
                iconName: "cart",
                searchKeywords: ["shop", "duty-free", "merchandise", "buy", "purchase", "retail", "in-flight", "6E Add-ons", "store", "e-commerce"]
            ),
            ProfileLinkItem(
                title: "Holidays",
                iconName: "sun.max",
                searchKeywords: ["holidays", "vacation", "package", "tour", "getaway", "travel package", "destination", "6E Holidays", "charter", "group booking"]
            ),
            ProfileLinkItem(
                title: "Sight Seeing",
                iconName: "binoculars",
                searchKeywords: ["sightseeing", "tour", "excursion", "activity", "attraction", "monument", "city tour", "explore", "adventure", "6E Explore"]
            ),
            ProfileLinkItem(
                title: "Experience",
                iconName: "star.circle",
                searchKeywords: ["experience", "activity", "event", "adventure", "culture", "local", "curated", "dining", "entertainment", "6E Experience"]
            ),
        ]),

        ProfileLinkSection(header: "DISCOVER INDIGO BLUCHIP", items: [
            ProfileLinkItem(
                title: "Loyalty Dashboard",
                iconName: "chart.bar.xaxis",
                searchKeywords: ["loyalty", "dashboard", "BluChip", "points", "miles", "frequent flyer", "FFP", "tier", "status", "rewards", "accrual"]
            ),
            ProfileLinkItem(
                title: "Our Partners",
                iconName: "person.2",
                badge: "Upto 32% Cash-back",
                badgeColor: Color(hex: "218946"),
                searchKeywords: ["partners", "earn", "coalition", "credit card", "bank", "co-brand", "alliance", "merchant", "transfer", "cashback"]
            ),
            ProfileLinkItem(
                title: "Retro Claim IndiGo BluChips",
                iconName: "arrow.counterclockwise.circle",
                badge: "New",
                badgeColor: Color(hex: "218946"),
                searchKeywords: ["retro", "claim", "retrospective", "missing points", "BluChip", "accrual", "credit", "past flight", "receipt"]
            ),
            ProfileLinkItem(
                title: "Earn IndiGo BluChip",
                iconName: "plus.circle",
                searchKeywords: ["earn", "BluChip", "points", "accrual", "miles", "accumulate", "reward", "bonus", "multiplier", "how to earn"]
            ),
            ProfileLinkItem(
                title: "Tiers & Benefits",
                iconName: "medal",
                searchKeywords: ["tiers", "benefits", "Blu", "Blu2", "Blu3", "status", "elite", "privilege", "lounge", "priority", "upgrade", "silver", "gold"]
            ),
            ProfileLinkItem(
                title: "IndiGo BluChips Terms and Conditions",
                iconName: "doc.text",
                searchKeywords: ["terms", "conditions", "BluChip", "T&C", "policy", "rules", "expiry", "validity", "governance", "legal"]
            ),
            ProfileLinkItem(
                title: "About IndiGo BluChip",
                iconName: "info.circle",
                searchKeywords: ["about", "BluChip", "loyalty", "program", "overview", "what is", "introduction", "guide", "learn"]
            ),
            ProfileLinkItem(
                title: "IndiGo BluChips FAQs",
                iconName: "questionmark.circle",
                searchKeywords: ["FAQ", "BluChip", "help", "question", "support", "how to", "guide", "troubleshoot", "common issues", "redeem"]
            ),
        ]),

        ProfileLinkSection(header: "OTHER INFORMATION", items: [
            ProfileLinkItem(
                title: "About Us",
                iconName: "book.closed",
                searchKeywords: ["about", "IndiGo", "company", "airline", "history", "fleet", "6E", "InterGlobe", "corporate", "mission"]
            ),
            ProfileLinkItem(
                title: "Contact Us",
                iconName: "phone",
                searchKeywords: ["contact", "support", "customer care", "helpline", "email", "call", "chat", "feedback", "complaint", "grievance", "DGCA", "helpdesk"]
            ),
            ProfileLinkItem(
                title: "Settings",
                iconName: "gearshape",
                searchKeywords: ["settings", "preferences", "notification", "language", "account", "password", "profile", "privacy", "security", "two-factor"]
            ),
            ProfileLinkItem(
                title: "Terms and Conditions",
                iconName: "doc.plaintext",
                searchKeywords: ["terms", "conditions", "T&C", "legal", "policy", "contract", "carriage", "refund", "cancellation", "baggage"]
            ),
            ProfileLinkItem(
                title: "Help & FAQs",
                iconName: "questionmark.bubble",
                searchKeywords: ["help", "FAQ", "support", "question", "guide", "troubleshoot", "issue", "resolve", "customer service"]
            ),
            ProfileLinkItem(
                title: "Log Out",
                iconName: "rectangle.portrait.and.arrow.right",
                isDestructive: true,
                searchKeywords: ["logout", "sign out", "exit", "end session", "disconnect"]
            ),
        ]),
    ]
}

// MARK: - PreferenceKey: search bar's minY in the profileCoord space

private struct SearchBarMinYKey: PreferenceKey {
    static var defaultValue: CGFloat = .infinity
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = min(value, nextValue())
    }
}

// MARK: - PreferenceKey: header bottom edge in the profileCoord space

private struct HeaderBottomYKey: PreferenceKey {
    static var defaultValue: CGFloat = 0
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

// MARK: - ProfileView

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var searchText = ""
    @State private var searchBarMinY: CGFloat = .infinity
    @State private var headerBottomY: CGFloat = 0

    private let powderBlue = Color(hex: "AFE4FF")
    private let borderColor = Color(hex: "000099")

    private var isSearchBarSticky: Bool {
        searchBarMinY <= headerBottomY + 1
    }

    private var filteredSections: [ProfileLinkSection] {
        guard !searchText.isEmpty else { return ProfileLinkData.sections }

        let query = searchText.lowercased()
        return ProfileLinkData.sections.compactMap { section in
            let filtered = section.items.filter { item in
                item.title.lowercased().contains(query) ||
                item.searchKeywords.contains { $0.lowercased().contains(query) }
            }
            return filtered.isEmpty ? nil : ProfileLinkSection(header: section.header, items: filtered)
        }
    }

    private let coordSpace = "profileCoord"

    var body: some View {
        ZStack(alignment: .top) {
            Color.white.ignoresSafeArea()

            ScrollView(.vertical, showsIndicators: false) {
                VStack(spacing: 0) {
                    Color.clear.frame(height: 48)

                    profileInfoSection
                    walletSection

                    searchBarInContent
                        .background(
                            GeometryReader { geo in
                                Color.clear.preference(
                                    key: SearchBarMinYKey.self,
                                    value: geo.frame(in: .named(coordSpace)).minY
                                )
                            }
                        )

                    linksListContent
                    versionLabel
                }
            }
            .coordinateSpace(name: coordSpace)
            .onPreferenceChange(SearchBarMinYKey.self) { value in
                searchBarMinY = value
            }

            VStack(spacing: 0) {
                stickyHeader
                    .background(
                        GeometryReader { geo in
                            Color.clear.preference(
                                key: HeaderBottomYKey.self,
                                value: geo.frame(in: .named(coordSpace)).maxY
                            )
                        }
                    )

                if isSearchBarSticky {
                    searchBarOverlay
                }
            }
            .onPreferenceChange(HeaderBottomYKey.self) { value in
                headerBottomY = value
            }
        }
        .navigationBarBackButtonHidden()
    }

    // MARK: - Sticky header

    private var stickyHeader: some View {
        HStack(spacing: IndiGoSpacing.sm) {
            Button(action: { dismiss() }) {
                Image(systemName: "xmark")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundStyle(IndiGoColors.indigoBlue)
                    .frame(width: 24, height: 24)
            }
            .frame(width: 53, alignment: .leading)

            Spacer()

            Text("My Profile")
                .font(IndiGoFonts.displayXS())
                .foregroundStyle(IndiGoColors.backgroundBase)

            Spacer()

            Color.clear.frame(width: 53, height: 32)
        }
        .padding(.horizontal, IndiGoSpacing.lg)
        .padding(.vertical, IndiGoSpacing.sm)
        .background(
            Rectangle()
                .fill(.ultraThinMaterial)
                .opacity(0.95)
                .shadow(color: IndiGoColors.cardSoftShadow, radius: 14, x: 0, y: 0)
        )
    }

    // MARK: - Search bar (in-content, natural position)

    private var searchBarInContent: some View {
        searchBarPill
            .padding(.horizontal, IndiGoSpacing.md)
            .padding(.vertical, IndiGoSpacing.sm)
            .opacity(isSearchBarSticky ? 0 : 1)
    }

    // MARK: - Search bar (sticky overlay)

    private var searchBarOverlay: some View {
        searchBarPill
            .padding(.horizontal, IndiGoSpacing.md)
            .padding(.vertical, IndiGoSpacing.sm)
            .background(
                Rectangle()
                    .fill(.ultraThinMaterial)
                    .opacity(0.9)
                    .shadow(color: Color(hex: "4C5D9E").opacity(0.12), radius: 14, x: 0, y: 4)
            )
    }

    private var searchBarPill: some View {
        HStack(spacing: IndiGoSpacing.md) {
            Image(systemName: "magnifyingglass")
                .font(.system(size: 18))
                .foregroundStyle(IndiGoColors.indigoBlue)

            TextField("Search", text: $searchText)
                .font(IndiGoFonts.body())
                .foregroundStyle(IndiGoColors.indigoBlue)
                .autocorrectionDisabled()

            if !searchText.isEmpty {
                Button(action: { searchText = "" }) {
                    Image(systemName: "xmark.circle.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(IndiGoColors.textDarkGrey)
                }
            } else {
                Image(systemName: "mic")
                    .font(.system(size: 18))
                    .foregroundStyle(IndiGoColors.indigoBlue)
            }
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .frame(height: 60)
        .background(
            ZStack {
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusFull)
                    .fill(.ultraThinMaterial)
                RoundedRectangle(cornerRadius: IndiGoSpacing.radiusFull)
                    .fill(Color.white.opacity(0.6))
                    .blendMode(.hardLight)
            }
        )
        .overlay(
            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusFull)
                .strokeBorder(borderColor, lineWidth: 2)
        )
    }

    // MARK: - Profile info

    private var profileInfoSection: some View {
        VStack(spacing: IndiGoSpacing.md) {
            HStack(spacing: IndiGoSpacing.sm) {
                Image("profile-avatar")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 48, height: 48)
                    .clipShape(Circle())

                VStack(alignment: .leading, spacing: 2) {
                    Text("Ishika Verma")
                        .font(IndiGoFonts.displayXS())
                        .foregroundStyle(IndiGoColors.backgroundBase)
                    Text("12,432 IndiGo BluChips")
                        .font(.custom("Poppins-Medium", size: 10))
                        .foregroundStyle(IndiGoColors.indigoBlue)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.textDarkGrey)
            }

            Divider()
                .frame(height: 1)
                .background(powderBlue)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.top, IndiGoSpacing.md)
    }

    // MARK: - Wallet section

    private var walletSection: some View {
        VStack(spacing: IndiGoSpacing.md) {
            HStack(spacing: IndiGoSpacing.sm) {
                Image(systemName: "indianrupeesign.circle.fill")
                    .font(.system(size: 40))
                    .foregroundStyle(Color(hex: "FFD700"))
                    .frame(width: 48, height: 48)

                VStack(alignment: .leading, spacing: 2) {
                    Text("₹1,824")
                        .font(IndiGoFonts.displayXS())
                        .foregroundStyle(IndiGoColors.backgroundBase)
                    Text("Active e-Wallet Balance")
                        .font(.custom("Poppins-Medium", size: 10))
                        .foregroundStyle(IndiGoColors.indigoBlue)
                }

                Spacer()

                Button(action: {}) {
                    Text("Redeem")
                        .font(IndiGoFonts.bodySmallMedium())
                        .foregroundStyle(IndiGoColors.indigoBlue)
                        .frame(width: 75, height: 32)
                        .overlay(
                            RoundedRectangle(cornerRadius: IndiGoSpacing.radiusFull)
                                .strokeBorder(IndiGoColors.indigoBlue, lineWidth: 2)
                        )
                }

                Image(systemName: "chevron.right")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.textDarkGrey)
            }

            Divider()
                .frame(height: 1)
                .background(powderBlue)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.top, IndiGoSpacing.md)
    }

    // MARK: - Links list

    private var linksListContent: some View {
        VStack(spacing: 0) {
            ForEach(filteredSections) { section in
                linkSectionView(section)
            }
        }
    }

    private func linkSectionView(_ section: ProfileLinkSection) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(section.header)
                .font(IndiGoFonts.body())
                .foregroundStyle(IndiGoColors.textDarkGrey)
                .textCase(.uppercase)
                .padding(.horizontal, IndiGoSpacing.xl)
                .padding(.top, IndiGoSpacing.xxl)
                .padding(.bottom, IndiGoSpacing.xxs)

            VStack(spacing: 0) {
                ForEach(section.items) { item in
                    linkRow(item)
                }
            }
            .padding(.horizontal, IndiGoSpacing.md)
        }
    }

    private func linkRow(_ item: ProfileLinkItem) -> some View {
        Button(action: {}) {
            HStack(spacing: IndiGoSpacing.md) {
                Image(systemName: item.iconName)
                    .font(.system(size: 14))
                    .foregroundStyle(item.isDestructive ? Color(hex: "C3272E") : IndiGoColors.indigoBlue)
                    .frame(width: 16, height: 16)

                Text(item.title)
                    .font(IndiGoFonts.body())
                    .foregroundStyle(item.isDestructive ? Color(hex: "C3272E") : IndiGoColors.indigoBlue)
                    .lineLimit(1)

                Spacer()

                if let badge = item.badge, let color = item.badgeColor {
                    Text(badge)
                        .font(.custom("Poppins-Regular", size: 8))
                        .foregroundStyle(.white)
                        .padding(.horizontal, IndiGoSpacing.xs)
                        .frame(height: 16)
                        .background(color)
                        .clipShape(Capsule())
                }
            }
            .padding(.horizontal, IndiGoSpacing.md)
            .padding(.vertical, IndiGoSpacing.lg)
            .overlay(alignment: .bottom) {
                Rectangle()
                    .fill(powderBlue)
                    .frame(height: 1)
            }
        }
        .buttonStyle(.plain)
    }

    // MARK: - Version

    private var versionLabel: some View {
        Text("Version 7.3.2")
            .font(.custom("Poppins-Regular", size: 10))
            .foregroundStyle(Color(hex: "9BA4B8"))
            .padding(.vertical, IndiGoSpacing.sm)
            .padding(.horizontal, IndiGoSpacing.lg)
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.bottom, 60)
    }
}

#Preview {
    NavigationStack {
        ProfileView()
    }
}
