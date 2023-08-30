import 'package:ticket_printer/src/_src.dart';

typedef GetBluetoothDevicesStreamInterface
    = UseCaseWithoutArgument<Stream<Result<List<BluetoothDeviceEntity>>>>;

/// The use case get the Bluetooth devices stream.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = GetBluetoothDevicesStream(repository: repository);
/// ```
class GetBluetoothDevicesStream implements GetBluetoothDevicesStreamInterface {
  const GetBluetoothDevicesStream({
    required BluetoothDevicesRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothDevicesRepositoryInterface _repository;

  @override
  Stream<Result<List<BluetoothDeviceEntity>>> call() {
    return _repository.getBluetoothDevicesStream();
  }
}
