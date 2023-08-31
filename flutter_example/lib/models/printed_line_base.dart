class PrintedLineBase {
  const PrintedLineBase({
    required this.key,
    this.fontSize = 8.0,
    this.isBold = false,
  });

  final String key;
  final double fontSize;
  final bool isBold;

  (String, double, bool) _equality() {
    return (
      key,
      fontSize,
      isBold,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is PrintedLineBase &&
            _equality() == other._equality());
  }

  @override
  int get hashCode => _equality().hashCode;
}
