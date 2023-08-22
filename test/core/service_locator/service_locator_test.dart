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
      'should return a RemoteDataSource when remoteDataSource is called.',
      () {
        expect(
          ServiceLocator.remoteDataSource,
          isA<RemoteDataSource>(),
        );
      },
    );

    test(
      'should return a BluetoothRepository when repository is called.',
      () {
        expect(
          ServiceLocator.repository,
          isA<BluetoothRepository>(),
        );
      },
    );

    test(
      'should return a StartBluetoothDevicesScan '
      'when startBluetoothDevicesScan is called.',
      () {
        expect(
          ServiceLocator.startBluetoothDevicesScan,
          isA<StartBluetoothDevicesScan>(),
        );
      },
    );

    test(
      'should return a GetBluetoothDevicesStream '
      'when getBluetoothDevicesStream is called.',
      () {
        expect(
          ServiceLocator.getBluetoothDevicesStream,
          isA<GetBluetoothDevicesStream>(),
        );
      },
    );

    test(
      'should return a StopBluetoothDevicesScan '
      'when stopBluetoothDevicesScan is called.',
      () {
        expect(
          ServiceLocator.stopBluetoothDevicesScan,
          isA<StopBluetoothDevicesScan>(),
        );
      },
    );

    test(
      'should return a ConnectAtBluetoothDevice '
      'when connectAtBluetoothDevice is called.',
      () {
        expect(
          ServiceLocator.connectAtBluetoothDevice,
          isA<ConnectAtBluetoothDevice>(),
        );
      },
    );

    test(
      'should return a DisconnectAtBluetoothDevice '
      'when disconnectAtBluetoothDevice is called.',
      () {
        expect(
          ServiceLocator.disconnectAtBluetoothDevice,
          isA<DisconnectAtBluetoothDevice>(),
        );
      },
    );

    test(
      'should return a PrintImageByBluetooth '
      'when printImageByBluetooth is called.',
      () {
        expect(
          ServiceLocator.printImageByBluetooth,
          isA<PrintImageByBluetooth>(),
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
