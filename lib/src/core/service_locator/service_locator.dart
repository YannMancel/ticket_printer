import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/foundation.dart';
import 'package:ticket_printer/src/_src.dart';

abstract class ServiceLocator {
  @visibleForTesting
  static BluetoothPrint get bluetoothPrint => BluetoothPrint.instance;

  @visibleForTesting
  static RemoteDataSource get remoteDataSource {
    return RemoteDataSource(bluetoothPrint: bluetoothPrint);
  }

  @visibleForTesting
  static BluetoothRepository get repository {
    return BluetoothRepository(remoteDataSource: remoteDataSource);
  }

  @visibleForTesting
  static StartBluetoothDevicesScan get startBluetoothDevicesScan {
    return StartBluetoothDevicesScan(repository: repository);
  }

  @visibleForTesting
  static GetBluetoothDevicesStream get getBluetoothDevicesStream {
    return GetBluetoothDevicesStream(repository: repository);
  }

  @visibleForTesting
  static StopBluetoothDevicesScan get stopBluetoothDevicesScan {
    return StopBluetoothDevicesScan(repository: repository);
  }

  @visibleForTesting
  static ConnectAtBluetoothDevice get connectAtBluetoothDevice {
    return ConnectAtBluetoothDevice(repository: repository);
  }

  @visibleForTesting
  static DisconnectAtBluetoothDevice get disconnectAtBluetoothDevice {
    return DisconnectAtBluetoothDevice(repository: repository);
  }

  @visibleForTesting
  static PrintImageByBluetooth get printImageByBluetooth {
    return PrintImageByBluetooth(repository: repository);
  }

  static BluetoothDevicesBloc get bluetoothDevicesBlocSingleton {
    return BluetoothDevicesBloc(
      startBluetoothDevicesScan: startBluetoothDevicesScan,
      getBluetoothDevicesStream: getBluetoothDevicesStream,
      stopBluetoothDevicesScan: stopBluetoothDevicesScan,
    );
  }

  static BluetoothConnectionBloc get bluetoothConnectionBlocSingleton {
    return BluetoothConnectionBloc(
      connectAtBluetoothDevice: connectAtBluetoothDevice,
      disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
    );
  }

  static BluetoothImagePrinterBloc get bluetoothImagePrinterBlocSingleton {
    return BluetoothImagePrinterBloc(
      printImageByBluetooth: printImageByBluetooth,
    );
  }
}
