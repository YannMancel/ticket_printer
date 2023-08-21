import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/data/_data.dart';

abstract interface class RemoteDataSourceInterface {
  Future<List<BluetoothDeviceModel>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<List<BluetoothDeviceModel>> getBluetoothDevicesStream();
  Future<void> stopBluetoothDevicesScan();
  Future<void> connectAtBluetoothDevice({
    required BluetoothDeviceModel model,
    BluetoothDevice? fakeBluetoothDevice,
  });
  Future<void> disconnectAtBluetoothDevice();
}
