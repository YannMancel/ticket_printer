import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_printer/src/_src.dart';

abstract class ServiceLocator {
  static BluetoothPrint? _bluetoothPrint;

  static Bloc<BluetoothDevicesEvent, BluetoothDevicesState>?
      _bluetoothDevicesBloc;

  static Bloc<BluetoothConnectionEvent, BluetoothConnectionState>?
      _bluetoothConnectionBloc;

  static Bloc<BluetoothImagePrinterEvent, BluetoothImagePrinterState>?
      _bluetoothImagePrinterBloc;

  @visibleForTesting
  static BluetoothPrint get bluetoothPrint {
    return _bluetoothPrint ??= BluetoothPrint.instance;
  }

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

  static Bloc<BluetoothDevicesEvent, BluetoothDevicesState>
      get bluetoothDevicesBlocSingleton {
    return _bluetoothDevicesBloc ??= BluetoothDevicesBloc(
      startBluetoothDevicesScan: startBluetoothDevicesScan,
      getBluetoothDevicesStream: getBluetoothDevicesStream,
      stopBluetoothDevicesScan: stopBluetoothDevicesScan,
    );
  }

  static Bloc<BluetoothConnectionEvent, BluetoothConnectionState>
      get bluetoothConnectionBlocSingleton {
    return _bluetoothConnectionBloc ??= BluetoothConnectionBloc(
      connectAtBluetoothDevice: connectAtBluetoothDevice,
      disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
    );
  }

  static Bloc<BluetoothImagePrinterEvent, BluetoothImagePrinterState>
      get bluetoothImagePrinterBlocSingleton {
    return _bluetoothImagePrinterBloc ??
        BluetoothImagePrinterBloc(
          printImageByBluetooth: printImageByBluetooth,
        );
  }
}
