import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticket_printer/src/_src.dart';

part 'bluetooth_devices_bloc.freezed.dart';
part 'bluetooth_devices_event.dart';
part 'bluetooth_devices_state.dart';

/// The bloc provides the bluetooth devices scan manager.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// final startBluetoothDevicesScan = StartBluetoothDevicesScan(
///   repository: repository,
/// );
/// final getBluetoothDevicesStream = GetBluetoothDevicesStream(
///   repository: repository,
/// );
/// final stopBluetoothDevicesScan = StopBluetoothDevicesScan(
///   repository: repository,
/// );
/// final bloc = BluetoothDevicesBloc(
///   startBluetoothDevicesScan: startBluetoothDevicesScan,
///   getBluetoothDevicesStream: getBluetoothDevicesStream,
///   stopBluetoothDevicesScan: stopBluetoothDevicesScan,
/// );
/// ```
class BluetoothDevicesBloc
    extends Bloc<BluetoothDevicesEvent, BluetoothDevicesState> {
  BluetoothDevicesBloc({
    BluetoothDevicesState? initialState,
    required StartBluetoothDevicesScan startBluetoothDevicesScan,
    required GetBluetoothDevicesStream getBluetoothDevicesStream,
    required StopBluetoothDevicesScan stopBluetoothDevicesScan,
  })  : _startBluetoothDevicesScan = startBluetoothDevicesScan,
        _getBluetoothDevicesStream = getBluetoothDevicesStream,
        _stopBluetoothDevicesScan = stopBluetoothDevicesScan,
        super(initialState ?? const BluetoothDevicesState.initial()) {
    on<_Started>(_onStarted);
    on<_Refreshed>(_onRefreshed);
    on<_Stopped>(_onStopped);
    on<_ChangedState>(_onChangedState);
  }

  final StartBluetoothDevicesScan _startBluetoothDevicesScan;
  final GetBluetoothDevicesStream _getBluetoothDevicesStream;
  final StopBluetoothDevicesScan _stopBluetoothDevicesScan;

  StreamSubscription<Result<List<BluetoothDeviceEntity>>>? _streamSubscription;

  Future<void> _setupBluetoothDevicesStream() async {
    if (_streamSubscription != null) await _streamSubscription?.cancel();

    _streamSubscription = _getBluetoothDevicesStream().listen((result) {
      final nextState = result.when<BluetoothDevicesState>(
        data: (entities) => BluetoothDevicesState.data(
          entities: entities ??
              List<BluetoothDeviceEntity>.empty(
                growable: false,
              ),
        ),
        error: (exception) => BluetoothDevicesState.error(
          exception: exception,
        ),
      );

      add(BluetoothDevicesEvent.changedState(nextState: nextState));
    }, onError: (error, _) {
      add(
        BluetoothDevicesEvent.changedState(
          nextState: BluetoothDevicesState.error(exception: error),
        ),
      );

      _streamSubscription?.cancel();
    });
  }

  Future<void> _startScan(
    Emitter<BluetoothDevicesState> emit, {
    Duration? timeout,
  }) async {
    emit(
      const BluetoothDevicesState.loading(),
    );

    final result = await _startBluetoothDevicesScan(timeout: timeout);

    emit(
      result.when<BluetoothDevicesState>(
        data: (entities) => BluetoothDevicesState.data(
          entities: entities ??
              List<BluetoothDeviceEntity>.empty(
                growable: false,
              ),
        ),
        error: (exception) => BluetoothDevicesState.error(
          exception: exception,
        ),
      ),
    );

    await _setupBluetoothDevicesStream();
  }

  Future<void> _stopScan(Emitter<BluetoothDevicesState> emit) async {
    emit(
      const BluetoothDevicesState.loading(),
    );

    final result = await _stopBluetoothDevicesScan();

    if (result.isError) {
      emit(
        BluetoothDevicesState.error(exception: result.errorExceptionOrNull!),
      );
    }
  }

  FutureOr<void> _onStarted(
    _Started event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _startScan(emit, timeout: event.timeout);
  }

  FutureOr<void> _onRefreshed(
    _Refreshed event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _startScan(emit, timeout: event.timeout);
  }

  FutureOr<void> _onStopped(
    _Stopped event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _stopScan(emit);
  }

  FutureOr<void> _onChangedState(
    _ChangedState event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    emit(event.nextState);
  }

  @override
  Future<void> close() {
    if (_streamSubscription != null) _streamSubscription?.cancel();
    return super.close();
  }
}
