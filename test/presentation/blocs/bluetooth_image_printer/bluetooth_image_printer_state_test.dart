import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothDevicesState', () {
    test(
      'should return false when there is two different states with '
      'different field reference.',
      () {
        expect(kPrinterInitialState == kPrinterLoadingState, isFalse);
        expect(kPrinterLoadingState == kPrinterSuccessState, isFalse);
        expect(kPrinterSuccessState == kPrinterInitialState, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with initial event.',
      () {
        expect(
          kPrinterInitialState.hashCode,
          Object.hashAll(
            <Object?>[kPrinterInitialState.runtimeType],
          ),
        );
      },
    );

    test(
      'should be success when hashcode is compared with loading event.',
      () {
        expect(
          kPrinterLoadingState.hashCode,
          Object.hashAll(
            <Object?>[kPrinterLoadingState.runtimeType],
          ),
        );
      },
    );

    test(
      'should be success when hashcode is compared with success event.',
      () {
        expect(
          kPrinterSuccessState.hashCode,
          Object.hashAll(
            <Object?>[kPrinterSuccessState.runtimeType],
          ),
        );
      },
    );

    test(
      'should return false when there is two error state with '
      'different field reference.',
      () {
        final event = PrinterErrorState(
          exception: Exception('Other'),
        );

        expect(printerErrorState == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with error event.',
      () {
        expect(
          printerErrorState.hashCode,
          Object.hash(
            printerErrorState.runtimeType,
            printerErrorState.exception,
          ),
        );
      },
    );
  });
}
