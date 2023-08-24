import 'package:collection/collection.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

import '../../helpers/helpers.dart';

void main() {
  group('Result', () {
    test('should be false on result of data when isError is called.', () {
      expect(resultOfData.isError, isFalse);
    });

    test('should be true on result of error when isError is called.', () {
      expect(resultOfError<void>().isError, isTrue);
    });

    test(
      'should be null on result of data when errorExceptionOrNull is called.',
      () {
        expect(resultOfData.errorExceptionOrNull, isNull);
      },
    );

    test(
      'should be an exception on result of error when errorExceptionOrNull is '
      'called.',
      () {
        expect(resultOfError<void>().errorExceptionOrNull, exception);
      },
    );

    test(
      'should return true when there is two error with '
      'same exception reference.',
      () {
        final firstError = ErrorResult<void>(exception: exception);
        final secondError = ErrorResult<void>(exception: exception);

        expect(firstError == secondError, isTrue);
      },
    );

    test(
      'should return false when there is two error with different exception.',
      () {
        final firstError = ErrorResult<void>(exception: Exception('A'));
        final secondError = ErrorResult<void>(exception: Exception('B'));

        expect(firstError == secondError, isFalse);
      },
    );

    test(
      'should be success when hashcode is compared with data result.',
      () {
        expect(
          resultOfData.hashCode,
          Object.hash(
            resultOfData.runtimeType,
            const DeepCollectionEquality().hash(resultOfData.value),
          ),
        );
      },
    );

    test(
      'should be success when hashcode is compared with error result.',
      () {
        final errorResult = resultOfError<void>() as ErrorResult<void>;
        expect(
          errorResult.hashCode,
          Object.hash(
            errorResult.runtimeType,
            errorResult.exception,
          ),
        );
      },
    );
  });
}
