import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../helpers/helpers.dart';

void main() {
  group('BluetoothDeviceModel', () {
    test(
      'should return BluetoothDevice when toThirdParty is called.',
      () async {
        expect(model.toThirdParty, isA<BluetoothDevice>());
      },
    );
  });
}
