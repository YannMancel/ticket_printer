import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothDevicesState', () {
    test(
      'should return false when there is two initial state with '
      'different field reference.',
      () {
        final event = BluetoothDevicesInitialState(
          bluetoothDevices: kNoBluetoothDeviceEntity,
        );

        expect(devicesInitialState == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with initial event.',
      () {
        expect(
          devicesInitialState.hashCode,
          Object.hash(
            devicesInitialState.runtimeType,
            devicesInitialState.bluetoothDevices,
          ),
        );
      },
    );

    test(
      'should return false when there is two different states.',
      () {
        expect(kDevicesLoadingState == devicesInitialState, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with loading event.',
      () {
        expect(
          kDevicesLoadingState.hashCode,
          Object.hashAll(
            <Object?>[kDevicesLoadingState.runtimeType],
          ),
        );
      },
    );

    test(
      'should return false when there is two data state with '
      'different field reference.',
      () {
        final event = BluetoothDevicesDataState(
          bluetoothDevices: kNoBluetoothDeviceEntity,
        );

        expect(devicesDataState == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with data event.',
      () {
        expect(
          devicesDataState.hashCode,
          Object.hash(
            devicesDataState.runtimeType,
            devicesDataState.bluetoothDevices,
          ),
        );
      },
    );

    test(
      'should return false when there is two error state with '
      'different field reference.',
      () {
        final event = BluetoothDevicesErrorState(
          exception: Exception('Other'),
        );

        expect(devicesErrorState == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with error event.',
      () {
        expect(
          devicesErrorState.hashCode,
          Object.hash(
            devicesErrorState.runtimeType,
            devicesErrorState.exception,
          ),
        );
      },
    );

    group('when event called when', () {
      test(
        'for initial event.',
        () {
          final value = devicesInitialState.when<bool>(
            initial: (_) => true,
            loading: () => false,
            data: (_) => false,
            error: (_) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for loading event.',
        () {
          final value = kDevicesLoadingState.when<bool>(
            initial: (_) => false,
            loading: () => true,
            data: (_) => false,
            error: (_) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for data event.',
        () {
          final value = devicesDataState.when<bool>(
            initial: (_) => false,
            loading: () => false,
            data: (_) => true,
            error: (_) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for error event.',
        () {
          final value = devicesErrorState.when<bool>(
            initial: (_) => false,
            loading: () => false,
            data: (_) => false,
            error: (_) => true,
          );

          expect(value, isTrue);
        },
      );
    });
  });
}
