import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

abstract interface class BluetoothPrinterRepositoryInterface {
  Future<Result<void>> printImage({
    required TicketConfigurationEntity ticketConfiguration,
    required Uint8List bytes,
  });
}
