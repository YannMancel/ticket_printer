part of 'bluetooth_devices_bloc.dart';

@freezed
class BluetoothDevicesState with _$BluetoothDevicesState {
  const factory BluetoothDevicesState.initial({
    @Default(<BluetoothDeviceEntity>[]) List<BluetoothDeviceEntity> entities,
  }) = _Initial;
  const factory BluetoothDevicesState.loading() = _Loading;
  const factory BluetoothDevicesState.data({
    @Default(<BluetoothDeviceEntity>[]) List<BluetoothDeviceEntity> entities,
  }) = _Data;
  const factory BluetoothDevicesState.error({
    required Exception exception,
  }) = _Error;
}
