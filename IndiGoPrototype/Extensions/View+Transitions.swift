//
//  View+Transitions.swift
//  IndiGoPrototype
//
//  Custom transitions for screen navigation and list stagger.
//

import SwiftUI

extension View {
    /// Slide-from-trailing transition for pushed screens.
    static var slideFromTrailing: AnyTransition {
        .asymmetric(
            insertion: .move(edge: .trailing).combined(with: .opacity),
            removal: .move(edge: .leading).combined(with: .opacity)
        )
    }
}
