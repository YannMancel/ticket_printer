import 'package:ticket_printer/src/_src.dart';

/// The use case starts the Bluetooth devices scan.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = StartBluetoothDevicesScan(repository: repository);
/// ```
class StartBluetoothDevicesScan {
  const StartBluetoothDevicesScan({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  Future<Result<List<BluetoothDeviceEntity>>> call({
    Duration? timeout,
  }) async {
    return _repository.startBluetoothDevicesScan(timeout: timeout);
  }
}
