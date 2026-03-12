//
//  UTTrackingService.swift
//  IndiGoPrototype
//
//  Central service for usability-testing data capture.
//  Active only in the UT_VARIANT build.
//

#if UT_VARIANT
import Foundation
import UIKit

// MARK: - Data models

struct UTDemographics: Codable {
    var role: String
    var experience: String
    var ageBand: String
    var device: String
}

struct UTStepEvent: Codable {
    let screenId: String
    let enteredAt: String
    var leftAt: String?
}

struct UTTapEvent: Codable {
    let screenId: String
    let x: Double
    let y: Double
    let timestamp: String
}

struct UTPostTaskAnswer: Codable {
    let question: String
    let answer: String
}

struct UTSessionPayload: Codable {
    let sessionId: String
    var sessionTitle: String
    var demographics: UTDemographics?
    let createdAt: String
    var endedAt: String?
    var steps: [UTStepEvent]
    var taps: [UTTapEvent]
    var journeyCompleted: Bool
    var completedAt: String?
    var rating: Int?
    var frustration: Int?
    var feedback: String?
    var postTaskAnswers: [UTPostTaskAnswer]
}

// MARK: - Service

@MainActor
final class UTTrackingService: ObservableObject {

    static let shared = UTTrackingService()

    @Published var sessionId: String?
    @Published var sessionStarted = false
    @Published var sessionEnded = false

    private(set) var payload: UTSessionPayload?
    private var activeScreenId: String?
    private var activeEnteredAt: Date?

    private let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    var backendBaseURL: String {
        "http://localhost:3100"
    }

    // MARK: - Session lifecycle

    func startSession(demographics: UTDemographics) {
        let id = UUID().uuidString
        let now = iso.string(from: Date())
        let title = buildTitle(demographics: demographics, date: Date())

        payload = UTSessionPayload(
            sessionId: id,
            sessionTitle: title,
            demographics: demographics,
            createdAt: now,
            steps: [],
            taps: [],
            journeyCompleted: false,
            postTaskAnswers: []
        )
        sessionId = id
        sessionStarted = true
        sessionEnded = false

        postToBackend(path: "/sessions", body: payload)
    }

    func endSession(rating: Int?, frustration: Int?, feedback: String?, postTaskAnswers: [UTPostTaskAnswer] = []) {
        leaveCurrentScreen()
        payload?.endedAt = iso.string(from: Date())
        payload?.rating = rating
        payload?.frustration = frustration
        payload?.feedback = feedback
        payload?.postTaskAnswers = postTaskAnswers
        sessionEnded = true

        sendAllEvents()
    }

    func markJourneyComplete() {
        payload?.journeyCompleted = true
        payload?.completedAt = iso.string(from: Date())
    }

    // MARK: - Step tracking

    func enterScreen(_ screenId: String) {
        leaveCurrentScreen()
        activeScreenId = screenId
        activeEnteredAt = Date()

        let step = UTStepEvent(screenId: screenId, enteredAt: iso.string(from: Date()))
        payload?.steps.append(step)
    }

    func leaveCurrentScreen() {
        guard let screenId = activeScreenId,
              let idx = payload?.steps.lastIndex(where: { $0.screenId == screenId && $0.leftAt == nil })
        else { return }
        payload?.steps[idx].leftAt = iso.string(from: Date())
        activeScreenId = nil
        activeEnteredAt = nil
    }

    // MARK: - Tap heatmap

    func recordTap(screenId: String, normalizedX: Double, normalizedY: Double) {
        let tap = UTTapEvent(
            screenId: screenId,
            x: normalizedX,
            y: normalizedY,
            timestamp: iso.string(from: Date())
        )
        payload?.taps.append(tap)
    }

    // MARK: - Export

    func exportFileURL() -> URL? {
        guard let payload else { return nil }
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        guard let data = try? encoder.encode(payload) else { return nil }

        let fileName = "\(payload.sessionTitle).json"
        let tmpURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: tmpURL)
        return tmpURL
    }

    // MARK: - Networking (fire-and-forget)

    private func postToBackend<T: Encodable>(path: String, body: T?) {
        guard let body,
              let url = URL(string: "\(backendBaseURL)\(path)")
        else { return }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("application/json", forHTTPHeaderField: "Content-Type")
        req.httpBody = try? JSONEncoder().encode(body)

        URLSession.shared.dataTask(with: req).resume()
    }

    private func sendAllEvents() {
        guard let id = sessionId else { return }
        postToBackend(path: "/sessions/\(id)/complete", body: payload)
    }

    // MARK: - Helpers

    private func buildTitle(demographics: UTDemographics, date: Date) -> String {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd_HHmm"
        let dateStr = df.string(from: date)
        let role = demographics.role.replacingOccurrences(of: " ", with: "-")
        let exp = demographics.experience.replacingOccurrences(of: " ", with: "-")
        return "UT_\(dateStr)_\(role)_\(exp)"
    }
}
#endif
