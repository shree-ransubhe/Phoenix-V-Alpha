//
//  AlphaThemeEnvironment.swift
//  IndiGoPrototype
//
//  SwiftUI Environment integration for AlphaTheme.
//  Usage:  @Environment(\.alphaTheme) private var theme
//

import SwiftUI

private struct AlphaThemeKey: EnvironmentKey {
    static let defaultValue: any AlphaTheme = ThemeProvider.current
}

extension EnvironmentValues {
    var alphaTheme: any AlphaTheme {
        get { self[AlphaThemeKey.self] }
        set { self[AlphaThemeKey.self] = newValue }
    }
}

extension View {
    func alphaTheme(_ theme: any AlphaTheme) -> some View {
        environment(\.alphaTheme, theme)
    }
}
