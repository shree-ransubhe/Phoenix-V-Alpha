import SwiftUI

/// Pill-shaped search summary card at the top of SRP.
/// Shows route, trip type, dates, pax count, currency. Tappable for quick edits.
struct SRPReferenceCard: View {
    let origin: String
    let destination: String
    let tripType: String
    let dates: String
    let paxCount: Int
    let currency: String
    var onBack: () -> Void = {}
    var onEdit: () -> Void = {}

    var body: some View {
        HStack(spacing: 0) {
            Button(action: onBack) {
                Image(systemName: "chevron.left")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)
                    .frame(width: 16, height: 16)
            }
            .buttonStyle(.plain)

            Spacer(minLength: 0)

            VStack(spacing: 0) {
                Text("\(origin) to \(destination)")
                    .font(IndiGoFonts.bodyMedium())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .lineSpacing(6)

                HStack(spacing: IndiGoSpacing.sm) {
                    infoChip(tripType)
                    dotSeparator
                    infoChip(dates)
                    dotSeparator
                    infoChip("\(paxCount) Pax")
                    dotSeparator
                    infoChip(currency)
                }
            }
            .padding(.horizontal, IndiGoSpacing.sm)
            .padding(.vertical, IndiGoSpacing.xs)

            Spacer(minLength: 0)

            Button(action: onEdit) {
                editPencilView
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, IndiGoSpacing.md)
        .padding(.vertical, IndiGoSpacing.xs)
        .frame(height: 52)
        .background(.white)
        .clipShape(Capsule())
        .shadow(color: .black.opacity(0.12), radius: 8, x: 0, y: 4)
    }

    private var editPencilView: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let s = min(w, h) / 16
            let fillColor = IndiGoColors.primaryMain

            // Bottom line: rounded rect from x=8..14, y=13..14
            let lineRect = CGRect(x: 8 * s, y: 13 * s, width: 6 * s, height: 1 * s)
            context.fill(RoundedRectangle(cornerRadius: 0.5 * s).path(in: lineRect), with: .color(fillColor))

            // Pencil body outline
            var pencil = Path()
            pencil.move(to: CGPoint(x: 10.729 * s, y: 3.152 * s))
            pencil.addLine(to: CGPoint(x: 3.151 * s, y: 10.729 * s))
            pencil.addCurve(to: CGPoint(x: 3.006 * s, y: 11.121 * s),
                            control1: CGPoint(x: 3.048 * s, y: 10.832 * s),
                            control2: CGPoint(x: 2.995 * s, y: 10.976 * s))
            pencil.addLine(to: CGPoint(x: 3.140 * s, y: 12.862 * s))
            pencil.addLine(to: CGPoint(x: 4.881 * s, y: 12.996 * s))
            pencil.addCurve(to: CGPoint(x: 5.273 * s, y: 12.851 * s),
                            control1: CGPoint(x: 5.027 * s, y: 13.008 * s),
                            control2: CGPoint(x: 5.170 * s, y: 12.955 * s))
            pencil.addLine(to: CGPoint(x: 12.847 * s, y: 5.272 * s))
            pencil.addCurve(to: CGPoint(x: 12.847 * s, y: 4.566 * s),
                            control1: CGPoint(x: 13.042 * s, y: 5.077 * s),
                            control2: CGPoint(x: 13.042 * s, y: 4.761 * s))
            pencil.addLine(to: CGPoint(x: 11.437 * s, y: 3.152 * s))
            pencil.addCurve(to: CGPoint(x: 10.729 * s, y: 3.152 * s),
                            control1: CGPoint(x: 11.241 * s, y: 2.956 * s),
                            control2: CGPoint(x: 10.924 * s, y: 2.956 * s))
            pencil.closeSubpath()
            context.stroke(pencil, with: .color(fillColor), lineWidth: 1.0)

            // Diagonal accent line
            var diag = Path()
            diag.move(to: CGPoint(x: 8.658 * s, y: 4.515 * s))
            diag.addLine(to: CGPoint(x: 12.194 * s, y: 6.637 * s))
            context.stroke(diag, with: .color(fillColor), lineWidth: 1.0)
        }
        .frame(width: 16, height: 16)
    }

    private func infoChip(_ text: String) -> some View {
        Text(text)
            .font(IndiGoFonts.bodyExtraSmall())
            .foregroundStyle(IndiGoColors.forYouTextSecondary)
    }

    private var dotSeparator: some View {
        Circle()
            .fill(IndiGoColors.secondaryMedium)
            .frame(width: 4, height: 4)
    }
}

#Preview {
    SRPReferenceCard(
        origin: "Delhi",
        destination: "Mumbai",
        tripType: "Return",
        dates: "22-22 Jan",
        paxCount: 3,
        currency: "INR"
    )
    .padding()
    .background(Color(hex: "EAF8FF"))
}
