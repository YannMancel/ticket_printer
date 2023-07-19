import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

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

  Future<Result<List<BluetoothDeviceEntity>>> execute({
    Duration? timeout,
  }) async {
    return _repository.startBluetoothDevicesScan(timeout: timeout);
  }
}
