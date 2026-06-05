library splash_content;

/// Hero copy and stats — parity with web HeroSection, mobile-appropriate hints.
class SplashContent {
  SplashContent._();

  static const eyebrow = 'SRK-X1';
  static const headlineLine1 = 'THE GUARDIAN';
  static const headlineLine2 = 'ON YOUR WRIST';
  static const body =
      'Precision-engineered safety hardware. Real-time location sharing, '
      'instant SOS, and family peace of mind — always within reach.';

  static const stats = [
    SplashStat(value: '0.8s', label: 'SOS response'),
    SplashStat(value: '14d', label: 'Battery life'),
    SplashStat(value: 'IP68', label: 'Waterproof'),
  ];

  static const statusHint = 'Initializing secure session…';
}

class SplashStat {
  const SplashStat({required this.value, required this.label});

  final String value;
  final String label;
}
