# Kutoot - Shopping & Rewards App (Putout Assignment)

Welcome to the **Kutoot** project repository! This is a complete, high-performance Flutter application developed as a shopping and rewards platform assignment.

## 🚀 Features

*   **Shopping UI & Discovery:** Pixel-perfect, modern UI with smooth navigation, curated store cards, and responsive banner layouts.
*   **State Management:** Built using feature-first clean architecture with **Riverpod** for state management.
*   **Local Storage & Caching:** Integrated local JSON data for stores, categories, and rewards using **Hive**.
*   **Search Functionality:** Functional search with debouncing and keyword filtering.
*   **Flight Booking Integration:** Integrated flight booking API for searching, listing, pagination, and robust error handling.
*   **Optimized Performance:** Fully optimized Release APK generation with split ABIs for minimum app size (ARM64, v7a, x86_64).

## 🛠 Tech Stack

*   **Framework:** Flutter (stable SDK 3.41+)
*   **State Management:** Riverpod 
*   **Local Storage:** Hive, SharedPreferences
*   **Fonts & Design:** Google Fonts, Cupertino Icons
*   **Architecture:** Feature-First Clean Architecture

## 📱 How to Run locally

1. Ensure you have the Flutter SDK installed on your machine.
2. Clone this repository:
   ```bash
   git clone https://github.com/ankitraaz/putout_assignment.git
   ```
3. Navigate into the project directory:
   ```bash
   cd kuttot
   ```
4. Install dependencies:
   ```bash
   flutter pub get
   ```
5. Run the app on your preferred emulator or device:
   ```bash
   flutter run
   ```

## 📦 Building optimized APK

To generate a split-ABI optimized release APK for Android machines, run:
```bash
flutter build apk --release --split-per-abi
```
To install it into your active android device:
```bash
flutter install
```
