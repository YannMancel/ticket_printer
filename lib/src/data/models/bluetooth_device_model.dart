import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

class BluetoothDeviceModel extends BluetoothDeviceEntity {
  const BluetoothDeviceModel({
    super.name,
    super.address,
    super.type = 0,
    super.isConnected = false,
  });

  factory BluetoothDeviceModel.fromThirdParty(BluetoothDevice thirdParty) {
    return BluetoothDeviceModel(
      name: thirdParty.name,
      address: thirdParty.address,
      type: thirdParty.type ?? 0,
      isConnected: thirdParty.connected ?? false,
    );
  }

  factory BluetoothDeviceModel.fromEntity(BluetoothDeviceEntity entity) {
    return BluetoothDeviceModel(
      name: entity.name,
      address: entity.address,
      type: entity.type,
      isConnected: entity.isConnected,
    );
  }

  BluetoothDevice get toThirdParty {
    return BluetoothDevice()
      ..name = name
      ..address = address
      ..type = type
      ..connected = isConnected;
  }
}
