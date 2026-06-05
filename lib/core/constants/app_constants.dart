library app_constants;

class AppConstants {
  AppConstants._();

  static const double tabletBreakpoint = 768.0;
  static const double desktopBreakpoint = 1024.0;

  static const String amsBaseUrl = 'https://ams-omwj.onrender.com';
  static const String prefsOnboardingDone = 'onboarding_done';
  static const String prefsLoggedIn = 'logged_in';
  static const String prefsMarketingSeen = 'marketing_seen';
  static const String policeSosEndpoint = '/police/sos';

  static const double mapDefaultZoom = 15.0;
  static const double mapDefaultLat = 27.7172;
  static const double mapDefaultLng = 85.3240;
  static const Duration liveLocationPollInterval = Duration(minutes: 1);
  static const Duration locationFetchTimeout = Duration(seconds: 15);
  static const double locationGeocodeMinDistanceMeters = 80;

  static const int sosCountdownSeconds = 5;
  static const double sosOvalWidth = 110;
  static const double sosOvalHeight = 145;
  static const double sosOvalRadius = 55;
  static const int sosOvalDotCount = 30;
  static const double sosOvalDotRadius = 3.0;
  static const double sosOvalPainterPad = 12.0;
  static const double sosOvalDotStartOffset = 0.62;
  static const int sosRadarRingCount = 5;
  static const double sosAvatarSize = 42;
  static const double sosOrbitRadiusX = 105;
  static const double sosOrbitRadiusY = 85;
  static const Duration bandDoubleTapWindow = Duration(milliseconds: 450);
  static const double sheetInitialSize = 0.38;
  static const double sheetMinSize = 0.22;
  static const double sheetMaxSize = 0.72;
}
