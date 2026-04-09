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
import Speech

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
    var contentHeight: Double?
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
    var transcript: String?
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

    private let speechRecognizer = SFSpeechRecognizer(locale: Locale(identifier: "en-IN"))
    private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    private var recognitionTask: SFSpeechRecognitionTask?
    private var audioEngine = AVAudioEngine()
    @Published var liveTranscript: String = ""

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

        AVAudioSession.sharedInstance().requestRecordPermission { [weak self] micGranted in
            Task { @MainActor in
                guard micGranted else {
                    self?.audioConsent = false
                    self?.payload?.audioConsent = false
                    return
                }
                self?.requestSpeechAuth(sessionTitle: sessionTitle)
            }
        }
    }

    private func requestSpeechAuth(sessionTitle: String) {
        SFSpeechRecognizer.requestAuthorization { [weak self] status in
            Task { @MainActor in
                let speechAvailable = (status == .authorized)
                self?.startAudioRecording(sessionTitle: sessionTitle)
                if speechAvailable {
                    self?.startLiveTranscription()
                }
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

    private func startLiveTranscription() {
        guard let speechRecognizer, speechRecognizer.isAvailable else {
            print("[UT Speech] Recognizer not available")
            return
        }

        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        guard let recognitionRequest else { return }
        recognitionRequest.shouldReportPartialResults = true
        if speechRecognizer.supportsOnDeviceRecognition {
            recognitionRequest.requiresOnDeviceRecognition = true
        }

        recognitionTask = speechRecognizer.recognitionTask(with: recognitionRequest) { [weak self] result, error in
            Task { @MainActor in
                if let result {
                    self?.liveTranscript = result.bestTranscription.formattedString
                    self?.payload?.transcript = result.bestTranscription.formattedString
                }
                if error != nil || (result?.isFinal ?? false) {
                    self?.stopTranscription()
                }
            }
        }

        let inputNode = audioEngine.inputNode
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] buffer, _ in
            self?.recognitionRequest?.append(buffer)
        }

        do {
            audioEngine.prepare()
            try audioEngine.start()
        } catch {
            print("[UT Speech] Audio engine failed to start: \(error)")
            stopTranscription()
        }
    }

    private func stopTranscription() {
        audioEngine.stop()
        audioEngine.inputNode.removeTap(onBus: 0)
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        recognitionTask?.cancel()
        recognitionTask = nil
    }

    func stopAudioRecording() {
        stopTranscription()
        audioRecorder?.stop()
        audioRecorder = nil
        try? AVAudioSession.sharedInstance().setActive(false)
    }

    var recordedAudioURL: URL? { audioFileURL }

    // MARK: - Session lifecycle

    #if ALPHA_5_0
    func startSession(demographics: UTDemographics) {
        self.audioConsent = true
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
            audioConsent: true,
            audioFileName: nil,
            transcript: nil
        )
        sessionId = id
        sessionStarted = true
        sessionEnded = false
        scrollDepthTracker.removeAll()

        postToBackend(path: "/sessions", body: payload)
        requestMicrophoneAndStartRecording(sessionTitle: title)
    }
    #else
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
            audioFileName: nil,
            transcript: nil
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
    #endif

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

    func recordTap(screenId: String, normalizedX: Double, normalizedY: Double, contentHeight: Double? = nil) {
        let tap = UTTapEvent(
            screenId: screenId,
            x: normalizedX,
            y: normalizedY,
            timestamp: iso.string(from: Date()),
            contentHeight: contentHeight
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

    // MARK: - Screen snapshots (one-time per screen, for heatmap watermarks)

    private var capturedScreens: Set<String> = []

    func captureScreenSnapshot(screenId: String, scrollView: UIScrollView?) {
        guard !capturedScreens.contains(screenId) else { return }
        capturedScreens.insert(screenId)

        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first
        else { return }

        if let sv = scrollView {
            captureFullScrollContent(screenId: screenId, scrollView: sv)
        } else {
            let renderer = UIGraphicsImageRenderer(bounds: window.bounds)
            let image = renderer.image { ctx in
                window.drawHierarchy(in: window.bounds, afterScreenUpdates: true)
            }
            uploadScreenshot(screenId: screenId, image: image)
        }
    }

    private func captureFullScrollContent(screenId: String, scrollView: UIScrollView) {
        let savedOffset = scrollView.contentOffset
        let savedFrame = scrollView.frame

        let contentSize = scrollView.contentSize
        let fullHeight = max(contentSize.height, scrollView.bounds.height)

        scrollView.contentOffset = .zero

        let renderer = UIGraphicsImageRenderer(
            size: CGSize(width: scrollView.bounds.width, height: fullHeight)
        )
        let image = renderer.image { ctx in
            scrollView.drawHierarchy(
                in: CGRect(origin: .zero, size: CGSize(width: scrollView.bounds.width, height: fullHeight)),
                afterScreenUpdates: true
            )
        }

        scrollView.contentOffset = savedOffset

        uploadScreenshot(screenId: screenId, image: image)
    }

    private func uploadScreenshot(screenId: String, image: UIImage) {
        guard let pngData = image.pngData(),
              let url = URL(string: "\(backendBaseURL)/screenshots/\(screenId)")
        else { return }

        var req = URLRequest(url: url)
        req.httpMethod = "POST"
        req.setValue("image/png", forHTTPHeaderField: "Content-Type")
        req.httpBody = pngData

        URLSession.shared.dataTask(with: req).resume()
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
