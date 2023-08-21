// ignore_for_file: void_checks

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

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

  @override
  Future<void> connectAtBluetoothDevice({
    required BluetoothDeviceModel model,
    BluetoothDevice? fakeBluetoothDevice,
  }) async {
    await _bluetoothPrint.connect(fakeBluetoothDevice ?? model.toThirdParty);
  }

  @override
  Future<void> disconnectAtBluetoothDevice() async {
    await _bluetoothPrint.disconnect();
  }
}
