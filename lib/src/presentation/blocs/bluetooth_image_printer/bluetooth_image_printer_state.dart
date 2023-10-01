import 'package:flutter/foundation.dart';

sealed class BluetoothImagePrinterState {
  const BluetoothImagePrinterState();
}

@immutable
class PrinterInitialState extends BluetoothImagePrinterState {
  const PrinterInitialState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType],
    );
  }
}

@immutable
class PrinterLoadingState extends BluetoothImagePrinterState {
  const PrinterLoadingState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType],
    );
  }
}

@immutable
class PrinterSuccessState extends BluetoothImagePrinterState {
  const PrinterSuccessState();

  @override
  bool operator ==(Object other) {
    return identical(this, other) || runtimeType == other.runtimeType;
  }

  @override
  int get hashCode {
    return Object.hashAll(
      <Object?>[runtimeType],
    );
  }
}

@immutable
class PrinterErrorState extends BluetoothImagePrinterState {
  const PrinterErrorState({required this.exception});

  final Exception exception;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is PrinterErrorState &&
            (identical(other.exception, exception) ||
                other.exception == exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);
}
