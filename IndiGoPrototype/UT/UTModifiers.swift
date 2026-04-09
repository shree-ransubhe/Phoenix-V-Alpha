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
///
/// Tap y-coordinates are normalised against the **full scroll content height**
/// (not the visible viewport) so that taps on below-the-fold content map to
/// their true position in the page.
final class UTPassthroughTouchView: UIView {
    var screenId: String = ""
    var expectedSize: CGSize = .zero
    private var tapRecognizer: UTPassthroughTapRecognizer?
    private weak var enclosingScrollView: UIScrollView?

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

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.enclosingScrollView = self?.findScrollView()
        }
    }

    override func removeFromSuperview() {
        if let recognizer = tapRecognizer, let window = self.window {
            window.removeGestureRecognizer(recognizer)
        }
        tapRecognizer = nil
        super.removeFromSuperview()
    }

    private func findScrollView() -> UIScrollView? {
        var current: UIView? = superview
        while let v = current {
            if let sv = v as? UIScrollView { return sv }
            current = v.superview
        }
        return nil
    }

    private func handleTap(windowLocation: CGPoint) {
        guard let window else { return }
        let viewWidth = bounds.width
        guard viewWidth > 0 else { return }

        let localPoint = convert(windowLocation, from: window)
        let nx = Double(localPoint.x / viewWidth)
        guard nx >= 0, nx <= 1 else { return }

        let ny: Double
        var contentH: Double?

        if let sv = enclosingScrollView ?? findScrollView() {
            enclosingScrollView = sv
            let contentHeight = sv.contentSize.height
            let scrollOffset = sv.contentOffset.y + sv.adjustedContentInset.top
            guard contentHeight > 0 else { return }

            let touchInScrollContent = localPoint.y + scrollOffset
            ny = Double(touchInScrollContent / contentHeight)
            contentH = Double(contentHeight)
        } else {
            let viewHeight = bounds.height
            guard viewHeight > 0 else { return }
            ny = Double(localPoint.y / viewHeight)
        }

        guard ny >= 0, ny <= 1.05 else { return }

        Task { @MainActor in
            UTTrackingService.shared.recordTap(
                screenId: screenId,
                normalizedX: min(max(nx, 0), 1),
                normalizedY: min(max(ny, 0), 1),
                contentHeight: contentH
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

// MARK: - Screen snapshot capture (one-time per screen, for heatmap watermarks)

struct UTScreenSnapshotModifier: ViewModifier {
    let screenId: String
    @State private var captured = false

    func body(content: Content) -> some View {
        content
            .background(
                UTScreenSnapshotTrigger(screenId: screenId, captured: $captured)
                    .frame(width: 0, height: 0)
            )
    }
}

struct UTScreenSnapshotTrigger: UIViewRepresentable {
    let screenId: String
    @Binding var captured: Bool

    func makeUIView(context: Context) -> UIView {
        let view = UTSnapshotProbeView()
        view.screenId = screenId
        view.onCapture = { [self] scrollView in
            guard !captured else { return }
            captured = true
            Task { @MainActor in
                UTTrackingService.shared.captureScreenSnapshot(screenId: screenId, scrollView: scrollView)
            }
        }
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {}
}

final class UTSnapshotProbeView: UIView {
    var screenId: String = ""
    var onCapture: ((UIScrollView?) -> Void)?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil else { return }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            guard let self else { return }
            let scrollView = self.findScrollView()
            self.onCapture?(scrollView)
        }
    }

    private func findScrollView() -> UIScrollView? {
        var current: UIView? = superview
        while let v = current {
            if let sv = v as? UIScrollView { return sv }
            current = v.superview
        }
        return nil
    }
}

// MARK: - Scroll depth tracking

struct UTScrollDepthModifier: ViewModifier {
    let screenId: String

    func body(content: Content) -> some View {
        content
            .background(
                GeometryReader { outer in
                    Color.clear
                        .preference(
                            key: UTScrollViewFrameKey.self,
                            value: outer.frame(in: .global)
                        )
                }
            )
            .onPreferenceChange(UTScrollViewFrameKey.self) { frame in
                guard frame.height > 0 else { return }
            }
            .overlay(
                GeometryReader { proxy in
                    UTScrollObserverView(screenId: screenId)
                        .frame(width: 0, height: 0)
                }
            )
    }
}

private struct UTScrollViewFrameKey: PreferenceKey {
    static var defaultValue: CGRect = .zero
    static func reduce(value: inout CGRect, nextValue: () -> CGRect) {
        value = nextValue()
    }
}

/// UIKit bridge to observe scroll offset via the nearest UIScrollView ancestor.
struct UTScrollObserverView: UIViewRepresentable {
    let screenId: String

    func makeUIView(context: Context) -> UIView {
        let view = UTScrollProbeView()
        view.screenId = screenId
        view.backgroundColor = .clear
        view.isUserInteractionEnabled = false
        return view
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        (uiView as? UTScrollProbeView)?.screenId = screenId
    }
}

final class UTScrollProbeView: UIView {
    var screenId: String = ""
    private var scrollObservation: NSKeyValueObservation?

    override func didMoveToWindow() {
        super.didMoveToWindow()
        guard window != nil, scrollObservation == nil else { return }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.attachToScrollView()
        }
    }

    private func attachToScrollView() {
        guard let scrollView = findScrollView(from: self) else { return }

        scrollObservation = scrollView.observe(\.contentOffset, options: [.new]) { [weak self, weak scrollView] _, _ in
            guard let self, let sv = scrollView else { return }
            let contentHeight = sv.contentSize.height
            let frameHeight = sv.bounds.height
            let insetBottom = sv.adjustedContentInset.bottom
            let scrollableHeight = contentHeight - frameHeight + insetBottom
            guard scrollableHeight > 0 else { return }

            let depth = (sv.contentOffset.y + sv.adjustedContentInset.top) / scrollableHeight
            let clamped = min(max(depth, 0), 1)

            Task { @MainActor in
                UTTrackingService.shared.updateScrollDepth(screenId: self.screenId, depth: clamped)
            }
        }
    }

    private func findScrollView(from view: UIView?) -> UIScrollView? {
        var current = view?.superview
        while let v = current {
            if let sv = v as? UIScrollView { return sv }
            current = v.superview
        }
        return nil
    }

    override func removeFromSuperview() {
        scrollObservation?.invalidate()
        scrollObservation = nil
        super.removeFromSuperview()
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

    func utScrollDepth(screenId: String) -> some View {
        modifier(UTScrollDepthModifier(screenId: screenId))
    }

    func utScreenSnapshot(screenId: String) -> some View {
        modifier(UTScreenSnapshotModifier(screenId: screenId))
    }

    func utInstrumented(screenId: String) -> some View {
        self
            .utStepTracking(screenId: screenId)
            .utTapCapture(screenId: screenId)
            .utScrollDepth(screenId: screenId)
            .utScreenSnapshot(screenId: screenId)
    }
}
#endif
