import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'bluetooth_device_model.freezed.dart';

@freezed
class BluetoothDeviceModel with _$BluetoothDeviceModel {
  const BluetoothDeviceModel._();

  const factory BluetoothDeviceModel({
    String? name,
    String? address,
    @Default(0) int type,
    @Default(false) bool isConnected,
  }) = _Model;

  factory BluetoothDeviceModel.fromThirdParty(BluetoothDevice thirdParty) {
    return BluetoothDeviceModel(
      name: thirdParty.name,
      address: thirdParty.address,
      type: thirdParty.type ?? 0,
      isConnected: thirdParty.connected ?? false,
    );
  }
}
