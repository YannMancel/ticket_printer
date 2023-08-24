import 'package:example/pages/_pages.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ticket_printer/ticket_printer.dart';

class App extends StatelessWidget {
  const App({super.key});

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
        child: const HomePage(),
      ),
    );
  }
}
