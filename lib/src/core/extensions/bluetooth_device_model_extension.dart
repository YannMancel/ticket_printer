import 'package:ticket_printer/src/data/_data.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

extension BluetoothDeviceModelsExt on List<BluetoothDeviceModel> {
  List<BluetoothDeviceEntity> get toEntities {
    return map(BluetoothDeviceEntity.fromModel).toList(growable: false);
  }
}
