import 'package:example/models/_models.dart';

class PrintedLine extends PrintedLineBase {
  const PrintedLine({
    required super.key,
    this.separator = ' : ',
    this.value = '',
    super.fontSize = 8.0,
    super.isBold = false,
  });

  final String separator;
  final String value;

  (String, String, String, double, bool) _equality() {
    return (
      key,
      separator,
      value,
      fontSize,
      isBold,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is PrintedLine &&
            _equality() == other._equality());
  }

  @override
  int get hashCode => _equality().hashCode;
}
