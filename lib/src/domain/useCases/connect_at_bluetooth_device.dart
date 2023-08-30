import 'package:ticket_printer/src/_src.dart';

typedef ConnectAtBluetoothDeviceInterface
    = UseCaseWithOneArgument<Future<Result<void>>, BluetoothDeviceEntity>;

/// The use case connect the Bluetooth device.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = ConnectAtBluetoothDevice(repository: repository);
/// ```
class ConnectAtBluetoothDevice implements ConnectAtBluetoothDeviceInterface {
  const ConnectAtBluetoothDevice({
    required BluetoothConnectionRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothConnectionRepositoryInterface _repository;

  @override
  Future<Result<void>> call(BluetoothDeviceEntity argument) async {
    return _repository.connectAtBluetoothDevice(bluetoothDevice: argument);
  }
}
