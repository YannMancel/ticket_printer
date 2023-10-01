import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

sealed class Result<T> {
  const Result();

  R when<R extends Object?>({
    required R Function(T?) data,
    required R Function(Exception) error,
  }) {
    return switch (this) {
      DataResult<T>(:final value) => data(value),
      ErrorResult<T>(:final exception) => error(exception),
    };
  }

  bool get isError {
    return switch (this) {
      DataResult<T> _ => false,
      ErrorResult<T> _ => true,
    };
  }

  Exception? get errorExceptionOrNull {
    return switch (this) {
      ErrorResult<T>(:final exception) => exception,
      _ => null,
    };
  }
}

@immutable
class DataResult<T> extends Result<T> {
  const DataResult({this.value});

  final T? value;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is DataResult<T> &&
            const DeepCollectionEquality().equals(value, other.value));
  }

  @override
  int get hashCode {
    return Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(value),
    );
  }
}

@immutable
class ErrorResult<T> extends Result<T> {
  const ErrorResult({required this.exception});

  final Exception exception;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is ErrorResult<T> &&
            (identical(exception, other.exception) ||
                exception == other.exception));
  }

  @override
  int get hashCode => Object.hash(runtimeType, exception);
}
