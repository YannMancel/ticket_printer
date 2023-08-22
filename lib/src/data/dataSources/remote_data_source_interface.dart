import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

abstract interface class RemoteDataSourceInterface {
  Future<List<BluetoothDeviceModel>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<List<BluetoothDeviceModel>> getBluetoothDevicesStream();
  Future<void> stopBluetoothDevicesScan();
  Future<void> connectAtBluetoothDevice({
    required BluetoothDeviceModel bluetoothDevice,
    BluetoothDevice? fakeBluetoothDevice,
  });
  Future<void> disconnectAtBluetoothDevice();
  Future<void> printImage({
    required TicketConfigurationModel ticketConfiguration,
    required Uint8List bytes,
    List<LineText>? fakePrintedData,
  });
}
