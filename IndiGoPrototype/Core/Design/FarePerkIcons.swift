import SwiftUI

/// Custom SVG-based icons for fare family perk rows.
/// Each icon is an 18×18 (or 16×16) vector converted to SwiftUI shapes.
enum FarePerkIcons {

    // MARK: - Icon Views

    struct CabinBag: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 18, height: 18)) { rect in
                let sx = rect.width / 18
                let sy = rect.height / 18
                var p = Path()
                // Main body
                p.move(to: CGPoint(x: 4.121 * sx, y: 9.624 * sy))
                p.addCurve(to: CGPoint(x: 5.809 * sx, y: 7.937 * sy),
                           control1: CGPoint(x: 4.121 * sx, y: 8.692 * sy),
                           control2: CGPoint(x: 4.877 * sx, y: 7.937 * sy))
                p.addLine(to: CGPoint(x: 12.186 * sx, y: 7.937 * sy))
                p.addCurve(to: CGPoint(x: 13.873 * sx, y: 9.624 * sy),
                           control1: CGPoint(x: 13.118 * sx, y: 7.937 * sy),
                           control2: CGPoint(x: 13.873 * sx, y: 8.692 * sy))
                p.addLine(to: CGPoint(x: 13.873 * sx, y: 13.689 * sy))
                p.addCurve(to: CGPoint(x: 12.186 * sx, y: 15.376 * sy),
                           control1: CGPoint(x: 13.873 * sx, y: 14.621 * sy),
                           control2: CGPoint(x: 13.118 * sx, y: 15.376 * sy))
                p.addLine(to: CGPoint(x: 5.809 * sx, y: 15.376 * sy))
                p.addCurve(to: CGPoint(x: 4.121 * sx, y: 13.689 * sy),
                           control1: CGPoint(x: 4.877 * sx, y: 15.376 * sy),
                           control2: CGPoint(x: 4.121 * sx, y: 14.621 * sy))
                p.closeSubpath()
                // Outer clip
                p.move(to: CGPoint(x: 2.996 * sx, y: 9.624 * sy))
                p.addCurve(to: CGPoint(x: 5.809 * sx, y: 6.812 * sy),
                           control1: CGPoint(x: 2.996 * sx, y: 8.071 * sy),
                           control2: CGPoint(x: 4.255 * sx, y: 6.812 * sy))
                p.addLine(to: CGPoint(x: 12.186 * sx, y: 6.812 * sy))
                p.addCurve(to: CGPoint(x: 14.998 * sx, y: 9.624 * sy),
                           control1: CGPoint(x: 13.739 * sx, y: 6.812 * sy),
                           control2: CGPoint(x: 14.998 * sx, y: 8.071 * sy))
                p.addLine(to: CGPoint(x: 14.998 * sx, y: 13.689 * sy))
                p.addCurve(to: CGPoint(x: 12.186 * sx, y: 16.501 * sy),
                           control1: CGPoint(x: 14.998 * sx, y: 15.242 * sy),
                           control2: CGPoint(x: 13.739 * sx, y: 16.501 * sy))
                p.addLine(to: CGPoint(x: 5.809 * sx, y: 16.501 * sy))
                p.addCurve(to: CGPoint(x: 2.996 * sx, y: 13.689 * sy),
                           control1: CGPoint(x: 4.255 * sx, y: 16.501 * sy),
                           control2: CGPoint(x: 2.996 * sx, y: 15.242 * sy))
                p.closeSubpath()
                // Left strap
                p.addRect(CGRect(x: 5.622 * sx, y: 7.374 * sy, width: 1.125 * sx, height: 8.564 * sy))
                // Handle
                p.move(to: CGPoint(x: 7.497 * sx, y: 3.187 * sy))
                p.addCurve(to: CGPoint(x: 8.060 * sx, y: 2.624 * sy),
                           control1: CGPoint(x: 7.497 * sx, y: 2.876 * sy),
                           control2: CGPoint(x: 7.749 * sx, y: 2.624 * sy))
                p.addLine(to: CGPoint(x: 9.935 * sx, y: 2.624 * sy))
                p.addCurve(to: CGPoint(x: 10.497 * sx, y: 3.187 * sy),
                           control1: CGPoint(x: 10.245 * sx, y: 2.624 * sy),
                           control2: CGPoint(x: 10.497 * sx, y: 2.876 * sy))
                p.addLine(to: CGPoint(x: 10.497 * sx, y: 7.374 * sy))
                p.addLine(to: CGPoint(x: 11.622 * sx, y: 7.374 * sy))
                p.addLine(to: CGPoint(x: 11.622 * sx, y: 3.187 * sy))
                p.addCurve(to: CGPoint(x: 9.935 * sx, y: 1.499 * sy),
                           control1: CGPoint(x: 11.622 * sx, y: 2.255 * sy),
                           control2: CGPoint(x: 10.867 * sx, y: 1.499 * sy))
                p.addLine(to: CGPoint(x: 8.060 * sx, y: 1.499 * sy))
                p.addCurve(to: CGPoint(x: 6.372 * sx, y: 3.187 * sy),
                           control1: CGPoint(x: 7.128 * sx, y: 1.499 * sy),
                           control2: CGPoint(x: 6.372 * sx, y: 2.255 * sy))
                p.addLine(to: CGPoint(x: 6.372 * sx, y: 7.374 * sy))
                p.addLine(to: CGPoint(x: 7.497 * sx, y: 7.374 * sy))
                p.closeSubpath()
                // Right strap
                p.addRect(CGRect(x: 11.247 * sx, y: 7.374 * sy, width: 1.125 * sx, height: 8.564 * sy))
                return p
            }
        }
    }

    struct CheckinBag: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 18, height: 18)) { rect in
                let sx = rect.width / 18
                let sy = rect.height / 18
                var p = Path()
                // Outer body
                p.move(to: CGPoint(x: 2.625 * sx, y: 6.625 * sy))
                p.addCurve(to: CGPoint(x: 4.313 * sx, y: 4.937 * sy),
                           control1: CGPoint(x: 2.625 * sx, y: 5.693 * sy),
                           control2: CGPoint(x: 3.381 * sx, y: 4.937 * sy))
                p.addLine(to: CGPoint(x: 13.690 * sx, y: 4.937 * sy))
                p.addCurve(to: CGPoint(x: 15.377 * sx, y: 6.625 * sy),
                           control1: CGPoint(x: 14.622 * sx, y: 4.937 * sy),
                           control2: CGPoint(x: 15.377 * sx, y: 5.693 * sy))
                p.addLine(to: CGPoint(x: 15.377 * sx, y: 12.939 * sy))
                p.addCurve(to: CGPoint(x: 13.690 * sx, y: 14.627 * sy),
                           control1: CGPoint(x: 15.377 * sx, y: 13.871 * sy),
                           control2: CGPoint(x: 14.622 * sx, y: 14.627 * sy))
                p.addLine(to: CGPoint(x: 4.313 * sx, y: 14.627 * sy))
                p.addCurve(to: CGPoint(x: 2.625 * sx, y: 12.939 * sy),
                           control1: CGPoint(x: 3.381 * sx, y: 14.627 * sy),
                           control2: CGPoint(x: 2.625 * sx, y: 13.871 * sy))
                p.closeSubpath()
                p.move(to: CGPoint(x: 1.5 * sx, y: 6.625 * sy))
                p.addCurve(to: CGPoint(x: 4.313 * sx, y: 3.812 * sy),
                           control1: CGPoint(x: 1.5 * sx, y: 5.071 * sy),
                           control2: CGPoint(x: 2.759 * sx, y: 3.812 * sy))
                p.addLine(to: CGPoint(x: 13.690 * sx, y: 3.812 * sy))
                p.addCurve(to: CGPoint(x: 16.502 * sx, y: 6.625 * sy),
                           control1: CGPoint(x: 15.243 * sx, y: 3.812 * sy),
                           control2: CGPoint(x: 16.502 * sx, y: 5.071 * sy))
                p.addLine(to: CGPoint(x: 16.502 * sx, y: 12.939 * sy))
                p.addCurve(to: CGPoint(x: 13.690 * sx, y: 15.752 * sy),
                           control1: CGPoint(x: 16.502 * sx, y: 14.492 * sy),
                           control2: CGPoint(x: 15.243 * sx, y: 15.752 * sy))
                p.addLine(to: CGPoint(x: 4.313 * sx, y: 15.752 * sy))
                p.addCurve(to: CGPoint(x: 1.5 * sx, y: 12.939 * sy),
                           control1: CGPoint(x: 2.759 * sx, y: 15.752 * sy),
                           control2: CGPoint(x: 1.5 * sx, y: 14.492 * sy))
                p.closeSubpath()
                // Handle
                p.move(to: CGPoint(x: 6.751 * sx, y: 3.937 * sy))
                p.addCurve(to: CGPoint(x: 8.064 * sx, y: 2.625 * sy),
                           control1: CGPoint(x: 6.751 * sx, y: 3.212 * sy),
                           control2: CGPoint(x: 7.339 * sx, y: 2.625 * sy))
                p.addLine(to: CGPoint(x: 9.939 * sx, y: 2.625 * sy))
                p.addCurve(to: CGPoint(x: 11.251 * sx, y: 3.937 * sy),
                           control1: CGPoint(x: 10.664 * sx, y: 2.625 * sy),
                           control2: CGPoint(x: 11.251 * sx, y: 3.212 * sy))
                p.addLine(to: CGPoint(x: 11.251 * sx, y: 4.375 * sy))
                p.addLine(to: CGPoint(x: 12.376 * sx, y: 4.375 * sy))
                p.addLine(to: CGPoint(x: 12.376 * sx, y: 3.937 * sy))
                p.addCurve(to: CGPoint(x: 9.939 * sx, y: 1.500 * sy),
                           control1: CGPoint(x: 12.376 * sx, y: 2.591 * sy),
                           control2: CGPoint(x: 11.285 * sx, y: 1.500 * sy))
                p.addLine(to: CGPoint(x: 8.064 * sx, y: 1.500 * sy))
                p.addCurve(to: CGPoint(x: 5.626 * sx, y: 3.937 * sy),
                           control1: CGPoint(x: 6.717 * sx, y: 1.500 * sy),
                           control2: CGPoint(x: 5.626 * sx, y: 2.591 * sy))
                p.addLine(to: CGPoint(x: 5.626 * sx, y: 4.375 * sy))
                p.addLine(to: CGPoint(x: 6.751 * sx, y: 4.375 * sy))
                p.closeSubpath()
                // 3 vertical stripes
                let stripeW = 1.125 * sx
                let stripeY = 7.126 * sy
                let stripeH = 5.250 * sy
                for cx in [6.001, 9.001, 12.001] {
                    p.addRect(CGRect(x: (cx - 0.563) * sx, y: stripeY, width: stripeW, height: stripeH))
                }
                return p
            }
        }
    }

    struct FastForward: View {
        var color: Color = Color(hex: "218946")
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 18, height: 18)) { rect in
                let sx = rect.width / 18
                let sy = rect.height / 18
                var p = Path()
                // Building outline
                p.move(to: CGPoint(x: 4.125 * sx, y: 5.063 * sy))
                p.addCurve(to: CGPoint(x: 5.813 * sx, y: 3.375 * sy),
                           control1: CGPoint(x: 4.125 * sx, y: 4.131 * sy),
                           control2: CGPoint(x: 4.881 * sx, y: 3.375 * sy))
                p.addLine(to: CGPoint(x: 12.188 * sx, y: 3.375 * sy))
                p.addCurve(to: CGPoint(x: 13.875 * sx, y: 5.063 * sy),
                           control1: CGPoint(x: 13.120 * sx, y: 3.375 * sy),
                           control2: CGPoint(x: 13.875 * sx, y: 4.131 * sy))
                p.addLine(to: CGPoint(x: 13.875 * sx, y: 15.0 * sy))
                p.addLine(to: CGPoint(x: 15.0 * sx, y: 15.0 * sy))
                p.addLine(to: CGPoint(x: 15.0 * sx, y: 5.063 * sy))
                p.addCurve(to: CGPoint(x: 12.188 * sx, y: 2.25 * sy),
                           control1: CGPoint(x: 15.0 * sx, y: 3.509 * sy),
                           control2: CGPoint(x: 13.741 * sx, y: 2.25 * sy))
                p.addLine(to: CGPoint(x: 5.813 * sx, y: 2.25 * sy))
                p.addCurve(to: CGPoint(x: 3.0 * sx, y: 5.063 * sy),
                           control1: CGPoint(x: 4.259 * sx, y: 2.25 * sy),
                           control2: CGPoint(x: 3.0 * sx, y: 3.509 * sy))
                p.addLine(to: CGPoint(x: 3.0 * sx, y: 15.0 * sy))
                p.addLine(to: CGPoint(x: 4.125 * sx, y: 15.0 * sy))
                p.closeSubpath()
                // Bottom-left base
                p.addRect(CGRect(x: 2.25 * sx, y: 14.625 * sy, width: 2.625 * sx, height: 1.125 * sy))
                // Bottom-right base
                p.addRect(CGRect(x: 13.125 * sx, y: 14.625 * sy, width: 2.625 * sx, height: 1.125 * sy))
                // Horizontal bar
                p.addRect(CGRect(x: 3.75 * sx, y: 6.375 * sy, width: 10.5 * sx, height: 1.125 * sy))
                // Lightning bolt
                p.move(to: CGPoint(x: 9.534 * sx, y: 9.928 * sy))
                p.addLine(to: CGPoint(x: 9.030 * sx, y: 11.438 * sy))
                p.addLine(to: CGPoint(x: 9.75 * sx, y: 11.438 * sy))
                p.addLine(to: CGPoint(x: 9.0 * sx, y: 14.0 * sy))
                p.addLine(to: CGPoint(x: 8.466 * sx, y: 14.072 * sy))
                p.addLine(to: CGPoint(x: 8.970 * sx, y: 12.563 * sy))
                p.addLine(to: CGPoint(x: 8.25 * sx, y: 12.563 * sy))
                p.addLine(to: CGPoint(x: 9.0 * sx, y: 9.928 * sy))
                p.closeSubpath()
                // Three dots
                for cx in [6.75, 9.0, 11.25] {
                    p.addEllipse(in: CGRect(x: (cx - 0.563) * sx, y: (4.875 - 0.563) * sy,
                                            width: 1.125 * sx, height: 1.125 * sy))
                }
                return p
            }
        }
    }

    struct Meal: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 16, height: 16)) { rect in
                let sx = rect.width / 16
                let sy = rect.height / 16
                var p = Path()
                // Fork handle + tines
                p.addRect(CGRect(x: 2.668 * sx, y: 1.333 * sy, width: 1.0 * sx, height: 4.167 * sy))
                p.addRect(CGRect(x: 5.001 * sx, y: 1.333 * sy, width: 1.0 * sx, height: 3.834 * sy))
                // Fork body arc
                p.move(to: CGPoint(x: 2.668 * sx, y: 5.5 * sy))
                p.addCurve(to: CGPoint(x: 5.501 * sx, y: 8.333 * sy),
                           control1: CGPoint(x: 2.668 * sx, y: 7.065 * sy),
                           control2: CGPoint(x: 3.937 * sx, y: 8.333 * sy))
                p.addCurve(to: CGPoint(x: 8.335 * sx, y: 5.5 * sy),
                           control1: CGPoint(x: 7.066 * sx, y: 8.333 * sy),
                           control2: CGPoint(x: 8.335 * sx, y: 7.065 * sy))
                p.addLine(to: CGPoint(x: 8.335 * sx, y: 1.833 * sy))
                p.addLine(to: CGPoint(x: 7.335 * sx, y: 1.833 * sy))
                p.addLine(to: CGPoint(x: 7.335 * sx, y: 5.5 * sy))
                p.addCurve(to: CGPoint(x: 5.501 * sx, y: 7.333 * sy),
                           control1: CGPoint(x: 7.335 * sx, y: 6.513 * sy),
                           control2: CGPoint(x: 6.514 * sx, y: 7.333 * sy))
                p.addCurve(to: CGPoint(x: 3.668 * sx, y: 5.5 * sy),
                           control1: CGPoint(x: 4.489 * sx, y: 7.333 * sy),
                           control2: CGPoint(x: 3.668 * sx, y: 6.513 * sy))
                p.addLine(to: CGPoint(x: 3.668 * sx, y: 1.833 * sy))
                p.addLine(to: CGPoint(x: 2.668 * sx, y: 1.833 * sy))
                p.closeSubpath()
                // Fork stem
                p.addRect(CGRect(x: 5.001 * sx, y: 7.833 * sy, width: 1.0 * sx, height: 6.833 * sy))
                // Knife
                p.move(to: CGPoint(x: 12.361 * sx, y: 2.541 * sy))
                p.addLine(to: CGPoint(x: 12.361 * sx, y: 13.320 * sy))
                p.addCurve(to: CGPoint(x: 12.014 * sx, y: 13.667 * sy),
                           control1: CGPoint(x: 12.361 * sx, y: 13.512 * sy),
                           control2: CGPoint(x: 12.206 * sx, y: 13.667 * sy))
                p.addCurve(to: CGPoint(x: 11.668 * sx, y: 13.320 * sy),
                           control1: CGPoint(x: 11.823 * sx, y: 13.667 * sy),
                           control2: CGPoint(x: 11.668 * sx, y: 13.512 * sy))
                p.addLine(to: CGPoint(x: 11.668 * sx, y: 10.333 * sy))
                p.addCurve(to: CGPoint(x: 11.01 * sx, y: 8.956 * sy),
                           control1: CGPoint(x: 11.668 * sx, y: 10.009 * sy),
                           control2: CGPoint(x: 11.368 * sx, y: 9.433 * sy))
                p.addLine(to: CGPoint(x: 10.713 * sx, y: 7.963 * sy))
                p.addCurve(to: CGPoint(x: 10.855 * sx, y: 5.626 * sy),
                           control1: CGPoint(x: 10.691 * sx, y: 7.319 * sy),
                           control2: CGPoint(x: 10.796 * sx, y: 6.493 * sy))
                p.addCurve(to: CGPoint(x: 12.033 * sx, y: 1.510 * sy),
                           control1: CGPoint(x: 10.958 * sx, y: 4.006 * sy),
                           control2: CGPoint(x: 11.474 * sx, y: 2.506 * sy))
                p.addCurve(to: CGPoint(x: 13.361 * sx, y: 2.159 * sy),
                           control1: CGPoint(x: 12.574 * sx, y: 1.090 * sy),
                           control2: CGPoint(x: 13.361 * sx, y: 1.475 * sy))
                p.closeSubpath()
                return p
            }
        }
    }

    struct Seat: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 16, height: 16)) { rect in
                let sx = rect.width / 16
                let sy = rect.height / 16
                var p = Path()
                // Seat base
                p.move(to: CGPoint(x: 4.165 * sx, y: 11.5 * sy))
                p.addCurve(to: CGPoint(x: 4.999 * sx, y: 10.667 * sy),
                           control1: CGPoint(x: 4.165 * sx, y: 11.04 * sy),
                           control2: CGPoint(x: 4.538 * sx, y: 10.667 * sy))
                p.addLine(to: CGPoint(x: 10.999 * sx, y: 10.667 * sy))
                p.addCurve(to: CGPoint(x: 11.832 * sx, y: 11.5 * sy),
                           control1: CGPoint(x: 11.459 * sx, y: 10.667 * sy),
                           control2: CGPoint(x: 11.832 * sx, y: 11.04 * sy))
                p.addCurve(to: CGPoint(x: 10.999 * sx, y: 12.333 * sy),
                           control1: CGPoint(x: 11.832 * sx, y: 11.96 * sy),
                           control2: CGPoint(x: 11.459 * sx, y: 12.333 * sy))
                p.addLine(to: CGPoint(x: 4.999 * sx, y: 12.333 * sy))
                p.addCurve(to: CGPoint(x: 4.165 * sx, y: 11.5 * sy),
                           control1: CGPoint(x: 4.538 * sx, y: 12.333 * sy),
                           control2: CGPoint(x: 4.165 * sx, y: 11.96 * sy))
                p.closeSubpath()
                p.move(to: CGPoint(x: 3.165 * sx, y: 11.5 * sy))
                p.addCurve(to: CGPoint(x: 4.999 * sx, y: 9.667 * sy),
                           control1: CGPoint(x: 3.165 * sx, y: 10.488 * sy),
                           control2: CGPoint(x: 3.986 * sx, y: 9.667 * sy))
                p.addLine(to: CGPoint(x: 10.999 * sx, y: 9.667 * sy))
                p.addCurve(to: CGPoint(x: 12.832 * sx, y: 11.5 * sy),
                           control1: CGPoint(x: 12.011 * sx, y: 9.667 * sy),
                           control2: CGPoint(x: 12.832 * sx, y: 10.488 * sy))
                p.addCurve(to: CGPoint(x: 10.999 * sx, y: 13.333 * sy),
                           control1: CGPoint(x: 12.832 * sx, y: 12.513 * sy),
                           control2: CGPoint(x: 12.011 * sx, y: 13.333 * sy))
                p.addLine(to: CGPoint(x: 4.999 * sx, y: 13.333 * sy))
                p.addCurve(to: CGPoint(x: 3.165 * sx, y: 11.5 * sy),
                           control1: CGPoint(x: 3.986 * sx, y: 13.333 * sy),
                           control2: CGPoint(x: 3.165 * sx, y: 12.513 * sy))
                p.closeSubpath()
                // Back
                p.move(to: CGPoint(x: 5.165 * sx, y: 2.333 * sy))
                p.addLine(to: CGPoint(x: 10.332 * sx, y: 2.333 * sy))
                p.addCurve(to: CGPoint(x: 10.832 * sx, y: 2.833 * sy),
                           control1: CGPoint(x: 10.608 * sx, y: 2.333 * sy),
                           control2: CGPoint(x: 10.832 * sx, y: 2.557 * sy))
                p.addLine(to: CGPoint(x: 10.832 * sx, y: 10.333 * sy))
                p.addLine(to: CGPoint(x: 11.832 * sx, y: 10.333 * sy))
                p.addLine(to: CGPoint(x: 11.832 * sx, y: 2.833 * sy))
                p.addCurve(to: CGPoint(x: 10.332 * sx, y: 1.333 * sy),
                           control1: CGPoint(x: 11.832 * sx, y: 2.005 * sy),
                           control2: CGPoint(x: 11.161 * sx, y: 1.333 * sy))
                p.addLine(to: CGPoint(x: 5.665 * sx, y: 1.333 * sy))
                p.addCurve(to: CGPoint(x: 4.165 * sx, y: 2.833 * sy),
                           control1: CGPoint(x: 4.837 * sx, y: 1.333 * sy),
                           control2: CGPoint(x: 4.165 * sx, y: 2.005 * sy))
                p.addLine(to: CGPoint(x: 4.165 * sx, y: 10.333 * sy))
                p.addLine(to: CGPoint(x: 5.165 * sx, y: 10.333 * sy))
                p.closeSubpath()
                // Left arm
                p.addRect(CGRect(x: 2.332 * sx, y: 7.333 * sy, width: 1.0 * sx, height: 2.5 * sy))
                // Right arm
                p.addRect(CGRect(x: 12.665 * sx, y: 7.333 * sy, width: 1.0 * sx, height: 2.5 * sy))
                // Left leg
                p.addRect(CGRect(x: 4.665 * sx, y: 12.833 * sy, width: 1.0 * sx, height: 1.834 * sy))
                // Right leg
                p.addRect(CGRect(x: 10.332 * sx, y: 12.833 * sy, width: 1.0 * sx, height: 1.834 * sy))
                // Headrest
                p.move(to: CGPoint(x: 6.832 * sx, y: 3.667 * sy))
                p.addLine(to: CGPoint(x: 6.832 * sx, y: 2.0 * sy))
                p.addLine(to: CGPoint(x: 5.832 * sx, y: 2.0 * sy))
                p.addLine(to: CGPoint(x: 5.832 * sx, y: 3.667 * sy))
                p.addCurve(to: CGPoint(x: 7.332 * sx, y: 5.167 * sy),
                           control1: CGPoint(x: 5.832 * sx, y: 4.495 * sy),
                           control2: CGPoint(x: 6.504 * sx, y: 5.167 * sy))
                p.addLine(to: CGPoint(x: 8.665 * sx, y: 5.167 * sy))
                p.addCurve(to: CGPoint(x: 10.165 * sx, y: 3.667 * sy),
                           control1: CGPoint(x: 9.494 * sx, y: 5.167 * sy),
                           control2: CGPoint(x: 10.165 * sx, y: 4.495 * sy))
                p.addLine(to: CGPoint(x: 10.165 * sx, y: 2.0 * sy))
                p.addLine(to: CGPoint(x: 9.165 * sx, y: 2.0 * sy))
                p.addLine(to: CGPoint(x: 9.165 * sx, y: 3.667 * sy))
                p.addCurve(to: CGPoint(x: 8.665 * sx, y: 4.167 * sy),
                           control1: CGPoint(x: 9.165 * sx, y: 3.943 * sy),
                           control2: CGPoint(x: 8.941 * sx, y: 4.167 * sy))
                p.addLine(to: CGPoint(x: 7.332 * sx, y: 4.167 * sy))
                p.addCurve(to: CGPoint(x: 6.832 * sx, y: 3.667 * sy),
                           control1: CGPoint(x: 7.056 * sx, y: 4.167 * sy),
                           control2: CGPoint(x: 6.832 * sx, y: 3.943 * sy))
                p.closeSubpath()
                return p
            }
        }
    }

    struct PlanChange: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 18, height: 18)) { rect in
                let sx = rect.width / 18
                let sy = rect.height / 18
                var p = Path()
                // Circle
                p.move(to: CGPoint(x: 9.75 * sx, y: 3.055 * sy))
                p.addCurve(to: CGPoint(x: 3.056 * sx, y: 9.749 * sy),
                           control1: CGPoint(x: 6.053 * sx, y: 3.055 * sy),
                           control2: CGPoint(x: 3.056 * sx, y: 6.052 * sy))
                p.addCurve(to: CGPoint(x: 9.75 * sx, y: 16.443 * sy),
                           control1: CGPoint(x: 3.056 * sx, y: 13.446 * sy),
                           control2: CGPoint(x: 6.053 * sx, y: 16.443 * sy))
                p.addCurve(to: CGPoint(x: 16.444 * sx, y: 9.749 * sy),
                           control1: CGPoint(x: 13.447 * sx, y: 16.443 * sy),
                           control2: CGPoint(x: 16.444 * sx, y: 13.446 * sy))
                p.addCurve(to: CGPoint(x: 9.75 * sx, y: 3.055 * sy),
                           control1: CGPoint(x: 16.444 * sx, y: 6.052 * sy),
                           control2: CGPoint(x: 13.447 * sx, y: 3.055 * sy))
                p.closeSubpath()
                p.move(to: CGPoint(x: 9.75 * sx, y: 1.874 * sy))
                p.addCurve(to: CGPoint(x: 17.625 * sx, y: 9.749 * sy),
                           control1: CGPoint(x: 14.099 * sx, y: 1.874 * sy),
                           control2: CGPoint(x: 17.625 * sx, y: 5.400 * sy))
                p.addCurve(to: CGPoint(x: 9.75 * sx, y: 17.624 * sy),
                           control1: CGPoint(x: 17.625 * sx, y: 14.098 * sy),
                           control2: CGPoint(x: 14.099 * sx, y: 17.624 * sy))
                p.addCurve(to: CGPoint(x: 1.875 * sx, y: 9.749 * sy),
                           control1: CGPoint(x: 5.401 * sx, y: 17.624 * sy),
                           control2: CGPoint(x: 1.875 * sx, y: 14.098 * sy))
                p.addCurve(to: CGPoint(x: 9.75 * sx, y: 1.874 * sy),
                           control1: CGPoint(x: 1.875 * sx, y: 5.400 * sy),
                           control2: CGPoint(x: 5.401 * sx, y: 1.874 * sy))
                p.closeSubpath()
                // Top bar
                p.addRect(CGRect(x: 7.512 * sx, y: 6.008 * sy, width: 4.477 * sx, height: 1.181 * sy))
                // Bottom bar
                p.addRect(CGRect(x: 7.512 * sx, y: 8.060 * sy, width: 4.477 * sx, height: 1.181 * sy))
                // Rupee curve + arrow
                p.move(to: CGPoint(x: 8.817 * sx, y: 7.190 * sy))
                p.addCurve(to: CGPoint(x: 10.278 * sx, y: 8.651 * sy),
                           control1: CGPoint(x: 9.624 * sx, y: 7.190 * sy),
                           control2: CGPoint(x: 10.278 * sx, y: 7.844 * sy))
                p.addCurve(to: CGPoint(x: 9.054 * sx, y: 10.112 * sy),
                           control1: CGPoint(x: 10.278 * sx, y: 9.458 * sy),
                           control2: CGPoint(x: 9.818 * sx, y: 10.112 * sy))
                p.addLine(to: CGPoint(x: 7.512 * sx, y: 10.112 * sy))
                p.addLine(to: CGPoint(x: 10.477 * sx, y: 14.128 * sy))
                p.addLine(to: CGPoint(x: 7.119 * sx, y: 11.144 * sy))
                p.addLine(to: CGPoint(x: 7.512 * sx, y: 10.112 * sy))
                p.addLine(to: CGPoint(x: 8.817 * sx, y: 10.112 * sy))
                p.addCurve(to: CGPoint(x: 11.460 * sx, y: 8.651 * sy),
                           control1: CGPoint(x: 10.402 * sx, y: 10.112 * sy),
                           control2: CGPoint(x: 11.460 * sx, y: 10.030 * sy))
                p.addCurve(to: CGPoint(x: 8.817 * sx, y: 6.008 * sy),
                           control1: CGPoint(x: 11.460 * sx, y: 7.191 * sy),
                           control2: CGPoint(x: 10.277 * sx, y: 6.008 * sy))
                p.addLine(to: CGPoint(x: 7.512 * sx, y: 6.008 * sy))
                p.addLine(to: CGPoint(x: 7.512 * sx, y: 7.190 * sy))
                p.closeSubpath()
                return p
            }
        }
    }

    struct Cancellation: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            FarePerkIconCanvas(color: color, viewBox: CGSize(width: 18, height: 18)) { rect in
                let sx = rect.width / 18
                let sy = rect.height / 18
                var p = Path()
                // Circle (partial, open right)
                p.move(to: CGPoint(x: 9.754 * sx, y: 3.061 * sy))
                p.addCurve(to: CGPoint(x: 3.061 * sx, y: 9.754 * sy),
                           control1: CGPoint(x: 6.057 * sx, y: 3.061 * sy),
                           control2: CGPoint(x: 3.061 * sx, y: 6.057 * sy))
                p.addCurve(to: CGPoint(x: 9.754 * sx, y: 16.447 * sy),
                           control1: CGPoint(x: 3.061 * sx, y: 13.451 * sy),
                           control2: CGPoint(x: 6.057 * sx, y: 16.447 * sy))
                p.addLine(to: CGPoint(x: 9.754 * sx, y: 17.629 * sy))
                p.addCurve(to: CGPoint(x: 1.879 * sx, y: 9.754 * sy),
                           control1: CGPoint(x: 5.405 * sx, y: 17.629 * sy),
                           control2: CGPoint(x: 1.879 * sx, y: 14.103 * sy))
                p.addCurve(to: CGPoint(x: 9.754 * sx, y: 1.879 * sy),
                           control1: CGPoint(x: 1.879 * sx, y: 5.405 * sy),
                           control2: CGPoint(x: 5.405 * sx, y: 1.879 * sy))
                p.addCurve(to: CGPoint(x: 16.408 * sx, y: 9.030 * sy),
                           control1: CGPoint(x: 13.206 * sx, y: 1.879 * sy),
                           control2: CGPoint(x: 16.048 * sx, y: 5.674 * sy))
                p.addLine(to: CGPoint(x: 17.584 * sx, y: 8.904 * sy))
                p.addCurve(to: CGPoint(x: 9.754 * sx, y: 1.879 * sy),
                           control1: CGPoint(x: 17.159 * sx, y: 4.954 * sy),
                           control2: CGPoint(x: 13.816 * sx, y: 1.879 * sy))
                p.closeSubpath()
                // Clock hand
                p.move(to: CGPoint(x: 9.163 * sx, y: 6.208 * sy))
                p.addLine(to: CGPoint(x: 9.163 * sx, y: 9.163 * sy))
                p.addLine(to: CGPoint(x: 10.345 * sx, y: 9.163 * sy))
                p.addLine(to: CGPoint(x: 10.345 * sx, y: 9.754 * sy))
                p.addLine(to: CGPoint(x: 9.754 * sx, y: 10.345 * sy))
                p.addLine(to: CGPoint(x: 7.390 * sx, y: 10.345 * sy))
                p.addLine(to: CGPoint(x: 7.390 * sx, y: 9.163 * sy))
                p.addLine(to: CGPoint(x: 9.163 * sx, y: 9.163 * sy))
                p.addLine(to: CGPoint(x: 10.345 * sx, y: 6.208 * sy))
                p.closeSubpath()
                // X mark (top-left to bottom-right)
                p.move(to: CGPoint(x: 16.616 * sx, y: 11.700 * sy))
                p.addLine(to: CGPoint(x: 17.452 * sx, y: 12.535 * sy))
                p.addLine(to: CGPoint(x: 13.323 * sx, y: 16.664 * sy))
                p.addLine(to: CGPoint(x: 12.488 * sx, y: 15.828 * sy))
                p.closeSubpath()
                // X mark (bottom-left to top-right)
                p.move(to: CGPoint(x: 16.616 * sx, y: 16.664 * sy))
                p.addLine(to: CGPoint(x: 12.488 * sx, y: 12.535 * sy))
                p.addLine(to: CGPoint(x: 13.323 * sx, y: 11.700 * sy))
                p.addLine(to: CGPoint(x: 17.452 * sx, y: 15.828 * sy))
                p.closeSubpath()
                return p
            }
        }
    }

    struct DateChange: View {
        var color: Color = IndiGoColors.accentDark
        var body: some View {
            Cancellation(color: color)
        }
    }
}

// MARK: - Reusable canvas that sizes & colors a Path

private struct FarePerkIconCanvas: View {
    let color: Color
    let viewBox: CGSize
    let pathBuilder: (CGRect) -> Path

    var body: some View {
        GeometryReader { geo in
            pathBuilder(CGRect(origin: .zero, size: geo.size))
                .fill(color)
        }
        .aspectRatio(viewBox.width / viewBox.height, contentMode: .fit)
    }
}
