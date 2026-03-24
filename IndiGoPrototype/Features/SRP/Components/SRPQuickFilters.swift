import SwiftUI

/// Quick filter chips row + filter/sort button.
/// Figma v5.0 node 2382:40281 — white bg, bright blue chip borders, 12px label font, 40px filter icon.
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
                            withAnimation(.easeInOut(duration: 0.15)) {
                                if selectedFilters.contains(filter) {
                                    selectedFilters.remove(filter)
                                } else {
                                    selectedFilters.insert(filter)
                                }
                            }
                        }
                    }
                }
                .padding(.leading, IndiGoSpacing.sm)
                .padding(.trailing, IndiGoSpacing.xxxl)
            }

            Button(action: onFilterTap) {
                Image(systemName: "slider.horizontal.3")
                    .font(.system(size: 18, weight: .medium))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 40, height: 40)
                    .contentShape(Rectangle())
            }
            .buttonStyle(.plain)
        }
        .padding(.leading, IndiGoSpacing.sm)
        .padding(.vertical, IndiGoSpacing.xs)
        .background(.white)
    }
}

private struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: {
            HapticManager.selection()
            action()
        }) {
            Text(title)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(isSelected ? .white : IndiGoColors.forYouTextSecondary)
                .lineLimit(1)
                .padding(.horizontal, IndiGoSpacing.md)
                .padding(.vertical, IndiGoSpacing.xxs)
                .frame(minWidth: 48, minHeight: 28)
                .background(isSelected ? IndiGoColors.primaryMain : .white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(isSelected ? Color.clear : IndiGoColors.chipBorderBlue, lineWidth: 1)
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
