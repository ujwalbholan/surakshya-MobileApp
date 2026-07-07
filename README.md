# Suraksha — Flutter Companion App

Women's safety IoT wearable companion app (hybrid build: yellow tracking dashboard + crimson marketing site).

## Run

```bash
export PATH="$HOME/flutter-sdk/bin:$PATH"   # or your Flutter SDK path
cd suraksha-app
flutter pub get
flutter run
```

### Android emulator (recommended)

`flutter run` can fail with `Can't find service: package` if the emulator is still booting or adb is stale. Use the helper script:

```bash
cd suraksha-app
./scripts/run_android.sh
# or a specific device:
./scripts/run_android.sh emulator-5554
```

To only wait for a ready emulator (then run flutter yourself):

```bash
./scripts/ensure_android_emulator.sh emulator-5554
flutter run -d emulator-5554
```

**If install still fails:** cold boot the AVD in Android Studio (Device Manager → ⋮ → Cold Boot Now), or:

```bash
adb -s emulator-5554 emu kill
emulator -avd Medium_Phone_API_36.1 -no-snapshot-load &
./scripts/ensure_android_emulator.sh
flutter run -d emulator-5554
```

**Kotlin Gradle warning** (`shared_preferences_android` applies KGP): harmless for now. `android/gradle.properties` already sets `android.builtInKotlin=true` per [Flutter’s migration guide](https://docs.flutter.dev/release/breaking-changes/migrate-to-built-in-kotlin). Upgrade Flutter/plugins over time to silence it.

**Backend URL on emulator:** Surakshya API defaults to `http://10.0.2.2:3000` (see `lib/core/constants/app_constants.dart`).

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
