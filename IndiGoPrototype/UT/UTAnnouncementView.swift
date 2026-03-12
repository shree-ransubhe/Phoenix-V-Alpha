//
//  UTAnnouncementView.swift
//  IndiGoPrototype
//
//  Friendly consent screen shown before the usability session begins.
//

#if UT_VARIANT
import SwiftUI

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
                        text: "We'll record how you navigate the app and how long you spend on each screen."
                    )
                    bulletRow(
                        icon: "hand.tap",
                        text: "Your taps and interactions will be captured to understand usage patterns."
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
#endif
