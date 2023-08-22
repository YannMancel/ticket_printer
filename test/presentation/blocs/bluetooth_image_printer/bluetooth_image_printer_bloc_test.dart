import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<PrintImageByBluetooth>(),
  ],
)
import 'bluetooth_image_printer_bloc_test.mocks.dart';

void main() {
  late PrintImageByBluetooth printImageByBluetooth;
  late BluetoothImagePrinterBloc bloc;
  late BluetoothImagePrinterEvent event;

  group('BluetoothImagePrinterBloc', () {
    setUp(() {
      printImageByBluetooth = MockPrintImageByBluetooth();
      bloc = BluetoothImagePrinterBloc(
        printImageByBluetooth: printImageByBluetooth,
      );
    });

    test(
      'should have an initial state when it is at the creation bloc.',
      () {
        expect(bloc.state, const BluetoothImagePrinterState.initial());
        verifyZeroInteractions(printImageByBluetooth);
      },
    );

    group('when print event is emitted', () {
      setUp(() {
        event = BluetoothImagePrinterEvent.print(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
        );
      });

      blocTest<BluetoothImagePrinterBloc, BluetoothImagePrinterState>(
        'should emit 2 states, a loading state then success state.',
        setUp: () {
          when(printImageByBluetooth(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
          )).thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothImagePrinterState>[
          BluetoothImagePrinterState.loading(),
          BluetoothImagePrinterState.success(),
        ],
        verify: (_) {
          verify(printImageByBluetooth(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
          )).called(1);
          verifyNoMoreInteractions(printImageByBluetooth);
        },
      );

      blocTest<BluetoothImagePrinterBloc, BluetoothImagePrinterState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          when(printImageByBluetooth(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
          )).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothImagePrinterState>[
          const BluetoothImagePrinterState.loading(),
          BluetoothImagePrinterState.error(exception: exception),
        ],
        verify: (_) {
          verify(printImageByBluetooth(
            ticketConfiguration: kTicketConfigurationEntity,
            bytes: bytes,
          )).called(1);
          verifyNoMoreInteractions(printImageByBluetooth);
        },
      );
    });
  });
}
