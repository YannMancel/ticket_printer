import 'package:flutter_test/flutter_test.dart';

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
  });
}
