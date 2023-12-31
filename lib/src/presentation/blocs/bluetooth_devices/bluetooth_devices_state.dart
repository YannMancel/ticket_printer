import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
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
      BluetoothDevicesInitialState(:final bluetoothDevices) =>
        initial(bluetoothDevices),
      BluetoothDevicesLoadingState _ => loading(),
      BluetoothDevicesDataState(:final bluetoothDevices) =>
        data(bluetoothDevices),
      BluetoothDevicesErrorState(:final exception) => error(exception),
    };
  }
}

@immutable
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

@immutable
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

@immutable
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

@immutable
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
