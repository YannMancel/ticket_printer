import 'package:ticket_printer/src/_src.dart';

abstract interface class BluetoothDevicesRepositoryInterface {
  Future<Result<List<BluetoothDeviceEntity>>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<Result<List<BluetoothDeviceEntity>>> getBluetoothDevicesStream();
  Future<Result<void>> stopBluetoothDevicesScan();
}
