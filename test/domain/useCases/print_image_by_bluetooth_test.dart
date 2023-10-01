import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<BluetoothPrinterRepositoryInterface>(),
  ],
)
import 'print_image_by_bluetooth_test.mocks.dart';

void main() {
  late BluetoothPrinterRepositoryInterface repository;
  late PrintImageByBluetoothInterface useCase;

  group('PrintImageByBluetooth', () {
    setUp(() {
      repository = MockBluetoothPrinterRepositoryInterface();
      useCase = PrintImageByBluetooth(repository: repository);
    });

    test('should be success when call is called.', () async {
      // To avoid error with sealed class
      provideDummy<Result<void>>(kResultOfVoidData);

      when(
        repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
          count: kCount,
        ),
      ).thenAnswer((_) async => kResultOfVoidData);

      final result = await useCase(
        kTicketConfigurationEntity,
        bytes,
        kCount,
      );

      expect(result, kResultOfVoidData);
      verify(
        repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
          count: kCount,
        ),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when call is called.',
      () async {
        // To avoid error with sealed class
        provideDummy<Result<void>>(resultOfError<void>());

        when(
          repository.printImage(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
            count: kCount,
          ),
        ).thenAnswer((_) async => resultOfError<void>());

        final result = await useCase(
          kTicketConfigurationEntity,
          bytes,
          kCount,
        );

        expect(result, resultOfError<void>());
        verify(
          repository.printImage(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
            count: kCount,
          ),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
