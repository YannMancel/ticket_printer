import 'package:ticket_printer/src/_src.dart';

extension BluetoothDeviceModelsExt on List<BluetoothDeviceModel> {
  List<BluetoothDeviceEntity> get toEntities {
    return map(BluetoothDeviceEntity.fromModel).toList(growable: false);
  }
}
