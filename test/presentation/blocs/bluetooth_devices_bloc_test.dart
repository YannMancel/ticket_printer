import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/domain/_domain.dart';
import 'package:ticket_printer/src/presentation/_presentation.dart';

import '../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<StartBluetoothDevicesScan>(),
    MockSpec<GetBluetoothDevicesStream>(),
    MockSpec<StopBluetoothDevicesScan>(),
  ],
)
import 'bluetooth_devices_bloc_test.mocks.dart';

void main() {
  late StartBluetoothDevicesScan startBluetoothDevicesScan;
  late GetBluetoothDevicesStream getBluetoothDevicesStream;
  late StopBluetoothDevicesScan stopBluetoothDevicesScan;
  late BluetoothDevicesBloc bloc;
  late BluetoothDevicesEvent event;

  group('BluetoothDevicesBloc', () {
    setUp(() async {
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
      () async {
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
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: entities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then data state then error '
        'state (from error stream).',
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => exceptionStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: entities),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then data state then error '
        'state (from stream).',
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => errorResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: entities),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then error state then data '
        'state (from stream).',
        setUp: () async {
          when(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => dataResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
          BluetoothDevicesState.data(entities: entities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 3 states, a loading state then error state then data '
        'state (empty data from stream).',
        setUp: () async {
          when(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => emptyDataResultStream());
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
          BluetoothDevicesState.data(entities: kNoEntity),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state (empty).',
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: kNoEntity),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
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
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => resultOfData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: entities),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then data state (empty).',
        setUp: () async {
          when(startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')))
              .thenAnswer((_) async => kResultOfEmptyData);

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.data(entities: kNoEntity),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
          verifyNoMoreInteractions(startBluetoothDevicesScan);
          verifyNoMoreInteractions(getBluetoothDevicesStream);
          verifyZeroInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).thenAnswer(
            (_) async => resultOfError<List<BluetoothDeviceEntity>>(),
          );

          when(getBluetoothDevicesStream.execute())
              .thenAnswer((_) => kEmptyStream);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothDevicesState>[
          const BluetoothDevicesState.loading(),
          BluetoothDevicesState.error(exception: exception),
        ],
        verify: (_) {
          verify(
            startBluetoothDevicesScan.execute(timeout: anyNamed('timeout')),
          ).called(1);
          verify(getBluetoothDevicesStream.execute()).called(1);
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
        setUp: () async {
          when(stopBluetoothDevicesScan.execute())
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothDevicesState>[
          BluetoothDevicesState.loading(),
        ],
        verify: (_) {
          verify(stopBluetoothDevicesScan.execute()).called(1);
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );

      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(stopBluetoothDevicesScan.execute()).thenAnswer(
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
          verify(stopBluetoothDevicesScan.execute()).called(1);
          verifyZeroInteractions(startBluetoothDevicesScan);
          verifyZeroInteractions(getBluetoothDevicesStream);
          verifyNoMoreInteractions(stopBluetoothDevicesScan);
        },
      );
    });

    group('when changedState event is emitted', () {
      blocTest<BluetoothDevicesBloc, BluetoothDevicesState>(
        'should emit an error state.',
        setUp: () async {
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
