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
        )).thenAnswer((_) async => bluetoothDeviceModels);

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

        final result = await repository.stopBluetoothDevicesScan();

        expect(result, kResultOfVoidData);
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
        when(remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
        )).thenAnswer((_) async {});

        final result = await repository.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceEntity,
        );

        expect(result, kResultOfVoidData);
        verify(remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
        )).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when Bluetooth device connexion is started.',
      () async {
        when(remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
        )).thenThrow(exception);

        final result = await repository.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceEntity,
        );

        expect(result, resultOfError<void>());
        verify(remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
        )).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be success when Bluetooth device connexion is stopped.',
      () async {
        when(remoteDataSource.disconnectAtBluetoothDevice())
            .thenAnswer((_) async {});

        final result = await repository.disconnectAtBluetoothDevice();

        expect(result, kResultOfVoidData);
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

    test(
      'should be success when printImage is called.',
      () async {
        when(
          remoteDataSource.printImage(
            ticketConfiguration: ticketConfigurationModel,
            bytes: bytes,
          ),
        ).thenAnswer((_) async {});

        final result = await repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        );

        expect(result, kResultOfVoidData);
        verify(
          remoteDataSource.printImage(
            ticketConfiguration: ticketConfigurationModel,
            bytes: bytes,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );

    test(
      'should be fail when printImage is called.',
      () async {
        when(
          remoteDataSource.printImage(
            ticketConfiguration: ticketConfigurationModel,
            bytes: bytes,
          ),
        ).thenThrow(exception);

        final result = await repository.printImage(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        );

        expect(result, resultOfError<void>());
        verify(
          remoteDataSource.printImage(
            ticketConfiguration: ticketConfigurationModel,
            bytes: bytes,
          ),
        ).called(1);
        verifyNoMoreInteractions(remoteDataSource);
      },
    );
  });
}
