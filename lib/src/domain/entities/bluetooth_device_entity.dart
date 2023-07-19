import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticket_printer/src/data/_data.dart';

part 'bluetooth_device_entity.freezed.dart';

@freezed
class BluetoothDeviceEntity with _$BluetoothDeviceEntity {
  const BluetoothDeviceEntity._();

  const factory BluetoothDeviceEntity({
    String? name,
    String? address,
    @Default(0) int type,
    @Default(false) bool isConnected,
  }) = _Entity;

  factory BluetoothDeviceEntity.fromModel(BluetoothDeviceModel model) {
    return BluetoothDeviceEntity(
      name: model.name,
      address: model.address,
      type: model.type,
      isConnected: model.isConnected,
    );
  }
}
