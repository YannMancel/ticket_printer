import 'package:flutter/foundation.dart';
import 'package:ticket_printer/src/_src.dart';

sealed class BluetoothConnectionState {
  const BluetoothConnectionState();

  R when<R extends Object?>({
    required R Function(BluetoothDeviceEntity?) loading,
    required R Function(BluetoothDeviceEntity) connecting,
    required R Function(BluetoothDeviceEntity?) disconnecting,
    required R Function(BluetoothDeviceEntity?, Exception) error,
  }) {
    return switch (this) {
      ConnectionLoadingState(:final bluetoothDevice) => loading(
          bluetoothDevice,
        ),
      ConnectingState(:final bluetoothDevice) => connecting(bluetoothDevice),
      DisconnectingState(:final bluetoothDevice) => disconnecting(
          bluetoothDevice,
        ),
      ConnectionErrorState(:final bluetoothDevice, :final exception) => error(
          bluetoothDevice,
          exception,
        ),
    };
  }

  R maybeWhen<R extends Object?>({
    R Function(BluetoothDeviceEntity?)? loading,
    R Function(BluetoothDeviceEntity)? connecting,
    R Function(BluetoothDeviceEntity?)? disconnecting,
    R Function(BluetoothDeviceEntity?, Exception)? error,
    required R Function() orElse,
  }) {
    return switch (this) {
      ConnectionLoadingState(:final bluetoothDevice) =>
        loading?.call(bluetoothDevice) ?? orElse(),
      ConnectingState(:final bluetoothDevice) =>
        connecting?.call(bluetoothDevice) ?? orElse(),
      DisconnectingState(:final bluetoothDevice) =>
        disconnecting?.call(bluetoothDevice) ?? orElse(),
      ConnectionErrorState(:final bluetoothDevice, :final exception) =>
        error?.call(bluetoothDevice, exception) ?? orElse(),
    };
  }
}

@immutable
class ConnectionLoadingState extends BluetoothConnectionState {
  const ConnectionLoadingState({this.bluetoothDevice});

  final BluetoothDeviceEntity? bluetoothDevice;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is ConnectionLoadingState &&
            (identical(bluetoothDevice, other.bluetoothDevice) ||
                bluetoothDevice == other.bluetoothDevice));
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType, bluetoothDevice],
    );
  }
}

@immutable
class ConnectingState extends BluetoothConnectionState {
  const ConnectingState({required this.bluetoothDevice});

  final BluetoothDeviceEntity bluetoothDevice;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is ConnectingState &&
            (identical(bluetoothDevice, other.bluetoothDevice) ||
                bluetoothDevice == other.bluetoothDevice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevice);
}

@immutable
class DisconnectingState extends BluetoothConnectionState {
  const DisconnectingState({this.bluetoothDevice});

  final BluetoothDeviceEntity? bluetoothDevice;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is DisconnectingState &&
            (identical(bluetoothDevice, other.bluetoothDevice) ||
                bluetoothDevice == other.bluetoothDevice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevice);
}

@immutable
class ConnectionErrorState extends BluetoothConnectionState {
  const ConnectionErrorState({
    this.bluetoothDevice,
    required this.exception,
  });

  final BluetoothDeviceEntity? bluetoothDevice;
  final Exception exception;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is ConnectionErrorState &&
            (identical(bluetoothDevice, other.bluetoothDevice) ||
                bluetoothDevice == other.bluetoothDevice) &&
            (identical(exception, other.exception) ||
                exception == other.exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevice, exception);
}
