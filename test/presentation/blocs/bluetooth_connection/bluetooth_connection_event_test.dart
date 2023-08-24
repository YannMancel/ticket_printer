import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothConnectionEvent', () {
    test(
      'should return true when there is two connected event with '
      'same field reference.',
      () {
        final event = BluetoothConnectedEvent(
          bluetoothDevice: bluetoothDeviceEntity,
        );

        expect(connectedEvent == event, isTrue);
      },
    );

    test(
      'should return false when there is two connected event with '
      'different field reference.',
      () {
        const kEvent = BluetoothConnectedEvent(
          bluetoothDevice: BluetoothDeviceEntity(),
        );

        expect(connectedEvent == kEvent, isFalse);
      },
    );

    test(
      'should return false when there is two different events.',
      () {
        expect(kDisconnectedEvent == connectedEvent, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with connected event.',
      () {
        expect(
          connectedEvent.hashCode,
          Object.hash(
            connectedEvent.runtimeType,
            connectedEvent.bluetoothDevice,
          ),
        );
      },
    );

    test(
      'should be success when hashcode is compared with disconnected event.',
      () {
        expect(
          kDisconnectedEvent.hashCode,
          Object.hashAll(
            <Object?>[kDisconnectedEvent.runtimeType],
          ),
        );
      },
    );
  });
}
