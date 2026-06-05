# Suraksha — Flutter Companion App

Women's safety IoT wearable companion app (hybrid build: yellow tracking dashboard + crimson marketing site).

## Run

```bash
export PATH="$HOME/flutter-sdk/bin:$PATH"   # or your Flutter SDK path
cd suraksha-app
flutter pub get
flutter run
```

## Routes

| Path | Screen |
|------|--------|
| `/splash` | Brand splash |
| `/onboarding` | First-launch intro |
| `/tracking` | Map + People/Places sheet (main app) |
| `/sos/countdown` | 3s SOS countdown + swipe to cancel |
| `/home` | Crimson marketing landing |
| `/login`, `/signup` | Auth (AMS with offline fallback) |
| `/evidence`, `/profile` | Vault and settings |

## Architecture

- **State:** Riverpod `StateNotifier`
- **Navigation:** go_router
- **Maps:** flutter_map ^8.3 + dark OSM tiles (Kathmandu default)
- **Phase 3 services:** AMS API, geolocator, BLE scan, Hive evidence encryption, local notifications
