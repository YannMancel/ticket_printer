import 'package:ticket_printer/src/_src.dart';

/// The use case connect the Bluetooth device.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = ConnectAtBluetoothDevice(repository: repository);
/// ```
class ConnectAtBluetoothDevice {
  const ConnectAtBluetoothDevice({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  Future<Result<void>> call({
    required BluetoothDeviceEntity entity,
  }) async {
    return _repository.connectAtBluetoothDevice(entity: entity);
  }
}
