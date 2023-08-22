import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

abstract interface class BluetoothRepositoryInterface {
  Future<Result<List<BluetoothDeviceEntity>>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<Result<List<BluetoothDeviceEntity>>> getBluetoothDevicesStream();
  Future<Result<void>> stopBluetoothDevicesScan();
  Future<Result<void>> connectAtBluetoothDevice({
    required BluetoothDeviceEntity bluetoothDevice,
  });
  Future<Result<void>> disconnectAtBluetoothDevice();
  Future<Result<void>> printImage({
    required TicketConfigurationEntity ticketConfiguration,
    required Uint8List bytes,
  });
}
