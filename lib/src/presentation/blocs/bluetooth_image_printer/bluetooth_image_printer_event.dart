import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

class BluetoothImagePrinterEvent {
  const BluetoothImagePrinterEvent({
    required this.ticketConfiguration,
    required this.bytes,
    required this.count,
  });

  final TicketConfigurationEntity ticketConfiguration;
  final Uint8List bytes;
  final int count;

  (TicketConfigurationEntity, Uint8List, int) _equality() {
    return (
      ticketConfiguration,
      bytes,
      count,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothImagePrinterEvent &&
            _equality() == other._equality());
  }

  @override
  int get hashCode => _equality().hashCode;
}
