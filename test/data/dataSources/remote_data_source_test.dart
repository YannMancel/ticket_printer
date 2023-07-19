import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/data/_data.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<BluetoothPrint>(),
  ],
)
import 'remote_data_source_test.mocks.dart';

void main() {
  late BluetoothPrint bluetoothPrint;
  late RemoteDataSourceInterface remoteDataSource;

  group('RemoteDataSource', () {
    setUp(() async {
      bluetoothPrint = MockBluetoothPrint();
      remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
    });

    test(
      'should be success when Bluetooth devices scan is started.',
      () async {
        when(bluetoothPrint.startScan(timeout: anyNamed('timeout')))
            .thenAnswer((_) async => bluetoothDevicesFromThirdParty);

        final values = await remoteDataSource.startBluetoothDevicesScan();

        expect(values, models);
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

        expect(values, models);
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
  });
}
