import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothConnectionState', () {
    test(
      'should be success when hashcode is compared with loading event.',
      () {
        expect(
          connectionLoadingState.hashCode,
          Object.hashAll(
            <Object?>[
              connectionLoadingState.runtimeType,
              bluetoothDeviceEntity,
            ],
          ),
        );
      },
    );

    test(
      'should return false when there is two connecting state with '
      'different field reference.',
      () {
        const kEvent = ConnectingState(
          bluetoothDevice: BluetoothDeviceEntity(),
        );

        expect(connectingState == kEvent, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with connection event.',
      () {
        expect(
          connectingState.hashCode,
          Object.hash(
            connectingState.runtimeType,
            connectingState.bluetoothDevice,
          ),
        );
      },
    );

    test(
      'should be success when hashcode is compared with disconnecting event.',
      () {
        expect(
          disconnectingState.hashCode,
          Object.hashAll(
            <Object?>[disconnectingState.runtimeType, bluetoothDeviceEntity],
          ),
        );
      },
    );

    test(
      'should return false when there is two error state with '
      'different field reference.',
      () {
        final event = ConnectionErrorState(
          exception: Exception('Other'),
        );

        expect(connectionErrorState == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with error event.',
      () {
        expect(
          connectionErrorState.hashCode,
          Object.hash(
            connectionErrorState.runtimeType,
            bluetoothDeviceEntity,
            connectionErrorState.exception,
          ),
        );
      },
    );

    group('when event called when', () {
      test(
        'for loading event.',
        () {
          final value = connectionLoadingState.when<bool>(
            loading: (_) => true,
            connecting: (_) => false,
            disconnecting: (_) => false,
            error: (_, __) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for connecting event.',
        () {
          final value = connectingState.when<bool>(
            loading: (_) => false,
            connecting: (_) => true,
            disconnecting: (_) => false,
            error: (_, __) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for disconnecting event.',
        () {
          final value = disconnectingState.when<bool>(
            loading: (_) => false,
            connecting: (_) => false,
            disconnecting: (_) => true,
            error: (_, __) => false,
          );

          expect(value, isTrue);
        },
      );

      test(
        'for error event.',
        () {
          final value = connectionErrorState.when<bool>(
            loading: (_) => false,
            connecting: (_) => false,
            disconnecting: (_) => false,
            error: (_, __) => true,
          );

          expect(value, isTrue);
        },
      );
    });

    group('when event called maybeWhen', () {
      test(
        'for loading part.',
        () {
          final shouldBeTrue = connectionLoadingState.maybeWhen<bool>(
            loading: (_) => true,
            orElse: () => false,
          );

          final shouldBeFalse = connectingState.maybeWhen<bool>(
            loading: (_) => true,
            orElse: () => false,
          );

          expect(shouldBeTrue, isTrue);
          expect(shouldBeFalse, isFalse);
        },
      );

      test(
        'for connecting part.',
        () {
          final shouldBeTrue = connectingState.maybeWhen<bool>(
            connecting: (_) => true,
            orElse: () => false,
          );

          final shouldBeFalse = connectionLoadingState.maybeWhen<bool>(
            connecting: (_) => true,
            orElse: () => false,
          );

          expect(shouldBeTrue, isTrue);
          expect(shouldBeFalse, isFalse);
        },
      );

      test(
        'for disconnecting part.',
        () {
          final shouldBeTrue = disconnectingState.maybeWhen<bool>(
            disconnecting: (_) => true,
            orElse: () => false,
          );

          final shouldBeFalse = connectionLoadingState.maybeWhen<bool>(
            disconnecting: (_) => true,
            orElse: () => false,
          );

          expect(shouldBeTrue, isTrue);
          expect(shouldBeFalse, isFalse);
        },
      );

      test(
        'for error part.',
        () {
          final shouldBeTrue = connectionErrorState.maybeWhen<bool>(
            error: (_, __) => true,
            orElse: () => false,
          );

          final shouldBeFalse = connectionLoadingState.maybeWhen<bool>(
            error: (_, __) => true,
            orElse: () => false,
          );

          expect(shouldBeTrue, isTrue);
          expect(shouldBeFalse, isFalse);
        },
      );
    });
  });
}
