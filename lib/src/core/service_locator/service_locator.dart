import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/foundation.dart';
import 'package:ticket_printer/src/_src.dart';

abstract class ServiceLocator {
  @visibleForTesting
  static BluetoothPrint get bluetoothPrint => BluetoothPrint.instance;

  @visibleForTesting
  static RemoteDataSourceInterface get remoteDataSource {
    return RemoteDataSource(bluetoothPrint: bluetoothPrint);
  }

  @visibleForTesting
  static BluetoothRepository get repositoryImplementation {
    return BluetoothRepository(remoteDataSource: remoteDataSource);
  }

  @visibleForTesting
  static BluetoothDevicesRepositoryInterface get devicesRepository {
    return repositoryImplementation;
  }

  @visibleForTesting
  static BluetoothConnectionRepositoryInterface get connectionRepository {
    return repositoryImplementation;
  }

  @visibleForTesting
  static BluetoothPrinterRepositoryInterface get printerRepository {
    return repositoryImplementation;
  }

  @visibleForTesting
  static StartBluetoothDevicesScanInterface get startBluetoothDevicesScan {
    return StartBluetoothDevicesScan(repository: devicesRepository);
  }

  @visibleForTesting
  static GetBluetoothDevicesStreamInterface get getBluetoothDevicesStream {
    return GetBluetoothDevicesStream(repository: devicesRepository);
  }

  @visibleForTesting
  static StopBluetoothDevicesScanInterface get stopBluetoothDevicesScan {
    return StopBluetoothDevicesScan(repository: devicesRepository);
  }

  @visibleForTesting
  static ConnectAtBluetoothDeviceInterface get connectAtBluetoothDevice {
    return ConnectAtBluetoothDevice(repository: connectionRepository);
  }

  @visibleForTesting
  static DisconnectAtBluetoothDeviceInterface get disconnectAtBluetoothDevice {
    return DisconnectAtBluetoothDevice(repository: connectionRepository);
  }

  @visibleForTesting
  static PrintImageByBluetoothInterface get printImageByBluetooth {
    return PrintImageByBluetooth(repository: printerRepository);
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
