import 'package:freezed_annotation/freezed_annotation.dart';

part 'ticket_configuration_entity.freezed.dart';

@freezed
sealed class TicketConfigurationEntity with _$TicketConfigurationEntity {
  const factory TicketConfigurationEntity({
    /// Dimension in mm
    @Default(55) int width,

    /// Dimension in mm
    @Default(29) int height,

    /// Dimension in mm
    @Default(3) int gap,
  }) = _Entity;
}
