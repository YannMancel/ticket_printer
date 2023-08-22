import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<RemoteDataSourceInterface>(),
  ],
)
import 'bluetooth_repository_test.mocks.dart';

void main() {
  late RemoteDataSourceInterface remoteDataSource;
  late BluetoothRepositoryInterface repository;

  group('BluetoothRepository', () {
    setUp(() {
      remoteDataSource = MockRemoteDataSourceInterface();
      repository = BluetoothRepository(remoteDataSource: remoteDataSource);
    });

    test(
      'should be success when Bluetooth devices scan is started.',
      () async {
        when(remoteDataSource.startBluetoothDevicesScan(
          timeout: anyNamed('timeout'),
        )).thenAnswer((_) async => models);

        final result = await repository.startBluetoothDevicesScan();

        expect(result, resultOfData);
        verify(
          remoteDataSource.startBluetoothDevicesScan(
            timeout: anyNamed('timeout'),
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth devices scan is started.',
      () async {
        when(remoteDataSource.startBluetoothDevicesScan(
          timeout: anyNamed('timeout'),
        )).thenThrow(exception);

        final result = await repository.startBluetoothDevicesScan();

        expect(result, resultOfError<List<BluetoothDeviceEntity>>());
        verify(
          remoteDataSource.startBluetoothDevicesScan(
            timeout: anyNamed('timeout'),
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be success when Bluetooth devices stream is called.',
      () async {
        when(remoteDataSource.getBluetoothDevicesStream())
            .thenAnswer((_) => modelStream());

        final stream = repository.getBluetoothDevicesStream();
        final result = await stream.single;

        expect(result, resultOfData);
        verify(remoteDataSource.getBluetoothDevicesStream()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth devices stream is called.',
      () async {
        when(remoteDataSource.getBluetoothDevicesStream()).thenThrow(exception);

        final stream = repository.getBluetoothDevicesStream();
        final result = await stream.single;

        expect(result, resultOfError<List<BluetoothDeviceEntity>>());
        verify(remoteDataSource.getBluetoothDevicesStream()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be success when Bluetooth devices scan is stopped.',
      () async {
        when(remoteDataSource.stopBluetoothDevicesScan())
            .thenAnswer((_) async {});

        await repository.stopBluetoothDevicesScan();

        verify(remoteDataSource.stopBluetoothDevicesScan()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth devices scan is stopped.',
      () async {
        when(remoteDataSource.stopBluetoothDevicesScan()).thenThrow(exception);

        final result = await repository.stopBluetoothDevicesScan();

        expect(result, resultOfError<void>());
        verify(remoteDataSource.stopBluetoothDevicesScan()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be success when Bluetooth device connexion is started.',
      () async {
        when(remoteDataSource.connectAtBluetoothDevice(model: model))
            .thenAnswer((_) async {});

        await repository.connectAtBluetoothDevice(entity: entity);

        verify(remoteDataSource.connectAtBluetoothDevice(model: model))
            .called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth device connexion is started.',
      () async {
        when(remoteDataSource.connectAtBluetoothDevice(model: model))
            .thenThrow(exception);

        final result =
            await repository.connectAtBluetoothDevice(entity: entity);

        expect(result, resultOfError<void>());
        verify(remoteDataSource.connectAtBluetoothDevice(model: model))
            .called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be success when Bluetooth device connexion is stopped.',
      () async {
        when(remoteDataSource.disconnectAtBluetoothDevice())
            .thenAnswer((_) async {});

        await repository.disconnectAtBluetoothDevice();

        verify(remoteDataSource.disconnectAtBluetoothDevice()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth device connexion is stopped.',
      () async {
        when(remoteDataSource.disconnectAtBluetoothDevice())
            .thenThrow(exception);

        final result = await repository.disconnectAtBluetoothDevice();

        expect(result, resultOfError<void>());
        verify(remoteDataSource.disconnectAtBluetoothDevice()).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
