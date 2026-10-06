# 🏏 Gully & Weekend Cricket Scorer

A fast, lightweight, zero-overhead cricket scoring mobile and web application built using **Flutter**. Designed specifically for **weekend, box, turf, and gully cricket matches** where team sizes, player availability, and match overs fluctuate each week.

---

## ✨ Features Built for Weekend Cricket

* **⚡ Zero Player Overhead:** No player registration, lineups, or bowler tracking required. Just **Team A vs Team B** (or Team 1 vs Team 2).
* **👥 Flexible Headcount & Wickets:** Play with 4 players (3 wickets), 5 players (4 wickets), or full 11 players (10 wickets). Custom wicket limit supported.
* **🏏 Standard Street Rules for Extras:**
  * **Wide Balls & No-Balls:** 1 extra run added + bowler must bowl a **re-ball**.
  * **Custom Extras Support:** Handle extra runs (e.g. 1 Wide + 2 runs by running, No-Ball + 4 off bat, Byes, Leg-byes).
* **🔄 Fast One-Tap Undo:** Easily revert mistakes or contested calls on the ground with one tap.
* **⏱️ Mid-Match Overs Adjustment:** Change total overs in real-time if time is limited, rain interrupts, or natural light fades.
* **🎯 Real-Time 2nd Innings Target Calculator:** Displays required runs, balls left, and required run rate (RRR) live as each ball is bowled.
* **🔒 Temporary & Local-First Storage:**
  * **100% Offline & Ephemeral:** Zero external servers or cloud databases.
  * **Crash Recovery:** Ongoing match state is cached locally in `SharedPreferences` so you never lose the score if the phone screen locks or app minimizes.
  * **1-Tap Wipe Data:** A "Clear All Data" button permanently wipes all stored match history to satisfy strict IT/privacy policies.

---

## 🛠️ Architecture & Tech Stack

* **Framework:** Flutter (Mobile Android / iOS & Web PWA)
* **State Management:** `Provider` (`ChangeNotifier`) for clean, reactive, zero-boilerplate scoring state.
* **Persistence:** `shared_preferences` (Client-side key-value cache).
* **Theme:** Sunlight-optimized dark high-contrast theme (Emerald Green, Amber, Crimson Red).

---

## 🚀 How to Run Locally

### Prerequisites
Make sure you have the Flutter SDK installed on your development machine.

### 1. Get Dependencies
```bash
flutter pub get
```

### 2. Run on Mobile (Android / iOS)
Connect your mobile device via USB or start an emulator:
```bash
flutter run
```

### 3. Run on Chrome (Web)
```bash
flutter run -d chrome
```

---

## 📱 Distribution & Deployment (Bypassing IT Restrictions)

### Option 1: Direct Android APK (Sideloading)
Build a standalone APK and share it directly to your phone (via USB, WhatsApp, or Google Drive):
```bash
flutter build apk --release --split-per-abi
```
The output `.apk` file will be in:
`build/app/outputs/flutter-apk/app-arm64-v8a-release.apk`

---

### Option 2: Free Hosting on GitHub Pages (Zero-Install PWA)
This project includes a pre-configured GitHub Actions CI/CD workflow (`.github/workflows/deploy.yml`).

1. **Initialize Git and Push to GitHub:**
   ```bash
   git init
   git add .
   git commit -m "Initial commit of Gully Cricket Scorer"
   git branch -M main
   git remote add origin https://github.com/<your-username>/<your-repo-name>.git
   git push -u origin main
   ```

2. **Enable GitHub Pages:**
   * Go to your repository settings on GitHub: **Settings > Pages**.
   * Under **Build and deployment > Source**, select **Deploy from a branch** and choose branch **`gh-pages`** (`/ (root)`).

3. **Open on any Mobile Phone:**
   * Open the GitHub Pages URL on mobile Safari or Chrome.
   * Tap **"Add to Home Screen"** to install it as an offline Progressive Web App (PWA) with full app feel.

---

## 📂 Project Structure

```
gully_cricket_scorer/
├── .github/
│   └── workflows/
│       └── deploy.yml            # Automated Web PWA & APK GitHub Actions
├── lib/
│   ├── main.dart                 # App initialization & auto-resume
│   ├── models/
│   │   ├── ball_event.dart       # Ball events, runs, extras, wickets
│   │   ├── match_config.dart     # Custom overs, wickets, team configs
│   │   ├── innings.dart          # Scores, CRR, boundaries, over summaries
│   │   └── match_record.dart     # Match state, target calculation, winner logic
│   ├── providers/
│   │   └── match_provider.dart   # Central state manager with undo & persistence
│   ├── services/
│   │   └── storage_service.dart  # Temporary local storage & privacy wipe
│   ├── theme/
│   │   └── app_theme.dart        # Sunlight-readable high contrast dark theme
│   ├── screens/
│   │   ├── setup_screen.dart     # Quick overs/wickets/toss configuration
│   │   ├── live_scoring_screen.dart # Real-time keypad, live over ticker, target card
│   │   ├── match_summary_screen.dart# Winner presentation & over-by-over review
│   │   └── history_screen.dart   # Recent matches & 1-tap data wipe
│   └── widgets/
│       ├── score_display.dart    # High-contrast primary score widget
│       ├── target_card.dart      # 2nd innings target chase card
│       ├── over_timeline.dart    # Ball-by-ball pill strip
│       ├── keypad.dart           # Large tactile scoring buttons
│       ├── extras_dialog.dart    # Custom extras modal
│       ├── wicket_dialog.dart    # Dismissal method selector
│       └── adjust_overs_dialog.dart # Mid-match overs changer
├── web/
│   ├── index.html                # Web entry with mobile meta tags
│   └── manifest.json             # PWA manifest
└── pubspec.yaml
```
