import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';

void main() {
  group('BluetoothImagePrinterEvent', () {
    test(
      'should return true when there is two event with '
      'different field reference.',
      () {
        final event = BluetoothImagePrinterEvent(
          ticketConfiguration: const TicketConfigurationEntity(width: 42),
          bytes: bytes,
        );

        expect(imagePrinterEvent == event, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared.',
      () {
        expect(
          imagePrinterEvent.hashCode,
          (
            imagePrinterEvent.ticketConfiguration,
            imagePrinterEvent.bytes,
          ).hashCode,
        );
      },
    );
  });
}
