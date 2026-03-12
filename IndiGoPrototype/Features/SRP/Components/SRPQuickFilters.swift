import SwiftUI

/// Quick filter chips row + filter/sort button.
struct SRPQuickFilters: View {
    let filters: [String]
    @Binding var selectedFilters: Set<String>
    var onFilterTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: IndiGoSpacing.xs) {
                    ForEach(filters, id: \.self) { filter in
                        FilterChip(
                            title: filter,
                            isSelected: selectedFilters.contains(filter)
                        ) {
                            if selectedFilters.contains(filter) {
                                selectedFilters.remove(filter)
                            } else {
                                selectedFilters.insert(filter)
                            }
                        }
                    }
                }
                .padding(.leading, IndiGoSpacing.sm)
                .padding(.trailing, IndiGoSpacing.md)
            }

            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 14))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 32, height: 32)
                    .background(.white)
                    .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusSm))
                    .shadow(color: .black.opacity(0.12), radius: 3, x: -6, y: 0)
            }
            .buttonStyle(.plain)
        }
        .padding(IndiGoSpacing.sm)
        .background(.white)
        .clipShape(RoundedRectangle(cornerRadius: IndiGoSpacing.radiusMd))
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(IndiGoFonts.bodyExtraSmall())
                .foregroundStyle(isSelected ? .white : IndiGoColors.forYouTextSecondary)
                .padding(.horizontal, IndiGoSpacing.sm)
                .padding(.vertical, 6)
                .background(isSelected ? IndiGoColors.primaryMain : IndiGoColors.semiWhite)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : IndiGoColors.srpCardBorder, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}

#Preview {
    SRPQuickFilters(
        filters: MockFlights.quickFilters,
        selectedFilters: .constant(["Non-stop only"])
    )
    .padding()
    .background(Color(hex: "EAF8FF"))
}
