//
//  UTModifiers.swift
//  IndiGoPrototype
//
//  SwiftUI view modifiers for UT instrumentation:
//    .utTapCapture(screenId:)   – transparent overlay that records normalised tap coordinates.
//    .utStepTracking(screenId:) – records enter/leave timestamps for the screen.
//

#if UT_VARIANT
import SwiftUI

// MARK: - Tap heatmap capture (via background GeometryReader + window-level hit-test)

struct UTTapCaptureModifier: ViewModifier {
    let screenId: String

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { geo in
                    UTTouchInterceptView(screenId: screenId, viewSize: geo.size)
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                }
            )
    }
}

/// UIKit view that installs on the window's gesture recogniser to passively
/// observe all touches without blocking any interaction.
struct UTTouchInterceptView: UIViewRepresentable {
    let screenId: String
    let viewSize: CGSize

    func makeUIView(context: Context) -> UTPassthroughTouchView {
        let view = UTPassthroughTouchView()
        view.screenId = screenId
        view.expectedSize = viewSize
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UTPassthroughTouchView, context: Context) {
        uiView.screenId = screenId
        uiView.expectedSize = viewSize
    }
}

/// Invisible UIView that observes touch events via the responder chain
/// without intercepting them. It attaches a passive tap recogniser to the
/// window once added to the hierarchy.
final class UTPassthroughTouchView: UIView {
    var screenId: String = ""
    var expectedSize: CGSize = .zero
    private var tapRecognizer: UTPassthroughTapRecognizer?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard let window, tapRecognizer == nil else { return }
        let recognizer = UTPassthroughTapRecognizer { [weak self] location in
            self?.handleTap(windowLocation: location)
        }
        recognizer.cancelsTouchesInView = false
        recognizer.delaysTouchesBegan = false
        recognizer.delaysTouchesEnded = false
        window.addGestureRecognizer(recognizer)
        tapRecognizer = recognizer
    }

    override func removeFromSuperview() {
        if let recognizer = tapRecognizer, let window = self.window {
            window.removeGestureRecognizer(recognizer)
        }
        tapRecognizer = nil
        super.removeFromSuperview()
    }

    private func handleTap(windowLocation: CGPoint) {
        guard let window else { return }
        let localPoint = convert(windowLocation, from: window)
        let bounds = self.bounds
        guard bounds.width > 0, bounds.height > 0 else { return }
        let nx = Double(localPoint.x / bounds.width)
        let ny = Double(localPoint.y / bounds.height)
        guard nx >= 0, nx <= 1, ny >= 0, ny <= 1 else { return }

        Task { @MainActor in
            UTTrackingService.shared.recordTap(
                screenId: screenId,
                normalizedX: min(max(nx, 0), 1),
                normalizedY: min(max(ny, 0), 1)
            )
        }
    }
}

/// Tap gesture recogniser that never cancels other touches.
final class UTPassthroughTapRecognizer: UIGestureRecognizer {
    private let handler: (CGPoint) -> Void

    init(handler: @escaping (CGPoint) -> Void) {
        self.handler = handler
        super.init(target: nil, action: nil)
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .possible
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent) {
        guard let touch = touches.first else { return }
        let location = touch.location(in: self.view)
        handler(location)
        state = .failed
    }

    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent) {
        state = .failed
    }

    override func canPrevent(_ preventedGestureRecognizer: UIGestureRecognizer) -> Bool { false }
    override func canBePrevented(by preventingGestureRecognizer: UIGestureRecognizer) -> Bool { false }
}

// MARK: - Step timing

struct UTStepTrackingModifier: ViewModifier {
    let screenId: String

    func body(content: Content) -> some View {
        content
            .onAppear { UTTrackingService.shared.enterScreen(screenId) }
            .onDisappear { UTTrackingService.shared.leaveCurrentScreen() }
    }
}

// MARK: - View extensions

extension View {
    func utTapCapture(screenId: String) -> some View {
        modifier(UTTapCaptureModifier(screenId: screenId))
    }

    func utStepTracking(screenId: String) -> some View {
        modifier(UTStepTrackingModifier(screenId: screenId))
    }

    func utInstrumented(screenId: String) -> some View {
        self
            .utStepTracking(screenId: screenId)
            .utTapCapture(screenId: screenId)
    }
}
#endif
