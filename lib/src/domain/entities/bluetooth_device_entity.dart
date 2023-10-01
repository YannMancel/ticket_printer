import 'package:flutter/foundation.dart';
import 'package:ticket_printer/src/_src.dart';

@immutable
class BluetoothDeviceEntity {
  const BluetoothDeviceEntity({
    this.name,
    this.address,
    this.type = 0,
    this.isConnected = false,
  });

  factory BluetoothDeviceEntity.fromModel(BluetoothDeviceModel model) {
    return BluetoothDeviceEntity(
      name: model.name,
      address: model.address,
      type: model.type,
      isConnected: model.isConnected,
    );
  }

  final String? name;
  final String? address;
  final int type;
  final bool isConnected;

  (String?, String?, int, bool) _equality() {
    return (
      name,
      address,
      type,
      isConnected,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is BluetoothDeviceEntity &&
            _equality() == other._equality());
  }

  @override
  int get hashCode => _equality().hashCode;
}
