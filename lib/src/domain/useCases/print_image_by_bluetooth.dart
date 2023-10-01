import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

typedef PrintImageByBluetoothInterface = UseCaseWithThreeArguments<
    Future<Result<void>>, TicketConfigurationEntity, Uint8List, int>;

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
    int thirdArgument,
  ) async {
    return _repository.printImage(
      ticketConfiguration: firstArgument,
      bytes: secondArgument,
      count: thirdArgument,
    );
  }
}
