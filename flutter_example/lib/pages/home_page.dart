import 'dart:async';

import 'package:example/app.dart';
import 'package:example/models/_models.dart';
import 'package:example/pages/_pages.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pdf;
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
    return switch (_bluetoothDevices.isEmpty) {
      true => const Center(
          child: Text('No device'),
        ),
      false => ListView.builder(
          itemCount: _bluetoothDevices.length,
          itemBuilder: (_, index) {
            final bluetoothDevice = _bluetoothDevices[index];
            return _BluetoothDeviceCard(bluetoothDevice);
          },
        ),
    };
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

  Future<pdf.Document> _generateCustomDocument({
    required TicketConfigurationEntity ticketConfiguration,
    required PrintedLineBase title,
    required DateTime dateTime,
    required List<PrintedLine> data,
  }) async {
    final document = pdf.Document();

    document.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat(
          ticketConfiguration.width * PdfPageFormat.mm,
          ticketConfiguration.height * PdfPageFormat.mm,
        ),
        build: (_) {
          final titleWidget = pdf.Container(
            width: double.infinity,
            padding: const pdf.EdgeInsets.all(4.0),
            decoration: pdf.BoxDecoration(
              border: pdf.Border.all(),
            ),
            alignment: pdf.Alignment.center,
            child: pdf.Text(
              title.key,
              style: pdf.TextStyle(
                fontSize: title.fontSize,
                fontWeight:
                    title.isBold ? pdf.FontWeight.bold : pdf.FontWeight.normal,
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

          final dateTimeWidget = pdf.Container(
            height: double.infinity,
            margin: const pdf.EdgeInsets.only(
              top: 4.0,
              right: 4.0,
            ),
            padding: const pdf.EdgeInsets.all(4.0),
            alignment: pdf.Alignment.center,
            color: PdfColor.fromInt(Colors.black.value),
            child: pdf.Stack(
              fit: pdf.StackFit.expand,
              children: <pdf.Widget>[
                pdf.Center(
                  child: pdf.Text(
                    firstLetter,
                    style: pdf.TextStyle(
                      fontSize: 25.0,
                      fontWeight: pdf.FontWeight.bold,
                      color: PdfColor.fromInt(Colors.white.value),
                    ),
                  ),
                ),
                pdf.Align(
                  alignment: pdf.Alignment.bottomCenter,
                  child: pdf.Text(
                    otherLetters,
                    style: pdf.TextStyle(
                      fontSize: 8.0,
                      fontWeight: pdf.FontWeight.bold,
                      color: PdfColor.fromInt(Colors.white.value),
                    ),
                  ),
                ),
              ],
            ),
          );

          final dataWidget = pdf.Padding(
            padding: const pdf.EdgeInsets.only(top: 4.0),
            child: pdf.Column(
              crossAxisAlignment: pdf.CrossAxisAlignment.start,
              children: data
                  .map<pdf.Widget>(
                    (line) => pdf.Text(
                      '${line.key}${line.separator}${line.value}',
                      style: pdf.TextStyle(
                        fontSize: line.fontSize,
                        fontWeight: line.isBold
                            ? pdf.FontWeight.bold
                            : pdf.FontWeight.normal,
                      ),
                    ),
                  )
                  .toList(growable: false),
            ),
          );

          final ticket = pdf.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.height,
            child: pdf.Padding(
              padding: const pdf.EdgeInsets.all(4.0),
              child: pdf.Column(
                children: <pdf.Widget>[
                  titleWidget,
                  pdf.Expanded(
                    child: pdf.Row(
                      children: <pdf.Widget>[
                        pdf.Expanded(child: dateTimeWidget),
                        pdf.Expanded(
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

          return pdf.DecoratedBox(
            decoration: pdf.BoxDecoration(
              color: PdfColor.fromInt(Colors.white.value),
            ),
            child: ticket,
          );
        },
      ),
    );

    return document;
  }

  Future<pdf.Document> _generateDocument({
    required TicketConfigurationEntity ticketConfiguration,
    required String imageAssetPath,
  }) async {
    final document = pdf.Document();
    final imageToDoc = await imageFromAssetBundle(imageAssetPath);

    document.addPage(
      pdf.Page(
        pageFormat: PdfPageFormat(
          ticketConfiguration.width * PdfPageFormat.mm,
          ticketConfiguration.height * PdfPageFormat.mm,
        ),
        build: (_) {
          final ticket = pdf.AspectRatio(
            aspectRatio: ticketConfiguration.width / ticketConfiguration.height,
            child: pdf.Image(
              imageToDoc,
              fit: pdf.BoxFit.fill,
            ),
          );

          return pdf.DecoratedBox(
            decoration: pdf.BoxDecoration(
              color: PdfColor.fromInt(Colors.white.value),
            ),
            child: ticket,
          );
        },
      ),
    );

    return document;
  }

  Future<Uint8List> _getBytes({
    required TicketConfigurationEntity ticketConfiguration,
  }) async {
    final document = await _generateDocument(
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
                        ticketConfiguration: _ticketConfiguration,
                      );
                      final event = BluetoothImagePrinterEvent(
                        ticketConfiguration: _ticketConfiguration,
                        bytes: bytes,
                        count: _count,
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
