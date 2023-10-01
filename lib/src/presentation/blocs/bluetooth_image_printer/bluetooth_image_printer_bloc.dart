import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_printer/src/_src.dart';

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
        super(initialState ?? const PrinterInitialState()) {
    on<BluetoothImagePrinterEvent>(_onPrinted);
  }

  final PrintImageByBluetoothInterface _printImageByBluetooth;

  FutureOr<void> _onPrinted(
    BluetoothImagePrinterEvent event,
    Emitter<BluetoothImagePrinterState> emit,
  ) async {
    emit(
      const PrinterLoadingState(),
    );

    final result = await _printImageByBluetooth(
      event.ticketConfiguration,
      event.bytes,
      event.count,
    );

    emit(
      result.when<BluetoothImagePrinterState>(
        data: (_) => const PrinterSuccessState(),
        error: (exception) => PrinterErrorState(exception: exception),
      ),
    );
  }
}
