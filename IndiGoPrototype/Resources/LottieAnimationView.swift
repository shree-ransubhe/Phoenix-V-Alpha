//
//  LottieAnimationView.swift
//  IndiGoPrototype
//
//  Wrapper for Lottie JSON animations (loading, success). Add Lottie package and uncomment.
//

import SwiftUI

/// Placeholder until Lottie package is integrated. Replace with LottieView when adding .lottie files.
struct LottieAnimationView: View {
    let name: String
    let loopMode: Bool

    init(name: String, loopMode: Bool = false) {
        self.name = name
        self.loopMode = loopMode
    }

    var body: some View {
        // When Lottie is added: LottieView(animation: .named(name))
        //   .looping()
        Color.clear
            .frame(width: 80, height: 80)
            .overlay {
                ProgressView()
            }
    }
}

#Preview {
    LottieAnimationView(name: "success", loopMode: false)
}
