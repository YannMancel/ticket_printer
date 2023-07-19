import 'package:ticket_printer/src/data/_data.dart';

abstract class RemoteDataSourceInterface {
  Future<List<BluetoothDeviceModel>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<List<BluetoothDeviceModel>> getBluetoothDevicesStream();
  Future<void> stopBluetoothDevicesScan();
}
