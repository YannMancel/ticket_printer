import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec>[
    MockSpec<ConnectAtBluetoothDevice>(),
    MockSpec<DisconnectAtBluetoothDevice>(),
  ],
)
import 'bluetooth_connection_bloc_test.mocks.dart';

void main() {
  late ConnectAtBluetoothDevice connectAtBluetoothDevice;
  late DisconnectAtBluetoothDevice disconnectAtBluetoothDevice;
  late BluetoothConnectionBloc bloc;
  late BluetoothConnectionEvent event;

  group('BluetoothConnectionBloc', () {
    setUp(() async {
      connectAtBluetoothDevice = MockConnectAtBluetoothDevice();
      disconnectAtBluetoothDevice = MockDisconnectAtBluetoothDevice();
      bloc = BluetoothConnectionBloc(
        connectAtBluetoothDevice: connectAtBluetoothDevice,
        disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
      );
    });

    test(
      'should have a disconnecting state when it is at the creation bloc.',
      () async {
        expect(bloc.state, const BluetoothConnectionState.disconnecting());
        verifyZeroInteractions(connectAtBluetoothDevice);
        verifyZeroInteractions(disconnectAtBluetoothDevice);
      },
    );

    group('when connected event is emitted', () {
      setUp(() {
        event = BluetoothConnectionEvent.connected(entity: entity);
      });

      blocTest<BluetoothConnectionBloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then connecting state.',
        setUp: () async {
          when(connectAtBluetoothDevice(entity: entity))
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const BluetoothConnectionState.loading(),
          BluetoothConnectionState.connecting(entity: entity),
        ],
        verify: (_) {
          verify(connectAtBluetoothDevice(entity: entity)).called(1);
          verifyNoMoreInteractions(connectAtBluetoothDevice);
          verifyZeroInteractions(disconnectAtBluetoothDevice);
        },
      );

      blocTest<BluetoothConnectionBloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(
            connectAtBluetoothDevice(entity: entity),
          ).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const BluetoothConnectionState.loading(),
          BluetoothConnectionState.error(exception: exception),
        ],
        verify: (_) {
          verify(connectAtBluetoothDevice(entity: entity)).called(1);
          verifyNoMoreInteractions(connectAtBluetoothDevice);
          verifyZeroInteractions(disconnectAtBluetoothDevice);
        },
      );
    });

    group('when disconnected event is emitted', () {
      setUp(() {
        event = const BluetoothConnectionEvent.disconnected();
      });

      blocTest<BluetoothConnectionBloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then disconnecting state.',
        setUp: () async {
          when(disconnectAtBluetoothDevice())
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothConnectionState>[
          BluetoothConnectionState.loading(),
          BluetoothConnectionState.disconnecting(),
        ],
        verify: (_) {
          verify(disconnectAtBluetoothDevice()).called(1);
          verifyZeroInteractions(connectAtBluetoothDevice);
          verifyNoMoreInteractions(disconnectAtBluetoothDevice);
        },
      );

      blocTest<BluetoothConnectionBloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () async {
          when(
            disconnectAtBluetoothDevice(),
          ).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const BluetoothConnectionState.loading(),
          BluetoothConnectionState.error(exception: exception),
        ],
        verify: (_) {
          verify(disconnectAtBluetoothDevice()).called(1);
          verifyZeroInteractions(connectAtBluetoothDevice);
          verifyNoMoreInteractions(disconnectAtBluetoothDevice);
        },
      );
    });
  });
}
