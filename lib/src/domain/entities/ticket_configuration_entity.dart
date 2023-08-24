/// The dimensions are in mm.
class TicketConfigurationEntity {
  const TicketConfigurationEntity({
    this.width = 55,
    this.height = 29,
    this.gap = 3,
  });

  final int width;
  final int height;
  final int gap;

  (int, int, int) _equality() {
    return (
      width,
      height,
      gap,
    );
  }

  TicketConfigurationEntity copyWith({
    int? width,
    int? height,
    int? gap,
  }) {
    return TicketConfigurationEntity(
      width: width ?? this.width,
      height: height ?? this.height,
      gap: gap ?? this.gap,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (runtimeType == other.runtimeType &&
            other is TicketConfigurationEntity &&
            _equality() == other._equality());
  }

  @override
  int get hashCode => _equality().hashCode;
}
