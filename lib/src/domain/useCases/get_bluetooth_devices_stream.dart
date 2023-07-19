import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

/// The use case get the Bluetooth devices stream.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = GetBluetoothDevicesStream(repository: repository);
/// ```
class GetBluetoothDevicesStream {
  const GetBluetoothDevicesStream({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  Stream<Result<List<BluetoothDeviceEntity>>> execute() {
    return _repository.getBluetoothDevicesStream();
  }
}
