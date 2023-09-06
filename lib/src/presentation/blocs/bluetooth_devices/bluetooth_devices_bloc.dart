import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_printer/src/_src.dart';

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
    required StartBluetoothDevicesScanInterface startBluetoothDevicesScan,
    required GetBluetoothDevicesStreamInterface getBluetoothDevicesStream,
    required StopBluetoothDevicesScanInterface stopBluetoothDevicesScan,
  })  : _startBluetoothDevicesScan = startBluetoothDevicesScan,
        _getBluetoothDevicesStream = getBluetoothDevicesStream,
        _stopBluetoothDevicesScan = stopBluetoothDevicesScan,
        super(initialState ?? const BluetoothDevicesInitialState()) {
    on<BluetoothDevicesStartedEvent>(_onStarted);
    on<BluetoothDevicesRefreshedEvent>(_onRefreshed);
    on<BluetoothDevicesStoppedEvent>(_onStopped);
    on<BluetoothDevicesChangedStateEvent>(_onChangedState);
  }

  final StartBluetoothDevicesScanInterface _startBluetoothDevicesScan;
  final GetBluetoothDevicesStreamInterface _getBluetoothDevicesStream;
  final StopBluetoothDevicesScanInterface _stopBluetoothDevicesScan;

  StreamSubscription<Result<List<BluetoothDeviceEntity>>>? _streamSubscription;

  Future<void> _setupBluetoothDevicesStream() async {
    if (_streamSubscription != null) await _streamSubscription?.cancel();

    _streamSubscription = _getBluetoothDevicesStream().listen((result) {
      final nextState = result.when<BluetoothDevicesState>(
        data: (bluetoothDevicesOrNull) => BluetoothDevicesDataState(
          bluetoothDevices: bluetoothDevicesOrNull ??
              List<BluetoothDeviceEntity>.empty(growable: false),
        ),
        error: (exception) => BluetoothDevicesErrorState(exception: exception),
      );

      add(BluetoothDevicesChangedStateEvent(nextState: nextState));
    }, onError: (Object error, _) {
      add(
        BluetoothDevicesChangedStateEvent(
          nextState: BluetoothDevicesErrorState(exception: error as Exception),
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
      const BluetoothDevicesLoadingState(),
    );

    final result = await _startBluetoothDevicesScan(argument: timeout);

    emit(
      result.when<BluetoothDevicesState>(
        data: (bluetoothDevicesOrNull) => BluetoothDevicesDataState(
          bluetoothDevices: bluetoothDevicesOrNull ??
              List<BluetoothDeviceEntity>.empty(growable: false),
        ),
        error: (exception) => BluetoothDevicesErrorState(exception: exception),
      ),
    );

    await _setupBluetoothDevicesStream();
  }

  Future<void> _stopScan(Emitter<BluetoothDevicesState> emit) async {
    emit(
      const BluetoothDevicesLoadingState(),
    );

    final result = await _stopBluetoothDevicesScan();

    if (result.isError) {
      emit(
        BluetoothDevicesErrorState(exception: result.errorExceptionOrNull!),
      );
    }
  }

  FutureOr<void> _onStarted(
    BluetoothDevicesStartedEvent event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _startScan(emit, timeout: event.timeout);
  }

  FutureOr<void> _onRefreshed(
    BluetoothDevicesRefreshedEvent event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _startScan(emit, timeout: event.timeout);
  }

  FutureOr<void> _onStopped(
    BluetoothDevicesStoppedEvent event,
    Emitter<BluetoothDevicesState> emit,
  ) async {
    return _stopScan(emit);
  }

  FutureOr<void> _onChangedState(
    BluetoothDevicesChangedStateEvent event,
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
