import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

import '../../helpers/helpers.dart';
import 'start_bluetooth_devices_scan_test.mocks.dart';

void main() {
  late BluetoothRepositoryInterface repository;
  late StopBluetoothDevicesScan useCase;

  group('StopBluetoothDevicesScan', () {
    setUp(() async {
      repository = MockBluetoothRepositoryInterface();
      useCase = StopBluetoothDevicesScan(repository: repository);
    });

    test('should be success when execute is called.', () async {
      when(repository.stopBluetoothDevicesScan())
          .thenAnswer((_) async => kResultOfVoidData);

      final result = await useCase.execute();

      expect(result, kResultOfVoidData);
      verify(repository.stopBluetoothDevicesScan()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when execute is called.',
      () async {
        when(repository.stopBluetoothDevicesScan())
            .thenAnswer((_) async => resultOfError<void>());

        final result = await useCase.execute();

        expect(result, resultOfError<void>());
        verify(repository.stopBluetoothDevicesScan()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
