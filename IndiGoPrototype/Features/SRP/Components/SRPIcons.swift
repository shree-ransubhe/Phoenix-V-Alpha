import SwiftUI

/// Custom pencil/edit icon from Figma SVG (node 3:8446)
struct EditPencilIcon: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let sx = w / 16
        let sy = h / 16

        var path = Path()

        // Bottom line
        path.move(to: CGPoint(x: 8 * sx, y: 13.5 * sy))
        path.addLine(to: CGPoint(x: 8 * sx, y: 13.5 * sy))
        path.addRoundedRect(in: CGRect(x: 8 * sx, y: 13 * sy, width: 6.0017 * sx, height: 1 * sy), cornerSize: .init(width: 0.5 * sx, height: 0.5 * sy))

        // Pencil body
        path.move(to: CGPoint(x: 10.729 * sx, y: 3.15145 * sy))
        path.addLine(to: CGPoint(x: 3.15133 * sx, y: 10.7291 * sy))
        path.addCurve(
            to: CGPoint(x: 3.00636 * sx, y: 11.121 * sy),
            control1: CGPoint(x: 3.04812 * sx, y: 10.8323 * sy),
            control2: CGPoint(x: 2.99517 * sx, y: 10.9755 * sy)
        )
        path.addLine(to: CGPoint(x: 3.14031 * sx, y: 12.8623 * sy))
        path.addLine(to: CGPoint(x: 4.88142 * sx, y: 12.9963 * sy))
        path.addCurve(
            to: CGPoint(x: 5.27344 * sx, y: 12.8512 * sy),
            control1: CGPoint(x: 5.02701 * sx, y: 13.0075 * sy),
            control2: CGPoint(x: 5.17023 * sx, y: 12.9545 * sy)
        )
        path.addLine(to: CGPoint(x: 12.8471 * sx, y: 5.27229 * sy))
        path.addCurve(
            to: CGPoint(x: 12.8474 * sx, y: 4.56567 * sy),
            control1: CGPoint(x: 13.0421 * sx, y: 5.07715 * sy),
            control2: CGPoint(x: 13.0422 * sx, y: 4.76095 * sy)
        )
        path.addLine(to: CGPoint(x: 11.4365 * sx, y: 3.15182 * sy))
        path.addCurve(
            to: CGPoint(x: 10.729 * sx, y: 3.15145 * sy),
            control1: CGPoint(x: 11.2413 * sx, y: 2.95621 * sy),
            control2: CGPoint(x: 10.9244 * sx, y: 2.95604 * sy)
        )
        path.closeSubpath()

        return path
    }
}

/// IndiGo airline logo dots (simplified from SVG)
struct IndiGoLogoShape: View {
    var color: Color = IndiGoColors.primaryMain

    var body: some View {
        Canvas { context, size in
            let sx = size.width / 8
            let sy = size.height / 8

            let dots: [(CGFloat, CGFloat, CGFloat)] = [
                (2.344, 7.694, 0.306),
                (2.344, 6.672, 0.306),
                (6.249, 5.829, 0.306),
                (0.306, 5.652, 0.306),
                (1.326, 5.652, 0.306),
                (2.344, 5.652, 0.306),
                (6.249, 4.808, 0.306),
                (3.788, 4.212, 0.306),
                (6.249, 3.789, 0.306),
                (6.249, 2.770, 0.306),
                (2.170, 1.747, 0.306),
                (3.190, 1.747, 0.306),
                (4.212, 1.747, 0.306),
                (5.231, 1.747, 0.306),
                (6.249, 1.747, 0.306),
            ]

            let diamonds: [(CGFloat, CGFloat)] = [
                (3.066, 4.930),
                (4.509, 3.489),
                (5.231, 2.766),
                (6.969, 1.027),
                (7.693, 0.306),
            ]

            for (cx, cy, r) in dots {
                let rect = CGRect(
                    x: cx * sx - r * sx,
                    y: cy * sy - r * sy,
                    width: r * 2 * sx,
                    height: r * 2 * sy
                )
                context.fill(Circle().path(in: rect), with: .color(color))
            }

            for (cx, cy) in diamonds {
                let r: CGFloat = 0.21
                let rect = CGRect(
                    x: cx * sx - r * sx,
                    y: cy * sy - r * sy,
                    width: r * 2 * sx,
                    height: r * 2 * sy
                )
                context.fill(
                    RoundedRectangle(cornerRadius: 0.5).path(in: rect),
                    with: .color(color)
                )
            }
        }
    }
}

/// Stretch/Business seat icon (white, from Figma SVG)
struct StretchSeatIcon: View {
    var color: Color = .white

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let sx = w / 14
            let sy = h / 14

            // Seat back (rounded rect outline)
            var seatBack = Path()
            seatBack.addRoundedRect(
                in: CGRect(x: 8.75 * sx, y: 2.625 * sy, width: 2.625 * sx, height: 3.9375 * sy),
                cornerSize: CGSize(width: 1.3125 * sx, height: 1.3125 * sy)
            )
            context.stroke(seatBack, with: .color(color), lineWidth: 0.875 * sx)

            // Armrest line
            var armrest = Path()
            armrest.move(to: CGPoint(x: 8.458 * sx, y: 4.229 * sy))
            armrest.addLine(to: CGPoint(x: 11.667 * sx, y: 4.229 * sy))
            context.stroke(armrest, with: .color(color), lineWidth: 0.875 * sx)

            // Seat base path
            var seatBase = Path()
            seatBase.move(to: CGPoint(x: 3.113 * sx, y: 3.208 * sy))
            seatBase.addCurve(
                to: CGPoint(x: 4.444 * sx, y: 3.407 * sy),
                control1: CGPoint(x: 3.113 * sx, y: 3.208 * sy),
                control2: CGPoint(x: 3.754 * sx, y: 2.781 * sy)
            )
            seatBase.addLine(to: CGPoint(x: 5.378 * sx, y: 7.729 * sy))
            seatBase.addLine(to: CGPoint(x: 7.432 * sx, y: 7.729 * sy))
            seatBase.addCurve(
                to: CGPoint(x: 8.817 * sx, y: 9.115 * sy),
                control1: CGPoint(x: 8.197 * sx, y: 7.729 * sy),
                control2: CGPoint(x: 8.817 * sx, y: 8.349 * sy)
            )
            seatBase.addCurve(
                to: CGPoint(x: 7.432 * sx, y: 10.5 * sy),
                control1: CGPoint(x: 8.817 * sx, y: 9.880 * sy),
                control2: CGPoint(x: 8.197 * sx, y: 10.5 * sy)
            )
            seatBase.addLine(to: CGPoint(x: 4.974 * sx, y: 10.5 * sy))
            context.stroke(seatBase, with: .color(color), lineWidth: 0.875 * sx)

            // Bottom bar
            var bottom = Path()
            bottom.move(to: CGPoint(x: 5.104 * sx, y: 11.813 * sy))
            bottom.addLine(to: CGPoint(x: 8.313 * sx, y: 11.813 * sy))
            context.stroke(bottom, with: .color(color), lineWidth: 0.875 * sx)
        }
    }
}

/// Economy seat icon (from Figma SVG)
struct EconomySeatIcon: View {
    var color: Color = Color(hex: "5E6167")

    var body: some View {
        Canvas { context, size in
            let w = size.width
            let h = size.height
            let sx = w / 14
            let sy = h / 14

            // Seat back
            var back = Path()
            back.move(to: CGPoint(x: 4.168 * sx, y: 2.042 * sy))
            back.addLine(to: CGPoint(x: 5.362 * sx, y: 8.772 * sy))
            back.addCurve(
                to: CGPoint(x: 6.654 * sx, y: 9.856 * sy),
                control1: CGPoint(x: 5.473 * sx, y: 9.399 * sy),
                control2: CGPoint(x: 6.018 * sx, y: 9.856 * sy)
            )
            back.addLine(to: CGPoint(x: 9.498 * sx, y: 9.856 * sy))
            back.addCurve(
                to: CGPoint(x: 9.935 * sx, y: 9.418 * sy),
                control1: CGPoint(x: 9.739 * sx, y: 9.856 * sy),
                control2: CGPoint(x: 9.935 * sx, y: 9.660 * sy)
            )
            back.addLine(to: CGPoint(x: 9.935 * sx, y: 8.786 * sy))
            back.addCurve(
                to: CGPoint(x: 9.498 * sx, y: 8.348 * sy),
                control1: CGPoint(x: 9.935 * sx, y: 8.544 * sy),
                control2: CGPoint(x: 9.739 * sx, y: 8.348 * sy)
            )
            back.addLine(to: CGPoint(x: 7.078 * sx, y: 8.348 * sy))
            context.stroke(back, with: .color(color), lineWidth: 0.875 * sx)

            // Armrest
            var arm = Path()
            arm.move(to: CGPoint(x: 6.244 * sx, y: 5.808 * sy))
            arm.addLine(to: CGPoint(x: 9.608 * sx, y: 5.808 * sy))
            context.stroke(arm, with: .color(color), lineWidth: 0.875 * sx)

            // Leg
            var leg = Path()
            leg.move(to: CGPoint(x: 6.729 * sx, y: 10.179 * sy))
            leg.addLine(to: CGPoint(x: 5.986 * sx, y: 11.219 * sy))
            leg.addCurve(
                to: CGPoint(x: 6.817 * sx, y: 11.958 * sy),
                control1: CGPoint(x: 5.504 * sx, y: 11.894 * sy),
                control2: CGPoint(x: 5.987 * sx, y: 12.833 * sy)
            )
            leg.addLine(to: CGPoint(x: 10.751 * sx, y: 11.958 * sy))
            context.stroke(leg, with: .color(color), lineWidth: 0.875 * sx)
        }
    }
}

/// Flight airplane icon pointing right (from Figma SVG)
struct FlightPathAirplaneIcon: Shape {
    func path(in rect: CGRect) -> Path {
        let w = rect.width
        let h = rect.height
        let sx = w / 8
        let sy = h / 10

        var p = Path()
        p.move(to: CGPoint(x: 3.288 * sx, y: 0.238 * sy))
        p.addLine(to: CGPoint(x: 5.181 * sx, y: 3.886 * sy))
        p.addLine(to: CGPoint(x: 7.396 * sx, y: 3.886 * sy))
        p.addCurve(
            to: CGPoint(x: 8 * sx, y: 4.571 * sy),
            control1: CGPoint(x: 7.730 * sx, y: 3.886 * sy),
            control2: CGPoint(x: 8 * sx, y: 4.192 * sy)
        )
        p.addCurve(
            to: CGPoint(x: 7.396 * sx, y: 5.257 * sy),
            control1: CGPoint(x: 8 * sx, y: 4.951 * sy),
            control2: CGPoint(x: 7.730 * sx, y: 5.257 * sy)
        )
        p.addLine(to: CGPoint(x: 5.181 * sx, y: 5.257 * sy))
        p.addLine(to: CGPoint(x: 3.288 * sx, y: 8.905 * sy))
        p.addCurve(
            to: CGPoint(x: 2.926 * sx, y: 9.143 * sy),
            control1: CGPoint(x: 3.216 * sx, y: 9.051 * sy),
            control2: CGPoint(x: 3.075 * sx, y: 9.143 * sy)
        )
        p.addCurve(
            to: CGPoint(x: 2.519 * sx, y: 8.530 * sy),
            control1: CGPoint(x: 2.644 * sx, y: 9.143 * sy),
            control2: CGPoint(x: 2.443 * sx, y: 8.837 * sy)
        )
        p.addLine(to: CGPoint(x: 3.365 * sx, y: 5.257 * sy))
        p.addLine(to: CGPoint(x: 1.154 * sx, y: 5.257 * sy))
        p.addLine(to: CGPoint(x: 0.610 * sx, y: 6.290 * sy))
        p.addCurve(
            to: CGPoint(x: 0.437 * sx, y: 6.400 * sy),
            control1: CGPoint(x: 0.574 * sx, y: 6.359 * sy),
            control2: CGPoint(x: 0.506 * sx, y: 6.400 * sy)
        )
        p.addLine(to: CGPoint(x: 0.204 * sx, y: 6.400 * sy))
        p.addCurve(
            to: CGPoint(x: 0.006 * sx, y: 6.117 * sy),
            control1: CGPoint(x: 0.071 * sx, y: 6.400 * sy),
            control2: CGPoint(x: -0.026 * sx, y: 6.258 * sy)
        )
        p.addLine(to: CGPoint(x: 0.300 * sx, y: 4.782 * sy))
        p.addLine(to: CGPoint(x: 0.349 * sx, y: 4.571 * sy))
        p.addLine(to: CGPoint(x: 0.312 * sx, y: 4.398 * sy))
        p.addLine(to: CGPoint(x: 0.268 * sx, y: 4.206 * sy))
        p.addLine(to: CGPoint(x: 0.075 * sx, y: 3.337 * sy))
        p.addLine(to: CGPoint(x: 0.006 * sx, y: 3.031 * sy))
        p.addCurve(
            to: CGPoint(x: 0.204 * sx, y: 2.747 * sy),
            control1: CGPoint(x: -0.026 * sx, y: 2.885 * sy),
            control2: CGPoint(x: 0.071 * sx, y: 2.747 * sy)
        )
        p.addLine(to: CGPoint(x: 0.437 * sx, y: 2.747 * sy))
        p.addCurve(
            to: CGPoint(x: 0.610 * sx, y: 2.857 * sy),
            control1: CGPoint(x: 0.510 * sx, y: 2.747 * sy),
            control2: CGPoint(x: 0.574 * sx, y: 2.789 * sy)
        )
        p.addLine(to: CGPoint(x: 1.154 * sx, y: 3.886 * sy))
        p.addLine(to: CGPoint(x: 3.369 * sx, y: 3.886 * sy))
        p.addLine(to: CGPoint(x: 2.523 * sx, y: 0.613 * sy))
        p.addCurve(
            to: CGPoint(x: 2.926 * sx, y: 0 * sy),
            control1: CGPoint(x: 2.443 * sx, y: 0.306 * sy),
            control2: CGPoint(x: 2.644 * sx, y: 0 * sy)
        )
        p.addCurve(
            to: CGPoint(x: 3.288 * sx, y: 0.238 * sy),
            control1: CGPoint(x: 3.075 * sx, y: 0 * sy),
            control2: CGPoint(x: 3.216 * sx, y: 0.091 * sy)
        )
        p.closeSubpath()
        return p
    }
}

/// Landing circle icon
struct LandingCircleIcon: View {
    var color: Color = Color(hex: "7A85A0")

    var body: some View {
        Circle()
            .stroke(color, lineWidth: 1)
            .frame(width: 4, height: 4)
    }
}

/// Chevron-down icon for dropdown
struct DropdownChevronIcon: View {
    var color: Color = IndiGoColors.primaryMain

    var body: some View {
        Image(systemName: "chevron.down")
            .font(.system(size: 10, weight: .medium))
            .foregroundStyle(color)
    }
}
