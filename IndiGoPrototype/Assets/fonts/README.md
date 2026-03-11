# IndiGo Native — Font assets

This folder contains the three primary fonts for the IndiGo Design System. Always refer to these in the design system and app.

| File | Design system token | Usage |
|------|---------------------|--------|
| `BauhausStd-Medium.ttf` | `fontDisplay` / `BauhausStd-Medium` | Display (L, M, S, XS) |
| `Poppins-Regular.ttf` | `fontBody` / `Poppins-Regular` | Body, Label, Link regular |
| `Poppins-SemiBold.ttf` | `fontBodySemiBold` / `Poppins-SemiBold` | Headings, Body/Label Semi Bold, Link bold |

**Loading:** Link these assets via `react-native.config.js` (e.g. `project.assets = ['./assets/fonts']`) and load with `react-native-asset` or your bundler’s font linking so that `fontFamily: 'BauhausStd-Medium'` etc. resolve at runtime.
