import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<BluetoothDevicesRepositoryInterface>(),
  ],
)
import 'start_bluetooth_devices_scan_test.mocks.dart';

void main() {
  late BluetoothDevicesRepositoryInterface repository;
  late StartBluetoothDevicesScanInterface useCase;

  group('StartBluetoothDevicesScan', () {
    setUp(() {
      repository = MockBluetoothDevicesRepositoryInterface();
      useCase = StartBluetoothDevicesScan(repository: repository);
    });

    test('should be success when call is called.', () async {
      // To avoid error with sealed class
      provideDummy<Result<List<BluetoothDeviceEntity>>>(resultOfData);

      when(repository.startBluetoothDevicesScan(
        timeout: anyNamed('timeout'),
      )).thenAnswer((_) async => resultOfData);

      final result = await useCase();

      expect(result, resultOfData);
      verify(
        repository.startBluetoothDevicesScan(timeout: anyNamed('timeout')),
      ).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when call is called.',
      () async {
        // To avoid error with sealed class
        provideDummy<Result<List<BluetoothDeviceEntity>>>(
          resultOfError<List<BluetoothDeviceEntity>>(),
        );

        when(repository.startBluetoothDevicesScan(
          timeout: anyNamed('timeout'),
        )).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>());

        final result = await useCase();

        expect(result, resultOfError<List<BluetoothDeviceEntity>>());
        verify(
          repository.startBluetoothDevicesScan(timeout: anyNamed('timeout')),
        ).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
