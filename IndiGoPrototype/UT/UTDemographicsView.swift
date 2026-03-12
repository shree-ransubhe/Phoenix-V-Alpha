//
//  UTDemographicsView.swift
//  IndiGoPrototype
//
//  Quick demographics form that drives automated session titles.
//

#if UT_VARIANT
import SwiftUI

struct UTDemographicsView: View {
    let onStart: (UTDemographics) -> Void

    @State private var role = "Occasional"
    @State private var experience = "Comfortable"
    @State private var ageBand = "25-34"
    @State private var device = "Provided"

    private let roles = ["First-time", "Occasional", "Frequent"]
    private let experiences = ["New", "Comfortable", "Expert"]
    private let ageBands = ["18-24", "25-34", "35-44", "45-54", "55+", "Prefer not to say"]
    private let devices = ["Personal", "Provided"]

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 24) {
                Text("About You")
                    .font(.custom("BauhausStd-Medium", size: 24))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .padding(.top, 16)

                Text("A few quick questions so we can label this session. Everything is optional.")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)

                chipSection(title: "How often do you travel?", options: roles, selection: $role)
                chipSection(title: "Experience with booking apps", options: experiences, selection: $experience)
                chipSection(title: "Age band", options: ageBands, selection: $ageBand)
                chipSection(title: "Device", options: devices, selection: $device)

                Spacer(minLength: 24)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 100)
        }
        .safeAreaInset(edge: .bottom) {
            Button(action: {
                onStart(UTDemographics(
                    role: role,
                    experience: experience,
                    ageBand: ageBand,
                    device: device
                ))
            }) {
                Text("Start Session")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(IndiGoColors.primaryMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 20)
            .background(.ultraThinMaterial)
        }
        .background(IndiGoColors.background.ignoresSafeArea())
    }

    private func chipSection(title: String, options: [String], selection: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(IndiGoFonts.bodySemiBold())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            FlowLayout(spacing: 8) {
                ForEach(options, id: \.self) { option in
                    let selected = selection.wrappedValue == option
                    Text(option)
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(selected ? .white : IndiGoColors.forYouTextSecondary)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 8)
                        .background(selected ? IndiGoColors.primaryMain : IndiGoColors.secondaryLight)
                        .clipShape(Capsule())
                        .overlay(Capsule().strokeBorder(
                            selected ? IndiGoColors.primaryMain : IndiGoColors.secondaryMedium,
                            lineWidth: 1
                        ))
                        .onTapGesture { selection.wrappedValue = option }
                        .animation(.easeInOut(duration: 0.2), value: selected)
                }
            }
        }
    }
}

// Simple flow layout for wrapping chips
private struct FlowLayout: Layout {
    var spacing: CGFloat = 8

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let result = arrange(proposal: proposal, subviews: subviews)
        return result.size
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let result = arrange(proposal: proposal, subviews: subviews)
        for (index, subview) in subviews.enumerated() {
            let point = CGPoint(
                x: bounds.minX + result.positions[index].x,
                y: bounds.minY + result.positions[index].y
            )
            subview.place(at: point, anchor: .topLeading, proposal: .unspecified)
        }
    }

    private func arrange(proposal: ProposedViewSize, subviews: Subviews) -> (positions: [CGPoint], size: CGSize) {
        let maxWidth = proposal.width ?? .infinity
        var positions: [CGPoint] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0

        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x + size.width > maxWidth, x > 0 {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            positions.append(CGPoint(x: x, y: y))
            rowHeight = max(rowHeight, size.height)
            x += size.width + spacing
        }

        return (positions, CGSize(width: maxWidth, height: y + rowHeight))
    }
}
#endif
