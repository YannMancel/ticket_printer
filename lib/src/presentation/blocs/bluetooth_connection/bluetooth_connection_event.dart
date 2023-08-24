import 'package:ticket_printer/src/_src.dart';

sealed class BluetoothConnectionEvent {
  const BluetoothConnectionEvent();
}

class BluetoothConnectedEvent extends BluetoothConnectionEvent {
  const BluetoothConnectedEvent({required this.bluetoothDevice});

  final BluetoothDeviceEntity bluetoothDevice;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothConnectedEvent &&
            (identical(bluetoothDevice, other.bluetoothDevice) ||
                bluetoothDevice == other.bluetoothDevice));
  }

  @override
  int get hashCode => Object.hash(runtimeType, bluetoothDevice);
}

class BluetoothDisconnectedEvent extends BluetoothConnectionEvent {
  const BluetoothDisconnectedEvent();

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
