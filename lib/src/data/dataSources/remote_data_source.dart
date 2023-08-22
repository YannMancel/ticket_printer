import 'dart:convert';
import 'dart:typed_data';

import 'package:bluetooth_print/bluetooth_print.dart';
import 'package:bluetooth_print/bluetooth_print_model.dart';
import 'package:ticket_printer/src/_src.dart';

/// This data source allows to manage the bluetooth features.
///
/// ```dart
/// final bluetoothPrint = BluetoothPrint.instance;
/// final remoteDataSource = RemoteDataSource(bluetoothPrint: bluetoothPrint);
/// ```
class RemoteDataSource implements RemoteDataSourceInterface {
  const RemoteDataSource({
    required BluetoothPrint bluetoothPrint,
  }) : _bluetoothPrint = bluetoothPrint;

  final BluetoothPrint _bluetoothPrint;

  @override
  Future<List<BluetoothDeviceModel>> startBluetoothDevicesScan({
    Duration? timeout,
  }) async {
    final bluetoothDevices = await _bluetoothPrint.startScan(
      timeout: timeout,
    );

    return (bluetoothDevices as List<BluetoothDevice>).toModels;
  }

  @override
  Stream<List<BluetoothDeviceModel>> getBluetoothDevicesStream() async* {
    await for (final bluetoothDevices in _bluetoothPrint.scanResults) {
      yield bluetoothDevices.toModels;
    }
  }

  @override
  Future<void> stopBluetoothDevicesScan({Duration? timeout}) async {
    return _bluetoothPrint.stopScan();
  }

  @override
  Future<void> connectAtBluetoothDevice({
    required BluetoothDeviceModel bluetoothDevice,
    BluetoothDevice? fakeBluetoothDevice,
  }) async {
    await _bluetoothPrint.connect(
      fakeBluetoothDevice ?? bluetoothDevice.toThirdParty,
    );
  }

  @override
  Future<void> disconnectAtBluetoothDevice() async {
    await _bluetoothPrint.disconnect();
  }

  @override
  Future<void> printImage({
    required TicketConfigurationModel ticketConfiguration,
    required Uint8List bytes,
    List<LineText>? fakePrintedData,
  }) async {
    // x & y are in dpi (1mm=8dp)
    //
    // + ---------------------------------------------> X
    // |
    // |    (0,0) --------------------------- (width,0)
    // |      |                                   |
    // |      |                                   |
    // |      |                                   |
    // |      |                                   |
    // |      |                                   |
    // |  (0,height) ---------------------- (width,height)
    // V
    // Y

    final base64Image = base64Encode(bytes);

    await _bluetoothPrint.printLabel(
      <String, dynamic>{
        'width': ticketConfiguration.width,
        'height': ticketConfiguration.height,
        'gap': ticketConfiguration.gap,
      },
      fakePrintedData ??
          <LineText>[
            LineText(
              type: LineText.TYPE_IMAGE,
              x: 0,
              y: 0,
              width: ticketConfiguration.width.toDpi,
              content: base64Image,
            ),
          ],
    );
  }
}
