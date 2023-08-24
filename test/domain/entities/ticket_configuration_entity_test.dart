import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';

void main() {
  group('TicketConfigurationEntity', () {
    test(
      'should be success when hashcode is compared.',
      () {
        expect(
          kTicketConfigurationEntity.hashCode,
          (
            kTicketConfigurationEntity.width,
            kTicketConfigurationEntity.height,
            kTicketConfigurationEntity.gap,
          ).hashCode,
        );
      },
    );

    test(
      'should be success when copyWith is called with update of all fields.',
      () {
        final actual = kTicketConfigurationEntity.copyWith(
          width: 1,
          height: 2,
          gap: 42,
        );

        const kMatcher = TicketConfigurationEntity(
          width: 1,
          height: 2,
          gap: 42,
        );

        expect(actual, kMatcher);
      },
    );

    test(
      'should be success when copyWith is called without update.',
      () {
        expect(
          kTicketConfigurationEntity.copyWith(),
          kTicketConfigurationEntity,
        );
      },
    );
  });
}
