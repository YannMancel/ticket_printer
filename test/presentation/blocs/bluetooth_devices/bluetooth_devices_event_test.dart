import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothDevicesEvent', () {
    test(
      'should return true when there is two started event with '
      'different field reference.',
      () {
        final event = BluetoothDevicesStartedEvent(
          timeout: kDuration + const Duration(seconds: 3),
        );

        expect(kDevicesStartedEvent == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with started event.',
      () {
        expect(
          kDevicesStartedEvent.hashCode,
          Object.hash(
            kDevicesStartedEvent.runtimeType,
            kDevicesStartedEvent.timeout,
          ),
        );
      },
    );

    test(
      'should return true when there is two refreshed event with '
      'different field reference.',
      () {
        final event = BluetoothDevicesRefreshedEvent(
          timeout: kDuration + const Duration(seconds: 3),
        );

        expect(kDevicesRefreshedEvent == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with refreshed event.',
      () {
        expect(
          kDevicesRefreshedEvent.hashCode,
          Object.hash(
            kDevicesRefreshedEvent.runtimeType,
            kDevicesRefreshedEvent.timeout,
          ),
        );
      },
    );

    test(
      'should return true when there is two different events with '
      'different field reference.',
      () {
        expect(kDevicesStoppedEvent == kDevicesRefreshedEvent, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with stop event.',
      () {
        expect(
          kDevicesStoppedEvent.hashCode,
          Object.hashAll(
            <Object?>[kDevicesStoppedEvent.runtimeType],
          ),
        );
      },
    );

    test(
      'should return true when there is two changed state event with '
      'different field reference.',
      () {
        final event = BluetoothDevicesChangedStateEvent(
          nextState: devicesErrorState,
        );

        expect(kDevicesChangedStateEvent == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with change state event.',
      () {
        expect(
          kDevicesChangedStateEvent.hashCode,
          Object.hash(
            kDevicesChangedStateEvent.runtimeType,
            kDevicesChangedStateEvent.nextState,
          ),
        );
      },
    );
  });
}
