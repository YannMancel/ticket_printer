import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

abstract class BluetoothRepositoryInterface {
  Future<Result<List<BluetoothDeviceEntity>>> startBluetoothDevicesScan({
    Duration? timeout,
  });
  Stream<Result<List<BluetoothDeviceEntity>>> getBluetoothDevicesStream();
  Future<Result<void>> stopBluetoothDevicesScan();
}
