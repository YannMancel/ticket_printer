import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
import 'start_bluetooth_devices_scan_test.mocks.dart';

void main() {
  late BluetoothRepositoryInterface repository;
  late PrintImageByBluetooth useCase;

  group('PrintImageByBluetooth', () {
    setUp(() {
      repository = MockBluetoothRepositoryInterface();
      useCase = PrintImageByBluetooth(repository: repository);
    });

    test('should be success when call is called.', () async {
      when(repository.printImage(
        ticketConfiguration: kTicketConfigurationEntity,
        bytes: bytes,
      )).thenAnswer((_) async => kResultOfVoidData);

      final result = await useCase(
        ticketConfiguration: kTicketConfigurationEntity,
        bytes: bytes,
      );

      expect(result, kResultOfVoidData);
      verify(repository.printImage(
        ticketConfiguration: kTicketConfigurationEntity,
        bytes: bytes,
      )).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when call is called.',
      () async {
        when(repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        )).thenAnswer((_) async => resultOfError<void>());

        final result = await useCase(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        );

        expect(result, resultOfError<void>());
        verify(repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        )).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}