import SwiftUI

/// "Compare our classes" CTA with divider lines on each side.
/// Figma node 3:8527 – pill with border, chevron-right icon, decorative lines.
struct SRPCompareClassesCTA: View {
    var onTap: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            dashedDivider

            Button(action: onTap) {
                HStack(spacing: 6) {
                    Text("Compare our classes")
                        .font(IndiGoFonts.bodyExtraSmallMedium())
                        .foregroundStyle(IndiGoColors.primaryMain)
                        .fixedSize(horizontal: true, vertical: false)
                        .lineLimit(1)

                    Image(systemName: "chevron.right")
                        .font(.system(size: 8, weight: .bold))
                        .foregroundStyle(IndiGoColors.primaryMain)
                }
                .padding(.horizontal, IndiGoSpacing.md)
                .padding(.vertical, IndiGoSpacing.xxs)
                .background(.white)
                .clipShape(Capsule())
                .overlay(
                    Capsule()
                        .stroke(IndiGoColors.primaryMain, lineWidth: 1)
                )
                .fixedSize()
            }
            .buttonStyle(.plain)

            dashedDivider
        }
        .padding(.vertical, IndiGoSpacing.xxs)
    }

    private var dashedDivider: some View {
        GeometryReader { geo in
            Path { path in
                path.move(to: CGPoint(x: 0, y: geo.size.height / 2))
                path.addLine(to: CGPoint(x: geo.size.width, y: geo.size.height / 2))
            }
            .stroke(IndiGoColors.srpCardBorder, lineWidth: 1)
        }
        .frame(height: 1)
    }
}

#Preview {
    SRPCompareClassesCTA()
        .padding()
        .background(Color(hex: "EAF8FF"))
}
