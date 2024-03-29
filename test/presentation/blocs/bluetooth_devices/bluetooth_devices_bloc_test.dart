import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<StartBluetoothDevicesScan>(),
    MockSpec<GetBluetoothDevicesStream>(),
    MockSpec<StopBluetoothDevicesScan>(),
  ],
)
import 'bluetooth_devices_bloc_test.mocks.dart';

typedef _Bloc = Bloc<BluetoothDevicesEvent, BluetoothDevicesState>;

void main() {
  late StartBluetoothDevicesScanInterface startBluetoothDevicesScan;
  late GetBluetoothDevicesStreamInterface getBluetoothDevicesStream;
  late StopBluetoothDevicesScanInterface stopBluetoothDevicesScan;
  late _Bloc bloc;
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
        expect(bloc.state, const BluetoothDevicesInitialState());
        verifyZeroInteractions(startBluetoothDevicesScan);
        verifyZeroInteractions(getBluetoothDevicesStream);
        verifyZeroInteractions(stopBluetoothDevicesScan);
      },
    );

    group('when started event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesStartedEvent();
      });

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(resultOfData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error '
        'state (from error stream).',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(resultOfData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => exceptionStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
          BluetoothDevicesErrorState(exception: exception),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error '
        'state (from stream).',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(resultOfData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream())
              .thenAnswer((_) => errorResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
          BluetoothDevicesErrorState(exception: exception),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data '
        'state (from stream).',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(
            resultOfError<List<BluetoothDeviceEntity>>(),
          );

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
          const BluetoothDevicesLoadingState(),
          BluetoothDevicesDataState(bluetoothDevices: bluetoothDeviceEntities),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data '
        'state (empty data from stream).',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(
            resultOfError<List<BluetoothDeviceEntity>>(),
          );

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
          const BluetoothDevicesLoadingState(),
          BluetoothDevicesDataState(bluetoothDevices: kNoBluetoothDeviceEntity),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(kResultOfEmptyData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(
            resultOfError<List<BluetoothDeviceEntity>>(),
          );

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
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when refreshed event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesRefreshedEvent();
      });

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);
          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(resultOfData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(kResultOfEmptyData);

          when(startBluetoothDevicesScan(argument: anyNamed('argument')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream()).thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);

          // To avoid error with sealed class
          provideDummy<Result<List<BluetoothDeviceEntity>>>(
            resultOfError<List<BluetoothDeviceEntity>>(),
          );

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
          const BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verify(
            startBluetoothDevicesScan(argument: anyNamed('argument')),
          ).called(1);
          verify(getBluetoothDevicesStream()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when stopped event is emitted', () {
      setUp(() {
        event = const BluetoothDevicesStoppedEvent();
      });

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(stopBluetoothDevicesScan())
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothDevicesState>[
          BluetoothDevicesLoadingState(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan()).called(1);
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit a loading state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(resultOfError<void>());

          when(stopBluetoothDevicesScan()).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesLoadingState(),
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
      blocTest<_Bloc, BluetoothDevicesState>(
        'should emit an error state.',
        setUp: () {
          event = BluetoothDevicesChangedStateEvent(
            nextState: BluetoothDevicesErrorState(exception: exception),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          BluetoothDevicesErrorState(exception: exception),
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
