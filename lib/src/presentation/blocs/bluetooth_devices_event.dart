part of 'bluetooth_devices_bloc.dart';

@freezed
class BluetoothDevicesEvent with _$BluetoothDevicesEvent {
  const factory BluetoothDevicesEvent.started({Duration? timeout}) = _Started;
  const factory BluetoothDevicesEvent.refreshed({
    Duration? timeout,
  }) = _Refreshed;
  const factory BluetoothDevicesEvent.stopped() = _Stopped;
  const factory BluetoothDevicesEvent.changedState({
    required BluetoothDevicesState nextState,
  }) = _ChangedState;
}
