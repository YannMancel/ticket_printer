import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:ticket_printer/src/_src.dart';

part 'ticket_configuration_model.freezed.dart';

@freezed
sealed class TicketConfigurationModel with _$TicketConfigurationModel {
  const TicketConfigurationModel._();

  const factory TicketConfigurationModel({
    /// Dimension in mm
    @Default(55) int width,

    /// Dimension in mm
    @Default(29) int height,

    /// Dimension in mm
    @Default(3) int gap,
  }) = _Model;

  factory TicketConfigurationModel.fromEntity(
    TicketConfigurationEntity entity,
  ) {
    return TicketConfigurationModel(
      width: entity.width,
      height: entity.height,
      gap: entity.gap,
    );
  }
}
