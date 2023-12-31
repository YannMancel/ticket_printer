import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<PrintImageByBluetooth>(),
  ],
)
import 'bluetooth_image_printer_bloc_test.mocks.dart';

typedef _Bloc = Bloc<BluetoothImagePrinterEvent, BluetoothImagePrinterState>;

void main() {
  late PrintImageByBluetoothInterface printImageByBluetooth;
  late _Bloc bloc;
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
        expect(bloc.state, const PrinterInitialState());
        verifyZeroInteractions(printImageByBluetooth);
      },
    );

    group('when print event is emitted', () {
      setUp(() {
        event = BluetoothImagePrinterEvent(
          ticketConfiguration: kTicketConfigurationEntity,
          bytes: bytes,
          count: kCount,
        );
      });

      blocTest<_Bloc, BluetoothImagePrinterState>(
        'should emit 2 states, a loading state then success state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(printImageByBluetooth(kTicketConfigurationEntity, bytes, kCount))
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothImagePrinterState>[
          PrinterLoadingState(),
          PrinterSuccessState(),
        ],
        verify: (_) {
          verify(
            printImageByBluetooth(
              kTicketConfigurationEntity,
              bytes,
              kCount,
            ),
          ).called(1);
          verifyNoMoreInteractions(printImageByBluetooth);
        },
      );

      blocTest<_Bloc, BluetoothImagePrinterState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(resultOfError<void>());

          when(
            printImageByBluetooth(
              kTicketConfigurationEntity,
              bytes,
              kCount,
            ),
          ).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothImagePrinterState>[
          const PrinterLoadingState(),
          PrinterErrorState(exception: exception),
        ],
        verify: (_) {
          verify(
            printImageByBluetooth(
              kTicketConfigurationEntity,
              bytes,
              kCount,
            ),
          ).called(1);
          verifyNoMoreInteractions(printImageByBluetooth);
        },
      );
    });
  });
}
