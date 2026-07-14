library device_status_sync;

import 'dart:async';

import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/features/dashboard/dashboard_provider.dart';
import 'package:suraksha/services/ble_service.dart';

/// Keeps dashboard battery + BLE connection status in sync with device APIs.
class DeviceStatusSync {
  DeviceStatusSync(this._ref);

  final Ref _ref;
  final Battery _battery = Battery();
  StreamSubscription<BatteryState>? _batterySub;
  StreamSubscription<bool>? _bleSub;
  Timer? _batteryPoll;
  bool _started = false;

  Future<void> start() async {
    if (_started) return;
    _started = true;

    await _refreshBattery();
    _batteryPoll = Timer.periodic(const Duration(minutes: 2), (_) {
      unawaited(_refreshBattery());
    });
    _batterySub = _battery.onBatteryStateChanged.listen((_) {
      unawaited(_refreshBattery());
    });

    final ble = _ref.read(bleServiceProvider);
    _ref.read(dashboardProvider.notifier).setBandConnected(ble.isConnected);
    _bleSub = ble.connectionState.listen((connected) {
      _ref.read(dashboardProvider.notifier).setBandConnected(connected);
    });
  }

  Future<void> _refreshBattery() async {
    try {
      final level = await _battery.batteryLevel;
      _ref.read(dashboardProvider.notifier).setBattery(level.clamp(0, 100));
    } catch (_) {
      // Keep last known level if platform battery is unavailable.
    }
  }

  void dispose() {
    _batterySub?.cancel();
    _bleSub?.cancel();
    _batteryPoll?.cancel();
  }
}

final deviceStatusSyncProvider = Provider<DeviceStatusSync>((ref) {
  final sync = DeviceStatusSync(ref);
  ref.onDispose(sync.dispose);
  unawaited(sync.start());
  return sync;
});
