import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/data/_data.dart';

extension ThirdPartyExt on List<BluetoothDevice> {
  List<BluetoothDeviceModel> get toModels {
    return map(BluetoothDeviceModel.fromThirdParty).toList(growable: false);
  }
}
