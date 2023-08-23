import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:ticket_printer/ticket_printer.dart';

void main() => runApp(const _App());

class _App extends StatelessWidget {
  const _App();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MultiBlocProvider(
        providers: [
          BlocProvider<BluetoothDevicesBloc>(
            create: (_) {
              final bloc = ServiceLocator.bluetoothDevicesBlocSingleton;
              bloc.add(
                const BluetoothDevicesEvent.started(
                  timeout: Duration(seconds: 4),
                ),
              );
              return bloc;
            },
          ),
          BlocProvider<BluetoothConnectionBloc>(
            create: (_) => ServiceLocator.bluetoothConnectionBlocSingleton,
          ),
          BlocProvider<BluetoothImagePrinterBloc>(
            create: (_) => ServiceLocator.bluetoothImagePrinterBlocSingleton,
          ),
        ],
        child: const _HomePage(),
      ),
    );
  }
}

class _HomePage extends StatelessWidget {
  const _HomePage();

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
              const kEvent = BluetoothDevicesEvent.refreshed(
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
                const BluetoothConnectionEvent.disconnected(),
              );

              if (device != _bluetoothDevice) {
                bloc.add(
                  BluetoothConnectionEvent.connected(
                    bluetoothDevice: _bluetoothDevice,
                  ),
                );
              }
            },
            // disconnecting and error states
            orElse: () => bloc.add(
              BluetoothConnectionEvent.connected(
                bluetoothDevice: _bluetoothDevice,
              ),
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

  Future<Uint8List> _getBytes({
    required int ticketCount,
    required TicketConfigurationEntity ticketConfiguration,
  }) async {
    final doc = pw.Document();
    final imageToDoc = await imageFromAssetBundle('assets/etiquette_test.png');

    doc.addPage(
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

          final widgets = List<pw.Widget>.empty(growable: true);
          for (int i = 0; i <= ticketCount; i++) {
            final top =
                (i * (ticketConfiguration.gap + ticketConfiguration.height))
                    .toDouble();

            final widget = pw.Positioned(
              left: 0.0,
              right: 0.0,
              top: top * PdfPageFormat.mm,
              child: ticket,
            );

            widgets.add(widget);
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

    final page = await Printing.raster(
      await doc.save(),
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
            child: ElevatedButton(
              onPressed: () async {
                final bloc = context.read<BluetoothImagePrinterBloc>();

                const kTicketConfiguration = TicketConfigurationEntity(
                  width: 55,
                  height: 29,
                  gap: 3,
                );
                final bytes = await _getBytes(
                  ticketCount: _count,
                  ticketConfiguration: kTicketConfiguration,
                );
                final event = BluetoothImagePrinterEvent.print(
                  ticketConfiguration: kTicketConfiguration.copyWith(
                    height: _count * kTicketConfiguration.height +
                        (_count - 1) * kTicketConfiguration.gap,
                  ),
                  bytes: bytes,
                );

                bloc.add(event);
              },
              child: const Text('Print'),
            ),
          ),
        ),
        Align(
          alignment: Alignment.topCenter,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
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
