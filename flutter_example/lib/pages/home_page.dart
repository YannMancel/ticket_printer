import 'dart:async';

import 'package:example/models/_models.dart';
import 'package:example/pages/_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ticket_printer/ticket_printer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ticket Printer example'),
        centerTitle: true,
        actions: <Widget>[
          // TODO(YannMancel): add scanning bloc  via package:bluetooth_print/bluetooth_print.dart Stream<bool> get isScanning
          IconButton(
            onPressed: () {
              const kEvent = BluetoothDevicesRefreshedEvent(
                timeout: Duration(seconds: 4),
              );
              context.read<BluetoothDevicesBloc>().add(kEvent);
            },
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: const Column(
        children: <Widget>[
          Expanded(
            flex: 2,
            child: _BluetoothDeviceScanner(),
          ),
          Divider(
            indent: 16.0,
            endIndent: 16.0,
          ),
          Expanded(
            child: _BluetoothConnection(),
          ),
        ],
      ),
    );
  }
}

class _BluetoothDeviceScanner extends StatelessWidget {
  const _BluetoothDeviceScanner();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothDevicesBloc, BluetoothDevicesState>(
      buildWhen: (previous, current) => previous != current,
      builder: (_, state) => state.when<Widget>(
        initial: (devices) => _BluetoothDevices(devices),
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        data: (devices) => _BluetoothDevices(devices),
        error: (_) => const Center(
          child: Text('Error During scanning'),
        ),
      ),
    );
  }
}

class _BluetoothDevices extends StatelessWidget {
  const _BluetoothDevices(
    List<BluetoothDeviceEntity> bluetoothDevices,
  ) : _bluetoothDevices = bluetoothDevices;

  final List<BluetoothDeviceEntity> _bluetoothDevices;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      IterableProperty<BluetoothDeviceEntity>(
        'bluetoothDevices',
        _bluetoothDevices,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_bluetoothDevices.isEmpty) {
      return const Center(
        child: Text('No device'),
      );
    }

    return ListView.builder(
      itemCount: _bluetoothDevices.length,
      itemBuilder: (_, index) {
        final bluetoothDevice = _bluetoothDevices[index];
        return _BluetoothDeviceCard(bluetoothDevice);
      },
    );
  }
}

class _BluetoothDeviceCard extends StatelessWidget {
  const _BluetoothDeviceCard(
    BluetoothDeviceEntity bluetoothDevice,
  ) : _bluetoothDevice = bluetoothDevice;

  final BluetoothDeviceEntity _bluetoothDevice;

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<BluetoothDeviceEntity>(
        'bluetoothDevice',
        _bluetoothDevice,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothConnectionBloc, BluetoothConnectionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => ListTile(
        leading: state.maybeWhen<Widget>(
          connecting: (device) {
            return Icon(
              device == _bluetoothDevice
                  ? Icons.check_box
                  : Icons.check_box_outline_blank,
              color: device == _bluetoothDevice ? Colors.green : null,
            );
          },
          orElse: () => const Icon(Icons.check_box_outline_blank),
        ),
        horizontalTitleGap: 0.0,
        title: Text(_bluetoothDevice.name ?? '[No Name]'),
        subtitle: Text(_bluetoothDevice.address ?? '[No Address]'),
        onTap: () {
          final bloc = context.read<BluetoothConnectionBloc>();
          state.maybeWhen<void>(
            loading: () {/* Do nothing here */},
            connecting: (device) {
              bloc.add(
                const BluetoothDisconnectedEvent(),
              );

              if (device != _bluetoothDevice) {
                bloc.add(
                  BluetoothConnectedEvent(bluetoothDevice: _bluetoothDevice),
                );
              }
            },
            // disconnecting and error states
            orElse: () => bloc.add(
              BluetoothConnectedEvent(bluetoothDevice: _bluetoothDevice),
            ),
          );
        },
      ),
    );
  }
}

class _BluetoothConnection extends StatelessWidget {
  const _BluetoothConnection();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BluetoothConnectionBloc, BluetoothConnectionState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) => state.when<Widget>(
        loading: () => const Center(
          child: CircularProgressIndicator.adaptive(),
        ),
        connecting: (device) => _ConnectedView(device),
        disconnecting: () => const Center(
          child: Text('No connection'),
        ),
        error: (_) => const Center(
          child: Text('Error During connection'),
        ),
      ),
    );
  }
}

class _ConnectedView extends StatefulWidget {
  const _ConnectedView(
    BluetoothDeviceEntity bluetoothDevice,
  ) : _bluetoothDevice = bluetoothDevice;

  final BluetoothDeviceEntity _bluetoothDevice;

  @override
  State<_ConnectedView> createState() => _ConnectedViewState();
}

class _ConnectedViewState extends State<_ConnectedView> {
  late int _count;

  TicketConfigurationEntity get _ticketConfiguration {
    return const TicketConfigurationEntity(
      width: 55,
      height: 29,
      gap: 3,
    );
  }

  Future<pw.Document> _generateCustomDocument({
    required int ticketCount,
    required TicketConfigurationEntity ticketConfiguration,
    required PrintedLineBase title,
    required DateTime dateTime,
    required List<PrintedLine> data,
  }) async {
    final document = pw.Document();

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          ticketConfiguration.width * PdfPageFormat.mm,
          (ticketCount * ticketConfiguration.height +
                  (ticketCount - 1) * ticketConfiguration.gap) *
              PdfPageFormat.mm,
        ),
        build: (_) {
          final titleWidget = pw.Container(
            width: double.infinity,
            padding: const pw.EdgeInsets.all(4.0),
            decoration: pw.BoxDecoration(
              border: pw.Border.all(),
            ),
            alignment: pw.Alignment.center,
            child: pw.Text(
              title.key,
              style: pw.TextStyle(
                fontSize: title.fontSize,
                fontWeight:
                    title.isBold ? pw.FontWeight.bold : pw.FontWeight.normal,
              ),
            ),
          );

          final (firstLetter, otherLetters) = switch (dateTime.weekday) {
            DateTime.monday => ('M', 'on'),
            DateTime.tuesday => ('T', 'ue'),
            DateTime.wednesday => ('W', 'ed'),
            DateTime.thursday => ('T', 'hu'),
            DateTime.friday => ('F', 'ri'),
            DateTime.saturday => ('S', 'at'),
            DateTime.sunday => ('S', 'un'),
            _ => throw UnimplementedError(),
          };

          final dateTimeWidget = pw.Container(
            height: double.infinity,
            margin: const pw.EdgeInsets.only(
              top: 4.0,
              right: 4.0,
            ),
            padding: const pw.EdgeInsets.all(4.0),
            alignment: pw.Alignment.center,
            color: PdfColor.fromInt(Colors.black.value),
            child: pw.Stack(
              fit: pw.StackFit.expand,
              children: <pw.Widget>[
                pw.Center(
                  child: pw.Text(
                    firstLetter,
                    style: pw.TextStyle(
                      fontSize: 25.0,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(Colors.white.value),
                    ),
                  ),
                ),
                pw.Align(
                  alignment: pw.Alignment.bottomCenter,
                  child: pw.Text(
                    otherLetters,
                    style: pw.TextStyle(
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColor.fromInt(Colors.white.value),
                    ),
                  ),
                ),
              ],
            ),
          );

          final dataWidget = pw.Padding(
            padding: const pw.EdgeInsets.only(top: 4.0),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: data
                  .map<pw.Widget>(
                    (line) => pw.Text(
                      '${line.key}${line.separator}${line.value}',
                      style: pw.TextStyle(
                        fontSize: line.fontSize,
                        fontWeight: line.isBold
                            ? pw.FontWeight.bold
                            : pw.FontWeight.normal,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          );

          final ticket = pw.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.height,
            child: pw.Padding(
              padding: const pw.EdgeInsets.all(4.0),
              child: pw.Column(
                children: <pw.Widget>[
                  titleWidget,
                  pw.Expanded(
                    child: pw.Row(
                      children: <pw.Widget>[
                        pw.Expanded(child: dateTimeWidget),
                        pw.Expanded(
                          flex: 3,
                          child: dataWidget,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );

          final gap = pw.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.gap,
            child: pw.Container(
              color: PdfColor.fromInt(Colors.grey.shade300.value),
            ),
          );

          final widgets = List<pw.Widget>.empty(growable: true);
          for (int i = 0; i <= ticketCount; i++) {
            final top =
                (i * (ticketConfiguration.gap + ticketConfiguration.height))
                    .toDouble();

            final ticketPositioned = pw.Positioned(
              left: 0.0,
              right: 0.0,
              top: top * PdfPageFormat.mm,
              child: ticket,
            );

            widgets.add(ticketPositioned);

            if (i < (ticketCount - 1)) {
              final gapPositioned = pw.Positioned(
                left: 0.0,
                right: 0.0,
                top: (ticketConfiguration.height + top) * PdfPageFormat.mm,
                child: gap,
              );

              widgets.add(gapPositioned);
            }
          }

          return pw.DecoratedBox(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(Colors.white.value),
            ),
            child: pw.Stack(children: widgets),
          );
        },
      ),
    );

    return document;
  }

  Future<pw.Document> _generateDocument({
    required int ticketCount,
    required TicketConfigurationEntity ticketConfiguration,
    required String imageAssetPath,
  }) async {
    final document = pw.Document();
    final imageToDoc = await imageFromAssetBundle(imageAssetPath);

    document.addPage(
      pw.Page(
        pageFormat: PdfPageFormat(
          ticketConfiguration.width * PdfPageFormat.mm,
          (ticketCount * ticketConfiguration.height +
                  (ticketCount - 1) * ticketConfiguration.gap) *
              PdfPageFormat.mm,
        ),
        build: (_) {
          final ticket = pw.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.height,
            child: pw.Image(
              imageToDoc,
              fit: pw.BoxFit.fill,
            ),
          );

          final gap = pw.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.gap,
            child: pw.Container(
              color: PdfColor.fromInt(Colors.red.value),
            ),
          );

          final widgets = List<pw.Widget>.empty(growable: true);
          for (int i = 0; i <= ticketCount; i++) {
            final top =
                (i * (ticketConfiguration.gap + ticketConfiguration.height))
                    .toDouble();

            final ticketPositioned = pw.Positioned(
              left: 0.0,
              right: 0.0,
              top: top * PdfPageFormat.mm,
              child: ticket,
            );

            widgets.add(ticketPositioned);

            if (i < (ticketCount - 1)) {
              final gapPositioned = pw.Positioned(
                left: 0.0,
                right: 0.0,
                top: (ticketConfiguration.height + top) * PdfPageFormat.mm,
                child: gap,
              );

              widgets.add(gapPositioned);
            }
          }

          return pw.DecoratedBox(
            decoration: pw.BoxDecoration(
              color: PdfColor.fromInt(Colors.white.value),
            ),
            child: pw.Stack(children: widgets),
          );
        },
      ),
    );

    return document;
  }

  Future<Uint8List> _getBytes({
    required int ticketCount,
    required TicketConfigurationEntity ticketConfiguration,
  }) async {
    final document = await _generateDocument(
      ticketCount: ticketCount,
      ticketConfiguration: ticketConfiguration,
      imageAssetPath: 'assets/etiquette_test.png',
    );

    final page = await Printing.raster(
      await document.save(),
      pages: <int>[0],
      dpi: PdfPageFormat.inch.toDpi,
    ).first;

    return await page.toPng();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties
      ..add(
        DiagnosticsProperty<BluetoothDeviceEntity>(
          'bluetoothDevice',
          widget._bluetoothDevice,
        ),
      )
      ..add(
        IntProperty(
          'count',
          _count,
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    _count = 1;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Center(
          child: Text('${widget._bluetoothDevice.name} is connecting.'),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      final bloc = context.read<BluetoothImagePrinterBloc>();
                      final bytes = await _getBytes(
                        ticketCount: _count,
                        ticketConfiguration: _ticketConfiguration,
                      );
                      final event = BluetoothImagePrinterEvent(
                        ticketConfiguration: _ticketConfiguration.copyWith(
                          height: _count * _ticketConfiguration.height +
                              (_count - 1) * _ticketConfiguration.gap,
                        ),
                        bytes: bytes,
                      );

                      bloc.add(event);
                    },
                    child: const Text('Print'),
                  ),
                ),
                const SizedBox.square(dimension: 16.0),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _generateCustomDocument(
                        ticketCount: _count,
                        ticketConfiguration: _ticketConfiguration,
                        title: PrintedLineBase(
                          key: 'Salade'.toUpperCase(),
                          fontSize: 12.0,
                        ),
                        dateTime: DateTime.now(),
                        data: const <PrintedLine>[
                          PrintedLine(
                            key: 'Cong.',
                            value: '01/01/2023',
                          ),
                          PrintedLine(
                            key: 'Lot',
                            value: '827490000',
                          ),
                          PrintedLine(
                            key: 'Ent./Fab.',
                            value: '05/01/2023',
                          ),
                          PrintedLine(
                            key: 'DLC',
                            value: '08/01/2023',
                            isBold: true,
                          ),
                          PrintedLine(
                            key: 'Par Yann Mancel',
                            separator: '',
                          ),
                        ],
                      ).then(
                        (document) => Navigator.push<void>(
                          context,
                          MaterialPageRoute<void>(
                            builder: (_) => PreviewPage(document),
                          ),
                        ),
                      );
                    },
                    child: const Text('Preview'),
                  ),
                ),
              ],
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 60.0,
            ),
            child: Row(
              children: <Widget>[
                FloatingActionButton(
                  heroTag: 'Decrement',
                  mini: true,
                  onPressed: _count > 0
                      ? () {
                          if (mounted) setState(() => _count--);
                        }
                      : null,
                  child: const Icon(Icons.remove),
                ),
                Expanded(
                  child: Text(
                    '$_count',
                    textAlign: TextAlign.center,
                  ),
                ),
                FloatingActionButton(
                  heroTag: 'Increment',
                  mini: true,
                  onPressed: () {
                    if (mounted) setState(() => _count++);
                  },
                  child: const Icon(Icons.add),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
