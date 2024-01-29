import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

// COUNT -----------------------------------------------------------------------
const kCount = 1;

// Third Party -----------------------------------------------------------------
final bluetoothDeviceFromThirdParty = BluetoothDevice()
  ..name = 'FAKE_NAME'
  ..address = '123'
  ..type = 0
  ..connected = false;
final bluetoothDevicesFromThirdParty = <BluetoothDevice>[
  bluetoothDeviceFromThirdParty,
];
Stream<List<BluetoothDevice>> bluetoothDevicesStreamFromThirdParty() async* {
  yield bluetoothDevicesFromThirdParty;
}

// MODEL -----------------------------------------------------------------------
final ticketConfigurationModel = TicketConfigurationModel.fromEntity(
  kTicketConfigurationEntity,
);
final bluetoothDeviceModel = BluetoothDeviceModel.fromThirdParty(
  bluetoothDeviceFromThirdParty,
);
final bluetoothDeviceModels = bluetoothDevicesFromThirdParty.toModels;
Stream<List<BluetoothDeviceModel>> modelStream() async* {
  yield bluetoothDeviceModels;
}

final ticketConfigurationModelJson = <String, dynamic>{
  'width': ticketConfigurationModel.width,
  'height': ticketConfigurationModel.height,
  'gap': ticketConfigurationModel.gap,
  'count': kCount,
};

// ENTITY ----------------------------------------------------------------------

const kTicketConfigurationEntity = TicketConfigurationEntity();
final bluetoothDeviceEntity = BluetoothDeviceEntity.fromModel(
  bluetoothDeviceModel,
);
final bluetoothDeviceEntities = bluetoothDeviceModels.toEntities;
final kNoBluetoothDeviceEntity = List<BluetoothDeviceEntity>.empty();

// ERROR -----------------------------------------------------------------------
final exception = Exception();

// RESULT ----------------------------------------------------------------------
final resultOfData = DataResult<List<BluetoothDeviceEntity>>(
  value: bluetoothDeviceEntities,
);
const kResultOfEmptyData = DataResult<List<BluetoothDeviceEntity>>();
const kResultOfVoidData = DataResult<void>();
Result<T> resultOfError<T>() => ErrorResult<T>(exception: exception);
const kEmptyStream = Stream<Result<List<BluetoothDeviceEntity>>>.empty();
Stream<Result<List<BluetoothDeviceEntity>>> dataResultStream() async* {
  yield resultOfData;
}

Stream<Result<List<BluetoothDeviceEntity>>> emptyDataResultStream() async* {
  yield kResultOfEmptyData;
}

Stream<Result<List<BluetoothDeviceEntity>>> errorResultStream() async* {
  yield resultOfError<List<BluetoothDeviceEntity>>();
}

Stream<Result<List<BluetoothDeviceEntity>>> exceptionStream() async* {
  throw exception;
}

// BYTES -----------------------------------------------------------------------
final bytes = Uint8List(5);

// DURATION --------------------------------------------------------------------
const kDuration = Duration(seconds: 1);

// EVENTS ----------------------------------------------------------------------
final connectedEvent = BluetoothConnectedEvent(
  bluetoothDevice: bluetoothDeviceEntity,
);
const kDisconnectedEvent = BluetoothDisconnectedEvent();
const kDevicesStartedEvent = BluetoothDevicesStartedEvent(timeout: kDuration);
const kDevicesRefreshedEvent = BluetoothDevicesRefreshedEvent(
  timeout: kDuration,
);
const kDevicesStoppedEvent = BluetoothDevicesStoppedEvent();
const kDevicesChangedStateEvent = BluetoothDevicesChangedStateEvent(
  nextState: kDevicesLoadingState,
);
final imagePrinterEvent = BluetoothImagePrinterEvent(
  ticketConfiguration: kTicketConfigurationEntity,
  bytes: bytes,
  count: kCount,
);

// STATES ----------------------------------------------------------------------
final connectionLoadingState = ConnectionLoadingState(
  bluetoothDevice: bluetoothDeviceEntity,
);
final connectingState = ConnectingState(
  bluetoothDevice: bluetoothDeviceEntity,
);
final disconnectingState = DisconnectingState(
  bluetoothDevice: bluetoothDeviceEntity,
);
final connectionErrorState = ConnectionErrorState(
  bluetoothDevice: bluetoothDeviceEntity,
  exception: exception,
);
final devicesInitialState = BluetoothDevicesInitialState(
  bluetoothDevices: bluetoothDeviceEntities,
);
const kDevicesLoadingState = BluetoothDevicesLoadingState();
final devicesDataState = BluetoothDevicesDataState(
  bluetoothDevices: bluetoothDeviceEntities,
);
final devicesErrorState = BluetoothDevicesErrorState(exception: exception);
const kPrinterInitialState = PrinterInitialState();
const kPrinterLoadingState = PrinterLoadingState();
const kPrinterSuccessState = PrinterSuccessState();
final printerErrorState = PrinterErrorState(exception: exception);
