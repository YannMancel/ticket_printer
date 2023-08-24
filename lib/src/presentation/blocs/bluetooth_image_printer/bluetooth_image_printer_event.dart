import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

class BluetoothImagePrinterEvent {
  const BluetoothImagePrinterEvent({
    required this.ticketConfiguration,
    required this.bytes,
  });

  final TicketConfigurationEntity ticketConfiguration;
  final Uint8List bytes;

  (TicketConfigurationEntity, Uint8List) _equality() {
    return (
      ticketConfiguration,
      bytes,
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
