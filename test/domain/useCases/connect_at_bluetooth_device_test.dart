import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
import 'start_bluetooth_devices_scan_test.mocks.dart';

void main() {
  late BluetoothRepositoryInterface repository;
  late ConnectAtBluetoothDeviceInterface useCase;

  group('ConnectAtBluetoothDevice', () {
    setUp(() {
      repository = MockBluetoothRepositoryInterface();
      useCase = ConnectAtBluetoothDevice(repository: repository);
    });

    test('should be success when call is called.', () async {
      // To avoid error with sealed class
      provideDummy<Result<void>>(kResultOfVoidData);

      when(repository.connectAtBluetoothDevice(
        bluetoothDevice: bluetoothDeviceEntity,
      )).thenAnswer((_) async => kResultOfVoidData);

      final result = await useCase(bluetoothDeviceEntity);

      expect(result, kResultOfVoidData);
      verify(repository.connectAtBluetoothDevice(
        bluetoothDevice: bluetoothDeviceEntity,
      )).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when call is called.',
      () async {
        // To avoid error with sealed class
        provideDummy<Result<void>>(resultOfError<void>());

        when(repository.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceEntity,
        )).thenAnswer((_) async => resultOfError<void>());

        final result = await useCase(bluetoothDeviceEntity);

        expect(result, resultOfError<void>());
        verify(repository.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceEntity,
        )).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
