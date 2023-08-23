import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('ServiceLocator', () {
    test(
      'should return a BluetoothPrint when bluetoothPrint is called.',
      () {
        expect(
          ServiceLocator.bluetoothPrint,
          isA<BluetoothPrint>(),
        );
      },
    );

    test(
      'should return a RemoteDataSourceInterface '
      'when remoteDataSource is called.',
      () {
        expect(
          ServiceLocator.remoteDataSource,
          isA<RemoteDataSourceInterface>(),
        );
      },
    );

    test(
      'should return a BluetoothRepositoryInterface '
      'when repository is called.',
      () {
        expect(
          ServiceLocator.repository,
          isA<BluetoothRepositoryInterface>(),
        );
      },
    );

    test(
      'should return a StartBluetoothDevicesScanInterface '
      'when startBluetoothDevicesScan is called.',
      () {
        expect(
          ServiceLocator.startBluetoothDevicesScan,
          isA<StartBluetoothDevicesScanInterface>(),
        );
      },
    );

    test(
      'should return a GetBluetoothDevicesStreamInterface '
      'when getBluetoothDevicesStream is called.',
      () {
        expect(
          ServiceLocator.getBluetoothDevicesStream,
          isA<GetBluetoothDevicesStreamInterface>(),
        );
      },
    );

    test(
      'should return a StopBluetoothDevicesScanInterface '
      'when stopBluetoothDevicesScan is called.',
      () {
        expect(
          ServiceLocator.stopBluetoothDevicesScan,
          isA<StopBluetoothDevicesScanInterface>(),
        );
      },
    );

    test(
      'should return a ConnectAtBluetoothDeviceInterface '
      'when connectAtBluetoothDevice is called.',
      () {
        expect(
          ServiceLocator.connectAtBluetoothDevice,
          isA<ConnectAtBluetoothDeviceInterface>(),
        );
      },
    );

    test(
      'should return a DisconnectAtBluetoothDeviceInterface '
      'when disconnectAtBluetoothDevice is called.',
      () {
        expect(
          ServiceLocator.disconnectAtBluetoothDevice,
          isA<DisconnectAtBluetoothDeviceInterface>(),
        );
      },
    );

    test(
      'should return a PrintImageByBluetoothInterface '
      'when printImageByBluetooth is called.',
      () {
        expect(
          ServiceLocator.printImageByBluetooth,
          isA<PrintImageByBluetoothInterface>(),
        );
      },
    );

    test(
      'should return a BluetoothDevicesBloc '
      'when bluetoothDevicesBlocSingleton is called.',
      () {
        expect(
          ServiceLocator.bluetoothDevicesBlocSingleton,
          isA<BluetoothDevicesBloc>(),
        );
      },
    );

    test(
      'should return a BluetoothConnectionBloc '
      'when bluetoothConnectionBlocSingleton is called.',
      () async {
        expect(
          ServiceLocator.bluetoothConnectionBlocSingleton,
          isA<BluetoothConnectionBloc>(),
        );
      },
    );

    test(
      'should return a BluetoothImagePrinterBloc '
      'when bluetoothImagePrinterBlocSingleton is called.',
      () async {
        expect(
          ServiceLocator.bluetoothImagePrinterBlocSingleton,
          isA<BluetoothImagePrinterBloc>(),
        );
      },
    );
  });
}
