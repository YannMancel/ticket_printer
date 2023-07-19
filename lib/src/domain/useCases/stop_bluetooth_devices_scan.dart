import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

/// The use case stops the Bluetooth devices scan.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = StopBluetoothDevicesScan(repository: repository);
/// ```
class StopBluetoothDevicesScan {
  const StopBluetoothDevicesScan({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  Future<Result<void>> execute() async {
    return _repository.stopBluetoothDevicesScan();
  }
}
