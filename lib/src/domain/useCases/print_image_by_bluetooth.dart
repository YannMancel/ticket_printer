import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

/// The use case prints an image by Bluetooth.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = PrintImageByBluetooth(repository: repository);
/// ```
class PrintImageByBluetooth {
  const PrintImageByBluetooth({
    required BluetoothRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothRepositoryInterface _repository;

  Future<Result<void>> call({
    required TicketConfigurationEntity ticketConfiguration,
    required Uint8List bytes,
  }) async {
    return _repository.printImage(
      ticketConfiguration: ticketConfiguration,
      bytes: bytes,
    );
  }
}
