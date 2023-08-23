import 'package:ticket_printer/src/_src.dart';

typedef StopBluetoothDevicesScanInterface
    = UseCaseWithoutArgument<Future<Result<void>>>;

/// The use case stops the Bluetooth devices scan.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = StopBluetoothDevicesScan(repository: repository);
/// ```
class StopBluetoothDevicesScan implements StopBluetoothDevicesScanInterface {
  const StopBluetoothDevicesScan({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  @override
  Future<Result<void>> call() async {
    return _repository.stopBluetoothDevicesScan();
  }
}
