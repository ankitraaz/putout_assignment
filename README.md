# Kutoot — Premium Shopping & Rewards Platform

<p align="center">
  <img src="assets/images/k_logo.png" width="100" height="100" style="border-radius: 20px" />
</p>

<p align="center">
  <b>Shop. Earn. Repeat.</b><br/>
  A feature-rich Flutter shopping & rewards platform built with highly scaled Native architectural constraints and optimized seamlessly for 120 FPS performance in Production.
</p>

<p align="center">
  <img src="https://img.shields.io/badge/Flutter-3.11+-02569B?logo=flutter" />
  <img src="https://img.shields.io/badge/Dart-Isolates-0175C2?logo=dart" />
  <img src="https://img.shields.io/badge/State-Riverpod-5C6BC0" />
  <img src="https://img.shields.io/badge/Performance-120FPS-4CAF50" />
  <img src="https://img.shields.io/badge/Architecture-Feature--First-4CAF50" />
</p>

---

## What is Kutoot?

Kutoot is a premium shopping app and rewards management platform empowering users to discover stores, engage in curated discount flows, upgrade their platform subscriptions, and track transactional histories smoothly.

I constructed this system entirely focused on **enterprise-grade performance**, establishing clean separation of logic from UI, and integrating "The Performance Architect" constraints natively on Android and iOS platforms.

---


---

## Premium Enhancements & Screens

The app leverages **7 core functional layouts** connected through a hybridized IndexedStack bottom navigation and distinct modal push routes:

| Component | Description |
|--------|------|
| **Home Dashboard** | Location discovery, dynamic banner components, nearby stores mapping, horizontal UI components. |
| **Store Grids** | Dynamic filtering via derived providers matching UI elements globally. |
| **Rewards System** | Complex Squircle Custom Painter cards enforcing visual boundaries seamlessly. |
| **Premium Subscriptions** | Decoupled standalone upgrade screen featuring glassmorphic designs, plan matrices, and animated interactions. |
| **Profile Configurations** | Implemented interactive features such as OS clipboard copying for dynamic discount coupons, and transactional caches. |

---

## 🚀 "The Performance Architect" Constraints

It is rigorously engineered under specialized performance thresholds ensuring absolute zero-stutter frame rates during dense infinite scrolls via native optimizations:

| Optimization | Method | Benefit |
|-------------|--------------|---------|
| **Isolate Data Decoders** | `dart:isolate` + `Isolate.run()` | Offloads heavy structural JSON decode blocks off the UI main thread into background processors for both Local SharedPreferences (Transactions) and Assets (Providers). |
| **Paint Constraints** | `RepaintBoundary` Wrappers | Caps isolated rendering geometry directly around rapidly changing layouts, freezing heavy custom painters behind static limits locally. |
| **Fast-Scroll Protection** | `cacheWidth: 300 / 600` | Drastically maps bounding box limits mathematically preventing heavy remote Images from spiking Application RAM loads. |
| **Visual Architecture** | `CustomPainter` Integrations | Eradicates unnecessary deep tree layouts (`Container` nesting) by drawing specialized UI tickets and dotted paths onto canvas contexts directly natively. |

---

## Native Release Adaptability

The codebase includes specific App Transport Security bounds guaranteeing external endpoints function seamlessly on deployed Hardware:

* **Android 9+ Cleartext Protection:** Configured `AndroidManifest.xml` permitting `android:usesCleartextTraffic` across domains safely.
* **Apple Arbitrary HTTP Blocks:** Handled `NSAppTransportSecurity` arrays actively inside iOS `Info.plist`.

---

## Getting Started

### Prerequisites
- Flutter SDK `3.11+`
- Configured iOS / Android emulators
- Any modern IDE supporting Dart runtimes.

### Run Debug
```bash
git clone https://github.com/ankitraaz/putout_assignment.git
cd kuttot
flutter pub get
flutter run
```

### ⚡ Build Split APKs (Extremely Lightweight)
Rather than a heavy universal FAT Apk, the platform divides architectural bounds per processor using:
```bash
flutter build apk --release --split-per-abi
```

**Generates 3 Ultra-light Deployments:**
- `app-armeabi-v7a-release.apk` (≈ 17MB) — Pre-2018 ARM Androids.
- `app-arm64-v8a-release.apk` (≈ 19MB) — Absolute Modern 64-bit Mobile SOCs.
- `app-x86_64-release.apk` (≈ 21MB) — Hardware Emulators.

### Direct Install
```bash
flutter install
```

---

## Application Tech Stack

| Domain | Technology Layer |
|-------|------|
| **Framework Base** | Flutter |
| **State Pipeline** | Riverpod |
| **Client Storage** | Local Hive + SharedPreferences |
| **Type Layouts** | Google Fonts `inter`, `oswald` |

---

<p align="center">
  Built explicitly for <b>High Performance Shopping</b> 💙
</p>

