import 'dart:async';

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
final model = BluetoothDeviceModel.fromThirdParty(
  bluetoothDeviceFromThirdParty,
);
final models = bluetoothDevicesFromThirdParty.toModels;
Stream<List<BluetoothDeviceModel>> modelStream() async* {
  yield models;
}

// ENTITY ----------------------------------------------------------------------
final entity = BluetoothDeviceEntity.fromModel(model);
final entities = models.toEntities;
final kNoEntity = List<BluetoothDeviceEntity>.empty();

// ERROR -----------------------------------------------------------------------
final exception = Exception();

// RESULT ----------------------------------------------------------------------
final resultOfData = Result<List<BluetoothDeviceEntity>>.data(value: entities);
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
