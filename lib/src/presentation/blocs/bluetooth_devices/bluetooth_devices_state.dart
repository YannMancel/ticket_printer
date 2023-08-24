import 'package:collection/collection.dart';
import 'package:ticket_printer/src/_src.dart';

sealed class BluetoothDevicesState {
  const BluetoothDevicesState();

  R when<R extends Object?>({
    required R Function(List<BluetoothDeviceEntity>) initial,
    required R Function() loading,
    required R Function(List<BluetoothDeviceEntity>) data,
    required R Function(Exception) error,
  }) {
    return switch (this) {
      BluetoothDevicesInitialState(bluetoothDevices: var devices) =>
        initial(devices),
      BluetoothDevicesLoadingState _ => loading(),
      BluetoothDevicesDataState(bluetoothDevices: var devices) => data(devices),
      BluetoothDevicesErrorState(exception: var exception) => error(exception),
    };
  }
}

class BluetoothDevicesInitialState extends BluetoothDevicesState {
  const BluetoothDevicesInitialState({
    this.bluetoothDevices = const <BluetoothDeviceEntity>[],
  });

  final List<BluetoothDeviceEntity> bluetoothDevices;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesInitialState &&
            const DeepCollectionEquality.unordered()
                .equals(bluetoothDevices, other.bluetoothDevices));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevices);
}

class BluetoothDevicesLoadingState extends BluetoothDevicesState {
  const BluetoothDevicesLoadingState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(<Object?>[runtimeType]);
  }
}

class BluetoothDevicesDataState extends BluetoothDevicesState {
  const BluetoothDevicesDataState({
    this.bluetoothDevices = const <BluetoothDeviceEntity>[],
  });

  final List<BluetoothDeviceEntity> bluetoothDevices;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesDataState &&
            const DeepCollectionEquality.unordered()
                .equals(bluetoothDevices, other.bluetoothDevices));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevices);
}

class BluetoothDevicesErrorState extends BluetoothDevicesState {
  const BluetoothDevicesErrorState({required this.exception});

  final Exception exception;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesErrorState &&
            (identical(exception, other.exception) ||
                exception == other.exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);
}
