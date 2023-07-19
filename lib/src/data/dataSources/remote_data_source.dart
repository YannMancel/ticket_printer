// ignore_for_file: void_checks

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/data/_data.dart';

/// This data source allows to manage the bluetooth features.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// ```
class RemoteDataSource implements RemoteDataSourceInterface {
  const RemoteDataSource({
    required BluetoothPrint bluetoothPrint,
  }) : _bluetoothPrint = bluetoothPrint;

  final BluetoothPrint _bluetoothPrint;

  @override
  Future<List<BluetoothDeviceModel>> startBluetoothDevicesScan({
    Duration? timeout,
  }) async {
    final bluetoothDevices = await _bluetoothPrint.startScan(
      timeout: timeout,
    );

    return (bluetoothDevices as List<BluetoothDevice>).toModels;
  }

  @override
  Stream<List<BluetoothDeviceModel>> getBluetoothDevicesStream() async* {
    await for (final bluetoothDevices in _bluetoothPrint.scanResults) {
      yield bluetoothDevices.toModels;
    }
  }

  @override
  Future<void> stopBluetoothDevicesScan({Duration? timeout}) async {
    return _bluetoothPrint.stopScan();
  }
}
