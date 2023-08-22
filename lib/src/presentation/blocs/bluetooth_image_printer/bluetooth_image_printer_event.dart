part of 'bluetooth_image_printer_bloc.dart';

@freezed
class BluetoothImagePrinterEvent with _$BluetoothImagePrinterEvent {
  const factory BluetoothImagePrinterEvent.print({
    required TicketConfigurationEntity ticketConfiguration,
    required Uint8List bytes,
  }) = _Printed;
}
