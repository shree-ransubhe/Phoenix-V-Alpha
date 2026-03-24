//
//  HapticManager.swift
//  IndiGoPrototype
//
//  Centralized haptic feedback engine.
//  Wraps UIKit feedback generators behind semantic action types so every
//  call site reads as *what happened*, not *which motor intensity*.
//

import UIKit

enum HapticManager {

    // MARK: - Semantic actions

    /// Lightweight tick for selection changes (tabs, chips, radio buttons, toggles).
    static func selection() {
        selectionGenerator.selectionChanged()
    }

    /// Soft tap for card taps, list row selections, avatar taps.
    static func lightImpact() {
        lightGenerator.impactOccurred()
    }

    /// Medium punch for primary CTAs (Search Flight, Next, Book Now).
    static func mediumImpact() {
        mediumGenerator.impactOccurred()
    }

    /// Heavier thud for high-commitment actions (navigation push, fare confirmation).
    static func heavyImpact() {
        heavyGenerator.impactOccurred()
    }

    /// Success buzz (e.g. city confirmed, booking step complete).
    static func success() {
        notificationGenerator.notificationOccurred(.success)
    }

    /// Warning nudge (e.g. disabled action attempted).
    static func warning() {
        notificationGenerator.notificationOccurred(.warning)
    }

    /// Error shake (e.g. validation failure).
    static func error() {
        notificationGenerator.notificationOccurred(.error)
    }

    /// Soft tick with custom intensity — useful for stepper increments.
    static func softImpact(intensity: CGFloat = 0.5) {
        softGenerator.impactOccurred(intensity: intensity)
    }

    // MARK: - Pre-warmed generators (reused across calls)

    private static let selectionGenerator: UISelectionFeedbackGenerator = {
        let g = UISelectionFeedbackGenerator()
        g.prepare()
        return g
    }()

    private static let lightGenerator: UIImpactFeedbackGenerator = {
        let g = UIImpactFeedbackGenerator(style: .light)
        g.prepare()
        return g
    }()

    private static let mediumGenerator: UIImpactFeedbackGenerator = {
        let g = UIImpactFeedbackGenerator(style: .medium)
        g.prepare()
        return g
    }()

    private static let heavyGenerator: UIImpactFeedbackGenerator = {
        let g = UIImpactFeedbackGenerator(style: .heavy)
        g.prepare()
        return g
    }()

    private static let softGenerator: UIImpactFeedbackGenerator = {
        let g = UIImpactFeedbackGenerator(style: .soft)
        g.prepare()
        return g
    }()

    private static let notificationGenerator: UINotificationFeedbackGenerator = {
        let g = UINotificationFeedbackGenerator()
        g.prepare()
        return g
    }()
}
