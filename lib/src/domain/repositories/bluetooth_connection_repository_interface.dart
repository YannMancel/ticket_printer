import 'package:ticket_printer/src/_src.dart';

abstract interface class BluetoothConnectionRepositoryInterface {
  Future<Result<void>> connectAtBluetoothDevice({
    required BluetoothDeviceEntity bluetoothDevice,
  });
  Future<Result<void>> disconnectAtBluetoothDevice();
}
