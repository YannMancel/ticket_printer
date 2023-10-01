import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<BluetoothPrint>(),
  ],
)
import 'remote_data_source_test.mocks.dart';

void main() {
  late BluetoothPrint bluetoothPrint;
  late RemoteDataSourceInterface remoteDataSource;

  group('RemoteDataSource', () {
    setUp(() {
      bluetoothPrint = MockBluetoothPrint();
      remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
    });

    test(
      'should be success when Bluetooth devices scan is started.',
      () async {
        when(bluetoothPrint.startScan(timeout: anyNamed('timeout')))
            .thenAnswer((_) async => bluetoothDevicesFromThirdParty);

        final values = await remoteDataSource.startBluetoothDevicesScan();

        expect(values, bluetoothDeviceModels);
        verify(
          bluetoothPrint.startScan(timeout: anyNamed('timeout')),
        ).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when Bluetooth devices scan is started.',
      () async {
        when(bluetoothPrint.startScan(timeout: anyNamed('timeout')))
            .thenThrow(exception);

        final call = remoteDataSource.startBluetoothDevicesScan;

        expect(
          () async => call(),
          throwsA(const TypeMatcher<Exception>()),
        );
        verify(
          bluetoothPrint.startScan(timeout: anyNamed('timeout')),
        ).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be success when Bluetooth devices stream is called.',
      () async {
        when(bluetoothPrint.scanResults)
            .thenAnswer((_) => bluetoothDevicesStreamFromThirdParty());

        final stream = remoteDataSource.getBluetoothDevicesStream();
        final values = await stream.single;

        expect(values, bluetoothDeviceModels);
        verify(bluetoothPrint.scanResults).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when Bluetooth devices stream is called.',
      () async {
        when(bluetoothPrint.scanResults).thenThrow(exception);

        final call = remoteDataSource.getBluetoothDevicesStream;

        await expectLater(
          () => call().single,
          throwsA(const TypeMatcher<Exception>()),
        );
        verify(bluetoothPrint.scanResults).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be success when Bluetooth devices scan is stopped.',
      () async {
        when(bluetoothPrint.stopScan()).thenAnswer((_) async {});

        await remoteDataSource.stopBluetoothDevicesScan();

        verify(bluetoothPrint.stopScan()).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when Bluetooth devices scan is stopped.',
      () async {
        when(bluetoothPrint.stopScan()).thenThrow(exception);

        final call = remoteDataSource.stopBluetoothDevicesScan;

        expect(
          () async => call(),
          throwsA(const TypeMatcher<Exception>()),
        );
        verify(bluetoothPrint.stopScan()).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be success when Bluetooth device connexion is started.',
      () async {
        when(bluetoothPrint.connect(bluetoothDeviceFromThirdParty))
            .thenAnswer((_) async {});

        await remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
          fakeBluetoothDevice: bluetoothDeviceFromThirdParty,
        );

        verify(bluetoothPrint.connect(bluetoothDeviceFromThirdParty)).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when Bluetooth device connexion is started.',
      () async {
        when(bluetoothPrint.connect(bluetoothDeviceFromThirdParty))
            .thenThrow(exception);

        final call = remoteDataSource.connectAtBluetoothDevice(
          bluetoothDevice: bluetoothDeviceModel,
          fakeBluetoothDevice: bluetoothDeviceFromThirdParty,
        );

        expect(
          () async => call,
          throwsA(const TypeMatcher<Exception>()),
        );

        verify(bluetoothPrint.connect(bluetoothDeviceFromThirdParty)).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be success when Bluetooth device connexion is stopped.',
      () async {
        when(bluetoothPrint.disconnect()).thenAnswer((_) async {});

        await remoteDataSource.disconnectAtBluetoothDevice();

        verify(bluetoothPrint.disconnect()).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when Bluetooth device connexion is stopped.',
      () async {
        when(bluetoothPrint.disconnect()).thenThrow(exception);

        final call = remoteDataSource.disconnectAtBluetoothDevice;

        expect(
          () async => call(),
          throwsA(const TypeMatcher<Exception>()),
        );

        verify(bluetoothPrint.disconnect()).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be success when printImage is called.',
      () async {
        final fakePrintedData = List<LineText>.empty();
        when(bluetoothPrint.printLabel(
          ticketConfigurationModelJson,
          fakePrintedData,
        )).thenAnswer((_) async {});

        await remoteDataSource.printImage(
          ticketConfiguration: ticketConfigurationModel,
          bytes: bytes,
          count: kCount,
          fakePrintedData: fakePrintedData,
        );

        verify(bluetoothPrint.printLabel(
          ticketConfigurationModelJson,
          fakePrintedData,
        )).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );

    test(
      'should be fail when printImage is called.',
      () async {
        final fakePrintedData = List<LineText>.empty();
        when(bluetoothPrint.printLabel(
          ticketConfigurationModelJson,
          fakePrintedData,
        )).thenThrow(exception);

        final call = remoteDataSource.printImage(
          ticketConfiguration: ticketConfigurationModel,
          bytes: bytes,
          count: kCount,
          fakePrintedData: fakePrintedData,
        );

        expect(
          () async => call,
          throwsA(const TypeMatcher<Exception>()),
        );

        verify(bluetoothPrint.printLabel(
          ticketConfigurationModelJson,
          fakePrintedData,
        )).called(1);
        verifyNoMoreInteractions(bluetoothPrint);
      },
    );
  });
}
