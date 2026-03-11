# IndiGo Mobile App 2026 – iOS Prototype

Pixel-accurate iOS prototype for **usability testing** (e.g. at airport). Built with SwiftUI, component-by-component, with animated transitions and Lottie support.

## Requirements

- **Xcode 15+** (iOS 17+)
- **macOS** (for building and Simulator)
- [XcodeGen](https://github.com/yonaskolb/XcodeGen) (optional; used to regenerate the Xcode project from `project.yml`)

## Setup

1. **Open the project**
   - Open `IndiGoPrototype.xcodeproj` in Xcode.
   - On first open, Xcode will resolve the **Lottie** Swift Package; wait for it to finish.

2. **Run the app**
   - Select an iPhone simulator (e.g. iPhone 17) and press **Run** (⌘R).

3. **Regenerating the Xcode project** (if you change `project.yml`)
   - Install XcodeGen: `brew install xcodegen`
   - From the repo root: `xcodegen generate`
   - Reopen `IndiGoPrototype.xcodeproj` in Xcode.

## Structure

- **App** – `@main` app entry, `ContentView` (root `NavigationStack`).
- **Core/Design** – Design tokens: `IndiGoColors`, `IndiGoFonts`, `IndiGoSpacing`.
- **Core/State** – `BookingState` (From/To, date, travellers).
- **Components/Atoms** – Buttons, chips, icon button (use tokens only).
- **Components/Molecules** – Header bar, cards, From/To select, etc. (use atoms + tokens).
- **Features** – Home, Book (FromTo, When, Who), SRP, FareSelection (compose molecules).
- **Data** – `MockCities`, `MockFlights`.
- **Resources** – `Assets.xcassets`, `LottieAnimationView` wrapper, `Resources/Lottie/` for Lottie JSONs.
- **Extensions** – e.g. `View+Transitions` for custom transitions.

## Dependencies

- **Lottie** (SPM): [airbnb/lottie-ios](https://github.com/airbnb/lottie-ios) – for Lottie JSON animations (loading, success). Version pinned in `project.yml`.

## Design source

- **Figma**: [IndiGo Mobile App 2026](https://www.figma.com/design/9FpDjxH8iFqU21bgDng04G/IndiGo-Mobile-App-2026?node-id=3-9141)
- Use Figma Dev Mode to align colors, fonts, and spacing in `Core/Design`.

## IndiGo Native 1 (React Native) – reference only

The project **IndiGo Native 1** on the local server contains reusable components in **React Native**. This prototype is **Swift/SwiftUI** and does **not** depend on that project or React Native:

- **No code reuse**: RN components cannot run inside this iOS app; we build equivalent SwiftUI components here.
- **No build dependency**: This project does not reference or build IndiGo Native 1, so it stays self-contained and quick to build.
- **Optional reference**: You can use IndiGo Native 1 as a **design/UX reference** (e.g. token values, component behaviour, copy) when implementing screens—copy the intent into SwiftUI, not the JS/TS code.

## Build from command line

```bash
cd "/path/to/Phoenix-prototype"
xcodebuild -scheme IndiGoPrototype -destination 'platform=iOS Simulator,name=iPhone 17' build
```

Replace `iPhone 17` with any available simulator from `xcodebuild -destinations`.
