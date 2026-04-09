//
//  UTAnnouncementView.swift
//  IndiGoPrototype
//
//  Friendly consent screen shown before the usability session begins.
//

#if UT_VARIANT
import SwiftUI

#if ALPHA_5_0

struct UTAnnouncementView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text("Help us improve\nyour experience")
                    .font(.custom("BauhausStd-Medium", size: 28))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                VStack(alignment: .leading, spacing: 12) {
                    bulletRow(
                        icon: "clock",
                        text: "We'll observe how you navigate the app to understand what works and what doesn't."
                    )
                    bulletRow(
                        icon: "hand.tap",
                        text: "Your interactions will be captured to understand usage patterns — no personal information is collected."
                    )
                    bulletRow(
                        icon: "lock.shield",
                        text: "We will not record your name, mobile number, or any personal details. All data is anonymous."
                    )
                    bulletRow(
                        icon: "doc.text",
                        text: "No real bookings or payments will be made. You can stop at any time — there are no wrong answers."
                    )
                }
                .padding(.horizontal, 8)
            }
            .padding(24)

            Spacer()

            Button(action: onContinue) {
                Text("I'm Ready")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(IndiGoColors.primaryMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(IndiGoColors.background.ignoresSafeArea())
    }

    private func bulletRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(IndiGoColors.primaryMain)
                .frame(width: 24)

            Text(text)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#else

struct UTAnnouncementView: View {
    let onContinue: (_ audioConsent: Bool) -> Void

    @State private var audioConsent = true

    var body: some View {
        VStack(spacing: 0) {
            Spacer()

            VStack(spacing: 24) {
                Image(systemName: "hand.wave.fill")
                    .font(.system(size: 48))
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text("Help us improve\nyour experience")
                    .font(.custom("BauhausStd-Medium", size: 28))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                VStack(alignment: .leading, spacing: 12) {
                    bulletRow(
                        icon: "clock",
                        text: "We'll record how you navigate the app and how long you spend on each screen."
                    )
                    bulletRow(
                        icon: "hand.tap",
                        text: "Your taps, scroll depth, and interactions will be captured to understand usage patterns."
                    )
                    bulletRow(
                        icon: "lock.shield",
                        text: "All data is anonymous and used only for this research. No real bookings or payments."
                    )
                    bulletRow(
                        icon: "xmark.circle",
                        text: "You can stop at any time — there are no wrong answers."
                    )
                }
                .padding(.horizontal, 8)

                audioConsentToggle
            }
            .padding(24)

            Spacer()

            Button(action: { onContinue(audioConsent) }) {
                Text("I'm Ready")
                    .font(IndiGoFonts.buttonMobile())
                    .foregroundStyle(.white)
                    .frame(maxWidth: .infinity)
                    .frame(height: 52)
                    .background(IndiGoColors.primaryMain)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 40)
        }
        .background(IndiGoColors.background.ignoresSafeArea())
    }

    private var audioConsentToggle: some View {
        VStack(spacing: 8) {
            Divider()
                .padding(.vertical, 4)

            Toggle(isOn: $audioConsent) {
                HStack(alignment: .top, spacing: 12) {
                    Image(systemName: "mic.fill")
                        .font(.system(size: 16))
                        .foregroundStyle(audioConsent ? IndiGoColors.primaryMain : IndiGoColors.forYouTextTertiary)
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 2) {
                        Text("Record audio during session")
                            .font(IndiGoFonts.bodySemiBold())
                            .foregroundStyle(IndiGoColors.forYouTextPrimary)

                        Text("Voice recording helps us capture verbal feedback. The audio stays on this device and is included in the session export.")
                            .font(IndiGoFonts.bodyExtraSmall())
                            .foregroundStyle(IndiGoColors.forYouTextTertiary)
                            .fixedSize(horizontal: false, vertical: true)
                    }
                }
            }
            .toggleStyle(SwitchToggleStyle(tint: IndiGoColors.primaryMain))
        }
    }

    private func bulletRow(icon: String, text: String) -> some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 16))
                .foregroundStyle(IndiGoColors.primaryMain)
                .frame(width: 24)

            Text(text)
                .font(IndiGoFonts.bodySmall())
                .foregroundStyle(IndiGoColors.forYouTextSecondary)
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#endif
#endif
