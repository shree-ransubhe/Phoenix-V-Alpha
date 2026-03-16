//
//  UTSessionCompleteView.swift
//  IndiGoPrototype
//
//  Post-session screen: rating, post-task questions, and export.
//

#if UT_VARIANT
import SwiftUI

struct UTSessionCompleteView: View {
    @EnvironmentObject private var tracker: UTTrackingService
    @State private var rating: Int = 3
    @State private var frustration: Int = 2
    @State private var feedback: String = ""
    @State private var communityStoriesAnswer: String = ""
    @State private var communityTriedMore: String = ""
    @State private var communityPaginationClear: String = ""
    @State private var submitted = false
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                headerSection
                if !submitted { formSection } else { thankYouSection }
            }
            .padding(24)
            .padding(.bottom, 60)
        }
        .background(IndiGoColors.background.ignoresSafeArea())
    }

    // MARK: - Header

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: submitted ? "checkmark.circle.fill" : "star.bubble")
                .font(.system(size: 44))
                .foregroundStyle(submitted ? IndiGoColors.successGreen : IndiGoColors.primaryMain)

            Text(submitted ? "Thank You!" : "Session Complete")
                .font(.custom("BauhausStd-Medium", size: 24))
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            if !submitted {
                Text("A few quick questions before we wrap up.")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .multilineTextAlignment(.center)
            }
        }
    }

    // MARK: - Form

    private var formSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            ratingRow(title: "How easy was the booking flow?", value: $rating, labels: ("Hard", "Easy"))
            ratingRow(title: "How frustrated did you feel?", value: $frustration, labels: ("Not at all", "Very"))

            Divider()

            Text("About the Community section")
                .font(IndiGoFonts.bodySemiBold())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            textQuestion("How many community stories did you notice?", binding: $communityStoriesAnswer)
            textQuestion("Did you try to see more? How?", binding: $communityTriedMore)
            textQuestion("Did the 1/3 indicator make sense?", binding: $communityPaginationClear)

            Divider()

            VStack(alignment: .leading, spacing: 6) {
                Text("Any other feedback?")
                    .font(IndiGoFonts.bodySemiBold())
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                TextEditor(text: $feedback)
                    .font(IndiGoFonts.bodySmall())
                    .frame(minHeight: 80)
                    .padding(8)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .strokeBorder(IndiGoColors.secondaryMedium, lineWidth: 1)
                    )
            }

            Button(action: submitSession) {
                Text("Submit & Finish")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(IndiGoColors.primaryMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
        }
    }

    // MARK: - Thank you + export

    @State private var skipped = false

    private var thankYouSection: some View {
        VStack(spacing: 16) {
            if skipped {
                Text("Session complete. You may close the app.")
                    .font(IndiGoFonts.body())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .multilineTextAlignment(.center)
            } else {
                Text("Your responses have been recorded.")
                    .font(IndiGoFonts.body())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .multilineTextAlignment(.center)

                if tracker.audioConsent {
                    HStack(spacing: 8) {
                        Image(systemName: "mic.badge.xmark")
                            .font(.system(size: 14))
                        Text("Audio recording has been stopped and will be included in the export.")
                            .font(IndiGoFonts.bodyExtraSmall())
                    }
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .padding(10)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(IndiGoColors.secondaryLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }

                Button(action: exportData) {
                    HStack(spacing: 8) {
                        Image(systemName: "square.and.arrow.up")
                        Text("Export Session Data")
                    }
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(IndiGoColors.secondaryLight)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .strokeBorder(IndiGoColors.primaryMain, lineWidth: 1)
                    )
                }

                Text(tracker.audioConsent
                     ? "Exports JSON session data + audio file via Email, WhatsApp, AirDrop, or Files."
                     : "Share via Email, WhatsApp, AirDrop, or save to Files.")
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)
                    .multilineTextAlignment(.center)

                Button(action: { withAnimation { skipped = true } }) {
                    Text("Skip for now")
                        .font(IndiGoFonts.bodySmall())
                        .foregroundStyle(IndiGoColors.forYouTextTertiary)
                        .underline()
                }
                .padding(.top, 4)

                HStack(spacing: 6) {
                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 11))
                    Text("Skipping means session data stays only on this device and the server. Export to avoid data loss.")
                        .font(IndiGoFonts.bodyExtraSmall())
                }
                .foregroundStyle(Color(hex: "A97D0E"))
                .padding(10)
                .background(Color(hex: "FFF8E5"))
                .clipShape(RoundedRectangle(cornerRadius: 8))
            }
        }
    }

    // MARK: - Helpers

    private func ratingRow(title: String, value: Binding<Int>, labels: (String, String)) -> some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(IndiGoFonts.bodySemiBold())
                .foregroundStyle(IndiGoColors.forYouTextPrimary)

            HStack {
                Text(labels.0)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)

                ForEach(1...5, id: \.self) { star in
                    let selected = star <= value.wrappedValue
                    Image(systemName: selected ? "circle.fill" : "circle")
                        .font(.system(size: 24))
                        .foregroundStyle(selected ? IndiGoColors.primaryMain : IndiGoColors.secondaryMedium)
                        .onTapGesture { value.wrappedValue = star }
                }

                Text(labels.1)
                    .font(IndiGoFonts.bodyExtraSmall())
                    .foregroundStyle(IndiGoColors.forYouTextTertiary)
            }
        }
    }

    private func textQuestion(_ question: String, binding: Binding<String>) -> some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(question)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)

            TextField("Your answer", text: binding)
                .font(IndiGoFonts.bodySmall())
                .padding(10)
                .background(IndiGoColors.secondaryLight)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .strokeBorder(IndiGoColors.secondaryMedium, lineWidth: 1)
                )
        }
    }

    private func submitSession() {
        let answers: [UTPostTaskAnswer] = [
            .init(question: "Community stories noticed", answer: communityStoriesAnswer),
            .init(question: "Tried to see more", answer: communityTriedMore),
            .init(question: "1/3 indicator clear", answer: communityPaginationClear),
        ]
        tracker.endSession(
            rating: rating,
            frustration: frustration,
            feedback: feedback.isEmpty ? nil : feedback,
            postTaskAnswers: answers
        )
        withAnimation { submitted = true }
    }

    private func exportData() {
        let files = tracker.exportableFiles()
        guard !files.isEmpty else { return }

        let activityVC = UIActivityViewController(activityItems: files, applicationActivities: nil)
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let rootVC = windowScene.windows.first?.rootViewController
        else { return }
        var presenter = rootVC
        while let presented = presenter.presentedViewController {
            presenter = presented
        }
        if let popover = activityVC.popoverPresentationController {
            popover.sourceView = presenter.view
            popover.sourceRect = CGRect(x: presenter.view.bounds.midX, y: presenter.view.bounds.midY, width: 0, height: 0)
            popover.permittedArrowDirections = []
        }
        presenter.present(activityVC, animated: true)
    }
}
#endif
