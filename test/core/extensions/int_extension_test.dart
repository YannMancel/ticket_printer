import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

void main() {
  group('IntExt', () {
    test('should return a correct value when toDpi is called.', () {
      expect(1.toDpi, 8);
    });
  });
}
