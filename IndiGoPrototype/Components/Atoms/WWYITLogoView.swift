//
//  WWYITLogoView.swift
//  IndiGoPrototype
//
//  "Where will you IndiGo today?" communication logo.
//  Renders the SVG asset from Figma node 5602:85163.
//  The SVG includes the globe icon, handwritten text,
//  and decorative dots — all in IndiGo blue (#000099).
//

import SwiftUI

struct WWYITLogoView: View {
    var body: some View {
        Image("wwyit-logo")
            .resizable()
            .aspectRatio(contentMode: .fit)
    }
}

#Preview {
    WWYITLogoView()
        .frame(width: 175, height: 50)
        .padding()
}
