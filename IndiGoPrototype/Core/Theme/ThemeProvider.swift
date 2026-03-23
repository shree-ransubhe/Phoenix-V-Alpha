//
//  ThemeProvider.swift
//  IndiGoPrototype
//
//  Compile-time resolver — selects the active AlphaTheme based on
//  the build target's SWIFT_ACTIVE_COMPILATION_CONDITIONS.
//
//  Default (no flag)  → Alpha 4.1
//  ALPHA_5_0          → Alpha 5.0
//

import Foundation

enum ThemeProvider {
    static let current: any AlphaTheme = {
        #if ALPHA_5_0
        return Alpha50Theme()
        #else
        return Alpha41Theme()
        #endif
    }()
}
