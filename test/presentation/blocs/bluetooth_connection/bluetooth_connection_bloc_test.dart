import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../../helpers/helpers.dart';
@GenerateNiceMocks(
  <MockSpec<dynamic>>[
    MockSpec<ConnectAtBluetoothDevice>(),
    MockSpec<DisconnectAtBluetoothDevice>(),
  ],
)
import 'bluetooth_connection_bloc_test.mocks.dart';

typedef _Bloc = Bloc<BluetoothConnectionEvent, BluetoothConnectionState>;

void main() {
  late ConnectAtBluetoothDeviceInterface connectAtBluetoothDevice;
  late DisconnectAtBluetoothDeviceInterface disconnectAtBluetoothDevice;
  late _Bloc bloc;
  late BluetoothConnectionEvent event;

  group('BluetoothConnectionBloc', () {
    setUp(() {
      connectAtBluetoothDevice = MockConnectAtBluetoothDevice();
      disconnectAtBluetoothDevice = MockDisconnectAtBluetoothDevice();
      bloc = BluetoothConnectionBloc(
        connectAtBluetoothDevice: connectAtBluetoothDevice,
        disconnectAtBluetoothDevice: disconnectAtBluetoothDevice,
      );
    });

    test(
      'should have a disconnecting state when it is at the creation bloc.',
      () {
        expect(bloc.state, const DisconnectingState());
        verifyZeroInteractions(connectAtBluetoothDevice);
        verifyZeroInteractions(disconnectAtBluetoothDevice);
      },
    );

    group('when connected event is emitted', () {
      setUp(() {
        event = BluetoothConnectedEvent(bluetoothDevice: bluetoothDeviceEntity);
      });

      blocTest<_Bloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then connecting state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(connectAtBluetoothDevice(bluetoothDeviceEntity))
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const ConnectionLoadingState(),
          ConnectingState(bluetoothDevice: bluetoothDeviceEntity),
        ],
        verify: (_) {
          verify(connectAtBluetoothDevice(bluetoothDeviceEntity)).called(1);
          verifyNoMoreInteractions(connectAtBluetoothDevice);
          verifyZeroInteractions(disconnectAtBluetoothDevice);
        },
      );

      blocTest<_Bloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(resultOfError<void>());

          when(
            connectAtBluetoothDevice(bluetoothDeviceEntity),
          ).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const ConnectionLoadingState(),
          ConnectionErrorState(exception: exception),
        ],
        verify: (_) {
          verify(connectAtBluetoothDevice(bluetoothDeviceEntity)).called(1);
          verifyNoMoreInteractions(connectAtBluetoothDevice);
          verifyZeroInteractions(disconnectAtBluetoothDevice);
        },
      );
    });

    group('when disconnected event is emitted', () {
      setUp(() {
        event = const BluetoothDisconnectedEvent();
      });

      blocTest<_Bloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then disconnecting state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(kResultOfVoidData);

          when(disconnectAtBluetoothDevice())
              .thenAnswer((_) async => kResultOfVoidData);
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => const <BluetoothConnectionState>[
          ConnectionLoadingState(),
          DisconnectingState(),
        ],
        verify: (_) {
          verify(disconnectAtBluetoothDevice()).called(1);
          verifyZeroInteractions(connectAtBluetoothDevice);
          verifyNoMoreInteractions(disconnectAtBluetoothDevice);
        },
      );

      blocTest<_Bloc, BluetoothConnectionState>(
        'should emit 2 states, a loading state then error state.',
        setUp: () {
          // To avoid error with sealed class
          provideDummy<Result<void>>(resultOfError<void>());

          when(
            disconnectAtBluetoothDevice(),
          ).thenAnswer(
            (_) async => resultOfError<void>(),
          );
        },
        build: () => bloc,
        act: (bloc) => bloc.add(event),
        expect: () => <BluetoothConnectionState>[
          const ConnectionLoadingState(),
          ConnectionErrorState(exception: exception),
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
