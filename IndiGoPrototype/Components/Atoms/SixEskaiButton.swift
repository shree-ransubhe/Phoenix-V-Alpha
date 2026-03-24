//
//  SixEskaiButton.swift
//  IndiGoPrototype
//
//  Atom – 6eSkai assistant entry point button (32x32 gradient circle
//  with scrolling "6Eskai" text animation).
//  Figma node: 2279:25586
//

import SwiftUI

struct SixEskaiButton: View {
    var size: CGFloat = 32
    var action: () -> Void = {}

    @State private var textOffset: CGFloat = 0
    private let textWidth: CGFloat = 24
    private let animDuration: Double = 2.5

    var body: some View {
        Button(action: {
            HapticManager.lightImpact()
            action()
        }) {
            ZStack {
                Circle()
                    .fill(
                        LinearGradient(
                            stops: [
                                .init(color: Color(hex: "00AEE5"), location: 0.195),
                                .init(color: Color(hex: "005EC2"), location: 0.382),
                                .init(color: IndiGoColors.indigoBlue, location: 0.600),
                                .init(color: Color(hex: "00AEE5"), location: 0.895),
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(width: size, height: size)
                    .shadow(color: Color(hex: "4C5D9E").opacity(0.08), radius: 6)

                SixEskaiTextShape()
                    .fill(Color.white)
                    .frame(width: textWidth, height: 6)
                    .offset(x: textOffset)
            }
            .clipShape(Circle())
        }
        .buttonStyle(.plain)
        .onAppear {
            textOffset = -size / 2 - textWidth / 2
            withAnimation(.linear(duration: animDuration).repeatForever(autoreverses: false)) {
                textOffset = size / 2 + textWidth / 2
            }
        }
    }
}

// MARK: - "6Eskai" text rendered as a Shape from the provided SVG

private struct SixEskaiTextShape: Shape {
    func path(in rect: CGRect) -> Path {
        let sx = rect.width / 24
        let sy = rect.height / 6
        var p = Path()

        // "6"
        p.move(to: s(1.92015, 2.45936, sx, sy))
        p.addLine(to: s(2.40907, 1.78815, sx, sy))
        p.addCurve(to: s(4.5159, 3.90246, sx, sy),
                    control1: s(3.78696, 1.82171, sx, sy),
                    control2: s(4.5159, 2.71945, sx, sy))
        p.addCurve(to: s(2.22239, 6, sx, sy),
                    control1: s(4.5159, 4.99318, sx, sy),
                    control2: s(3.53805, 6, sx, sy))
        p.addCurve(to: s(0, 3.91085, sx, sy),
                    control1: s(0.995632, 6, sx, sy),
                    control2: s(0, 5.09386, sx, sy))
        p.addCurve(to: s(0.808951, 2.05663, sx, sy),
                    control1: s(0, 3.13057, sx, sy),
                    control2: s(0.364472, 2.65233, sx, sy))
        p.addLine(to: s(2.32907, 0.0262188, sx, sy))
        p.addLine(to: s(3.36026, 0.0262188, sx, sy))
        p.addLine(to: s(1.42233, 2.5936, sx, sy))
        p.addCurve(to: s(0.853398, 3.97798, sx, sy),
                    control1: s(1.06675, 3.07184, sx, sy),
                    control2: s(0.853398, 3.41584, sx, sy))
        p.addCurve(to: s(2.24017, 5.26167, sx, sy),
                    control1: s(0.853398, 4.67436, sx, sy),
                    control2: s(1.49345, 5.26167, sx, sy))
        p.addCurve(to: s(3.6625, 3.91924, sx, sy),
                    control1: s(3.00467, 5.26167, sx, sy),
                    control2: s(3.6625, 4.65758, sx, sy))
        p.addCurve(to: s(1.92015, 2.45936, sx, sy),
                    control1: s(3.6625, 2.92921, sx, sy),
                    control2: s(2.91578, 2.44258, sx, sy))
        p.closeSubpath()

        // "E"
        p.move(to: s(8.80657, 2.49292, sx, sy))
        p.addLine(to: s(8.80657, 3.23125, sx, sy))
        p.addLine(to: s(5.8019, 3.23125, sx, sy))
        p.addCurve(to: s(7.99762, 5.16099, sx, sy),
                    control1: s(5.87302, 4.33875, sx, sy),
                    control2: s(6.9131, 5.16099, sx, sy))
        p.addLine(to: s(8.80657, 5.16099, sx, sy))
        p.addLine(to: s(8.80657, 5.89932, sx, sy))
        p.addLine(to: s(8.14875, 5.89932, sx, sy))
        p.addCurve(to: s(4.93072, 2.96277, sx, sy),
                    control1: s(6.28194, 5.89932, sx, sy),
                    control2: s(4.93072, 4.62402, sx, sy))
        p.addCurve(to: s(8.14875, 0.0262188, sx, sy),
                    control1: s(4.93072, 1.30152, sx, sy),
                    control2: s(6.28194, 0.0262188, sx, sy))
        p.addLine(to: s(8.80657, 0.0262188, sx, sy))
        p.addLine(to: s(8.80657, 0.764551, sx, sy))
        p.addLine(to: s(8.24653, 0.764551, sx, sy))
        p.addCurve(to: s(5.8019, 2.49292, sx, sy),
                    control1: s(6.61974, 0.764551, sx, sy),
                    control2: s(5.83746, 1.90561, sx, sy))
        p.closeSubpath()

        // "s"
        p.move(to: s(9.41995, 5.89932, sx, sy))
        p.addLine(to: s(9.41995, 5.19455, sx, sy))
        p.addLine(to: s(11.6068, 5.19455, sx, sy))
        p.addCurve(to: s(12.1135, 4.8086, sx, sy),
                    control1: s(11.9713, 5.19455, sx, sy),
                    control2: s(12.1135, 5.0603, sx, sy))
        p.addCurve(to: s(9.41995, 2.96277, sx, sy),
                    control1: s(12.1135, 4.07027, sx, sy),
                    control2: s(9.41995, 4.35553, sx, sy))
        p.addCurve(to: s(10.8778, 1.87205, sx, sy),
                    control1: s(9.41995, 2.24961, sx, sy),
                    control2: s(9.94444, 1.87205, sx, sy))
        p.addLine(to: s(12.718, 1.87205, sx, sy))
        p.addLine(to: s(12.718, 2.57682, sx, sy))
        p.addLine(to: s(10.7445, 2.57682, sx, sy))
        p.addCurve(to: s(10.2378, 2.92921, sx, sy),
                    control1: s(10.3622, 2.57682, sx, sy),
                    control2: s(10.2467, 2.6775, sx, sy))
        p.addCurve(to: s(12.9313, 4.77504, sx, sy),
                    control1: s(10.2289, 3.62559, sx, sy),
                    control2: s(12.9313, 3.33193, sx, sy))
        p.addCurve(to: s(11.6068, 5.89932, sx, sy),
                    control1: s(12.9313, 5.53854, sx, sy),
                    control2: s(12.3624, 5.89932, sx, sy))
        p.closeSubpath()

        // "k"
        p.move(to: s(14.3655, 5.89932, sx, sy))
        p.addLine(to: s(13.5833, 5.89932, sx, sy))
        p.addLine(to: s(13.5833, 0.0262188, sx, sy))
        p.addLine(to: s(14.3655, 0.0262188, sx, sy))
        p.addLine(to: s(14.3655, 3.3655, sx, sy))
        p.addLine(to: s(14.6945, 3.3655, sx, sy))
        p.addCurve(to: s(15.3523, 3.06345, sx, sy),
                    control1: s(15.0234, 3.3655, sx, sy),
                    control2: s(15.2367, 3.24803, sx, sy))
        p.addLine(to: s(16.0901, 1.87205, sx, sy))
        p.addLine(to: s(16.9791, 1.87205, sx, sy))
        p.addLine(to: s(16.419, 2.77819, sx, sy))
        p.addCurve(to: s(15.7523, 3.51652, sx, sy),
                    control1: s(16.2501, 3.05506, sx, sy),
                    control2: s(15.9923, 3.45779, sx, sy))
        p.addLine(to: s(15.7523, 3.5333, sx, sy))
        p.addCurve(to: s(16.7302, 4.71631, sx, sy),
                    control1: s(16.3835, 3.65076, sx, sy),
                    control2: s(16.7302, 4.00315, sx, sy))
        p.addLine(to: s(16.7302, 5.89932, sx, sy))
        p.addLine(to: s(15.9479, 5.89932, sx, sy))
        p.addLine(to: s(15.9479, 4.80021, sx, sy))
        p.addCurve(to: s(15.2545, 4.07027, sx, sy),
                    control1: s(15.9479, 4.2968, sx, sy),
                    control2: s(15.6634, 4.07027, sx, sy))
        p.addLine(to: s(14.3655, 4.07027, sx, sy))
        p.closeSubpath()

        // "a" (with descender)
        p.move(to: s(21.658, 5.89932, sx, sy))
        p.addLine(to: s(20.8757, 5.89932, sx, sy))
        p.addLine(to: s(20.8757, 3.63398, sx, sy))
        p.addCurve(to: s(19.4889, 2.49292, sx, sy),
                    control1: s(20.8757, 2.87887, sx, sy),
                    control2: s(20.2001, 2.49292, sx, sy))
        p.addCurve(to: s(18.0844, 3.90246, sx, sy),
                    control1: s(18.6266, 2.49292, sx, sy),
                    control2: s(18.0844, 3.13896, sx, sy))
        p.addCurve(to: s(19.48, 5.27845, sx, sy),
                    control1: s(18.0844, 4.64919, sx, sy),
                    control2: s(18.6622, 5.27845, sx, sy))
        p.addCurve(to: s(20.5557, 4.7247, sx, sy),
                    control1: s(19.9245, 5.27845, sx, sy),
                    control2: s(20.289, 5.04352, sx, sy))
        p.addLine(to: s(20.5557, 5.59727, sx, sy))
        p.addCurve(to: s(19.4, 5.98322, sx, sy),
                    control1: s(20.2445, 5.81542, sx, sy),
                    control2: s(19.9423, 5.98322, sx, sy))
        p.addCurve(to: s(17.3021, 3.84373, sx, sy),
                    control1: s(18.1733, 5.98322, sx, sy),
                    control2: s(17.3021, 5.02674, sx, sy))
        p.addCurve(to: s(19.5067, 1.78815, sx, sy),
                    control1: s(17.3021, 2.69428, sx, sy),
                    control2: s(18.1377, 1.78815, sx, sy))
        p.addCurve(to: s(21.658, 3.7011, sx, sy),
                    control1: s(20.8224, 1.78815, sx, sy),
                    control2: s(21.658, 2.54326, sx, sy))
        p.closeSubpath()

        // "i" — dot
        p.addEllipse(in: CGRect(
            x: 22.1495 * sx, y: 0 * sy,
            width: (23.5385 - 22.1495) * sx, height: 1.31096 * sy
        ))

        // "i" — vertical dots
        let dotRx = (23.2607 - 22.4273) / 2 * sx
        let dotRy = (2.75302 - 1.96644) / 2 * sy
        let dotCenters: [(CGFloat, CGFloat)] = [
            (22.844, 2.35973),
            (22.844, 3.40849),
            (22.844, 4.45726),
            (22.844, 5.50603),
        ]
        for (cx, cy) in dotCenters {
            p.addEllipse(in: CGRect(
                x: cx * sx - dotRx, y: cy * sy - dotRy,
                width: dotRx * 2, height: dotRy * 2
            ))
        }

        return p
    }

    private func s(_ x: CGFloat, _ y: CGFloat, _ sx: CGFloat, _ sy: CGFloat) -> CGPoint {
        CGPoint(x: x * sx, y: y * sy)
    }
}

#Preview {
    HStack(spacing: 20) {
        SixEskaiButton()
        SixEskaiButton(size: 48)
    }
    .padding()
    .background(Color.gray.opacity(0.1))
}
