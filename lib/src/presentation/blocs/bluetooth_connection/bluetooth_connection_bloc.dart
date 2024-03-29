import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_printer/src/_src.dart';

/// The bloc provides the bluetooth device connection manager.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final connectAtBluetoothDevice = ConnectAtBluetoothDevice(
///   repository: repository,
/// );
/// final disconnectAtBluetoothDevice = DisconnectAtBluetoothDevice(
///   repository: repository,
/// );
/// final bloc = BluetoothConnectionBloc(
///   connectAtBluetoothDevice: connectAtBluetoothDevice,
///   disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
/// );
/// ```
class BluetoothConnectionBloc
    extends Bloc<BluetoothConnectionEvent, BluetoothConnectionState> {
  BluetoothConnectionBloc({
    BluetoothConnectionState? initialState,
    required ConnectAtBluetoothDeviceInterface connectAtBluetoothDevice,
    required DisconnectAtBluetoothDeviceInterface disconnectAtBluetoothDevice,
  })  : _connectAtBluetoothDevice = connectAtBluetoothDevice,
        _disconnectAtBluetoothDevice = disconnectAtBluetoothDevice,
        super(initialState ?? const DisconnectingState()) {
    on<BluetoothConnectedEvent>(_onConnected);
    on<BluetoothDisconnectedEvent>(_onDisconnected);
  }

  final ConnectAtBluetoothDeviceInterface _connectAtBluetoothDevice;
  final DisconnectAtBluetoothDeviceInterface _disconnectAtBluetoothDevice;

  FutureOr<void> _onConnected(
    BluetoothConnectedEvent event,
    Emitter<BluetoothConnectionState> emit,
  ) async {
    emit(
      ConnectionLoadingState(bluetoothDevice: event.bluetoothDevice),
    );

    final result = await _connectAtBluetoothDevice(event.bluetoothDevice);

    emit(
      result.when<BluetoothConnectionState>(
        data: (_) => ConnectingState(bluetoothDevice: event.bluetoothDevice),
        error: (exception) => ConnectionErrorState(
          bluetoothDevice: event.bluetoothDevice,
          exception: exception,
        ),
      ),
    );
  }

  FutureOr<void> _onDisconnected(
    BluetoothDisconnectedEvent event,
    Emitter<BluetoothConnectionState> emit,
  ) async {
    final deviceOrNull = state.maybeWhen<BluetoothDeviceEntity?>(
      connecting: (device) => device,
      orElse: () => null,
    );

    emit(
      ConnectionLoadingState(bluetoothDevice: deviceOrNull),
    );

    final result = await _disconnectAtBluetoothDevice();

    emit(
      result.when<BluetoothConnectionState>(
        data: (_) => DisconnectingState(bluetoothDevice: deviceOrNull),
        error: (exception) => ConnectionErrorState(
          bluetoothDevice: deviceOrNull,
          exception: exception,
        ),
      ),
    );
  }
}
