library ble_service;

import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:suraksha/services/wristband_sos_service.dart';

class BleService {
  Stream<bool> get isScanning => FlutterBluePlus.isScanning;

  Future<void> startScan() async {
    if (await FlutterBluePlus.isSupported == false) return;
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 8));
  }

  Future<void> stopScan() => FlutterBluePlus.stopScan();

  Stream<List<BluetoothDevice>> get scanResults =>
      FlutterBluePlus.scanResults.map(
        (results) => results.map((r) => r.device).toList(),
      );

  Future<bool> connectToBand(BluetoothDevice device) async {
    await device.connect(timeout: const Duration(seconds: 12));
    return device.isConnected;
  }

  /// When BLE SOS characteristic reports a double-tap, forward to the app.
  void forwardBandDoubleTap(WristbandSosService sos) {
    sos.notifyBandDoubleTap();
  }
}

final bleServiceProvider = Provider<BleService>((ref) => BleService());
