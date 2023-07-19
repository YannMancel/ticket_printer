// ignore_for_file: void_checks

import 'package:ticket_printer/src/core/_core.dart';
import 'package:ticket_printer/src/data/_data.dart';
import 'package:ticket_printer/src/domain/_domain.dart';

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

      return Result<List<BluetoothDeviceEntity>>.data(value: models.toEntities);
    } catch (e) {
      return Result<List<BluetoothDeviceEntity>>.error(
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
        yield Result<List<BluetoothDeviceEntity>>.data(
          value: models.toEntities,
        );
      }
    } catch (e) {
      yield Result<List<BluetoothDeviceEntity>>.error(
        exception: e as Exception,
      );
    }
  }

  @override
  Future<Result<void>> stopBluetoothDevicesScan({Duration? timeout}) async {
    try {
      await _remoteDataSource.stopBluetoothDevicesScan();
      return const Result<void>.data();
    } catch (e) {
      return Result<void>.error(exception: e as Exception);
    }
  }
}
