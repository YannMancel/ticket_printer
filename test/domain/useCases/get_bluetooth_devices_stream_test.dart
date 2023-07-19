import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

import '../../helpers/helpers.dart';
import 'start_bluetooth_devices_scan_test.mocks.dart';

void main() {
  late BluetoothRepositoryInterface repository;
  late GetBluetoothDevicesStream useCase;

  group('GetBluetoothDevicesStream', () {
    setUp(() async {
      repository = MockBluetoothRepositoryInterface();
      useCase = GetBluetoothDevicesStream(repository: repository);
    });

    test('should be success when execute is called.', () async {
      when(repository.getBluetoothDevicesStream())
          .thenAnswer((_) => dataResultStream());

      final stream = useCase.execute();
      final result = await stream.single;

      expect(result, resultOfData);
      verify(repository.getBluetoothDevicesStream()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when execute is called.',
      () async {
        when(repository.getBluetoothDevicesStream())
            .thenAnswer((_) => errorResultStream());

        final stream = useCase.execute();
        final result = await stream.single;

        expect(result, resultOfError<List<BluetoothDeviceEntity>>());
        verify(repository.getBluetoothDevicesStream()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
