import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<StartBluetoothDevicesScan>(),
    MockSpec<GetBluetoothDevicesStream>(),
    MockSpec<StopBluetoothDevicesScan>(),
  ],
)
import 'bluetooth_devices_bloc_test.mocks.dart';

void main() {
  late StartBluetoothDevicesScanInterface startBluetoothDevicesScan;
  late GetBluetoothDevicesStreamInterface getBluetoothDevicesStream;
  late StopBluetoothDevicesScanInterface stopBluetoothDevicesScan;
  late BluetoothDevicesBloc bloc;
  late BluetoothDevicesEvent event;

  group('BluetoothDevicesBloc', () {
    setUp(() {
      startBluetoothDevicesScan = MockStartBluetoothDevicesScan();
      getBluetoothDevicesStream = MockGetBluetoothDevicesStream();
      stopBluetoothDevicesScan = MockStopBluetoothDevicesScan();
      bloc = BluetoothDevicesBloc(
        startBluetoothDevicesScan: startBluetoothDevicesScan,
        getBluetoothDevicesStream: getBluetoothDevicesStream,
        stopBluetoothDevicesScan: stopBluetoothDevicesScan,
      );
    });

    test(
      'should have an initial state when it is at the creation bloc.',
      () {
        expect(bloc.state, const BluetoothDevicesState.initial());
        verifyZeroInteractions(startBluetoothDevicesScan);
        verifyZeroInteractions(getBluetoothDevicesStream);
        verifyZeroInteractions(stopBluetoothDevicesScan);
      },
    );

    group('when started event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesEvent.started();
      });

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state.',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(bluetoothDevices: bluetoothDeviceEntities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then data state then error '
        'state (from error stream).',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => exceptionStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(bluetoothDevices: bluetoothDeviceEntities),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then data state then error '
        'state (from stream).',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => errorResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(bluetoothDevices: bluetoothDeviceEntities),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then error state then data '
        'state (from stream).',
        setUp: () {
          when(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => dataResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
          BluetoothDevicesState.data(bluetoothDevices: bluetoothDeviceEntities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then error state then data '
        'state (empty data from stream).',
        setUp: () {
          when(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => emptyDataResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
          BluetoothDevicesState.data(
            bluetoothDevices: kNoBluetoothDeviceEntity,
          ),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state (empty).',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(
            bluetoothDevices: kNoBluetoothDeviceEntity,
          ),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          when(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when refreshed event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesEvent.refreshed();
      });

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state.',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(bluetoothDevices: bluetoothDeviceEntities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state (empty).',
        setUp: () {
          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(
            bluetoothDevices: kNoBluetoothDeviceEntity,
          ),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          when(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when stopped event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesEvent.stopped();
      });

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothDevicesState>[
          BluetoothDevicesState.loading(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          when(stopBluetoothDevicesScan()).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when changedState event is emitted', () {
      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit an error state.',
        setUp: () {
          event = BluetoothDevicesEvent.changedState(
            nextState: BluetoothDevicesState.error(exception: exception),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );
    });
  });
}
