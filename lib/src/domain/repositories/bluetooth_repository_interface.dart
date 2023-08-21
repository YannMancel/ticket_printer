import 'package:ticket_printer/src/_src.dart';

abstract interface class BluetoothRepositoryInterface {
  Future<Result<List<BluetoothDeviceEntity>>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<Result<List<BluetoothDeviceEntity>>> getBluetoothDevicesStream();
  Future<Result<void>> stopBluetoothDevicesScan();
  Future<Result<void>> connectAtBluetoothDevice({
    required BluetoothDeviceEntity entity,
  });
  Future<Result<void>> disconnectAtBluetoothDevice();
}
