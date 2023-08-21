import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticket_printer/src/_src.dart';

part 'bluetooth_connection_bloc.freezed.dart';
part 'bluetooth_connection_event.dart';
part 'bluetooth_connection_state.dart';

/// The bloc provides the bluetooth device manager.
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
/// final bloc = BluetoothDevicesBloc(
///   connectAtBluetoothDevice: connectAtBluetoothDevice,
///   disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
/// );
/// ```
class BluetoothConnectionBloc
    extends Bloc<BluetoothConnectionEvent, BluetoothConnectionState> {
  @visibleForTesting
  BluetoothConnectionBloc({
    BluetoothConnectionState? initialState,
    required ConnectAtBluetoothDevice connectAtBluetoothDevice,
    required DisconnectAtBluetoothDevice disconnectAtBluetoothDevice,
  })  : _connectAtBluetoothDevice = connectAtBluetoothDevice,
        _disconnectAtBluetoothDevice = disconnectAtBluetoothDevice,
        super(initialState ?? const BluetoothConnectionState.disconnecting()) {
    on<_Connected>(_onConnected);
    on<_Disconnected>(_onDisconnected);
  }

  final ConnectAtBluetoothDevice _connectAtBluetoothDevice;
  final DisconnectAtBluetoothDevice _disconnectAtBluetoothDevice;

  FutureOr<void> _onConnected(
    _Connected event,
    Emitter<BluetoothConnectionState> emit,
  ) async {
    emit(
      const BluetoothConnectionState.loading(),
    );

    final result = await _connectAtBluetoothDevice(entity: event.entity);

    emit(
      result.when<BluetoothConnectionState>(
        data: (_) => BluetoothConnectionState.connecting(entity: event.entity),
        error: (exception) => BluetoothConnectionState.error(
          exception: exception,
        ),
      ),
    );
  }

  FutureOr<void> _onDisconnected(
    _Disconnected event,
    Emitter<BluetoothConnectionState> emit,
  ) async {
    emit(
      const BluetoothConnectionState.loading(),
    );

    final result = await _disconnectAtBluetoothDevice();

    emit(
      result.when<BluetoothConnectionState>(
        data: (_) => const BluetoothConnectionState.disconnecting(),
        error: (exception) => BluetoothConnectionState.error(
          exception: exception,
        ),
      ),
    );
  }
}
