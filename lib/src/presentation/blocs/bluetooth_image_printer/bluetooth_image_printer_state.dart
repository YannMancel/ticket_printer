part of 'bluetooth_image_printer_bloc.dart';

@freezed
class BluetoothImagePrinterState with _$BluetoothImagePrinterState {
  const factory BluetoothImagePrinterState.initial() = _Initial;
  const factory BluetoothImagePrinterState.loading() = _Loading;
  const factory BluetoothImagePrinterState.success() = _Success;
  const factory BluetoothImagePrinterState.error({
    required Exception exception,
  }) = _Error;
}
