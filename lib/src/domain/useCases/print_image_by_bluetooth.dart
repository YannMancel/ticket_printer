import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

typedef PrintImageByBluetoothInterface = UseCaseWithTwoArguments<
    Future<Result<void>>, TicketConfigurationEntity, Uint8List>;

/// The use case prints an image by Bluetooth.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final useCase = PrintImageByBluetooth(repository: repository);
/// ```
class PrintImageByBluetooth implements PrintImageByBluetoothInterface {
  const PrintImageByBluetooth({
    required BluetoothPrinterRepositoryInterface repository,
  }) : _repository = repository;

  final BluetoothPrinterRepositoryInterface _repository;

  @override
  Future<Result<void>> call(
    TicketConfigurationEntity firstArgument,
    Uint8List secondArgument,
  ) async {
    return _repository.printImage(
      ticketConfiguration: firstArgument,
      bytes: secondArgument,
    );
  }
}
