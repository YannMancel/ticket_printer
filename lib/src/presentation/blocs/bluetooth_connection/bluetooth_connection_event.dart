part of 'bluetooth_connection_bloc.dart';

@freezed
class BluetoothConnectionEvent with _$BluetoothConnectionEvent {
  const factory BluetoothConnectionEvent.connected({
    required BluetoothDeviceEntity bluetoothDevice,
  }) = _Connected;
  const factory BluetoothConnectionEvent.disconnected() = _Disconnected;
}
