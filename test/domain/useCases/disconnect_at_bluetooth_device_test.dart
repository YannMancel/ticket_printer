import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
import 'connect_at_bluetooth_device_test.mocks.dart';

void main() {
  late BluetoothConnectionRepositoryInterface repository;
  late DisconnectAtBluetoothDeviceInterface useCase;

  group('DisconnectAtBluetoothDevice', () {
    setUp(() {
      repository = MockBluetoothConnectionRepositoryInterface();
      useCase = DisconnectAtBluetoothDevice(repository: repository);
    });

    test('should be success when call is called.', () async {
      // To avoid error with sealed class
      provideDummy<Result<void>>(kResultOfVoidData);

      when(repository.disconnectAtBluetoothDevice())
          .thenAnswer((_) async => kResultOfVoidData);

      final result = await useCase();

      expect(result, kResultOfVoidData);
      verify(repository.disconnectAtBluetoothDevice()).called(1);
      verifyNoMoreInteractions(repository);
    });

    test(
      'should be fail when call is called.',
      () async {
        // To avoid error with sealed class
        provideDummy<Result<void>>(resultOfError<void>());

        when(repository.disconnectAtBluetoothDevice())
            .thenAnswer((_) async => resultOfError<void>());

        final result = await useCase();

        expect(result, resultOfError<void>());
        verify(repository.disconnectAtBluetoothDevice()).called(1);
        verifyNoMoreInteractions(repository);
      },
    );
  });
}
