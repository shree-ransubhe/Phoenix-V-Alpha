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
import AVFoundation

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

struct UTScrollDepthEvent: Codable {
    let screenId: String
    let maxDepth: Double
    let timestamp: String
}

struct UTDeviceMetadata: Codable {
    let deviceModel: String
    let screenSize: String
    let osVersion: String
    let appVersion: String
}

struct UTSessionPayload: Codable {
    let sessionId: String
    var sessionTitle: String
    var demographics: UTDemographics?
    var deviceMetadata: UTDeviceMetadata?
    let createdAt: String
    var endedAt: String?
    var steps: [UTStepEvent]
    var taps: [UTTapEvent]
    var scrollDepths: [UTScrollDepthEvent]
    var journeyCompleted: Bool
    var completedAt: String?
    var rating: Int?
    var frustration: Int?
    var feedback: String?
    var postTaskAnswers: [UTPostTaskAnswer]
    var audioConsent: Bool
    var audioFileName: String?
}

// MARK: - Service

@MainActor
final class UTTrackingService: ObservableObject {

    static let shared = UTTrackingService()

    @Published var sessionId: String?
    @Published var sessionStarted = false
    @Published var sessionEnded = false
    @Published var audioConsent = true

    private(set) var payload: UTSessionPayload?
    private var activeScreenId: String?
    private var activeEnteredAt: Date?

    private var scrollDepthTracker: [String: Double] = [:]

    private var audioRecorder: AVAudioRecorder?
    private var audioFileURL: URL?

    private let iso: ISO8601DateFormatter = {
        let f = ISO8601DateFormatter()
        f.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return f
    }()

    var backendBaseURL: String {
        "http://localhost:3100"
    }

    // MARK: - Device metadata

    private func captureDeviceMetadata() -> UTDeviceMetadata {
        var systemInfo = utsname()
        uname(&systemInfo)
        let machine = withUnsafePointer(to: &systemInfo.machine) {
            $0.withMemoryRebound(to: CChar.self, capacity: 1) {
                String(validatingUTF8: $0) ?? UIDevice.current.model
            }
        }

        let screen = UIScreen.main.bounds
        let screenSize = "\(Int(screen.width))x\(Int(screen.height))"
        let osVersion = "\(UIDevice.current.systemName) \(UIDevice.current.systemVersion)"
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
            ?? Bundle.main.infoDictionary?["CFBundleVersion"] as? String
            ?? "unknown"

        return UTDeviceMetadata(
            deviceModel: machine,
            screenSize: screenSize,
            osVersion: osVersion,
            appVersion: appVersion
        )
    }

    // MARK: - Audio recording

    func requestMicrophoneAndStartRecording(sessionTitle: String) {
        guard audioConsent else { return }

        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] granted in
            Task { @MainActor in
                guard granted else {
                    self?.audioConsent = false
                    self?.payload?.audioConsent = false
                    return
                }
                self?.startAudioRecording(sessionTitle: sessionTitle)
            }
        }
    }

    private func startAudioRecording(sessionTitle: String) {
        let fileName = "\(sessionTitle)_audio.m4a"
        let dir = FileManager.default.temporaryDirectory
        let fileURL = dir.appendingPathComponent(fileName)

        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 22050,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.medium.rawValue
        ]

        do {
            let session = AVAudioSession.sharedInstance()
            try session.setCategory(.playAndRecord, mode: .default, options: [.defaultToSpeaker])
            try session.setActive(true)

            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.record()
            audioFileURL = fileURL
            payload?.audioFileName = fileName
        } catch {
            print("[UT Audio] Failed to start recording: \(error)")
            audioFileURL = nil
        }
    }

    func stopAudioRecording() {
        audioRecorder?.stop()
        audioRecorder = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    var recordedAudioURL: URL? { audioFileURL }

    // MARK: - Session lifecycle

    func startSession(demographics: UTDemographics, audioConsent: Bool) {
        self.audioConsent = audioConsent
        let id = UUID().uuidString
        let now = iso.string(from: Date())
        let title = buildTitle(demographics: demographics, date: Date())

        payload = UTSessionPayload(
            sessionId: id,
            sessionTitle: title,
            demographics: demographics,
            deviceMetadata: captureDeviceMetadata(),
            createdAt: now,
            steps: [],
            taps: [],
            scrollDepths: [],
            journeyCompleted: false,
            postTaskAnswers: [],
            audioConsent: audioConsent,
            audioFileName: nil
        )
        sessionId = id
        sessionStarted = true
        sessionEnded = false
        scrollDepthTracker.removeAll()

        postToBackend(path: "/sessions", body: payload)

        if audioConsent {
            requestMicrophoneAndStartRecording(sessionTitle: title)
        }
    }

    func endSession(rating: Int?, frustration: Int?, feedback: String?, postTaskAnswers: [UTPostTaskAnswer] = []) {
        leaveCurrentScreen()
        flushScrollDepths()
        stopAudioRecording()

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

    // MARK: - Scroll depth

    func updateScrollDepth(screenId: String, depth: Double) {
        let clamped = min(max(depth, 0), 1)
        let current = scrollDepthTracker[screenId] ?? 0
        if clamped > current {
            scrollDepthTracker[screenId] = clamped
        }
    }

    private func flushScrollDepths() {
        let now = iso.string(from: Date())
        for (screenId, depth) in scrollDepthTracker {
            payload?.scrollDepths.append(
                UTScrollDepthEvent(screenId: screenId, maxDepth: depth, timestamp: now)
            )
        }
    }

    // MARK: - Export

    func exportableFiles() -> [URL] {
        var files: [URL] = []

        if let payload {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            if let data = try? encoder.encode(payload) {
                let jsonURL = FileManager.default.temporaryDirectory
                    .appendingPathComponent("\(payload.sessionTitle).json")
                try? data.write(to: jsonURL)
                files.append(jsonURL)
            }
        }

        if let audioURL = audioFileURL, FileManager.default.fileExists(atPath: audioURL.path) {
            files.append(audioURL)
        }

        return files
    }

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
