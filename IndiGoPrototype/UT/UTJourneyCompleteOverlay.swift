//
//  UTJourneyCompleteOverlay.swift
//  IndiGoPrototype
//
//  Friendly overlay shown after the user selects a fare, signalling
//  the journey test is done and guiding them to the feedback screen.
//

#if UT_VARIANT
import SwiftUI

struct UTJourneyCompleteOverlay: View {
    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .ignoresSafeArea()

            VStack(spacing: 20) {
                Image(systemName: "airplane.arrival")
                    .font(.system(size: 48))
                    .foregroundStyle(IndiGoColors.primaryMain)

                Text("You've completed\nthe booking journey!")
                    .font(.custom("BauhausStd-Medium", size: 24))
                    .tracking(0.4)
                    .multilineTextAlignment(.center)
                    .foregroundStyle(IndiGoColors.forYouTextPrimary)

                Text("Thank you for going through the full flow.\nWe just have a few quick questions\nbefore we wrap up.")
                    .font(IndiGoFonts.bodySmall())
                    .foregroundStyle(IndiGoColors.forYouTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 8)

                #if !ALPHA_5_0
                if UTTrackingService.shared.audioConsent {
                    HStack(spacing: 6) {
                        Image(systemName: "mic.fill")
                            .font(.system(size: 11))
                        Text("Audio recording is still active — it will stop when you continue.")
                            .font(IndiGoFonts.bodyExtraSmall())
                    }
                    .foregroundStyle(IndiGoColors.primaryMain)
                    .padding(8)
                    .background(IndiGoColors.secondaryLight)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                #endif

                Button {
                    UTTrackingService.shared.endSession(
                        rating: nil, frustration: nil, feedback: nil
                    )
                } label: {
                    Text("Continue to Feedback")
                        .font(IndiGoFonts.buttonMobile())
                        .foregroundStyle(.white)
                        .frame(maxWidth: .infinity)
                        .frame(height: 52)
                        .background(IndiGoColors.primaryMain)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
            }
            .padding(32)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.15), radius: 20)
            )
            .padding(.horizontal, 32)
        }
    }
}
#endif
