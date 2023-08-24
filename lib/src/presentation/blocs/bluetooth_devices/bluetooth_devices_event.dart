import 'package:ticket_printer/src/_src.dart';

sealed class BluetoothDevicesEvent {
  const BluetoothDevicesEvent();
}

class BluetoothDevicesStartedEvent extends BluetoothDevicesEvent {
  const BluetoothDevicesStartedEvent({this.timeout});

  final Duration? timeout;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesStartedEvent &&
            (identical(timeout, other.timeout) || timeout == other.timeout));
  }

  @override
  int get hashCode => Object.hash(runtimeType, timeout);
}

class BluetoothDevicesRefreshedEvent extends BluetoothDevicesEvent {
  const BluetoothDevicesRefreshedEvent({this.timeout});

  final Duration? timeout;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesRefreshedEvent &&
            (identical(timeout, other.timeout) || timeout == other.timeout));
  }

  @override
  int get hashCode => Object.hash(runtimeType, timeout);
}

class BluetoothDevicesStoppedEvent extends BluetoothDevicesEvent {
  const BluetoothDevicesStoppedEvent();

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

class BluetoothDevicesChangedStateEvent extends BluetoothDevicesEvent {
  const BluetoothDevicesChangedStateEvent({required this.nextState});

  final BluetoothDevicesState nextState;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDevicesChangedStateEvent &&
            (identical(nextState, other.nextState) ||
                nextState == other.nextState));
  }

  @override
  int get hashCode => Object.hash(runtimeType, nextState);
}
