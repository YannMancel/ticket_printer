import 'dart:typed_data';

import 'package:ticket_printer/src/_src.dart';

/// The repository allows to manage the bluetooth features.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// final repository = BluetoothRepository(remoteDataSource: remoteDataSource);
/// ```
class BluetoothRepository implements BluetoothRepositoryInterface {
  const BluetoothRepository({
    required RemoteDataSourceInterface remoteDataSource,
  }) : _remoteDataSource = remoteDataSource;

  final RemoteDataSourceInterface _remoteDataSource;

  @override
  Future<Result<List<BluetoothDeviceEntity>>> startBluetoothDevicesScan({
    Duration? timeout,
  }) async {
    try {
      final models = await _remoteDataSource.startBluetoothDevicesScan(
        timeout: timeout,
      );

      return DataResult<List<BluetoothDeviceEntity>>(value: models.toEntities);
    } catch (e) {
      return ErrorResult<List<BluetoothDeviceEntity>>(
        exception: e as Exception,
      );
    }
  }

  @override
  Stream<Result<List<BluetoothDeviceEntity>>>
      getBluetoothDevicesStream() async* {
    try {
      final stream = _remoteDataSource.getBluetoothDevicesStream();

      await for (final models in stream) {
        yield DataResult<List<BluetoothDeviceEntity>>(
          value: models.toEntities,
        );
      }
    } catch (e) {
      yield ErrorResult<List<BluetoothDeviceEntity>>(
        exception: e as Exception,
      );
    }
  }

  @override
  Future<Result<void>> stopBluetoothDevicesScan({Duration? timeout}) async {
    try {
      await _remoteDataSource.stopBluetoothDevicesScan();
      return const DataResult<void>();
    } catch (e) {
      return ErrorResult<void>(exception: e as Exception);
    }
  }

  @override
  Future<Result<void>> connectAtBluetoothDevice({
    required BluetoothDeviceEntity bluetoothDevice,
  }) async {
    try {
      await _remoteDataSource.connectAtBluetoothDevice(
        bluetoothDevice: BluetoothDeviceModel.fromEntity(bluetoothDevice),
      );
      return const DataResult<void>();
    } catch (e) {
      return ErrorResult<void>(exception: e as Exception);
    }
  }

  @override
  Future<Result<void>> disconnectAtBluetoothDevice() async {
    try {
      await _remoteDataSource.disconnectAtBluetoothDevice();
      return const DataResult<void>();
    } catch (e) {
      return ErrorResult<void>(exception: e as Exception);
    }
  }

  @override
  Future<Result<void>> printImage({
    required TicketConfigurationEntity ticketConfiguration,
    required Uint8List bytes,
  }) async {
    try {
      await _remoteDataSource.printImage(
        ticketConfiguration: TicketConfigurationModel.fromEntity(
          ticketConfiguration,
        ),
        bytes: bytes,
      );
      return const DataResult<void>();
    } catch (e) {
      return ErrorResult<void>(exception: e as Exception);
    }
  }
}
