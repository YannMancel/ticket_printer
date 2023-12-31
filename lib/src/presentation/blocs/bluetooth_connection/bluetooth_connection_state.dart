import 'package:flutter/foundation.dart';
import 'package:ticket_printer/src/_src.dart';

sealed class BluetoothConnectionState {
  const BluetoothConnectionState();

  R when<R extends Object?>({
    required R Function() loading,
    required R Function(BluetoothDeviceEntity) connecting,
    required R Function() disconnecting,
    required R Function(Exception) error,
  }) {
    return switch (this) {
      ConnectionLoadingState _ => loading(),
      ConnectingState(:final bluetoothDevice) => connecting(bluetoothDevice),
      DisconnectingState _ => disconnecting(),
      ConnectionErrorState(:final exception) => error(exception),
    };
  }

  R maybeWhen<R extends Object?>({
    R Function()? loading,
    R Function(BluetoothDeviceEntity)? connecting,
    R Function()? disconnecting,
    R Function(Exception)? error,
    required R Function() orElse,
  }) {
    return switch (this) {
      ConnectionLoadingState _ => loading?.call() ?? orElse(),
      ConnectingState(:final bluetoothDevice) =>
        connecting?.call(bluetoothDevice) ?? orElse(),
      DisconnectingState _ => disconnecting?.call() ?? orElse(),
      ConnectionErrorState(:final exception) =>
        error?.call(exception) ?? orElse(),
    };
  }
}

@immutable
class ConnectionLoadingState extends BluetoothConnectionState {
  const ConnectionLoadingState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType],
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
  const DisconnectingState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType],
    );
  }
}

@immutable
class ConnectionErrorState extends BluetoothConnectionState {
  const ConnectionErrorState({required this.exception});

  final Exception exception;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is ConnectionErrorState &&
            (identical(exception, other.exception) ||
                exception == other.exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);
}
