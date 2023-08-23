import 'package:ticket_printer/src/_src.dart';

typedef DisconnectAtBluetoothDeviceInterface
    = UseCaseWithoutArgument<Future<Result<void>>>;

/// The use case disconnects the Bluetooth device.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = DisconnectAtBluetoothDevice(repository: repository);
/// ```
class DisconnectAtBluetoothDevice
    implements DisconnectAtBluetoothDeviceInterface {
  const DisconnectAtBluetoothDevice({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  @override
  Future<Result<void>> call() async {
    return _repository.disconnectAtBluetoothDevice();
  }
}
