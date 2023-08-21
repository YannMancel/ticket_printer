part of 'bluetooth_connection_bloc.dart';

@freezed
class BluetoothConnectionState with _$BluetoothConnectionState {
  const factory BluetoothConnectionState.loading() = _Loading;
  const factory BluetoothConnectionState.connecting({
    required BluetoothDeviceEntity entity,
  }) = _Connecting;
  const factory BluetoothConnectionState.disconnecting() = _Disconnecting;
  const factory BluetoothConnectionState.error({
    required Exception exception,
  }) = _Error;
}
