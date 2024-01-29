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

  Future<void> _resetStream() async {
    if (_streamSubscription != null) {
      await _streamSubscription?.cancel();
      _streamSubscription = null;
    }
  }

  Future<void> _setupBluetoothDevicesStream() async {
    _streamSubscription = _getBluetoothDevicesStream().listen(
      (result) {
        final nextState = result.when<BluetoothDevicesState>(
          data: (bluetoothDevicesOrNull) => BluetoothDevicesDataState(
            bluetoothDevices:
                bluetoothDevicesOrNull ?? const <BluetoothDeviceEntity>[],
          ),
          error: (exception) => BluetoothDevicesErrorState(
            exception: exception,
          ),
        );

        if (state != nextState) {
          add(BluetoothDevicesChangedStateEvent(nextState: nextState));
        }
      },
      onError: (Object error, _) async {
        add(
          BluetoothDevicesChangedStateEvent(
            nextState: BluetoothDevicesErrorState(
              exception: error as Exception,
            ),
          ),
        );

        await _resetStream();
      },
    );
  }

  Future<void> _startScan(
    Emitter<BluetoothDevicesState> emit, {
    Duration? timeout,
  }) async {
    await _resetStream();
    // All scans use timeout=null else implement isScanning
    await _stopBluetoothDevicesScan();

    emit(
      const BluetoothDevicesLoadingState(),
    );

    // Don't wait for Future if the event.timeout is null.
    unawaited(
      _startBluetoothDevicesScan(argument: timeout),
    );

    await _setupBluetoothDevicesStream();
  }

  Future<void> _stopScan(Emitter<BluetoothDevicesState> emit) async {
    await _resetStream();

    emit(
      const BluetoothDevicesLoadingState(),
    );

    await _stopBluetoothDevicesScan();
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
  Future<void> close() async {
    await _resetStream();
    return super.close();
  }
}
