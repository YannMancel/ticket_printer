import 'dart:async';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

// Third Party -------------------------------------------------------------------
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
final resultOfData =
    Result<List<BluetoothDeviceEntity>>.data(value: bluetoothDeviceEntities);
const kResultOfEmptyData = Result<List<BluetoothDeviceEntity>>.data();
const kResultOfVoidData = Result<void>.data();
Result<T> resultOfError<T>() => Result<T>.error(exception: exception);
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
