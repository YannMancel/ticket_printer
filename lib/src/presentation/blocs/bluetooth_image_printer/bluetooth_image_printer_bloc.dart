import 'dart:async';
import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticket_printer/src/_src.dart';

part 'bluetooth_image_printer_bloc.freezed.dart';
part 'bluetooth_image_printer_event.dart';
part 'bluetooth_image_printer_state.dart';

/// The bloc provides the bluetooth image printer manager.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final printImageByBluetooth = PrintImageByBluetooth(
///   repository: repository,
/// );
/// final bloc = BluetoothImagePrinterBloc(
///   printImageByBluetooth: printImageByBluetooth,
/// );
/// ```
class BluetoothImagePrinterBloc
    extends Bloc<BluetoothImagePrinterEvent, BluetoothImagePrinterState> {
  BluetoothImagePrinterBloc({
    BluetoothImagePrinterState? initialState,
    required PrintImageByBluetoothInterface printImageByBluetooth,
  })  : _printImageByBluetooth = printImageByBluetooth,
        super(initialState ?? const BluetoothImagePrinterState.initial()) {
    on<_Printed>(_onPrinted);
  }

  final PrintImageByBluetoothInterface _printImageByBluetooth;

  FutureOr<void> _onPrinted(
    _Printed event,
    Emitter<BluetoothImagePrinterState> emit,
  ) async {
    emit(
      const BluetoothImagePrinterState.loading(),
    );

    final result = await _printImageByBluetooth(
      event.ticketConfiguration,
      event.bytes,
    );

    emit(
      result.when<BluetoothImagePrinterState>(
        data: (_) => const BluetoothImagePrinterState.success(),
        error: (exception) => BluetoothImagePrinterState.error(
          exception: exception,
        ),
      ),
    );
  }
}
