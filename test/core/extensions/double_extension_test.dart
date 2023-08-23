import 'package:flutter_test/flutter_test.dart';
import 'package:ticket_printer/src/_src.dart';

void main() {
  group('DoubleExt', () {
    test('should return a correct value when toDpi is called.', () {
      expect(1.0.toDpi, 8.0);
    });
  });
}
