import 'package:ticket_printer/src/_src.dart';

typedef StartBluetoothDevicesScanInterface = UseCaseWithOneNullableArgument<
    Future<Result<List<BluetoothDeviceEntity>>>, Duration?>;

/// The use case starts the Bluetooth devices scan.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = StartBluetoothDevicesScan(repository: repository);
/// ```
class StartBluetoothDevicesScan implements StartBluetoothDevicesScanInterface {
  const StartBluetoothDevicesScan({
    required BluetoothDevicesRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothDevicesRepositoryInterface _repository;

  @override
  Future<Result<List<BluetoothDeviceEntity>>> call({Duration? argument}) async {
    return _repository.startBluetoothDevicesScan(timeout: argument);
  }
}
