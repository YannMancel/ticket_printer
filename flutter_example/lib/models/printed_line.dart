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
  bool operator ==(covariant PrintedLine other) {
    if (identical(this, other)) return true;
    return _equality() == other._equality();
  }

  @override
  int get hashCode => _equality().hashCode;
}
